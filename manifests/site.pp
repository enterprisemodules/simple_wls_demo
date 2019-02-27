include stdlib                       # Make sure the standard functions are available
include easy_type::license::activate  # Always include the license class. This makes sure all the license files are copied
#
# This is the schedule used for applying patches. The databases and WebLogic instances
# might go down during these times.
#
schedule { 'maintenance-window':
  range  => "00:00 - 23:59"  # Change to your requirements
}
lookup('role', String).include
