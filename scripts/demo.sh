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

# terminal demo
print_inf "> DEMO: Terminal"
print_inf "demo command started"
print_wrn "number of arguments recieved: ${#*}"

# direct echo demo
# Following outputs will be captured in the logfile only if JustBash is invoked non-interactively
print_inf "> DEMO: direct shell comand invocation"
echo ">>> directly echoed message without using terminal methods <<<"
echo ">>> directly printing to stderr <<<" >&2

# logger demo
# Direct logging won't display anything in the terminal
print_inf "> DEMO: Logger"
log_inf "direct logging from command"

# artist demo
# This might get a little slow. But will display the input text as word-arts!
print_inf "> DEMO: Artist"
draw_inf "JustBash Artist!"
draw_wrn "Input>> '$*'"

# toggle color demo
# You can turn on/off display colors
print_inf "> DEMO: toggle Terminal colors"
disable_colors
print_inf "info message with colors disabled"
enable_colors

# rewriting demo
# All the terminal print_* methods (except pring_dbg) can re-write previously written line
# Can be used for different purposes if used wisely!
print_inf "> DEMO: Terminal Re-writing"
echo "[placeholder] this line gets re-written"
disable_print_tags
enable_rewrite
for i in {0..10}; do
    print_txt "progress $(printf '%02d' $i) %"
    sleep 0.1
done
disable_rewrite
enable_print_tags

# print_utils: progress demo
# Use this to display a progress bar for an action with a known number of sub actions
# e.g. copying a known number of files
disable_cursor
print_inf "> DEMO: print_utils: print_progress"
echo "[placeholder] this line gets re-written"
TOTAL_SUB_ACTIONS=13 # number of sub actions
set_color $INF_CLR
for i in $(seq 0 $TOTAL_SUB_ACTIONS); do
    clear_prev_line
    # do sub action i out of TOTAL_SUB_ACTIONS
    print_progress $i $TOTAL_SUB_ACTIONS 100
    echo
    sleep 0.1
done
set_color $RST_CLR
enable_cursor

# print_utils: spinner demo
# Use this to display a spinner for a process that takes a long time to complete
# The process must be backgrounded while redirecting the output to /dev/null.
# print_spinner method must be called before backgrounding any other process
print_inf "> DEMO: print_utils: print_spinner"
sleep 5 & &>/dev/null
print_spinner "I'm going to dance for 5 secs.. " 0.5

# error code handeling demo
# JustBash captures the return code of the script. Anything other than 0 is considered an error
print_inf "> DEMO: command return error detection"
print_err "returning with fake error 123"
exit 123
