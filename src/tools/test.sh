#arg_count=1:

print_inf "test command started"
echo ">>> directly echoed message without using terminal methods <<<"
print_wrn "number of arguments recieved: ${#*}"
print_txt "arguments: '$*'"
print_err "returning with fake error"

# logger test
log_inf "direct logging from command"

# artist test
draw_txt "arguments: '$*'"
draw_inf "This is JustBash!"

# error code handeling test
exit -1
