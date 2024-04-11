#!/bin/bash

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -f|--full)
      FULLSCREEN=1
      shift
      ;;
    -h|--help)
      echo "Usage: $0 OPTIONS"
      echo "OPTIONS:"
      echo "\t-f: capture full screen"
      echo "\t-h: display this message"
      exit 0
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"

TODAY=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPATH="$HOME/Pictures/Screenshots"
FILENAME="$OUTPATH/screen_$TODAY.png"

[ ! -d $OUTPATH ] && mkdir -p $OUTPATH

if [ ! -z ${FULLSCREEN+x} ]
then
    import -quality 100 -window root $FILENAME
else
    import -quality 100 $FILENAME
fi
