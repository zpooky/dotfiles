# Disable confirmation messages:
set confirm off

# Enable command history:
set history save on

# Print Python stack dumps on error:
set python print-stack full
#
set history save
set verbose off

set print pretty on
set print object on
set print vtbl on
set print demangle on
set demangle-style gnu-v3

set print array off
set print array-indexes on


source ~/sources/gdb-dashboard/.gdbinit

python
import sys
sys.path.insert(0, os.environ['HOME']+'/sources/gdb_pp')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
