#!/usr/bin/env python

import sys
import matplotlib.pyplot as plt

xmax = 0
fig, (ax1,ax2) = plt.subplots(2, 1, sharex=True, figsize=(7,4))
ax2.set_yscale('log')
ax2.set_ylabel('# writes in 3 days')
ax2.set_xlabel('Data size (GB)')
ax1.set_ylabel('Write count CDF')

ls = ['-', '--', ':']

for j in range(1, len(sys.argv)):

    X = []
    Y = []
    Z = []

    file = open(sys.argv[j])
    
    curx = 0.0
    curz = 0.0
    x = 0
    for freq in file:
        freq = freq.split()[0]
        freq = float(freq) / 20 * 3
        curx += 8.0
        if x == 0 and freq < 3.0:
            x = curx / (2**20)
        curz += freq
        X.append(curx / (2**20))
        Y.append(freq)
        Z.append(curz)
    
    X.append((curx + 8.0) / (2**20))
    Y.append(1e-1)
    Z.append(curz)
    Z = [i/curz for i in Z]

    ax2.plot(X, Y, 'k', ls=ls[j-1],
    label=sys.argv[j].split('/')[-1].split('.')[-3].split('_')[0])
    #ax2.axhline(y=3, ls='--', c='black')
    #ax2.axvline(x=x, ls='--', c='black')
    xmax = max(xmax, (curx + 8) / 2**20)
    ax2.set_xlim([0, xmax])
       
    ax1.plot(X, Z, 'k', ls=ls[j-1])
    #ax1.axvline(x=x, ls='--', c='black')

#plt.show()
ax2.set_ylim([1e-1, 1e3])
plt.legend(loc='upper right', framealpha=0, prop={'size':12})
plt.savefig('pyplot.pdf', bbox_inches='tight')
