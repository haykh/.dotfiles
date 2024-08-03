#!/usr/bin/env bash

MAXWAIT=100

if [ -z "$1" ]; then
  echo "INFO:HST_FILE is $HST_FILE" >>$LOG_FILE
  echo "INFO:CMD_FILE is $CMD_FILE" >>$LOG_FILE
  echo "INFO:OUT_FILE is $OUT_FILE" >>$LOG_FILE
  echo "INFO:ERR_FILE is $ERR_FILE" >>$LOG_FILE

  echo "" >$HST_FILE
  echo -en "\0prompt\x1fwrite python\n"
  echo -en "\0data\x1f$HST_FILE\n"
else
  # get HST_FILE name
  HST_FILE=$ROFI_DATA
  # pass HST_FILE name forward
  echo -en "\0data\x1f$HST_FILE\n"

  # write input to the log file
  echo "> $1" >>$HST_FILE

  # send command to python
  echo -n "$1" >>$CMD_FILE
  # read output from python
  out=$(cat $OUT_FILE | tr '\n' ' ')
  err=$(cat $ERR_FILE | tr '\n' ' ')
  # while [ -z "$out" ]; do
  for i in $(seq 1 $MAXWAIT); do
    if [[ "$out" == "" ]] && [[ "$err" == "" ]]; then
      echo "INFO:waiting for output: $out $err" >>$LOG_FILE
      out=$(cat $OUT_FILE | tr '\n' ' ')
      err=$(cat $ERR_FILE | tr '\n' ' ')
      sleep 0.01
    else
      break
    fi
  done
  # write output to the log file
  if [[ "$out" != "None"* ]] && [[ "$out" != "" ]]; then
    echo "< $out" >>$HST_FILE
    echo -en "\0message\x1fOUT: $out\n"
  fi
  # send error to rofi
  if [[ "$err" != "" ]]; then
    echo "ERROR: $err" >>$LOG_FILE
    echo "E $err" >>$HST_FILE
    echo -en "\0message\x1fERR: $err\n"
  fi
  # clear output and error files
  echo -n "" >$OUT_FILE
  echo -n "" >$ERR_FILE

  # read all entries of the log file
  cat "$HST_FILE" | while IFS= read -r line; do
    # pass lines to rofi
    if [[ "$line" == ">"* ]]; then
      # input line
      line=${line:1}
      echo -en ":$line\0permanent\x1ftrue\x1fnonselectable\x1ftrue\n"
    elif [[ "$line" == "<"* ]]; then
      line=${line:1}
      # output line
      echo -en ":$line\0permanent\x1ftrue\x1fnonselectable\x1ftrue\x1factive\x1ftrue\n"
    elif [[ "$line" == "E"* ]]; then
      line=${line:1}
      # error line
      echo -en ":$line\0permanent\x1ftrue\x1fnonselectable\x1ftrue\x1furgent\x1ftrue\n"
    fi
  done

  # move cursor to the end of the list
  if command -v wtype &>/dev/null; then
    wtype -P end
  fi
fi
