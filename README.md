```
	
	
	     ____.               __ __________               .__     
	    |    |__ __  _______/  |\______   \_____    _____|  |__  
	    |    |  |  \/  ___/\   __\    |  _/\__  \  /  ___/  |  \ 
	/\__|    |  |  /\___ \  |  | |    |   \ / __ \_\___ \|   Y  \
	\________|____//____  > |__| |______  /(____  /____  >___|  /
	                    \/              \/      \/     \/     \/ 
	
	
```
                                    

## What is JustBash?
JustBash is a highly customizable, bash based simplified scripting framework. It can be used for implementing a library of bash scripts for performing regular tasks without having to worry about logging, display formatting, input validation etc...

Users can implement custom scripts for performing whatever task that can be done through bash and invoke them through JustBash. JustBash provides a set of simple and convinient functions for displaying messages, logging etc...

## System requirements
JustBash can be used in any Linux environment. It does not require any additional tools, it just uses the standard Linux tools available in most distributions by default.

## Usage
JustBash main script is invoked with the name of the desired JustBash command, instance ID and other required arguments (command-line arguments for the JustBash script, debug flags etc..). Then from inside it will perform initial validations and invoke the requested script.

e.g. 
``` sh
    $ ./main.sh -i test_instance_1 -c test
```

### Instance ID
Instance ID is there to make it easy to identify the JustBash instance while analyzing logs.

Default JustBash logfile is created in the following format.
```
justbash-<INSTANCE ID>.log
```

All the log entries with the same instance ID will be written to a single file.

### JustBash scripts
JustBash scripts are implemented by the user. A JustBash script is an ordinary bash script which is implemented utilizing the features provided by JustBash.

## JustBash Features
JustBash provides a set of functions and macros users can use from inside the JustBash script they are developing.

JustBash provides,
 - functions to display messages with different error levels
 - functions to display word-arts
 - logging functions to log messages with different error levels
 - ability to re-write lines (useful when displaying progress)
 - utility class with convenient functions for displaying complex outputs
 - ability to change display colors and other terminal manipulations

JustBash macros,
 - macro to validate user defined scripts input argument count

## How to implement a new JustBash script
Create the new script inside the tools directory. 

e.g.
``` sh
vi tools/my_script.sh
```

> Note that every script must have '.sh' extension.
> When calling through JustBash, call without the extension.

sample content.
``` sh
#arg_count=1:3
print_inf "My First JustBash script"
draw_txt "Hello World!"
print_wrn "input arguments: " $*

```

Invoke the new script through JustBash as below.

```
$ ./main.sh -i test_instance -c my_script arg_1 arg_2
```

> Refer to the already implemented demo command for sample usage

License
----

MIT
