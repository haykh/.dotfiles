#!/usr/bin/env bash

json_data=$(cat apps.json)

APP_DIR=$HOME/.local/share/applications

mapfile -t IN < <(echo "$json_data" | jq -r '.[].IN')
mapfile -t EXE < <(echo "$json_data" | jq -r '.[].EXE')
mapfile -t ICON < <(echo "$json_data" | jq -r '.[].ICON')
mapfile -t FNAME < <(echo "$json_data" | jq -r '.[].FNAME')
mapfile -t SCRIPT < <(echo "$json_data" | jq -r '.[].SCRIPT')
NITEMS=${#IN[@]}

ignorelist=("fontmanager" "fontviewer" "protonvpn")

mkdir -p $APP_DIR/bak
mv $APP_DIR/*.desktop $APP_DIR/bak
if [[ -d $APP_DIR/launchers ]]; then
  if [[ $(ls -A $APP_DIR/launchers) ]]; then
    mv $APP_DIR/launchers/* $APP_DIR/bak
  fi
fi

for file in $APP_DIR/bak/*; do
  if [[ $file != *.bak ]]; then
    mv "$file" "$file.bak"
  fi
done

for ((i = 0; i < NITEMS; i++)); do
  template="${IN[$i]}"
  exe="${EXE[$i]}"
  icon="${ICON[$i]}"
  output="${FNAME[$i]}"
  script="${SCRIPT[$i]}"

  if [[ $script != "." ]]; then
    mkdir -p $APP_DIR/launchers
    printf "#!/usr/bin/env bash\n$script\n" >$APP_DIR/launchers/$template.sh
    chmod +x $APP_DIR/launchers/$template.sh
    exe="$APP_DIR/launchers/$template.sh"
  fi

  # replace "$HOME" with actual value of $HOME in exe and icon
  exe=$(echo "$exe" | sed "s|\$HOME|$HOME|g")
  icon=$(echo "$icon" | sed "s|\$HOME|$HOME|g")

  if [[ " ${ignorelist[@]} " =~ " $template " ]]; then
    continue
  fi

  cat templates/"$template".desktop.in |
    sed "s/@exe@/$(printf '%s\n' "$exe" | sed 's/[\/&]/\\&/g')/g" |
    sed "s/@icon@/$(printf '%s\n' "$icon" | sed 's/[\/&]/\\&/g')/g" >$output.desktop
  mv $output.desktop $APP_DIR/
done
