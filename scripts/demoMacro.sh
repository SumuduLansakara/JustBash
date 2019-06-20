#ARG_COUNT=:3

# ARG_COUNT macro defines the number of minimum and maximum arguments accepted by this script
#   Syntax: ARG_COUNT=<min_args>:<max_args>
# If the macro is not provided on top of the script, script will be executed without this
#  validation
# If the macro is set and provided argument count is invalid, JustBash will not start 
#  the script and fail with an error message
# If any of the arguments are omitted, following default values will be assigned.
#   min_args=0
#   max_args=99
