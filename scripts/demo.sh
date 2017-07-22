#arg_count=:3
# terminal demo
print_inf "demo command started"
print_wrn "number of arguments recieved: ${#*}"

# direct echo demo
echo ">>> directly echoed message without using terminal methods <<<"
echo ">>> directly printing to stderr <<<" >&2

# logger demo
log_inf "direct logging from command"

# artist demo
draw_inf "JustBash Artist!"
draw_wrn "Input>> '$*'"

# toggle color demo
disable_colors
print_inf "info message with colors disabled"
enable_colors

# rewriting demo
echo "[placeholder] this line gets re-written"
disable_print_tags
enable_rewrite
for i in {0..10}; do
    print_txt "progress $(printf '%02d' $i) %"
    sleep 0.1
done
disable_rewrite
enable_print_tags

# print utils demo
disable_cursor
echo "progress demo:"
echo "[placeholder] this line gets re-written"
MAX_PROGRESS=13
set_color $INF_CLR
for i in $(seq 0 $MAX_PROGRESS); do
    clear_prev_line
    print_progress $i $MAX_PROGRESS 100
    echo
    sleep 0.1
done
set_color $RST_CLR
enable_cursor

# spinner demo
# Use this to display a spinner for a process that takes a long time to complete
# The process must be backgrounded while redirecting the output to /dev/null.
# print_spinner method must be called before backgrounding any other process
sleep 5 & &>/dev/null
print_spinner "I'm going to dance for 5 secs.. " 0.5

# error code handeling demo
print_err "returning with fake error 123"
exit 123
