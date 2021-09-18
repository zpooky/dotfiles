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
π2 = π*2.


def find_period(ω):
  N = π2 / ω
  T = 1
  while not (T * N).is_integer():
    T = T + 1
  return int(T * N)


def magnitude(z):
  """
  z = x + yi
         _____
  |z| = √x²+y²
  """
  return math.sqrt(math.pow(z.real, 2.) + math.pow(z.imag, 2.))


def DFT(k, x):
  """
  DFT:
          N-1
    X[k] = ∑ x[n]e⁻ⁱ²πᵏⁿ/ᴺ
          n=0

  Euler formula:
    e⁻ⁱᵠ = cos(φ) -i⋅sin(φ) = cos(-φ) + i⋅sin(-φ)
  """
  N = len(x)
  result = complex(0, 0)

  for n in range(0, N):
    arg = π2 * float(k) * (float(n) / float(N))
    result += x[n] * complex(np.cos(arg), -np.sin(arg))

  return result


def plot_signal():
  # ω = np.pi*(1./8.)
  # ω = np.pi
  # ω = (4*np.pi)/5
  # ω = π / 4
  ω = np.pi / 4
  period = find_period(ω)
  print("period: {}".format(period))
  if period < 200:
    n = np.arange(0, period)
  else:
    stop = 8
    n = np.arange(0, stop)
  x = np.cos(ω * n)

  plt.xlabel('n')
  plt.ylabel('x[n]')
  plt.stem(n, x)
  plt.show()


def plot_DFT():
  Fₛ = 50
  Tₛ = 1. / Fₛ
  X = [0] * Fₛ

  n = np.arange(0, Fₛ)
  ω = 20 * π
  x = 2 * np.cos(ω*n + π/4)

  for k in range(0, Fₛ):
    X[k] = DFT(k, x)

  # k = np.linspace(0, 1, Fₛ)

  X = list(map(lambda z: magnitude(z), X))

  plt.xlabel('k')
  plt.ylabel('X[k]')
  plt.stem(n, X)
  plt.show()


plot_DFT()
