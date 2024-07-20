#!/bin/sh

# ID=USNJ0427:1:US
# https://weather.com/weather/today/l/USNJ0427:1:US
# report=$(curl -s https://weather.com/en-IN/weather/today/l/72cba3ccb5577318ae47e920688d0c8a19919e3016548e689837a56390f80dacc2a9b8780476a3c860edab26918d338f)

HOME="/home/hayk"
get_weather() {
  # echo $report
  cat $HOME/.config/waybar/scripts/weather.html
}

declare -A state_icons

state_icons["sunnyDay"]=""
state_icons["clearNight"]=""
state_icons["cloudyFoggyDay"]=""
state_icons["cloudyFoggyNight"]=""
state_icons["rainyDay"]=""
state_icons["rainyNight"]=""
state_icons["snowyIcyDay"]=""
state_icons["snowyIcyNight"]=""
state_icons["severe"]=""
state_icons["default"]=""

declare -A current
pup=$HOME/go/bin/pup
  
current["temp"]=$(get_weather | \
  $pup 'span[data-testid="TemperatureValue"] json{}' |\
  jq '.[0].text' | tr -d '"')

current["feels_like"]=$(get_weather | \
  $pup 'div[data-testid="FeelsLikeSection"] > span > span[data-testid="TemperatureValue"] json{}' | \
  jq '.[0].text' | tr -d '"')

current["temp_hi"]=$(get_weather | \
  $pup 'div[data-testid="wxData"] > span[data-testid="TemperatureValue"] json{}' | \
  jq '.[0].text' | tr -d '"')

current["temp_lo"]=$(get_weather | \
  $pup 'div[data-testid="wxData"] > span[data-testid="TemperatureValue"] json{}' | \
  jq '.[1].text' | tr -d '"')

current["state"]=$(get_weather | \
  $pup 'div[data-testid="wxPhrase"] json{}' | \
  jq '.[].text' | tr -d '"')

current["state_code"]=$(get_weather | \
  $pup '#regionHeader json{}' | \
  jq '.[].class | split(" ";"") | .[2] | split("-";"") | .[2]' | tr -d '"')

current["wind_speed"]=$(get_weather | \
  $pup 'span[data-testid="Wind"] json{}' | \
  jq '.[].children.[1].text' | tr -d '"')

current["humidity"]=$(get_weather | \
  $pup 'span[data-testid="PercentageValue"] json{}' | \
  jq '.[].text | sub("%";"")' | tr -d '"')

current["visibility"]=$(get_weather | \
  $pup 'span[data-testid="VisibilityValue"] json{}' | \
  jq '.[].text' | tr -d '"')

current["air_quality"]=$(get_weather | \
  $pup '[data-testid="DonutChartValue"] json{}' | \
  jq '.[].text' | tr -d '"')

current["air_quality_state"]=$(get_weather | \
  $pup 'span[data-testid="AirQualityCategory"] json{}' | \
  jq '.[].text' | tr -d '"')

declare -A forecast

forecast["hours"]=$(get_weather | \
  $pup 'section[aria-label="Hourly Forecast"] ul[data-testid="WeatherTable"] li h3 span json{}' | \
  jq '.[].text' | tr -d '"')

forecast["precipitation"]=$(get_weather | \
  $pup 'section[aria-label="Hourly Forecast"] '\
  'ul[data-testid="WeatherTable"] '\
  '[data-testid="SegmentPrecipPercentage"] json{}' | \
  jq '.[].children.[].text | sub("%";"")' | tr -d '"')

if [ ! -v state_icons[$current["state_code"]] ]; then
  current["state_icon"]=${state_icons["default"]}
else
  current["state_icon"]=${state_icons[$current["state_code"]]}
fi

tooltip=$(printf "\t\t%s\t\t\n%s\n%s\n%s\n\n%s\n%s\n%s" \
  "<span size='xx-large'>${current['temp']}</span>" \
  "<big>${current['state_icon']}</big>" \
  "<big>${current['state']}</big>" \
  "<small>${current['feels_like']}</small>" \
  "<big>${current['temp_hi']}/${current['temp_lo']}</big>" \
  "${current['wind_speed']}\t${current['humidity']}" \
  "${current['visbility']}\tAQI ${current['air_quality']}")

text="${current['state_icon']}  ${current['temp']}°C"
alt="${current['state']} ${current['temp']}°C"
tooltip="${tooltip}"
class="none"

jq -n --unbuffered --compact-output \
   --arg TEXT "$text" \
   --arg ALT "$alt" \
   --arg TOOLTIP "$tooltip" \
   --arg CLASS "${current['state_code']}" \
   '{
       text: $TEXT,
       alt: $ALT, 
       tooltip: $TOOLTIP,
       class: $CLASS
    }'

# echo " ${current["temp"]}°C"
# echo " ${current["feels_like"]}°C"
# echo " ${current["temp_hi"]}°C"
# echo " ${current["temp_lo"]}°C"
# echo " ${current["state"]} ${current["state_icon"]}"
# echo " ${current["wind_speed"]} km/h"
# echo " ${current["humidity"]}%"
# echo " ${current["visibility"]}"
# echo " ${current["air_quality"]} ${current["air_quality_state"]}"
#
# echo " ${forecast["hours"]} ${forecast["precipitation"]}"

