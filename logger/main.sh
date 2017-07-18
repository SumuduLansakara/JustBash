# source dependent scripts
. $ROOT/logger/settings.sh
. $ROOT/logger/configs.sh

# private functions
function __init__()
{
    if ! [[ -z $LOGGER_INITIALIZED ]]; then
        return
    fi
    LOGGER_INITIALIZED=true

    if ! [[ -e $LOGDIR ]]; then
        mkdir "$LOGDIR"
        if [[ $? -ne 0 ]]; then
            echo "[FATAL] unable to create log directory $LOGDIR"
        fi
    fi
    LOGPATH="$LOGDIR/$LOGFILE"
    if $BACKUP_LAST_LOG; then
        if [[ -f $LOGPATH ]]; then
            mv "$LOGPATH" "$LOGDIR/$INSTANCEID-$LOGFILE"
            if [[ $? -ne 0 ]]; then
                log_err "failed backing up last log"
            fi
        fi
    fi
    touch $LOGPATH
    if [[ $? -ne 0 ]]; then
        ENABLE_LOGGING=false
    fi
    if ! $ENABLE_LOGGING; then
        return
    fi
    echo "" >> $LOGPATH
    echo "+---------------------------------------+" >> $LOGPATH
    echo "| LOGGING STARTED : $(date +'%Y-%m-%d %H:%M:%S') |" >> $LOGPATH
    echo "| INSTANCE ID     : $INSTANCEID   |" >> $LOGPATH
    echo "+---------------------------------------+" >> $LOGPATH
    echo "" >> $LOGPATH
}

function __log__(){
    if ! $ENABLE_LOGGING; then
        return
    fi
    echo "$(date +'%y%m%d %H:%M:%S.%3N') $1" >> $LOGPATH
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
export -f log_txt
export -f log_inf
export -f log_wrn
export -f log_err

if [[ $1 == "DEBUG" ]]; then
    log_txt "text log"
    log_inf "info log"
    log_wrn "warn log"
    log_err "erro log"
fi
