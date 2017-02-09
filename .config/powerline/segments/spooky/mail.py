#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os

# from powerline.segments import Segment, with_docstring
# from powerline.theme import requires_segment_info
def file(pl, inboxes = {}):
  result = {}
  total = 0
  info = ""

  for key in inboxes.keys():
    folder = inboxes[key]
    normalized = folder.replace("~", os.environ['HOME'], 1)
    new_folder = normalized + '/new'
    current = len(os.listdir(new_folder))
    if current > 0:
      result[key] = str(current)
    total += current

  ret = []
  if total > 0:
    # if there is only one mailbox
    # then no need to prefix it
    if len(inboxes.keys()) > 1:
      for key in result.keys():
        info += str(key) + "("+str(result[key])+")"
    else:
      info = str(total)

    ret.append({
      'contents':  '✉ ' + info,
      'draw_inner_divider': True,
      'highlight_groups': ['battery_full'],
      'gradient_level': 0
    })
  return ret

# ll = file(None, {"w": "~/.mail/work/inbox","g":"~/.mail/gmail/INBOX"})
# print ll[0].get('contents')
