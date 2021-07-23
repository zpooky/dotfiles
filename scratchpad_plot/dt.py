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

def realDFT(f, x):
  """
  DFT:
          N-1
    X[k] = ∑ 𝑥[n]e⁻ⁱ²πᵏⁿ/ᴺ
          n=0

  Euler formula:
    e⁻ⁱᵠ = cos(φ) -i⋅sin(φ) = cos(-φ) + i⋅sin(-φ)
  """
  N = len(x)
  result = 0
  for n in range(0, N):
    arg = 2.*π*k*(n/N)
    result += x[n] * np.complex(np.cos(arg), -np.sin(arg))
  return result

start = 0

def plot_signal():
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

def plot_DFT():
  n = np.arange(start, stop)
  ω = 20*π
  x = 2*np.cos(ω*n+π/4)

plot_DFT()
realDFT()
