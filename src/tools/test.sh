#arg_count=1:

# terminal test
print_inf "test command started"

# direct echo test
echo ">>> directly echoed message without using terminal methods <<<"
print_wrn "number of arguments recieved: ${#*}"
print_err "returning with fake error"

# logger test
log_inf "direct logging from command"

# artist test
draw_inf "This is JustBash!"
draw_txt "Input> '$*'"

# error code handeling test
exit -1
