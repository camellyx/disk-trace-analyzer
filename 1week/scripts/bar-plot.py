#!/usr/bin/env python

import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
import csv as csv
import sys as sys
import os as os

# get numbers
x0 = []
y0 = [0]*100
maxx = 0
filename = sys.argv[1]
csvfile = open(filename, 'rb')
next(csvfile)
rows = csv.reader(csvfile)
for row in rows:
    y0[int(row[0])-1] = int(row[1])
    maxx = max(maxx, int(row[0]))
if (maxx == 0):
    sys.exit(0)
y0 = np.asarray(y0[:maxx])
#print y0
for i in range(1,maxx+1):
    x0.append(i)
x0 = np.asarray(x0)

sns.set(style="white", context="talk")
sns.set_style({"font.family": "sans-serif"})
rs = np.random.RandomState(7)

#x = np.array(list("ABCDEFGHI"))

f, ax0 = plt.subplots(1, 1, figsize=(8, 6), sharex=False)

sns.barplot(x0, y0, ci=None, palette="BuPu_d", hline=0, ax=ax0)
ax0.set_ylabel("Write interval (hour)")

sns.despine(bottom=True)
plt.setp(f.axes, yticks=[])
plt.tight_layout(h_pad=3)

plt.savefig(os.path.splitext(filename)[0] + ".pdf", format='pdf')
#plt.show()
