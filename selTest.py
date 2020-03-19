##technical debt: # initialization parameters (event ID, racer ID)
    # API push
    # race processing 
import time

import pandas as pd

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

rammerId = '#4'

class RacerTable:
    def __init__(self,df,teamId):
        self.df = df
        self.teamId = teamId

    def __repr__(self):
        return self.df.head()

    def __str__(self):
        return self.df.head()

    def update(self,row):
        for key in row.keys():
            if row[key] != self.df[self.df['number']==row['number']][key].item():
                print(row['number'],key,row[key])



driver = webdriver.Chrome(executable_path=r'C:/py/Rammer/ChromeDriver.exe')
driver.get(r'http://api.race-monitor.com/Timing/?raceid=37872&source=www.race-monitor.com')

timeout = 30
try:
    WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((By.CLASS_NAME,
    "racerRowWide")))
except TimeoutException:
    driver.quit()

def racerParse(html_output):
    """Converts web scraped racer data into pandas dataframe update.
    Input of selenium mined racer row (from class racerRowWide) as raw string.
    Output of dictionary"""
    data = html_output.text.split('\n')


    number = data[1].split(' ')[0]
    name = data[1].split(' ')[1]

    laps = data[data.index('Laps:')+1]
    if laps[0].isnumeric() == False:
        laps = None

    lapTime = data[data.index('Last Time:')+1]
    if lapTime[0].isnumeric == False:
            lapTime = None

    bestLap = data[data.index('Best Lap:')+1]
    if bestLap[0].isnumeric == False:
        bestLap = None

    bestTime = data[data.index('Best Time:')+1]
    if bestTime[0].isnumeric() == False:
        bestTime = None

    output = {'number':number, 'name':name, 'laps':laps, 'lapTime':lapTime, 'bestLap':bestLap, 'bestTime':bestTime}
    return output

timeRaw = driver.find_elements_by_class_name('racerRowWide')

initDict = {'number':list(), 'name':list(), 'laps':list(), 'lapTime':list(), 'bestLap':list(), 'bestTime':list()}
for i in timeRaw:
    elm = racerParse(i)
    for k,v in elm.items():
        initDict[k].append(v)
raceMaster= RacerTable(pd.DataFrame(initDict), rammerId)

while True:
    for row in timeRaw:
        raceMaster.update(racerParse(row))
        time.sleep(0.1)
