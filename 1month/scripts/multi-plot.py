#!/usr/bin/env python

import numpy as np
import seaborn as sns
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

sns.set_style({"font.family": "sans-serif"})

# find all files
f, axes = plt.subplots(4, 5, figsize = (16,8), sharex=True, sharey=True)
plt.subplots_adjust(hspace=0.4)
files = glob.glob("*.csv")
fx = 0
fy = 0
for filename in files:
    print filename
    x0 = [1,2,3,4]
    y0 = [0]*100
    y0_day = []
    maxx = 0
    sumx = 0
    csvfile = open(filename, 'rb')
    next(csvfile)
    rows = csv.reader(csvfile)
    for row in rows:
        y0[int(row[0])-1] = int(row[1])
        maxx = max(maxx, int(row[0]))
    for i in range(0,4):
        y0_day.append(0)
        for j in range(0,23):
            y0_day[i] += y0[i*24+j]
            sumx += y0[i*24+j]
    for i in range(0,4):
        if (sumx > 0):
            y0_day[i] = (1.0*y0_day[i])/sumx * 100
    #y0 = y0[:maxx]
    #y0 = np.asarray(y0[:maxx])
    #for i in range(1,maxx+1):
    #    x0.append(i)
    #x0 = np.asarray(x0)
    x0 = np.asarray(x0)
    y0_day = np.asarray(y0_day)
    print x0, y0_day
    #axes[fx,fy].plot(x0,y0_day,label=filename) # line plot
    sns.barplot(x0,y0_day, ci=None, hline = 0, ax=axes[fy,fx])
    #plt.gca().yaxis.set_major_formatter(FuncFormatter(to_percent))
    axes[fy,fx].set_title(filename[9:-4])
    #axes[fy,fx].ticklabel_format(axis='y', style='sci', scilimits=(2,2))
    if (fx == 0):
        axes[fy,fx].set_ylabel("percentage")
    if (fy == 3):
        axes[fy,fx].set_xlabel("days")
    if (maxx == 0):
        axes[fy,fx].set_ylim(0,100)
    fx += 1
    if (fx == 5):
        fx = 0
        fy += 1

#plt.yscale('log')
#plt.legend()
#sns.tsplot(gammas, "timepoint", "subject", "ROI", "BOLD signal")
plt.savefig("multi-plot.pdf", format='pdf')
sys.exit(0)
