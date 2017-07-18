# source dependent scripts
. settings.sh
. configs.sh

# private functions
function __init__(){
    if ! $ENABLE_COLORS; then
        ERR_CLR=
        INF_CLR=
        WRN_CLR=
        TXT_CLR=
        RST_CLR=
    fi
    if ! $DISPLAY_TAGS; then
        ERR_TAG=
        INF_TAG=
        WRN_TAG=
        TXT_TAG=
    fi
    set_newline
}

function __print_clr__(){
    echo -ne "\033[$1m"
}

function __print_tag__(){
    echo -n "$1"
}

function __print__(){
    if [[ $2 != "-" ]]; then
        echo -n ""
    fi
    echo -n "$1"
    if $END_WITH_NEWLINE; then
        echo ""
    fi
}

# public functions
function set_newline() {
    END_WITH_NEWLINE=true
}

function unset_newline() {
    END_WITH_NEWLINE=false
}

function print_txt() {
    __print_clr__ "$TXT_CLR"
    __print_tag__ "$TXT_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
}

function print_inf() {
    __print_clr__ "$INF_CLR"
    __print_tag__ "$INF_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
}

function print_wrn() {
    __print_clr__ "$WRN_CLR"
    __print_tag__ "$WRN_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
}

function print_err() {
    __print_clr__ "$ERR_CLR"
    __print_tag__ "$ERR_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
}

# entry point
__init__

if [[ $1 == "DEBUG" ]]; then
    print_txt "text message"
    print_inf "info message"
    print_wrn "warn message"
    print_err "erro message"
fi
