from selenium.webdriver.common.by import By
from selenium import webdriver
from bs4 import BeautifulSoup
import requests
import json

# 특별관 지점 정보가 바뀌었을 경우 사용
def getSpecialBarchList():
  fields = {"playDe":"20220522"}
  headers = {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'}
  r = requests.post('https://www.megabox.co.kr/on/oh/ohb/PlayTime/selectPlayTimeMasterList.do', data=fields, headers=headers)
  result = json.loads(r.text)

  brchList = []
  for branch in result['areaBrchList']:
    brchList.append(branch['brchNo'])

  specialBrchList = {}

  for brchNo in brchList:
    for type in ['DBC', 'TB', 'MX', 'MKB', 'CFT']:
      fields = {"masterType":"brch","detailType":"spcl","theabKindCd":f"{type}","brchNo":f"{brchNo}","firstAt":"Y","brchNo1":f"{brchNo}","spclbYn1":"Y","theabKindCd1":f"{type}"}
      r = requests.post('https://www.megabox.co.kr/on/oh/ohc/Brch/schedulePage.do', data=fields, headers=headers)
      result = json.loads(r.text)
      if len(result['megaMap']['movieFormList']) > 0:
        if type in specialBrchList.keys():
          specialBrchList[type].append(brchNo)
        else:
          specialBrchList[type] = [brchNo]
      continue

  return specialBrchList

def getMovies():
  specialBrchList = {'CFT': ['1003', '1581', '1311', '1211', '1202', '1351', '0029', '0019', '4451', '4113', '4421', '4291', '4821', '0012', '4462', '4112', '4132', '4041', '4062', '0027', '3021', '0028', '3301', '0013', '0022', '6161', '6312', '6906', '6261', '6262', '6811', '0014', '6121', '5021', '5061'],
                     'MX':  ['1581', '1211', '1331', '4121', '4431', '4651', '4062', '0017', '7011'],
                     'TB':  ['1331', '1371', '1351', '4631', '4104', '4112', '4651', '0028'],
                     'DBC': ['1351', '0019', '0020', '0028'],
                     'MKB': ['4651', '6312', '6121']}
  movieData = {}
  for type in ['DBC', 'TB', 'MX', 'MKB', 'CFT']:
    for brchNo in specialBrchList[type]:
      fields = {"masterType":"brch","detailType":"spcl","theabKindCd":f"{type}","brchNo":f"{brchNo}","firstAt":"Y","brchNo1":f"{brchNo}","spclbYn1":"Y","theabKindCd1":f"{type}"}
      headers = {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'}
      r = requests.post('https://www.megabox.co.kr/on/oh/ohc/Brch/schedulePage.do', data=fields, headers=headers)
      try:
        result = json.loads(r.text)
      except:
        print(f'Error ocuurs in type:{type}, brch:{brchNo}')
        continue
      
      for movie in result['megaMap']['movieFormList']:
        if movie['movieNm'] in movieData.keys():
          if type in movieData[movie['movieNm']][0]:
            continue
          movieData[movie['movieNm']][0].append(type)
        else:
          movieData[movie['movieNm']] = [[type], movie['rpstMovieNo']]

  return movieData

def getMovieInfo(code):
  driver = webdriver.Chrome()
  driver.get('https://megabox.co.kr/movie-detail?rpstMovieNo='+code)
  try:
    posterURL = driver.find_element(by=By.CSS_SELECTOR, value='div.poster > div > img').get_attribute('src')
  except:
    print(f'Cannot find poster element: code:{code}')
    driver.quit()
    return 
  try:
    info = driver.find_element(by=By.CSS_SELECTOR, value='div.movie-info.infoContent').text
    genre = info[info.find("장르"):].split('/')[0].replace(' ', '').split(',')[0].split(':')[1]
  except:
    print(f'Cannot find info element: code:{code}')
    driver.quit()
    return (posterURL, '')

  driver.quit()
  return (genre, posterURL)

print(getMovieInfo('22028500'))

# DBC 돌비시네마
# TB  더 부티크
# MX  MX
# MKB 메가박스 키즈
# CFT 컴포트