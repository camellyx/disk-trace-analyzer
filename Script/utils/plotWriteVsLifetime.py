#!/usr/bin/env python

import matplotlib.pyplot as plt
from matplotlib.lines import Line2D
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages

# plot line

w = np.arange(0.1, 10.0, 0.01) # writes per day

l3d = 150000.0 / (w/512/1024/1024*4 + 1.0/3)        # 3-day refresh lifetime
l3w =  20000.0 / (w/512/1024/1024*4 + 1.0/3/7)      # 3-week refresh lifetime
l3m =   8000.0 / (w/512/1024/1024*4 + 1.0/3/30)     # 3-month refresh lifetime
l3y =   3000.0 / (w/512/1024/1024*4 + 1.0/3/365)    # 3-year refresh lifetime

l3dn = 150000.0 / (w/512/1024/1024*4)    # 3-day refresh lifetime
l3wn =  20000.0 / (w/512/1024/1024*4)    # 3-week refresh lifetime
l3mn =   8000.0 / (w/512/1024/1024*4)    # 3-month refresh lifetime
l3yn =   3000.0 / (w/512/1024/1024*4)    # 3-year refresh lifetime

plt.figure(figsize=(16,4))
fig, ax = plt.subplots(1, 4, sharey=True)

ax[0].plot(w, l3d, 'k')
ax[1].plot(w, l3w, 'k')
ax[2].plot(w, l3m, 'k')
ax[3].plot(w, l3y, 'k')

ax[0].plot(w, l3dn, 'k')
ax[1].plot(w, l3wn, 'k')
ax[2].plot(w, l3mn, 'k')
ax[3].plot(w, l3yn, 'k')

ax[0].fill_between(w, l3d, l3dn, facecolor='b')
ax[1].fill_between(w, l3w, l3wn, facecolor='b')
ax[2].fill_between(w, l3m, l3mn, facecolor='b')
ax[3].fill_between(w, l3y, l3yn, facecolor='b')

pp = PdfPages('WriteVsLifetime.pdf')
plt.savefig(pp, format='pdf')
pp.close()
