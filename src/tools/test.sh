#arg_count=:3

# terminal test
print_inf "test command started"
print_wrn "number of arguments recieved: ${#*}"

# direct echo test
echo ">>> directly echoed message without using terminal methods <<<"
echo ">>> directly printing to stderr <<<" >&2

# logger test
log_inf "direct logging from command"

# artist test
draw_inf "JustBash Artist!"
draw_txt "Input>> '$*'"

# error code handeling test
print_err "returning with fake error"
exit -1
