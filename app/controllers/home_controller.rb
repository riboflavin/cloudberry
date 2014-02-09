class HomeController < ApplicationController

  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'

  Codes = {
    0 => ['tornado', 0],
    1 => ['tropical storm', 100],
    2 => ['hurricane', 100],
    3 => ['severe thunderstorms', 100],
    4 => ['thunderstorms', 100],
    5 => ['mixed rain and snow', 90],
    6 => ['mixed rain and sleet', 90],
    7 => ['mixed snow and sleet', 90],
    8 => ['freezing drizzle', 80],
    9 => ['drizzle', 50],
    10 => ['freezing rain', 60],
    11 => ['showers', 70],
    12 => ['showers', 70],
    13 => ['snow flurries', 30],
    14 => ['light snow showers', 30],
    15 => ['blowing snow', 20],
    16 => ['snow', 40],
    17 => ['hail', 60],
    18 => ['sleet', 60],
    19 => ['dust', 0],
    20 => ['foggy', 30],
    21 => ['haze', 0],
    22 => ['smoky', 0],
    23 => ['blustery', 0],
    24 => ['windy', 0],
    25 => ['cold', 0],
    26 => ['cloudy', 20],
    27 => ['mostly cloudy (night)', 20],
    28 => ['mostly cloudy (day)', 20],
    29 => ['partly cloudy (night)', 20],
    30 => ['partly cloudy (day)', 20],
    31 => ['clear (night)', 0],
    32 => ['sunny', 0],
    33 => ['fair (night)', 0],
    34 => ['fair (day)', 0],
    35 => ['mixed rain and hail', 70],
    36 => ['hot', 0],
    37 => ['isolated thunderstorms', 50],
    38 => ['scattered thunderstorms', 50],
    39 => ['scattered thunderstorms', 50],
    40 => ['scattered showers', 40],
    41 => ['heavy snow', 90],
    42 => ['scattered snow showers', 60],
    43 => ['heavy snow', 90],
    44 => ['partly cloudy', 20],
    45 => ['thundershowers', 50],
    46 => ['snow showers', 50],
    47 => ['isolated thundershowers', 40],
    3200 => ['not available', 0]
  }

  def index
  url = "http://weather.yahooapis.com/forecastrss?w=" + params[:loc] 
  src = Nokogiri::XML(open(url));

  doc = {
    #'full' => src.xpath("//channel").to_s,
    'forecast' => src.xpath("//yweather:forecast")[0].to_s,
    'date' => src.xpath("//yweather:forecast")[0].attr('date').to_s,
    'low' => src.xpath("//yweather:forecast")[0].attr('low').to_i,
    'high' => src.xpath("//yweather:forecast")[0].attr('high').to_i,
    'code' => src.xpath("//yweather:forecast")[0].attr('code').to_i,
    'where' => src.xpath("//yweather:location")[0].attr('city').to_s,
    'loc' => params[:loc]
  }

  #we only have two digits, so if a number is less than 0 or greater than 99, clip
  doc['low'] = [doc['low'],0].max
  doc['low'] = [doc['low'],99].min
  doc['high'] = [doc['high'],0].max
  doc['high'] = [doc['high'],99].min

  #look up code in chance table
  doc['chance'] = Codes[doc['code']][1]

  #we need two digits, so if a number is less than 11, add a zero at the beginning
  doc['low'] < 11 ? doc['low'] = '0' + doc['low'].to_s : doc['low'] = doc['low'].to_s
  doc['high'] < 11 ? doc['high'] = '0' + doc['high'].to_s : doc['high'] = doc['high'].to_s
  doc['chance'] < 11 ? doc['chance'] = '0' + doc['chance'].to_s : doc['chance'] = doc['chance'].to_s

  if params[:format] == 'short' 
    render :text => (doc['low'] + ',' + doc['high'] + ',' + doc['chance']) 
  else
    render :json => doc
  end

  end

end