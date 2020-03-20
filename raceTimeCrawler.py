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

        self.df = df#.astype({'position':int, 'number':str, 'name':str, 'laps':int, 'lapTime':str, 'bestLap':int, 'bestTime':str})
        self.teamId = teamId
        self.teamData = self.df[self.df['number']==self.teamId]
        self.position = self.df[self.df['number']==self.teamId]['position'].item()



    def __repr__(self):
        return print(self.df.head())

    def __str__(self):
        return self.df.head()

    # def updateSplits(self):
    # # maintain & post
    #     #my position/data
    #     #time gap of pos+-
    #     # direction of gap rate of change
    #
    #     myPosition = self.df[self.df["number"]==self.teamId]['position'].item()
    #     if myPosition != '1':
    #         opponentUp = self.df[self.df['postion']==str(int(myPosition)+1)]

    def update(self,row):
        for key in row.keys():
            if row[key] != self.df[self.df['number']==row['number']][key].item():
                print(row['number'],key,row[key])

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
            laps = None

        if laps == None:
            lapTime = None
        else:
            lapTime = time.strptime(data[data.index('Last Time:')+1],'%M:%S.%f')

        bestLap = data[data.index('Best Lap:')+1]

        if lapTime == None:
            bestLap = None

        bestTime = data[data.index('Best Time:')+1]
        if lapTime == None:
            bestTime = None

        output = {'number':number, 'name':name, 'position':position, 'laps':laps, 'lapTime':lapTime, 'bestLap':bestLap, 'bestTime':bestTime, 'gap':None}
        return output

    timeRaw = driver.find_elements_by_class_name('racerRowWide')

    initDict = {'position':list(), 'number':list(), 'name':list(), 'laps':list(), 'lapTime':list(), 'bestLap':list(), 'bestTime':list(), 'gap':list()}
    for i in timeRaw:
        elm = racerParse(i)
        for k,v in elm.items():
            initDict[k].append(v)
    raceMaster= RacerTable(pd.DataFrame(initDict), rammerId)

    return raceMaster, timeRaw
    while True:
        for row in timeRaw:
            raceMaster.update(racerParse(row))
            time.sleep(0.1)

if __name__ == "__main__":
    i,f = main(rammerId = '#4',raceId = '37872')
