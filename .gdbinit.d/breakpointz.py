#!/usr/bin/python

# gdb
# >>> python help (gdb.Breakpoint)

class Breakpointz(Dashboard.Module):
  """asdasd"""

  def label(self):
    return 'Breakpointz'

  @staticmethod
  def format(width,id,file,line,enabled,hit_count):
    return '{}|{}|{}'.format(id,file,line)

  def lines(self, term_width, term_height, style_changed):
    lines = []

    breakpoints = gdb.breakpoints()
    if breakpoints is not None:
      for br in breakpoints:
        path = br.location
        paths = path.split('/')

        file_and_line = paths[-1].split(':')
        file = file_and_line[0]
        line = None
        if len(file_and_line) > 1:
          line = file_and_line[1]
        lines.append(Breakpointz.format(term_width,br.number,file,line,br.enabled,br.hit_count))

    return lines
