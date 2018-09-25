#!/usr/bin/env python
# -*- coding: utf-8 -*-

##=Raw================
# hex:    0xDEADBEEF
# to hex: hex(number)

# binary: 0b1011_1111
# to bin: bin(number)

# octet:  0100

# char -> raw: ord('a')
# raw -> char: chr(97)

# Math functions
# math.log(x)
# xor(x,y)

# hex encoded -> utf8 string
# bytearray.fromhex(hex).decode('utf-8')
# hex encoded -> raw
# binascii.unhexlify(hex)
# ===================

import math
import binascii
from operator import xor
import sys

sys.setrecursionlimit(1500)

#=========================================================
def monthly(loan, monthly_fee, ranta):
  assert (monthly_fee > 0)

  one_percent = loan /100
  ranta_payment = math.ceil(one_percent * (float(ranta)/12.0))

  assert(ranta_payment < monthly_fee)
  ammortering = monthly_fee - ranta_payment

  if ammortering >= loan:
    print("ränta: {} Amortering: {} Återstående lån: {}".format(ranta_payment, ammortering, 0))
    return ranta_payment, 1
  else:
    print("ränta: {} Amortering: {} Återstående lån: {}".format(ranta_payment,ammortering, loan-ammortering))

    res = monthly(loan - ammortering, monthly_fee, ranta)
    return (res[0]+ranta_payment), (res[1]+1)

#=========================================================
def calc(loan, ammortering, ranta):
  assert (ammortering > 0)

  one_percent = loan /100
  payment = one_percent * (float(ranta)/12.0)
  if ammortering >= loan:
    return payment, 1
  else:
    res = calc(loan - ammortering, ammortering, ranta)
    # print(res[1]+1)
    return (res[0]+payment), (res[1]+1)

#=========================================================
loan = 1000000
# ranta = 2.05
ranta=2
aterbetalning_years = 10 # 50
aterbetalningar = aterbetalning_years*12
aterbetalningar

lan_one_percent = loan/100
yearly_ranta=lan_one_percent*ranta
monthly_ranta=yearly_ranta/12

yearly_ranta
monthly_ranta

yearly_amortering=loan/aterbetalning_years
monthly_amortering=loan/aterbetalningar

"monthly loan:"
math.ceil(monthly_ranta+monthly_amortering)

# ranta_forandring_aterbetalning=lan_one_percent*50
# total_pay=ranta_forandring_aterbetalning+loan
#
# total_pay

res = calc(loan, monthly_amortering, ranta)
math.ceil(res[0])
loan+math.ceil(res[0])

res = monthly(loan, 10000, ranta)
res[0]
res[1]
res[1]/12


# 121/12
