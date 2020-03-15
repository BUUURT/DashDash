import requests
#http://api.race-monitor.com/Timing/?raceid=37872&source=www.race-monitor.com

url = r'https://www.api.motorsportreg.com/'
# test = r'rest/tokens/access'
test = r'rest/me'
i = requests.post(url+test)
print(i)
print(i.json())
