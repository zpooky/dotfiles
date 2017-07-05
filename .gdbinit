# Disable confirmation messages:
set confirm off

# Print Python stack dumps on error:
set python print-stack full
#

set history filename ~/.gdb_history
set history save
set history expansion on

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

#disable



source ~/sources/gdb-dashboard/.gdbinit

python
import sys
sys.path.insert(0, os.environ['HOME']+'/sources/gdb_pp')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
