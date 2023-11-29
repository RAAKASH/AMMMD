# -*- coding: utf-8 -*-
"""
Created on Tue Aug 31 21:07:27 2021

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


#origin1 = ["DEL","SLV","AGR","KUU","DED","DHM","DED","ATQ"];
origin1 = ["NDLS","KLK","AGC","HW","ASR","CDG","BSB","MTJ","LJN","JP","UHL","JSM","JU","ABR","MAS","CHTS","SBC","HYB","VSKP","HWH","GHY","RNGPO","SGUJ"]
origin2 = ["NDLS","KLK","AGC","DDN","PTK","RMR","HW","ASR","CDG","KGM","BSB","MTJ","LJN","JP","UHL","JSM","JU","ABR","VSG","MAS","CHTS","SBC","HYB","VSKP","HWH","GHY","RNGPO","SGUJ"];

destin1 = origin1;
baseDataUrl = []
baseDataUrl2 = []
temp= []
trDate = "20211021"
for origin in origin1:
    for destin in destin1:
        if origin!=destin:
            #baseDataUrl.append("https://www.makemytrip.com/flight/search?itinerary="+ origin +"-"+ destin +"-"+ trDate +"&tripType=O&paxType=A-1_C-0_I-0&intl=false&=&cabinClass=E" )
            baseDataUrl.append("https://railways.makemytrip.com/railways/listing/?classCode=3A&className=3ACs%20Classes&date="+trDate+"&destStn="+origin+"&srcStn="+destin)                               
            temp.append(origin+";"+destin)
temp= []
for origin in origin2:
    for destin in origin2:
        if origin!=destin:
            #baseDataUrl.append("https://www.makemytrip.com/flight/search?itinerary="+ origin +"-"+ destin +"-"+ trDate +"&tripType=O&paxType=A-1_C-0_I-0&intl=false&=&cabinClass=E" )
            baseDataUrl2.append("https://railways.makemytrip.com/railways/listing/?classCode=3A&className=3ACs%20Classes&date="+trDate+"&destStn="+origin+"&srcStn="+destin)                               
            temp.append(origin+";"+destin)

 # %% Section-2

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
j = -1;
for k in tqdm(range(706,len(baseDataUrl2))):
    url = baseDataUrl2[k]
    j=k
    if url in baseDataUrl:
        continue
    #url = "https://www.goibibo.com/flights/air-PNQ-MAA-20210903--1-0-0-E-D/"
    
    driver = webdriver.Chrome()
    driver.implicitly_wait(20)
    html = driver.get(url)
    #element_xpath = '//div[@class="srp-card-uistyles__CardLeft-sc-3flq99-5 bBiAbn"]'
    
    #element_xpath = '//div[@class="srp-card-uistyles__CardFooter-sc-3flq99-8 jFjiRJ dF width100 justifyBetween alignItemsEnd"]'
    element_xpath = '//div[@class="train-name"]'
    #element_xpath2 ='//button[@class=srp-card-uistyles__BookButton-sc-3flq99-21 gyWCJl dF justifyCenter alignItemsCenter"]'
    #new_height = driver.execute_script("return document.body.scrollHeight / 2")
    try:
        element = WebDriverWait(driver,2).until(EC.visibility_of_all_elements_located((By.XPATH, element_xpath)))
        
        
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
    #train_names = soup.findAll("div",{"class":"train-name"})
    
    #train_start_time = soup.findAll("div",{"class":"depart-time"})
    #train_end_time = soup.findAll("div",{"class":"arrival-time"})
    #train_duration_time = soup.findAll("span",{"duration"})
    #price = soup.findAll("div",{"class":"ticket-price justify-flex-end"})
    #rail_class = soup.findAll("div",{"class":"rail-class"})
    trains = soup.findAll("div",{"class":"single-train-detail"})
    
    
    with open('webscrap2.txt', 'a', encoding="utf-8") as f:
        for i in range(len(trains)) :
            
                for m in trains[i].findAll("div",{"class":"card"}):
                    try: 
                        f.write(temp[j]+";"+trains[i].findAll("div",{"class":"train-name"})[0].text +";"+m.findAll("div",{"class":"rail-class"})[0].text+";"+trains[i].findAll("div",{"class":"depart-time"})[0].text +";"+ trains[i].findAll("div",{"class":"arrival-time"})[0].text +";"+ trains[i].findAll("span",{"duration"})[0].text+";"+m.findAll("div",{"class":"ticket-price justify-flex-end"})[0].text)
                        f.write("\n")
                    except:
                        pass
                    
                    continue
               
            
    
    
    f.close()