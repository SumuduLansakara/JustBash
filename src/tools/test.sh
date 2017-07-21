#arg_count=:3
enable_rewrite
print_wrn "line1"
sleep 0.2
print_wrn "line2"
sleep 0.2
print_wrn "line3"
sleep 0.2
print_wrn "line4"
sleep 0.2
print_wrn "line5"
sleep 0.2
disable_rewrite

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

# progress

# rewriter test
disable_cursor
echo "progress demo:"
echo
for i in {0..100}; do
    clear_prev_line
    print_progress $i 100
    echo
    sleep 0.1
done
enable_cursor


# error code handeling test
print_err "returning with fake error 123"
exit 123
