# -*- coding: utf-8 -*-
"""
Created on Sun Aug 29 21:09:48 2021

@author: Aakash.R
"""


import requests
import numpy as np
from tqdm import tqdm
import csv
from bs4 import BeautifulSoup
import sys
import logging
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
import selenium
import http.client
#http.client.HTTPConnection.debuglevel = 1
import time


origin1 = ["DEL","SLV","AGR","KUU","DED","DHM","DED","ATQ"];
destin1 = origin1;
baseDataUrl = []
baseDataUrl2 = []
temp= []
trDate = "20211021"
for origin in origin1:
    for destin in destin1:
        if origin!=destin:
            #baseDataUrl.append("https://www.makemytrip.com/flight/search?itinerary="+ origin +"-"+ destin +"-"+ trDate +"&tripType=O&paxType=A-1_C-0_I-0&intl=false&=&cabinClass=E" )
            baseDataUrl.append("https://www.goibibo.com/flights/air-"+origin+"-"+destin+"-"+trDate+"--1-0-0-E-D/" )                               
            temp.append(origin+";"+destin)

temp= []
for origin in origin2:
    for destin in origin2:
        if origin!=destin:
            #baseDataUrl.append("https://www.makemytrip.com/flight/search?itinerary="+ origin +"-"+ destin +"-"+ trDate +"&tripType=O&paxType=A-1_C-0_I-0&intl=false&=&cabinClass=E" )
            baseDataUrl2.append("https://www.goibibo.com/flights/air-"+origin+"-"+destin+"-"+trDate+"--1-0-0-E-D/" )                               
            temp.append(origin+";"+destin)
#url = "https://www.makemytrip.com/flight/search?itinerary=PNQ-MAA-30/08/2021&tripType=O&paxType=A-1_C-0_I-0&intl=false&cabinClass=E&ccde=IN&lang=eng"                        
#url = "https://stackoverflow.com/questions/62599036/python-requests-is-slow-and-takes-very-long-to-complete-http-or-https-request"
# You must initialize logging, otherwise you'll not see debug output.
#logging.basicConfig()
#logging.getLogger().setLevel(logging.DEBUG)
#requests_log = logging.getLogger("requests.packages.urllib3")
#requests_log.setLevel(logging.DEBUG)
#requests_log.propagate = True                               
r = []
#for url in baseDataUrl:
    
#r  += requests.get(url)
#len(baseDataUrl)
j = -1;
for k in tqdm(range(470,484)):
    url = baseDataUrl[k]
    j=k
    #url = "https://www.goibibo.com/flights/air-PNQ-MAA-20210903--1-0-0-E-D/"
    
    driver = webdriver.Chrome()
    driver.implicitly_wait(20)
    html = driver.get(url)
    #element_xpath = '//div[@class="srp-card-uistyles__CardLeft-sc-3flq99-5 bBiAbn"]'
    
    element_xpath = '//div[@class="srp-card-uistyles__CardFooter-sc-3flq99-8 jFjiRJ dF width100 justifyBetween alignItemsEnd"]'
    #element_xpath2 ='//button[@class=srp-card-uistyles__BookButton-sc-3flq99-21 gyWCJl dF justifyCenter alignItemsCenter"]'
    #new_height = driver.execute_script("return document.body.scrollHeight / 2")
    try:
        element = WebDriverWait(driver,4).until(EC.visibility_of_all_elements_located((By.XPATH, element_xpath)))
        
        
        #soup=BeautifulSoup(driver.page_source, 'lxml')
        #soup.findAll("span",{"class":"font22 quicksand black marginB8 marginT20"})
        
    except:
        driver.quit()
        continue
        
    #element = WebDriverWait(driver,10000).until(EC.visibility_of_element_located((By.XPATH, element_xpath2)))
    
    #for j in range(1, 100):
        
    driver.execute_script("window.scrollTo(0, document.body.scrollHeight/5);")
    time.sleep(0.2)
    
    #for j in range(1, 100):
        
    driver.execute_script("window.scrollTo( document.body.scrollHeight/5, 2*document.body.scrollHeight/5);")
    time.sleep(0.2)
    
    #for j in range(1, 100):
        
    driver.execute_script("window.scrollTo(2*document.body.scrollHeight/5, 3*document.body.scrollHeight/5);")
    time.sleep(0.2)
    
    driver.execute_script("window.scrollTo(3*document.body.scrollHeight/5, 4*document.body.scrollHeight/5);")
    time.sleep(0.2)    
      
    soup=BeautifulSoup(driver.page_source, 'lxml')
    driver.quit() 
    
    #print(soup.prettify())
    flight_names = soup.findAll("span",{"class":"font14 padL5 black"})
    
    flight_start_time = soup.findAll("span",{"class":"srp-card-uistyles__Time-sc-3flq99-15 PUNzz padT5 fb"})
    flight_end_time = soup.findAll("span",{"class":"srp-card-uistyles__Time-sc-3flq99-15 PUNzz fb"})
    flight_duration_time = soup.findAll("span",{"class":"srp-card-uistyles__DurTime-sc-3flq99-16 grhOtk fb padT5"})
    price = soup.findAll("div",{"class":"srp-card-uistyles__Price-sc-3flq99-17 kvQzRp alignItemsCenter dF fb"})
    with open('webscrap_flight.txt', 'a', encoding="utf-8") as f:
        for i in range(len(flight_start_time)) :
            try:
                f.write(temp[j]+";"+flight_names[i].text +";"+ flight_start_time[i].text +";"+ flight_end_time[i].text +";"+ flight_duration_time[i].text+";"+price[i].text)
            except:
                pass
                
            f.write("\n")
            
    
    
    f.close()
    

