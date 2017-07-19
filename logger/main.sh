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
        mkdir "$LOGDIR" &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "[ERR][LOGGER] unable to create log directory $LOGDIR"
        fi
    fi
    LOGPATH="$LOGDIR/$LOGFILENAME"
    if [[ -f $LOGPATH ]]; then
        return
    fi

    touch $LOGPATH &>/dev/null
    if [[ $? -ne 0 ]]; then
        ENABLE_LOGGING=false
        return
    fi

    cd "$LOGDIR" &>/dev/null
    ln -sf "$LOGFILENAME" lastlog &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "[ERR][LOGGER] failed uplading lastlog link"
    fi
    cd - &>/dev/null

    # log banner
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
