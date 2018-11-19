#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import sys
import math

sys.setrecursionlimit(1500)

def parse_time(token):
  return (8,0)

def parse_interval(tokens):
  return [parse_time(tokens), parse_time(tokens)]

def parse_day(tokens):
  return [parse_interval(tokens), parse_interval(tokens)]

def parse_week(tokens):
  return True

def tokenize(line):
  return []

def main(args):

  if len(args) != 1:
    print("missing file", file=sys.stderr)
    sys.exit(1)

  file = args[0]

  tokens = []
  with open(file, "r") as f:
    for line in f:
      tokens = tokens + tokenize(line)
      tokens.appen("\n")


assert parse_time("08:00") == (8,0)
assert parse_interval(["08:00", "-", "08:00"]) == [(8,0), (8,0)]
assert parse_day(["08:00", "-", "08:00", "|", "08:00", "-", "08:00", "\n"]) == [[(8,0), (8,0)],[(8,0), (8,0)]]
assert parse_week(["#", "1", "\n", "..."])

if __name__ == "__main__":
   main(sys.argv[1:])
