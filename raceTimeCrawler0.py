##technical debt: # initialization parameters (event ID, racer ID)
    # API push
    # race processing
    # chrome version/install location issues
    # parse racer class
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

        self.position = self.df[self.df['number']==self.teamId].index[0]
        self.opponentUp = lambda x : self.df.loc[str(int(self.position)-1)]['number'] if (self.position != '1') else None
        self.opponentDown = self.df.loc[str(int(self.position)+1)]['number']


    def __repr__(self):
        return print(self.df.head())

    def __str__(self):
        return self.df.head()

    def update(self,row):
        """receives parsed row as a pandas series
        Determines if row reflects a new lap.  If so:
        - incorporate changes into master dataframe
        - calculate new gap
        - if update reflects opponent or self, post new values to display"""

        # print(self.df[self.df['number']==row['number']]['laps'])
        if len(self.df[self.df['number']==row['number']]['laps']) != 0:
            if self.df[self.df['number']==row['number']]['laps'][0] != row['laps'] :
                for key in row.keys():
                    self.df.at[row['position'], key] = row[key]
                if row['number'] == self.teamId or row['number'] == self.opponentUp or row['number'] == self.opponentDown:
                    for x,y in row.items():
                        print(f'{x}: {y}')
                    print('\n')


def main(rammerId, raceId):
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

#    return raceMaster, timeRaw, racerParse
    while True:
        for row in timeRaw:
            raceMaster.update(racerParse(row))
            time.sleep(0.1)

if __name__ == "__main__":
#    main(rammerId = '#3',raceId = '37872')
    i,f,r = main(rammerId = '#3',raceId = '37872')
