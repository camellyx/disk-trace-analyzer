#!/usr/bin/env python

import numpy as np
#import seaborn as sns
import matplotlib.pyplot as plt
import csv as csv
import sys as sys
import os as os
import glob as glob
from matplotlib.ticker import ScalarFormatter
from matplotlib.ticker import FuncFormatter

def to_percent(y, position=0):
    # Ignore the passed in position. This has the effect of scaling the default
    # tick locations.
    s = str(100 * y)

    # The percent symbol needs escaping in latex
    if matplotlib.rcParams['text.usetex'] == True:
        return s + r'$\%$'
    else:
        return s + '%'

#sns.set_style({"font.family": "sans-serif"})
fsize = 10 # font size
bwidth = 0.5 # bar width

# find all files
f, axes = plt.subplots(1, figsize = (12,8))
files = glob.glob("*.csv")
files = sorted(files)
fx = 0
fy = 0
x0 = [1,2,3,4]
y0_day = [0]*4
sumx = 0

for filename in files:
    print filename
    y0 = [0]*100
    csvfile = open(filename, 'rb')
    next(csvfile)
    rows = csv.reader(csvfile)
    for row in rows:
        y0[int(row[0])-1] = int(row[1])
    for i in range(0,4):
        for j in range(0,23):
            y0_day[i] += y0[i*24+j]
            sumx += y0[i*24+j]

for i in range(0,4):
    y0_day[i] = (1.0*y0_day[i])/sumx * 100

x0 = np.asarray(x0)
y0_day = np.asarray(y0_day)
print x0, y0_day
axes.bar(x0,y0_day,width=bwidth)
axes.set_title(filename[9:-4].replace("msrcambridge","msrcamb"), fontsize=fsize)
axes.tick_params(axis='both', labelsize=fsize)
axes.tick_params(axis='x',which='both',bottom='off',top='off')
axes.tick_params(axis='y',which='both',left='off',right='off')
axes.set_ylabel("percentage", fontsize=fsize)
axes.set_xlabel("days", fontsize=fsize)
axes.spines['top'].set_visible(False)
axes.spines['right'].set_visible(False)

#plt.yscale('log')
#plt.legend()
#sns.tsplot(gammas, "timepoint", "subject", "ROI", "BOLD signal")
plt.xticks(x0 + bwidth/2, [1,2,3,'4+'])
plt.savefig("combined-plot.pdf", format='pdf')
sys.exit(0)
