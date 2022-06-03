# Selenium Webdriver를 구동하려면, chrome driver가 있어야 합니다.
# 맥에 설치된 chrome 버전과 맞는 chrome driver(chromium)을 다운로드 받아 /usr/local/bin 폴더에 저장해주세요.
# https://chromedriver.storage.googleapis.com/index.html

import lottecinema # {name: [[type], genre, posterURL]}
import megabox     # {name: [[type], code]}
import cgv         # {name: [[type], code]}

import datetime
import json

def getMovieData():
  print("데이터 수집을 시작합니다.")

  # lottecinema
  print("롯데시네마에서 영화 목록을 가져옵니다.")
  collectedData = lottecinema.getMovies()

  # megabox
  print("메가박스에서 영화 목록을 가져옵니다.")
  movieDataFromMegabox = megabox.getMovies()
  for name, [types, code] in movieDataFromMegabox.items():
    if name in collectedData.keys():
      collectedData[name][0] += types
    else:
      genre, posterURL = megabox.getMovieInfo(code)
      collectedData[name] = [types, genre, posterURL]

  # cgv
  print("CGV에서 영화 목록을 가져옵니다.")
  movieDataFromCgv = cgv.getMovies()
  for name, [types, code] in movieDataFromCgv.items():
    if name in collectedData.keys():
      collectedData[name][0] += types
    else:
      try:
        genre, posterURL = cgv.getMovieInfo(code)
        collectedData[name] = [types, genre, posterURL]
      except:
        print(f'CGV에서 영화 정보를 가져오는 중 알 수 없는 문제가 발생했습니다. name:{name} code:{code}')
  
  print("수집한 데이터를 올바른 형식으로 변환합니다.")
  date = (datetime.datetime.now() + datetime.timedelta(days=1)).strftime("%Y%m%d")
  tidyData = {}
  tidyData[date] = []
  for name, contents in collectedData.items():
    movie = {}
    movie['name'] = name
    movie['types'] = contents[0]
    movie['genre'] = contents[1]
    if movie['genre'] == '':
      continue
    movie['poster'] = contents[2]
    tidyData[date].append(movie)

  # 변환된 데이터를 json 문자열로 변환합니다.
  json_string = json.dumps(tidyData, indent=2, ensure_ascii=False)

  return json_string

def main():
  movieData = getMovieData()
  print(movieData)

if __name__ == '__main__':
  main()