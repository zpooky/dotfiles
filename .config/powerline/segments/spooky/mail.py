# from powerline.segments import Segment, with_docstring
# from powerline.theme import requires_segment_info

def file(pl, folders = []):
  ret = []
  pl.debug('test')
  ret.append({
    'contents': 'test',
    'draw_inner_divider': False,
    'highlight_groups': ['battery_full'],
    'gradient_level': 0
  })
  return ret
