#!/usr/bin/python

# gdb
# >>> python help (gdb.Breakpoint)

class Breakpoints(Dashboard.Module):
  """asdasd"""

  def label(self):
    return 'Breakpoints'

  @staticmethod
  def format(width,id,file,line,enabled,hit_count):
    return '{}|{}|{}'.format(id,file,line)

  def lines(self, term_width, style_changed):
    lines = []

    breakpoints = gdb.breakpoints()
    for br in breakpoints:
      path = br.location
      paths = path.split('/')

      file_and_line = paths[-1].split(':')
      file = file_and_line[0]
      line = None
      if len(file_and_line) > 1:
        line = file_and_line[1]

      lines.append(Breakpoints.format(term_width,br.number,file,line,br.enabled,br.hit_count))

    return lines
