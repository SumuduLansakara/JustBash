# source dependent scripts
. settings.sh
. configs.sh

# private functions
function __init__()
{
    if [[ -z $LOGFILE ]]; then
        ENABLE_LOGGING=false
    else
        touch $LOGFILE
        if [[ $? -ne 0 ]]; then
            ENABLE_LOGGING=false
        fi
    fi
}

function __log__(){
    if $ENABLE_LOGGING; then
        echo "$1" >> $LOGFILE
    fi
}

# public functions
function log_txt(){
    __log__ "[txt] $1"
}

function log_inf(){
    __log__ "[inf] $1"
}

function log_wrn(){
    __log__ "[wrn] $1"
}

function log_err(){
    __log__ "[err] $1"
}

# entry point
__init__

if [[ $1 == "DEBUG" ]]; then
    log_txt "text log"
    log_inf "info log"
    log_wrn "warn log"
    log_err "erro log"
fi
