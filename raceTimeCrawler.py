##technical debt: # initialization parameters (event ID, racer ID)
    # API push
    # figure out opponent, self data to export
    # first place none type is handled poorly

from datetime import datetime
import time

import requests

import pandas as pd
import numpy as np

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

class RacerTable:
    def __init__(self,df,teamId):
        self.df = df.set_index('position')
        self.teamId = teamId

    def position(self):
        return self.df[self.df['number']==self.teamId].index[0]

    def opponentUp(self,method):
        if self.position() == '1':
            return None
        if method == 'all':
            return self.df.loc[str(int(self.position())-1)]
        else:
            return self.df.loc[str(int(self.position())-1)][method]

    def opponentDown(self,method):
        if method == 'all':
            return self.df.loc[str(int(self.position())+1)]
        else:
            return self.df.loc[str(int(self.position())+1)][method]

    def update(self,row,debug = False):
        """receives parsed HTML row as a pandas series.
        Determines if row reflects a new lap.  If so:
        - incorporate changes into master dataframe
        - determines if update impacts export time (self, opponent up/down, or leader)
        - if so, calculates new gap data, formats and POSTs to webserver
        - otherwise, passes
        debug == True prints every row update.  False by default"""

        if len(self.df[self.df['number']==row['number']]['laps']) != 0:  #catches condition where the dataframe was returning empty series
            if self.df[self.df['number']==row['number']]['laps'][0] != row['laps'] :  #only evaluate new laps
                for key in row.keys(): #update dataframe
                    self.df.at[row['position'], key] = row[key]

                if debug == True:
                    for x,y in row.items():
                        print(f'{x}: {y}')


                def calcSplit(other):
                    self_lapTime = self.df[self.df['number']== self.teamId]['lapTime'][0]
                    self_lapTime = datetime.strptime(f'2020 {self_lapTime}','%Y %M:%S.%f')


                    other_lapTime = other['lapTime']
                    other_lapTime = datetime.strptime(f'2020 {other_lapTime}','%Y %M:%S.%f')

                    if self_lapTime > other_lapTime:
                        faster = False
                        delta =str(self_lapTime-other_lapTime).split(':',1)[1][1:9]

                    if self_lapTime < other_lapTime:
                        faster = True
                        delta =str(other_lapTime-self_lapTime).split(':',1)[1][1:9]

                    other_lapTime = datetime.strftime(other_lapTime,'%M:%S.%f')[1:]
                    self_lapTime = datetime.strftime(self_lapTime,'%M:%S.%f')[1:]

                    self_laps = int(self.df[self.df['number']== self.teamId]['laps'][0])
                    other_laps = int(other['laps'])
                    if self_laps == other_laps:
                        gap = delta
                    if self_laps > other_laps:
                        gap = str(self_laps-other_laps)
                    if self_laps < other_laps:
                        gap = str(other_laps-self_laps)
                    return self_lapTime, other_lapTime, delta, faster, gap


                self_position = int(self.df[self.df['number']==self.teamId].index[0])

                if row['number'] == self.teamId or row['position']==str(self_position+1) or row['position']==str(self_position-1): #only export update if impacts self or up/down opponent
                    self_lapTime, opUp_lapTime, opUp_delta, opUp_faster, opUp_gap = calcSplit(self.opponentUp('all'))
                    self_lapTime, opDown_lapTime, opDown_delta, opDown_faster, opDown_gap = calcSplit(self.opponentDown('all'))

                    payload = {
                        'self laptime':self_lapTime,
                        'self laps': self.df[self.df['number']==self.teamId]['laps'][0],
                        'self position': self.df[self.df['number']==self.teamId]['position'][0],
                        'opponent up laptime':opUp_lapTime,
                        'opponent up lap delta':opUp_delta,
                        'opponent up faster':opUp_faster,
                        'opponent up gap':opUp_gap,
                        'opponent down laptime':opDown_lapTime,
                        'opponent down lap delta':opDown_delta,
                        'opponent down faster':opDown_faster,
                        'opponent down gap':opDown_gap}
                    for x,y in payload.items():  #replace with POST to webserver
                        print(f'{x}: {y}')
                    print('\n')
                else:
                    pass

def main(rammerId, raceId, debug = False):
    """primary function initialize and crawl RaceMonitor's live updates, process results, and post relevant updates
        Inputs are your team's race number (with #) and the event id, both as strings.  Run loop until killed.  """

    driver = webdriver.Chrome(executable_path=r'C:/py/Rammer/ChromeDriver.exe')
    driver.get(fr'http://api.race-monitor.com/Timing/?raceid={raceId}&source=www.race-monitor.com')

    timeout = 30
    try:
        WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((By.CLASS_NAME,"racerRowWide")))
    except TimeoutException:
        driver.quit()

    def racerParse(html_output):
        """Converts web scraped racer data into pandas dataframe update.
        Input of selenium mined racer row (from class racerRowWide) as raw string.
        Output of dictionary"""
        data = html_output.text.split('\n')

        position = data[0]
        number = data[1].split(' ')[0]
        name = data[1].split(' ')[1]

        laps = data[data.index('Laps:')+1]
        if laps[0].isnumeric() == False:
            laps = '0'

        if laps == '0':
            lapTime = None
            bestLap = None
            bestTime = None
        else:
            # lapTime = time.strptime(data[data.index('Last Time:')+1],'%M:%S.%f') # moved to processing phase of class
            lapTime = data[data.index('Last Time:')+1]
            bestLap = data[data.index('Best Lap:')+1]
            bestTime = data[data.index('Best Time:')+1]

        output = {'number':number, 'name':name, 'position':position, 'laps':laps, 'lapTime':lapTime, 'bestLap':bestLap, 'bestTime':bestTime}#, 'gap':None, 'lead':None}
        return output

    timeRaw = driver.find_elements_by_class_name('racerRowWide')

    initDict = {'number':list(), 'name':list(), 'position':list(), 'laps':list(), 'lapTime':list(), 'bestLap':list(), 'bestTime':list()}#, 'gap':list(), 'lead':list()}
    for i in timeRaw:
        elm = racerParse(i)
        for k,v in elm.items():
            initDict[k].append(v)
    raceMaster= RacerTable(pd.DataFrame(initDict), rammerId)

    if debug == True:
        return raceMaster
    while True:
        for row in timeRaw:
            raceMaster.update(racerParse(row))
            time.sleep(0.01)

if __name__ == "__main__":
    i = main(rammerId = '#645',raceId = '37820', debug=False)
