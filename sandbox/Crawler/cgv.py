from selenium.webdriver.common.by import By
from selenium import webdriver
import time

REGION_CODES = {'IMAX': '07',
                '4DX': '4D14',
                'SCREENX': 'SCX',
                '4DX SCREEN': '4DXSC',
                'SUITE CINEMA': 'SC',
                'CINE de CHEF': '103',
                'TEMPUR CINEMA': 'TEM',
                'GOLD CLASS': '99',
                'SKYBOX': 'SKY',
                'THE PRIVATE CINEMA': 'pc',
                'CINE & FORET': 'CF',
                'CINE&LIVING ROOM': 'LM',
                'CINE KIDS': 'CK',
                'STARIUM': '110',
                'SphereX': 'SPX',
                'SOUNDX': 'SDX',
                'PREMIUM': 'PRM', 
                'SWEETBOX': '09'}

THEATER_CODES = {'IMAX': ['0257', '0090', '0007', '0005', '0143', '0012', '0074', '0013', '0128', '0113', '0002', '0054', '0179', '0079', '0199', '0070', '0181'],
                 '4DX': ['0001', '0043', '0257', '0218', '0090', '0028', '0108', '0007', '0127', '0041', '0265', '0015', '0046', '0005', '0089', '0088', '0012', '0150', '0160', '0211', '0112', '0292', '0059', '0074', '0013', '0128', '0002', '0054', '0213', '0302', '0055', '0131', '0023', '0293', '0110', '0107', '0142', '0181', '0052'],
                 'SCREENX': ['0056', '0139', '0043', '0193', '0090', '0010', '0028', '0216', '0007', '0202', '0042', '0106', '0265', '0011', '0015', '0194', '0046', '0005', '0219', '0089', '0088', '0012', '0150', '0160', '0211', '0112', '0029', '0059', '0004', '0074', '0013', '0128', '0246', '0144', '0113', '0002', '0054', '0213', '0179', '0055', '0131', '0079', '0110', '0199', '0070', '0181', '0195', '0052', '0045', '0191'],
                 'SUITE CINEMA': ['0303', '0292'],
                 'CINE de CHEF': ['0089', '0040', '0013'],
                 'TEMPUR CINEMA': ['0089', '0040', '0112', '0013', '0181'],
                 'GOLD CLASS': ['0059', '0004', '0074', '0013', '0128'],
                 'SKYBOX': ['0013'],
                 'CINE & FORET': ['0001', '0295', '0147', '0041', '0015', '0054', '0293'],
                 'CINE&LIVING ROOM': ['0074'],
                 'CINE KIDS': ['0164'],
                 'STARIUM': ['0089', '0059'],
                 'SphereX': ['0088', '0059', '0199'],
                 'SOUNDX': ['0112', '0059', '0205', '0107'],
                 'PREMIUM': ['0040', '0013', '0205', '0107', '0235'],
                 'SWEETBOX': ['0056', '0139', '0001', '0043', '0218', '0090', '0010', '0053', '0028', '0207', '0108', '0147', '0109', '0007', '0154', '0127', '0151', '0042', '0041', '0106', '0265', '0033', '0009', '0105', '0011', '0015', '0194', '0049', '0030', '0091', '0083', '0219', '0089', '0088', '0012', '0114', '0150', '0160', '0211', '0003', '0029', '0059', '0004', '0074', '0013', '0128', '0113', '0205', '0020', '0002', '0054', '0027', '0055', '0079', '0044', '0110', '0107', '0142', '0070', '0195', '0052', '0045', '0253', '0115']}

def getRegionCodes():
  REGION_CODES = {}
  options = webdriver.ChromeOptions()
  options.add_argument("headless")
  driver = webdriver.Chrome(options=options)
  driver.get('http://www.cgv.co.kr/theaters/special')

  nextButton = driver.find_element(by=By.CSS_SELECTOR, value='button.btn-next')
  for i in range(0, 11):
    nextButton.click()
    time.sleep(3)
    types = driver.find_elements(by=By.CSS_SELECTOR, value='#contents div.item > a')
    for type in types:
      typeName = type.text
      regionCode = type.get_attribute('href').split('=')[-1]
      REGION_CODES[typeName] = regionCode
  driver.quit()
  return REGION_CODES

def getTheaterCodes():
  THEATER_CODES = {}
  options = webdriver.ChromeOptions()
  options.add_argument("headless")
  driver = webdriver.Chrome(options=options)
  for region, code in REGION_CODES.items():
    driver.get(f'http://www.cgv.co.kr/theaters/special/?regioncode={code}')
    try:
      buttons = driver.find_elements(by=By.CSS_SELECTOR, value='div.submenu > ul > li > a')
      for button in buttons:
        if button.text.find('상영시간표') == -1:
          button = None
        else:
          button.click()
          break
      if button == None:
        continue
    except:
      continue
    theaters = driver.find_elements(by=By.CSS_SELECTOR, value='div.wrap-theaterlist > ul > li > a')
    for theater in theaters:
      theaterCode = theater.get_attribute('href').split('=')[-1]
      if region in THEATER_CODES.keys():
        THEATER_CODES[region].append(theaterCode)
      else:
        THEATER_CODES[region] = [theaterCode]
    driver.quit()
    return THEATER_CODES

def getMovies():
  movieData = {}
  driver = webdriver.Chrome()
  for region, regionCode in REGION_CODES.items():
    if not(region in THEATER_CODES.keys()):
      continue
    for theaterCode in THEATER_CODES[region]:
      driver.get(f'http://www.cgv.co.kr/theaters/special/show-times.aspx?regioncode={regionCode}&theatercode={theaterCode}')
      try:
        iframe = driver.find_element(by=By.CSS_SELECTOR, value='#ifrm_movie_time_table')
      except:
        print(f'해당 특별관에 상영 예정인 영화가 없습니다. regionCode:{regionCode}, theaterCode:{theaterCode}')
        continue
      driver.switch_to.frame(iframe)
      try:
        driver.find_element(by=By.CSS_SELECTOR, value='#slider > div:nth-child(1) > ul > li:nth-child(2) > div > a').click()
      except:
        print(f'해당 특별관에 대한 시간표가 없습니다. regionCode:{regionCode}, theaterCode:{theaterCode}')
        continue
      movies = driver.find_elements(by=By.CSS_SELECTOR, value='body > div > div.sect-showtimes > ul > li > div > div.info-movie > a')
      for movie in movies:
        movieName = movie.text

        if movieName.find('GV') != -1:
          continue

        colonIdx = movieName.find(':')
        if colonIdx != -1 and colonIdx > 0 and colonIdx < len(movieName) - 1:
          if movieName[colonIdx + 1] == ' ':
            movieName = movieName[:colonIdx + 1] + movieName[colonIdx + 2:]
          if movieName[colonIdx - 1] == ' ':
            movieName = movieName[:colonIdx - 1] + movieName[colonIdx:]

        dashIdx = movieName.find('-')
        if dashIdx != -1 and dashIdx > 0 and dashIdx < len(movieName) - 1:
          movieName = movieName.replace('-', ':')
          if movieName[dashIdx + 1] == ' ':
            movieName = movieName[:dashIdx + 1] + movieName[dashIdx + 2:]
          if movieName[dashIdx - 1] == ' ':
            movieName = movieName[:dashIdx - 1] + movieName[dashIdx:]

        movieId = movie.get_attribute('href').split('=')[-1]
        if movieName in movieData.keys():
          if region in movieData[movieName][0]:
            continue
          movieData[movieName][0].append(region)
        else:
          movieData[movieName] = [[region], movieId]
  driver.quit()
  return movieData

def getMovieInfo(code):
  print(f'CGV에서 영화 정보를 수집합니다. {code}.')  
  driver = webdriver.Chrome()
  driver.get('http://www.cgv.co.kr/movies/detail-view/?midx=' + code)
  posterURL = driver.find_element(by=By.CSS_SELECTOR, value='#select_main > div.sect-base-movie > div.box-image > a > span > img').get_attribute('src')
  info = driver.find_element(by=By.CSS_SELECTOR, value='#select_main > div.sect-base-movie > div.box-contents > div.spec').text
  genre = info[info.find("장르"):].split('/')[0].replace('\n', '').replace(' ', '').split(',')[0].split(':')[1]
  return (genre, posterURL)