#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import math
import binascii
import hashlib
import random
from operator import xor
import numpy as np
import scipy
import matplotlib.pyplot as plt
import socket

sys.setrecursionlimit(1500)

π = np.pi


def find_period(ω):
  N = (2.*π) / ω
  T = 1
  while not (T * N).is_integer():
    T = T + 1
  return int(T * N)


start = 0

# ω = np.pi*(1./8.)
# ω = np.pi
# ω = (4*np.pi)/5
# ω = π / 4
ω = np.pi/4
period = find_period(ω)
print("period: {}".format(period))
if period < 200:
  n = np.arange(start, start + period)
else:
  stop = 8
  n = np.arange(start, stop)
x = np.cos(ω * n)

plt.xlabel('n')
plt.ylabel('x[n]')
plt.stem(n, x)
plt.show()
