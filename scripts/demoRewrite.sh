# All the terminal print_* methods (except pring_dbg) can re-write previously written line
# Can be used for different purposes if used wisely!
echo "[placeholder] this line gets re-written"
disable_print_tags
enable_rewrite
for i in {0..10}; do
    print_txt "progress $(printf '%02d' $i)/10"
    sleep 0.1
done
disable_rewrite
enable_print_tags
