#!/usr/bin/env bash

CMD_FILE=/tmp/pyfia.cmd
OUT_FILE=/tmp/pyfia.out
ERR_FILE=/tmp/pyfia.err
LOG_FILE=/tmp/pyfia.log

rm -f $CMD_FILE $OUT_FILE $ERR_FILE $LOG_FILE

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# launch python
(~/.venv/bin/python3 -u $SCRIPT_DIR/engine.py $CMD_FILE $OUT_FILE $ERR_FILE $LOG_FILE &) && echo "INFO:launched python engine" >>$LOG_FILE

# launch rofi
CMD_FILE=$CMD_FILE \
  OUT_FILE=$OUT_FILE \
  ERR_FILE=$ERR_FILE \
  LOG_FILE=$LOG_FILE \
  rofi \
  -show pyfia -modes "pyfia:$SCRIPT_DIR/pyfia.sh" \
  -no-show-match -no-fixed-num-lines -no-show-icons -no-sort \
  -scroll-method 1 \
  -kb-accept-entry '' -kb-accept-custom 'Return' \
  -theme-str '@import "~/.config/rofi/pyfia.rasi"' >$OUT_FILE 2>$ERR_FILE

# cleanup
kill $(pgrep -f engine.py) && echo "INFO:killed python engine" >>$LOG_FILE
