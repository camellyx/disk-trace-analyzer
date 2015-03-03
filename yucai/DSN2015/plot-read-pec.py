#!/usr/bin/env python

import csv
import sys
import numpy as np
import matplotlib.pyplot as plt

fig, ax = plt.subplots(1,1,figsize=(16,9))
ax.set_yscale('log')

N = 1000
a = 7.86387e-17
b = 3.38157e-13
c = 6.57322e-11
d = 3.27152e-16
e = 3.68467e-12
f = 1.81963e-9
pec_max = 100000000

pec = np.linspace(1, pec_max, N, endpoint=True)
baseline_read = (1e-3 - d*pec*pec - e*pec - f) / (a*pec*pec + b*pec + c)

ax.plot(baseline_read, pec, ls='-', label="baseline")
ax.plot(baseline_read / 0.0011, pec, ls='--', label="5% Vpass")


ax.set_xlim([0, 200000])
ax.set_ylim([1, 1000000])
plt.legend(loc='upper right', framealpha=0, prop={'size':12})
#plt.savefig('pyplot.pdf', bbox_inches='tight')
plt.show()
