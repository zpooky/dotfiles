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

#
set disassembly-flavor intel

#gdb-dashboard
source ~/sources/gdb-dashboard/.gdbinit

#gcc pretty printers {
python
import sys
sys.path.insert(0, os.environ['HOME']+'/sources/gdb_pp')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
# }

#clang pretty printers {
python
try:
  import sys
  sys.path.insert(0, os.environ['HOME']+'/sources/libcxx-pretty-printers/src')
  from libcxx.v1.printers import register_libcxx_printers
  register_libcxx_printers (None)
except:
  pass

end
# }

# refresh dashboard [gdb hooks]
# define - a new hook
# hookpost - means post execution of command
# -*command* - the command to hook for
# dashboard - refreshes the gdb-dashboard

# refresh on moving up a stack frame
define hookpost-up
dashboard
end

# refresh on moving down a stack frame
define hookpost-down
dashboard
end

# refresh on change stack frame
define hookpost-frame
dashboard
end

# refresh on new breakpoint
define hookpost-break
dashboard
end

# refresh active breakpoints
define hookpost-clear
dashboard
end

# save active breakpoints on gdb quit
define hook-quit
save breakpoints .gdb_breakpoints
end
