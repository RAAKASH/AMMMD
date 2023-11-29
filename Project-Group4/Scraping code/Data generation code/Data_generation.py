# -*- coding: utf-8 -*-
"""
Created on Wed Sep  1 19:47:41 2021

@author: aakash
"""
import numpy as np
cities = 4;
nodes = cities*(cities-1)*3; #5 paths beween every pair of cities
Costs = np.zeros((nodes,nodes))


