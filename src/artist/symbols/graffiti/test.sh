#!/usr/bin/env bash

IFS=''
read -rd '' A <<"EOF"
###_____###
##/##_##\##
#/##/_\##\#
/####|####\
\____|__##/
########\/#
EOF

read -rd '' B <<"EOF"
########
_____###
\__##\##
#/#__#\_
(____##/
#####\/#
EOF

echo "${B}"

echo "----- [start]"
function display(){
    unset IFS
    for row in $(seq 0 10 65); do
        for col in {0..8}; do
            index=$(($row+$col))
            printf '%3s' "$index"
            # echo -n "${B:$index:1}"
        done
        echo ""
    done
}

function display2(){
    unset IFS
    for row in $(seq 0 9 65); do
        for col in {0..7}; do
            index=$(($row+$col))
            echo -n "${B:$index:1}"
        done
        echo ""
    done
}

MAP=""
set -- "$B"
display $*
display2 $*
