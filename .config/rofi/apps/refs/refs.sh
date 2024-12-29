#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR=$HOME/Documents/Literature/

bibfile=$CACHE_DIR/refs.bib

# parse the bib file
refs=$(awk -f $SCRIPT_DIR/refs.awk $bibfile)

# forward to rofi
pick=$(
  echo "$refs" |
    jq -r '.[] | (.type + "\t" + .year + "\t" + .author + "\t" + .title + "\t" + .journal + "\t" + .groups + "\t" + .keywords + "\t" + .file)' |
    awk -F"\t" '{
    icon = "󰯁"
    if ($1 == "Article") {
      icon = "󰯁"
    } else if ($1 == "Book") {
      icon = ""
    } else if ($1 == "PhdThesis" || $1 == "MastersThesis") {
      icon = ""
    }
    journal = ""
    if ($5 != "") {
      journal = "(" $5 ") "
    } else if ($1 == "Book") {
      journal = "(Book) "
    } else if ($1 == "PhdThesis" || $1 == "MastersThesis") {
      journal = "(Thesis) "
    }
    printf "<span color=\"#ee889b\" font=\"MonaspiceKr Nerd Font 12\">%d </span>%s <span color=\"#ad84be\">%s</span><span color=\"#81a3de\">%s</span>\0icon\x1f<span color=\"#9cb9dd\">%s </span>\x1fmeta\x1f%s %s\n", 
      $2, $3, journal, $4, icon, $6, $7
  }' |
    rofi -dmenu -no-sort -no-custom -markup-rows -i \
      -format i \
      -theme-str "@import \"$SCRIPT_DIR/refs.rasi\""
)

if [ -z "$pick" ]; then
  exit 1
fi

# open the selected reference
fname=$CACHE_DIR/$(echo "$refs" | jq -r ".[$pick] | .file")

if [ -n "$fname" ]; then
  zathura "$fname"
fi
