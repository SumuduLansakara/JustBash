# BASHRUN
## What is it?
BASHRUN is a heavily customizable, bash based simplified scripting framework. It can be used for implementing a library of bash scripts for performing regular tasks without having to worry about logging, display formatting, argument validating etc...

Users can implement custom scripts for performing whatever task that can be done through bash and invoke them through BASHRUN. BASHRUN provides a set of few and simple functions for displaying messages to standatd output (in place on echo), logging etc...

## System requirements
BASHRUN can be used in any Linux environment. It does not require any additional tools, it just uses the standard Linux tools available in most distributions by default.

## What does it have?
Currently it provides following modules.

 - Terminal
 - Logger

## How to invoke?
Just invoke the main.sh in the topmost directory with a unique ID.

e.g.
``` sh
    $ $BASHRUN/main.sh my-instance-1
```

This ID can be anything, it's just there to make it easy to identify the instance while analyzing the logs.

Default BASHRUN logfile is created in the following format.
```
bashrun-<INSTANCE ID>.log
```

All the log entries with the same instance ID will be written to a single file.

## Todos

Following features are will be available soon.

 - ability to implement/run user defined scripts

License
----

MIT
