# Selenium Webdriver를 구동하려면, chrome driver가 있어야 합니다.
# 맥에 설치된 chrome 버전과 맞는 chrome driver(chromium)을 다운로드 받아 /usr/local/bin 폴더에 저장해주세요.
# https://chromedriver.storage.googleapis.com/index.html

import lottecinema # {name: [[type], genre, posterURL]}
import megabox     # {name: [[type], code]}
import cgv         # {name: [[type], code]}

def getMovieData():
  print("데이터 수집을 시작합니다.")

  # lottecinema
  print("롯데시네마...")
  movieData = lottecinema.getMovies()

  # megabox
  print("메가박스...")
  movieDataFromMegabox = megabox.getMovies()
  for name, [types, code] in movieDataFromMegabox.items():
    if name in movieData.keys():
      movieData[name][0] += types
    else:
      genre, posterURL = megabox.getMovieInfo(code)
      movieData[name] = [types, genre, posterURL]

  # cgv
  print("씨지브이...")
  movieDataFromCgv = cgv.getMovies()
  for name, [types, code] in movieDataFromCgv.items():
    if name in movieData.keys():
      movieData[name][0] += types
    else:
      genre, posterURL = cgv.getMovieInfo(code)
      movieData[name] = [types, genre, posterURL]
  
  print("데이터 수집을 완료했습니다..")
  return movieData

def main():
  movieData = getMovieData()
  for name, contents in movieData.items():
    print(name, contents)

if __name__ == '__main__':
  main()