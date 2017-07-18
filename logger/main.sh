# source dependent scripts
. settings.sh
. configs.sh

# private functions
function __init__()
{
    if ! [[ -z $LOGGER_INITIALIZED ]]; then
        return
    fi
    LOGGER_INITIALIZED=true

    if [[ -z $LOGFILE ]]; then
        ENABLE_LOGGING=false
    else
        touch $LOGFILE
        if [[ $? -ne 0 ]]; then
            ENABLE_LOGGING=false
        fi
    fi
    if $ENABLE_LOGGING; then
        echo "" >> $LOGFILE
        echo "+--------------------------------------+" >> $LOGFILE
        echo "| LOGGING STARTED: $(date +'%Y-%m-%d %H:%M:%S') |" >> $LOGFILE
        echo "+--------------------------------------+" >> $LOGFILE
        echo "" >> $LOGFILE
    fi
}

function __log__(){
    if $ENABLE_LOGGING; then
        echo "$(date +'%y%m%d %H:%M:%S.%3N') $1" >> $LOGFILE
    fi
}

# public functions
function log_txt(){
    __log__ "[T] $1"
}

function log_inf(){
    __log__ "[I] $1"
}

function log_wrn(){
    __log__ "[W] $1"
}

function log_err(){
    __log__ "[E] $1"
}

# entry point
__init__
__init__

if [[ $1 == "DEBUG" ]]; then
    log_txt "text log"
    log_inf "info log"
    log_wrn "warn log"
    log_err "erro log"
fi
