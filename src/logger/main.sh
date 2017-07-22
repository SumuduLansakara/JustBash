# source dependent scripts
. $ROOT/logger/settings.sh
. $ROOT/logger/configs.sh

# private functions
function __init__()
{
    if $LOGGER_INITIALIZED; then
        return
    fi
    export LOGGER_INITIALIZED=true

    if ! [[ -e $LOGDIR ]]; then
        mkdir "$LOGDIR" &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "[ERR][LOGGER] unable to create log directory $LOGDIR"
        fi
    fi
    export LOGPATH="$LOGDIR/$LOGFILENAME"
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
    timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    echo "+$(printf -- "-%.0s" {1..45} )+" >> $LOGPATH
    echo "| LOGGING STARTED : $(printf '%-25s' "$timestamp") |" >> $LOGPATH
    echo "| INSTANCE ID     : $(printf '%-25s' "$INSTANCEID") |" >> $LOGPATH
    echo "+$(printf -- "-%.0s" {1..45} )+" >> $LOGPATH
    echo "" >> $LOGPATH
}

function __log__(){
    if ! $ENABLE_LOGGING; then
        return
    fi
    if $ENABLE_LOG_TIMESTAMP; then
        echo "$(date +'%y%m%d %H:%M:%S.%3N') $LOGTAG$1" >> $LOGPATH
    else
        echo "$LOGTAG$1" >> $LOGPATH
    fi
}

# public functions
function log_dbg(){
    __log__ "[D] $1"
}

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

function enable_log_timestamp(){
    export ENABLE_LOG_TIMESTAMP=true
}

function disable_log_timestamp(){
    export ENABLE_LOG_TIMESTAMP=false
}


# entry point
__init__

export -f __log__

export -f log_dbg
export -f log_txt
export -f log_inf
export -f log_wrn
export -f log_err

export -f enable_log_timestamp
export -f disable_log_timestamp

if [[ $1 == "DEBUG" ]]; then
    log_txt "text log"
    log_inf "info log"
    log_wrn "warn log"
    log_err "erro log"
fi
