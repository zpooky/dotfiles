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
def monthly(loan, monthly_fee, ranta, cnt=1):
  assert (monthly_fee > 0)

  one_percent = loan /100
  ranta_payment = math.ceil(one_percent * (float(ranta)/12.0))

  assert(ranta_payment < monthly_fee)
  ammortering = monthly_fee - ranta_payment

  if ammortering >= loan:
    print("{}. loan: {}kr ränt kostnad: {}kr Amortering: {}kr Återstående lån: {}kr".format(cnt, loan, ranta_payment, ammortering, 0))
    res = (ranta_payment, 1)
  else:
    print("{}. loan: {}kr ränt kostnad: {}kr Amortering: {}kr Återstående lån: {}kr".format(cnt, loan, ranta_payment, ammortering, loan-ammortering))
    res = monthly(loan - ammortering, monthly_fee, ranta,cnt+1)

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
loan = 700000.0
# ranta = 2.05
ranta=1.53
# aterbetalning_years = 3 # 50
#
#
# aterbetalningar = aterbetalning_years*12
# print("återbetalnings år: {}st".format(aterbetalning_years))
# print("återbetalnings tillfälle: {}st".format(aterbetalningar))
#
# lan_one_percent = loan/100
# yearly_ranta=lan_one_percent*ranta
# monthly_ranta=yearly_ranta/12
#
# print("årlig ränta: {}kr".format(yearly_ranta))
# print("månads ränta {}kr".format(monthly_ranta))
#
# yearly_amortering=loan/aterbetalning_years
# monthly_amortering=loan/aterbetalningar
#
# dd = math.ceil(monthly_ranta+monthly_amortering)
# print("monthly loan: {}kr".format(dd))
# print("---------------")
# print("")
#
#
# # ranta_forandring_aterbetalning=lan_one_percent*50
# # total_pay=ranta_forandring_aterbetalning+loan
# #
# # total_pay
#
# res = calc(loan, monthly_amortering, ranta)
# math.ceil(res[0])
# loan+math.ceil(res[0])

#=========================================================
monthly_repayment=10000.0
res = monthly(loan, monthly_repayment, ranta)
print("lån: {}kr, ränta {}%".format(loan,ranta))
print("månadsvis återbetlaning: {}kr".format(monthly_repayment))
print("total ränt kostnad innan lånet är återbetalad: {}kr".format(res[0]))
print("återbetalnings tillfällen: {}".format(res[1]))
print("år att betala tillbaka: {}".format(float(res[1])/12.0))


# 121/12
