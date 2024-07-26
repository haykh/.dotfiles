#!/bin/sh

weather=$(curl -s "wttr.in/?m&format=j1")
short=$(curl -s "wttr.in/?m&format=\{\"wind\":\"%w\"\}\n")
# for debugging purposes
# place=/home/hayk/.config/waybar/scripts
# weather=$(cat $place/wttr.json)
# short=$(cat $place/wttr.short.json)

(echo $weather ; echo $short) | jq -c '
def uvcolor(v): 
  if v < 3 then "#7fccff" 
  elif v < 5 then "#a2dcfb" 
  elif v < 7 then "#c9edec" 
  elif v < 8 then "#e9f9cc" 
  elif v < 9 then "#f8e28f" 
  elif v < 10 then "#f9b848" 
  elif v < 11 then "#f7743a" 
  else "#f42a2a" 
  end;
def humiditycolor(h):
  if h < 15 then "#f79e53"
  elif h < 30 then "#edb383"
  elif h < 35 then "#e1cbbb"
  elif h < 55 then "#d7dee8"
  elif h < 65 then "#a3a8f0"
  elif h < 80 then "#6f73f8"
  else "#4345ff"
  end;
def pressurecolor(p):
  if p < 985 then "#43b1ff"
  elif p < 1007 then "#68b8f5"
  elif p < 1015 then "#cfdbeb"
  elif p < 1021 then "#e76e76"
  else "#f75353"
  end;
def rainorsnow(snowcm; rainpct):
  if snowcm > 0 and rainpct > 30 then ("󰙿 " + (snowcm | tostring) + " cm")
  elif snowcm > 0 then ("󰼶 " + (snowcm | tostring) + " cm")
  else ("󰖗 " + (rainpct | tostring) + "%")
  end;
def forecast_icon(clouds; rain; snow):
  if snow > 30 and rain > 30 then "󰙿"
  elif snow > 30 then "󰼶"
  elif rain > 30 then ""
  elif rain > 60 then ""
  elif clouds > 30 then ""
  else ""
  end;
def timeofday(now; sunrise; sunset):
  if now < (sunrise - 3600) then 0
  elif now < (sunrise + 3600) then 1
  elif now < (sunset - 3600) then 2
  elif now < (sunset + 3600) then 3
  else 0
  end;
def geticon(t; c; r; h; w):
  if t == 0 then
    # night
    if c then # cloudy
      if r then # rainy
        if w then "" # windy
        else "" # not windy
        end
      else # not rainy
        if w then "" # windy
        else "" # not windy
        end
      end
    else "" # clear
    end
  elif t == 1 or t == 3 then
    # dusk/dawn
    if c then # cloudy
      if r then # rainy
        if w then "" # windy
        else "" # not windy
        end
      else # not rainy
        if w then "" # windy
        else "" # not windy
        end
      end
    else # clear
      if t == 1 then "" # dawn
      else "" # dusk
      end
    end
  else
    # day
    if c then # cloudy
      if r then # rainy
        if w then "" # windy
        else "" # not windy
        end
      else # not rainy
        if w then "" # windy
        else "" # not windy
        end
      end
    else # clear
      if w then "" # windy
      elif h then "" # hot
      else "" # not windy not hot
      end
    end
  end;
. + input | {
  localTime: .current_condition.[].localObsDateTime | strptime("%Y-%m-%d %I:%M %p"),
  tempC: .current_condition.[].temp_C,
  feelslikeC: .current_condition.[].FeelsLikeC,
  status: .current_condition.[].weatherDesc.[].value,
  # statusicon: .state_icon,
  windKMpH: .wind,
  windrawMpH: .current_condition.[].windspeedMiles,
  humidityPct: .current_condition.[].humidity,
  pressureHPa: .current_condition.[].pressure,
  uvindex: .current_condition.[].uvIndex,
  sunriseTime: (.weather[0].date + " " + .weather.[0].astronomy.[].sunrise) | strptime("%Y-%m-%d %I:%M %p"),
  sunsetTime: (.weather[0].date + " " + .weather.[0].astronomy.[].sunset) | strptime("%Y-%m-%d %I:%M %p"),
  snowCM: .weather.[0].totalSnow_cm,
  rainchancePct: .weather.[0].hourly[0].chanceofrain,
  rainMM: .current_condition.[].precipMM,
  cloudcoverPct: .current_condition.[].cloudcover,
  location: (.nearest_area.[].areaName.[].value + ", " + 
    (.nearest_area.[].region.[].value | 
      gsub("(?i)\\bAlabama\\b"; "AL") |
      gsub("(?i)\\bAlaska\\b"; "AK") |
      gsub("(?i)\\bArizona\\b"; "AZ") |
      gsub("(?i)\\bArkansas\\b"; "AR") |
      gsub("(?i)\\bCalifornia\\b"; "CA") |
      gsub("(?i)\\bColorado\\b"; "CO") |
      gsub("(?i)\\bConnecticut\\b"; "CT") |
      gsub("(?i)\\bDelaware\\b"; "DE") |
      gsub("(?i)\\bFlorida\\b"; "FL") |
      gsub("(?i)\\bGeorgia\\b"; "GA") |
      gsub("(?i)\\bHawaii\\b"; "HI") |
      gsub("(?i)\\bIdaho\\b"; "ID") |
      gsub("(?i)\\bIllinois\\b"; "IL") |
      gsub("(?i)\\bIndiana\\b"; "IN") |
      gsub("(?i)\\bIowa\\b"; "IA") |
      gsub("(?i)\\bKansas\\b"; "KS") |
      gsub("(?i)\\bKentucky\\b"; "KY") |
      gsub("(?i)\\bLouisiana\\b"; "LA") |
      gsub("(?i)\\bMaine\\b"; "ME") |
      gsub("(?i)\\bMaryland\\b"; "MD") |
      gsub("(?i)\\bMassachusetts\\b"; "MA") |
      gsub("(?i)\\bMichigan\\b"; "MI") |
      gsub("(?i)\\bMinnesota\\b"; "MN") |
      gsub("(?i)\\bMississippi\\b"; "MS") |
      gsub("(?i)\\bMissouri\\b"; "MO") |
      gsub("(?i)\\bMontana\\b"; "MT") |
      gsub("(?i)\\bNebraska\\b"; "NE") |
      gsub("(?i)\\bNevada\\b"; "NV") |
      gsub("(?i)\\bNew Hampshire\\b"; "NH") |
      gsub("(?i)\\bNew Jersey\\b"; "NJ") |
      gsub("(?i)\\bNew Mexico\\b"; "NM") |
      gsub("(?i)\\bNew York\\b"; "NY") |
      gsub("(?i)\\bNorth Carolina\\b"; "NC") |
      gsub("(?i)\\bNorth Dakota\\b"; "ND") |
      gsub("(?i)\\bOhio\\b"; "OH") |
      gsub("(?i)\\bOklahoma\\b"; "OK") |
      gsub("(?i)\\bOregon\\b"; "OR") |
      gsub("(?i)\\bPennsylvania\\b"; "PA") |
      gsub("(?i)\\bRhode Island\\b"; "RI") |
      gsub("(?i)\\bSouth Carolina\\b"; "SC") |
      gsub("(?i)\\bSouth Dakota\\b"; "SD") |
      gsub("(?i)\\bTennessee\\b"; "TN") |
      gsub("(?i)\\bTexas\\b"; "TX") |
      gsub("(?i)\\bUtah\\b"; "UT") |
      gsub("(?i)\\bVermont\\b"; "VT") |
      gsub("(?i)\\bVirginia\\b"; "VA") |
      gsub("(?i)\\bWashington\\b"; "WA") |
      gsub("(?i)\\bWest Virginia\\b"; "WV") |
      gsub("(?i)\\bWisconsin\\b"; "WI") |
      gsub("(?i)\\bWyoming\\b"; "WY")
    )
  ),
  forecast: [.weather[1:][] | {
    dateTime: .date | strptime("%Y-%m-%d") | strftime("%a %e %b"),
    tminC: .mintempC,
    tmaxC: .maxtempC,
    cloudcoverPct: ([.hourly[].cloudcover | tonumber] | add / length | tostring),
    snowchancePct: [.hourly[].chanceofsnow | tonumber] | max | tostring,
    rainchancePct: [.hourly[].chanceofrain | tonumber] | max | tostring
  }]
} | (. + {
  statusicon: geticon(
        (timeofday((.localTime | mktime); (.sunriseTime | mktime); (.sunsetTime | mktime)));
        (.cloudcoverPct | tonumber > 30);
        (.rainchancePct | tonumber > 30);
        (.tempC | tonumber > 28);
        (.windrawMpH | tonumber > 20)
      )
}) | {
  text: ("<tt><big>" + .statusicon + " </big></tt>" + .tempC + "°"),
  alt: (.status + " " + .tempC + "°"),
  class: "wttr",
  tooltip: (
    .location + 
      "\t\t<span font=\"15px\">~" + (.status | ascii_downcase) + "~</span>" +
    "\n<span font=\"50px\">" + .tempC + "°</span>" + 
      " (" + .feelslikeC + "°C)" +
      "\t\t<span font=\"60px\">" + 
        .statusicon + 
        "</span>" +
    "\n " + (.sunriseTime | strftime("%l:%M%P")) + 
      "\t\t\t<span font=\"25px\">" + rainorsnow(.snowCM | tonumber; .rainchancePct | tonumber) + "</span>" +
    "\n " + (.sunsetTime | strftime("%l:%M%P")) +
      "\n\n<span font=\"18px\" color=\"" + uvcolor(.uvindex | tonumber) + "\">󱟿 " + .uvindex + "</span>" + 
      "\t\t<span font=\"18px\" color=\"" + humiditycolor(.humidityPct | tonumber) + "\"> " + .humidityPct + "%</span>" +
    "\n<span font=\"18px\"> " + .windKMpH + "</span>" +
      "\t<span font=\"18px\" color=\"" + pressurecolor(.pressureHPa | tonumber) + "\"> " + .pressureHPa + " hPA</span>" +
    "\n\n<span font=\"12px\">`````````````\t`````````````\n" + 
    .forecast[0].dateTime + 
      "\t" + .forecast[1].dateTime + "</span>" +
    "\n<span font=\"30px\">" + forecast_icon(.forecast[0].cloudcoverPct | tonumber; .forecast[0].rainchancePct | tonumber; .forecast[0].snowchancePct | tonumber) + "</span>  " +
      "<span font=\"12px\">" + .forecast[0].tminC + "°/" + .forecast[0].tmaxC + "°</span>" +
      "\t<span font=\"30px\">" + forecast_icon(.forecast[1].cloudcoverPct | tonumber; .forecast[1].rainchancePct | tonumber; .forecast[1].snowchancePct | tonumber) + "</span>  " +
      "<span font=\"12px\">" + .forecast[1].tminC + "°/" + .forecast[1].tmaxC + 
    "°\n.............\t.............</span>"
  )
}'
