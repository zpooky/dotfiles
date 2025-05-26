# Disable confirmation messages:
set confirm off

# Print Python stack dumps on error:
set python print-stack full
#

set history filename ~/.gdb_history
set history save
set history expansion on

# print any object ignoring any size limitation
set max-value-size unlimited

#
set verbose off
#set confirm off
#set print static-members off

set print pretty on
set print object on
set print vtbl on
set print demangle on
set demangle-style gnu-v3

set print array off
set print array-indexes on

#
set disassembly-flavor att

# threaded
set target-async 1
set non-stop on

#
add-auto-load-safe-path ~/sources/linux-shallow
add-auto-load-safe-path ~/sources/linux

#gdb-dashboard
# source ~/sources/gdb-dashboard/.gdbinit

#gcc pretty printers {
python
import sys
import os
from pathlib import Path

pp = os.environ['HOME']+'/sources/gdb_pp'
path = Path(pp)
if path.is_dir():
  try:
    sys.path.insert(0, pp)
    from libstdcxx.v6.printers import register_libstdcxx_printers
    register_libstdcxx_printers (None)
  except:
    pass
else:
  import glob
  sys.path.insert(0, glob.glob('/usr/share/gcc-*/python')[0])
  from libstdcxx.v6.printers import register_libstdcxx_printers
  register_libstdcxx_printers (None)
end
# }

#clang pretty printers {
python
import sys
import os
from pathlib import Path

pp = os.environ['HOME']+'/sources/libcxx-pretty-printers/src'
path = Path(pp)
if path.is_dir():
  try:
    sys.path.insert(0, pp)
    from libcxx.v1.printers import register_libcxx_printers
    register_libcxx_printers (None)
  except:
    pass

end
# }
