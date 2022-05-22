import requests
import json

def getMovies():
  fields = {
    "MethodName":"GetMoviesToBe",
    "channelType":"HO",
    "osType":"Safari",
    "osVersion":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Safari/605.1.15",
    "multiLanguageID":"KR",
    "division":"1",
    "moviePlayYN":"Y",
    "orderType":"1",
    "blockSize":"100",
    "pageNo":"1",
    "memberOnNo":""
  }
  data = {"paramList": str(fields).encode()}
  headers = {'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'}
  r = requests.post('https://www.lottecinema.co.kr/LCWS/Movie/MovieData.aspx', data=data, headers=headers)
  result = json.loads(r.text)

  movies = result['Movies']['Items']
  movieData = {}
  for movie in movies:
    if movie["SpecialScreenDivisionCode"] == None:
      continue
    if movie["SpecialScreenDivisionCode"][0] == '':
      continue
    movieData[movie["MovieNameKR"]] = [movie["SpecialScreenDivisionCode"], movie["MovieGenreName"], movie["PosterURL"]]

  return movieData

# 200 씨네커플
# 400 아르뗴
# 300 샤롯데
# 301 샤롯데 프라이빗
# 930 수퍼 4D
# 940 수퍼플렉스
# 941 수퍼플렉스 G
# 950 씨네비즈
# 960 씨네패밀리
# 980 수퍼 S
# 986 씨네콤포트(리클라이너)
# 987 씨네살롱
# 988 컬러리움

# {name: [type  , genre, posterURL]}
# 장르와 포스터는 롯데시네마에서만 빼오기