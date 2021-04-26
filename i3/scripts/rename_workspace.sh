#!/bin/zsh
# Get new name
NN=$(dmenu -p "NEW WORKSPACE NAME:" <&-) 

# If escape, then exit
RES=$?
if ! test "$RES" = "0"
then 
    exit $RES
fi

# Trim name
NN=$(echo ${NN} | sed 's/^[[:space:]]*//')
NN=$(echo ${NN} | sed 's/[[:space:]]*$//')

# Get workspace name
WN=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')
NAME=${WN}
if [ -n "${NN}" ]
then
    NAME=${WN}:${NN}
fi

i3-msg "rename workspace to ${NAME}"
