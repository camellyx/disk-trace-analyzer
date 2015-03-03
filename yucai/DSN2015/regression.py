#!/usr/bin/env python

import csv
import sys
import numpy as np
import matplotlib.pyplot as plt

pec = []
s = []
o = []

with open('fig6.csv', 'rb') as csvfile:
    data = csv.reader(csvfile, delimiter=',')
    for row in data:
        read = np.array(np.linspace(0, 1000000, 11, endpoint=True)).astype(float)
        pec += [row[0]]
        rber = np.array([float(i) for i in row[1:]])
        z = np.polyfit(read, rber, 1)
        s += [z[0]]
        o += [z[1]]

pec = np.array(pec).astype(float)
sz = np.polyfit(pec, s, 2)
oz = np.polyfit(pec, o, 2)

N = 101
i = 0

reads = np.zeros(N)
baseline_pec = np.zeros(N)
mitigate_pec = np.zeros(N)

with open('yu.csv', 'rb') as csvfile:
    data = csv.reader(csvfile, delimiter=',')
    for row in data:
        trace = row[0]

        read = float(row[1])
        reads[i] = read

        coeff = sz*read + oz - [0, 0, 1e-3]
        root = np.roots(coeff)
        baseline_pec[i] = root[1]

        coeff = sz*read*(0.0045*3/7 + 0.018*4/7) + oz - [0, 0, 1e-3]
        root = np.roots(coeff)
        mitigate_pec[i] = root[1]

        print trace+","+str(baseline_pec[i])+","+str(mitigate_pec[i])
        i += 1



