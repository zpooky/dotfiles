#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

# from powerline.segments import Segment, with_docstring
# from powerline.theme import requires_segment_info
def file(pl, folders = []):
  count = 0
  for folder in folders:
    normalized = folder.replace("~", os.environ['HOME'], 1)
    count += len(os.listdir(normalized))

  ret = []
  if count > 0:
    ret.append({
      'contents':  '✉ ' + str(count),
      'draw_inner_divider': False,
      'highlight_groups': ['battery_full'],
      'gradient_level': 0
    })
  return ret

# ll = file(None, ['~'])
# print ll[0].get('contents')
