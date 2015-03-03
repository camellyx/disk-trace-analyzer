#!/usr/bin/env python

import csv
import sys
import numpy as np
import matplotlib.pyplot as plt

fig, ax = plt.subplots(1,1,figsize=(16,9))
ax.set_yscale('log')

with open('yu.csv', 'rb') as csvfile:
    data = csv.reader(csvfile, delimiter=',')
    for row in data:
        baseline_label = row[0]
        mitigate_label = row[0]+"_miti"
        baseline_read = float(row[1])
        mitigate_read = float(row[2])

        N = 10000
        a = 7.86387e-17
        b = 3.38157e-13
        c = 6.57322e-11
        d = 3.27152e-16
        e = 3.68467e-12
        f = 1.81963e-9
        pec_max = 1000000
        
        pec = np.linspace(0, pec_max, N, endpoint=True)
        baseline_rber = a*pec*pec*baseline_read + b*pec*baseline_read + c*baseline_read + d*pec*pec + e*pec + f
        mitigate_rber = a*pec*pec*mitigate_read + b*pec*mitigate_read + c*mitigate_read + d*pec*pec + e*pec + f
        
        ax.plot(pec, baseline_rber, ls='-', label=baseline_label)
        ax.plot(pec, mitigate_rber, ls='--', label=mitigate_label)


ax.set_xlim([0, pec_max])
ax.set_ylim([0, 2e-3])
plt.legend(loc='upper right', framealpha=0, prop={'size':12})
#plt.savefig('pyplot.pdf', bbox_inches='tight')
plt.show()
