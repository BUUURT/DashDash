import time

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException

class Racer:
    def __init__(self,name,position,laps,lastTime,bestLap,bestTime,diff,gap):
        self.name = name
        self.position = position
        self.laps = laps
        self.lastTime = lastTime
        self.bestLap = bestLap
        self.bestTime = bestTime
        self.diff = diff
        self.gap = gap

    def __str__(self):
        return str(self.name,self.position)

    def __repr__(self):
        return str(self.name,self.position)


driver = webdriver.Chrome(executable_path=r'C:/py/ChromeDriver.exe')
driver.get(r'http://api.race-monitor.com/Timing/?raceid=37872&source=www.race-monitor.com')

timeout = 30
try:
    WebDriverWait(driver, timeout).until(EC.visibility_of_element_located((By.CLASS_NAME,
    "racerRowWide")))
except TimeoutException:
    driver.quit()

racerSet = set()
timeList = driver.find_elements_by_class_name('racerRowWide')
for racer in timeList:
    print(racer.text)
    # time.sleep(0.01)
