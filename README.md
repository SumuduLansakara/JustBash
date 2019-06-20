```
	
	
	     ____.               __ __________               .__     
	    |    |__ __  _______/  |\______   \_____    _____|  |__  
	    |    |  |  \/  ___/\   __\    |  _/\__  \  /  ___/  |  \ 
	/\__|    |  |  /\___ \  |  | |    |   \ / __ \_\___ \|   Y  \
	\________|____//____  > |__| |______  /(____  /____  >___|  /
	                    \/              \/      \/     \/     \/ 
	
	
```
                                    
# What is JustBash?
*JustBash* is a highly customizable, bash based simplified scripting framework, which provides a simple interface for useful functionalities like logging, display formatting, input validation etc...

Any regular bash script can be implemented as a *JustBash* script.

# System requirements
JustBash can be used on any Linux environment.
It does not depend on any additional tool, other than the standard Linux tools.

# Usage
1. Clone the repository
2. Implement your script and put it inside *JustBash* scripts directory
3. Call your script via *JustBash* 

# Example
## Demo 
Execute `demo.sh` in the repository root directory for a quick demonstration of JustBash capabilities.
`demo.sh` sequentially invokes all the demo scripts available inside the scripts directory.

# Usage syntax 

*JustBash* usage syntax can be displayed as follows.

    ./jb.sh -h

This gives the following output.

>Usage:
>
>  ./jb.sh [-i instance_id] [-l log_tag] [-c command_name] [-d] [-h] 
>
>Options:
>
>  -i <instance_id>  : JustBash instance id
>
>  -l <log_tag>      : optional tag to be used when logging current instance
>
>  -c <command_name> : command to be invoked
>
>  -d                : enable debug output
>
>  -h                : display this help message

### *JustBash* instance ID (-i)
Instance ID is there to make it easy to identify the corresponding JustBash instance while analyzing logs.

Default JustBash logfile is created in the following format.
    
	justbash-<INSTANCE ID>.log

> e.g.
> Following log file will be created if invoked as "**jb.sh -i test_instance_1** ..."
>   > **justbash-test_instance_1.log**

All the log entries with the same instance ID will be written to a single file.

### Debug mode (-d)
This mode is used for quick running a script for testing purposes. 
With this flag instance id is not required and log entries will be written to a file called "**justbash-DEBUG.log**"

> e.g.
> In the examples above, the demo script is executed in debug mode without an instance ID "**./jb.sh -d -c jbdemo**"

### Command name (-c)
Name of the script (or command) to be invoked.

> e.g.
> Demo script (named jbdemo) is invoked as "**jb.sh -c jbdemo ...**"

# JustBash Features

*JustBash* provides a set of functions and macros that can be used while implementing custom *JustBash* scripts.

*JustBash* functions,
 - functions for displaying messages with different error levels
 - functions for displaying word-arts
 - functions for logging messages with different error levels
 - functions for re-write lines (useful when displaying progress)
 - functions for changing display colors (and other terminal manipulations)
 - utility class with convenient functions for displaying complex outputs

*JustBash* macros,
 - macro to validate input argument count in *JustBash* scripts

# How to implement a new *JustBash* script
Create a file with the name of the script inside scripts directory
(default directory is **scripts** in the top level of the git repository)

e.g.

    vi scripts/my_script.sh

> Note that every script must have '.sh' extension.
> However, extension is omitted when calling though *JustBash*.

Sample content:

    #arg_count=1:3
    print_inf "My First JustBash script"
    draw_txt "Hello World!"
    print_wrn "input arguments: " $*

> **arg_count** macro is used for validating input argument count of a *JustBash* script. 
> It must be in the first line of a script and has the following syntax

    #arg_count=<minimum argument count>:<maximum argument count>

After implementation, the new script can be invoked as below.

    ./jb.sh -i test_instance -c my_script arg_1 arg_2

> Refer to the already implemented demo command for sample usage

License
----

MIT
