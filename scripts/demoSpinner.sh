# Use this to display a spinner for a process that takes a long time to complete
# The process must be backgrounded and output must be redirected to /dev/null.
# print_spinner method must be called before backgrounding any other process
sleep 3 & &>/dev/null
print_spinner "I'm going to dance for 3 secs.. " 0.5
