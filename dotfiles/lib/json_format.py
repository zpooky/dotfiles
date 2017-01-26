import sys
import json

def main():
  length = len(sys.argv)
  if length == 1 or length == 2:
    infile = sys.stdin
    outfile = sys.stdout
    indentation = 4
    if length == 2:
      indentation = int(sys.argv[1])
  else:
    raise SystemExit(sys.argv[0] + " indentation")

  content =""
  contents = []
  for line in infile:
    content += line
    # contents.append(line)
  try:
    obj = json.loads(content)
  except ValueError, e:
    # for line in content:
    outfile.write(content)
    return 0
  
  try:
    json.dump(obj, outfile, sort_keys=True, indent=indentation)
    outfile.write('\n')
  except ValueError:
    pass

if __name__ == '__main__':
  main()
