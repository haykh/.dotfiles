max() {
  if [[ $# -eq 2 ]]; then
    echo $(($1 > $2 ? $1 : $2))
  else
    echo $(($1 > $2 ? $(max $1 $3) : $(max $2 $3)))
  fi
}

min() {
  if [[ $# -eq 2 ]]; then
    echo $(($1 < $2 ? $1 : $2))
  else
    echo $(($1 < $2 ? $(min $1 $3) : $(min $2 $3)))
  fi
}

hsl2hex() {
  echo $(awk -v h="$1" -v s="$2" -v l="$3" '
    function huergb(p, q, t) {
      if(t < 0) t += 1;
      if(t > 1) t -= 1;
      if(t < 1 / 6) return p + (q - p) * 6 * t;
      if(t < 1 / 2) return q;
      if(t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
      return p;
    }
    BEGIN {
      h /= 360; s /= 100; l /= 100;
      if (s == 0) {
        r = g = b = l;
      } else {
        q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        p = 2 * l - q;
        r = huergb(p, q, h + 1 / 3);
        g = huergb(p, q, h);
        b = huergb(p, q, h - 1 / 3);
      }
      printf("#%02x%02x%02x", r * 255, g * 255, b * 255);
    }
  ')
}

hex2hsl() {
  echo $(
    awk -v r="$(($(printf '0x%.2s' "${1#?}")))" \
      -v g="$(($(printf '0x%.2s' "${1#???}")))" \
      -v b="$(($(printf '0x%s' "${1#?????}")))" 'BEGIN{
    r /= 255; g /= 255; b /= 255;
    max = (r > g) ? r : g; max = (max > b) ? max : b;
    min = (r < g) ? r : g; min = (min < b) ? min : b;
    l = (max + min) / 2;
    if (max == min) {
      h = s = 0;
    } else {
      d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
      if (max == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if(max == g){
        h = (b - r) / d + 2;
      } else if(max == b){
        h = (r - g) / d + 4;
      }
      h /= 6;
    }
    printf("%d %d %d", h * 360, s * 100, l * 100);
  }'
  )
}

setH() {
  hsl=$(hex2hsl $1)
  echo $(hsl2hex $2 $(echo $hsl | awk '{print $2}') $(echo $hsl | awk '{print $3}'))
}
setS() {
  hsl=$(hex2hsl $1)
  echo $(hsl2hex $(echo $hsl | awk '{print $1}') $2 $(echo $hsl | awk '{print $3}'))
}
setL() {
  hsl=$(hex2hsl $1)
  echo $(hsl2hex $(echo $hsl | awk '{print $1}') $(echo $hsl | awk '{print $2}') $2)
}

lighten() {
  echo $(setL $1 $(min 100 $(echo $(hex2hsl $1) |
    awk -v p="$2" '{printf "%.0f", $3 + $3 * p / 100}')))
}

darken() {
  echo $(setL $1 $(echo $(hex2hsl $1) |
    awk -v p="$2" '{printf "%.0f", $3 - $3 * p / 100}'))
}

saturate() {
  echo $(setS $1 $(min 100 $(echo $(hex2hsl $1) |
    awk -v p="$2" '{printf "%.0f", $2 + $2 * p / 100}')))
}

desaturate() {
  echo $(setS $1 $(echo $(hex2hsl $1) |
    awk -v p="$2" '{printf "%.0f", $2 - $2 * p / 100}'))
}

hueshift() {
  echo $(setH $1 $(echo $(hex2hsl $1) |
    awk -v p="$2" '{printf "%.0f", ($1 + p + 360) % 360}'))
}

setalpha() {
  printf "%s%02x" $1 $((255 * $2 / 100))
}
