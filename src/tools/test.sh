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

# rewriting test
disable_print_tags
enable_rewrite
for i in {0..100}; do
    print_txt "progress $(printf '%02d' $i) %"
    sleep 0.2
done
disable_rewrite
enable_print_tags

# print utils test
disable_cursor
echo "progress demo:"
echo
for i in {0..100}; do
    clear_prev_line
    print_progress $i 100
    echo
    sleep 0.05
done
enable_cursor


# error code handeling test
print_err "returning with fake error 123"
exit 123
