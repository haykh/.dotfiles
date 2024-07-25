package utils

import (
	"fmt"
	"math"
	"strconv"
	"strings"
)

const (
	RGB int8 = iota
	RGBA
	HSV
	HSVA
	HSL
	HSLA
	HEX
	HEXA
)

type ColorFormat = int8

type Color struct {
	r   float64 // [0, 1]
	g   float64 // [0, 1]
	b   float64 // [0, 1]
	h   float64 // [0, 360]
	s_v float64 // [0, 1]
	s_l float64 // [0, 1]
	v   float64 // [0, 1]
	l   float64 // [0, 1]
	a   float64 // [0, 1]
	hex string
}

func fmod(a float64, b int) float64 {
	return a - float64(int(a)/b*b)
}

func get_intermediate(r, g, b float64) (float64, float64, float64, float64) {
	M := max(r, g, b)
	m := min(r, g, b)
	C := M - m
	h := 0.0
	if C != 0 {
		switch M {
		case r:
			h = fmod(((g - b) / C), 6)
		case g:
			h = (b-r)/C + 2
		case b:
			h = (r-g)/C + 4
		}
	}
	return M, m, C, h
}

// IN: rgb ([]float64{ 0-255, 0-255, 0-255 })
// OUT: hsv (float64: 0-360, float64: 0-1, float64: 0-1)
func rgb2hsv(rgb []float64) (float64, float64, float64) {
	r, g, b := rgb[0]/255, rgb[1]/255, rgb[2]/255
	M, _, C, h := get_intermediate(r, g, b)
	if M == 0 {
		return h * 60, 0, 0
	}
	return h * 60, C / M, M
}

// IN: hsv ([]float64{ 0-360, 0-100, 0-100 })
// OUT: rgb ([]float64{ 0-1, 0-1, 0-1 })
func hsv2rgb(hsv []float64) (float64, float64, float64) {
	h, s_v, v := hsv[0]/60, hsv[1]/100, hsv[2]/100
	C := v * s_v
	X := C * (1 - math.Abs(fmod(h, 2)-1))
	m := v - C
	r, g, b := 0.0, 0.0, 0.0
	switch {
	case h < 1:
		r, g, b = C, X, 0
	case h < 2:
		r, g, b = X, C, 0
	case h < 3:
		r, g, b = 0, C, X
	case h < 4:
		r, g, b = 0, X, C
	case h < 5:
		r, g, b = X, 0, C
	default:
		r, g, b = C, 0, X
	}
	return r + m, g + m, b + m
}

// IN: hsl ([]float64{ 0-360, 0-100, 0-100 })
// OUT: rgb ([]float64{ 0-1, 0-1, 0-1 })
func hsl2rgb(hsl []float64) (float64, float64, float64) {
	h, s_l, l := float64(hsl[0])/60, float64(hsl[1])/100, float64(hsl[2])/100
	C := (1 - math.Abs(2*l-1)) * s_l
	X := C * (1 - math.Abs(fmod(h, 2)-1))
	m := l - C/2
	if h < 1 {
		return C + m, X + m, m
	} else if h < 2 {
		return X + m, C + m, m
	} else if h < 3 {
		return m, C + m, X + m
	} else if h < 4 {
		return m, X + m, C + m
	} else if h < 5 {
		return X + m, m, C + m
	}
	return C + m, m, X + m
}

// IN: rgb ([]float64{ 0-255, 0-255, 0-255 })
// OUT: hsl (float64: 0-360, float64: 0-1, float64: 0-1)
func rgb2hsl(rgb []float64) (float64, float64, float64) {
	r, g, b := float64(rgb[0])/255, float64(rgb[1])/255, float64(rgb[2])/255
	M, m, C, h := get_intermediate(r, g, b)
	l := (M + m) / 2
	if l == 0 || l == 1 {
		return h * 60, 0, l
	}
	return h * 60, C / (1 - math.Abs(2*l-1)), l
}

// IN: hsl ([]float64{ 0-360, 0-100, 0-100 })
// OUT: hsv ([]float64{ 0-360, 0-1, 0-1 })
func hsv2hsl(hsv []float64) (float64, float64, float64) {
	h, s_v, v := float64(hsv[0]), float64(hsv[1])/100, float64(hsv[2])/100
	l := (1 - s_v/2) * v
	if l == 0 || l == 1 {
		return h, 0, l
	}
	return h, (v - l) / min(l, 1-l), l
}

// IN: hsl ([]float64{ 0-360, 0-100, 0-100 })
// OUT: hsv ([]float64{ 0-360, 0-1, 0-1 })
func hsl2hsv(hsl []float64) (float64, float64, float64) {
	h, s_l, l := float64(hsl[0]), float64(hsl[1])/100, float64(hsl[2])/100
	v := l + s_l*min(l, 1-l)
	if v == 0 {
		return h, 0, v
	}
	return h, 2 - 2*l/v, v
}

// IN: hex (string)
// OUT: rgb ([]float64{ 0-1, 0-1, 0-1 })
func hex2rgb(hex string) (float64, float64, float64) {
	r, g, b := 0, 0, 0
	if len(hex) == 7 {
		fmt.Sscanf(hex, "#%02x%02x%02x", &r, &g, &b)
	} else if len(hex) == 9 {
		fmt.Sscanf(hex, "#%02x%02x%02x%02x", &r, &g, &b)
	}
	return float64(r) / 255, float64(g) / 255, float64(b) / 255
}

// IN: rgb ([]float64{ 0-255, 0-255, 0-255 })
// OUT: hex (string)
func rgb2hex(rgb []float64) string {
	return fmt.Sprintf("#%02x%02x%02x", int(rgb[0]), int(rgb[1]), int(rgb[2]))
}

func recast(v interface{}) []float64 {
	switch v := v.(type) {
	case []int:
		vnew := make([]float64, len(v))
		for i := range v {
			vnew[i] = float64(v[i])
		}
		return vnew
	case []float64:
		return v
	default:
		panic("Invalid type")
	}
}

// RGB_IN: []int/float{ 0-255, 0-255, 0-255 }
// HSV_IN: []int/float{ 0-360, 0-100, 0-100 }
// HSL_IN: []int/float{ 0-360, 0-100, 0-100 }
// HEX_IN: string
// A_IN: []int{ 0-100 }
func ColorFrom(f ColorFormat, vals interface{}) Color {
	var r, g, b, h, s_v, v, s_l, l, a float64
	var hex string

	if f == RGB || f == RGBA {
		v_cast := recast(vals)
		r, g, b = v_cast[0]/255, v_cast[1]/255, v_cast[2]/255
		h, s_v, v = rgb2hsv(v_cast)
		_, s_l, l = rgb2hsl(v_cast)
		hex = rgb2hex(v_cast[:3])
	} else if f == HSV || f == HSVA {
		v_cast := recast(vals)
		h, s_v, v = v_cast[0], v_cast[1]/100, v_cast[2]/100
		r, g, b = hsv2rgb(v_cast)
		_, s_l, l = hsv2hsl(v_cast)
		hex = rgb2hex([]float64{r * 255, g * 255, b * 255})
	} else if f == HSL || f == HSLA {
		v_cast := recast(vals)
		h, s_l, l = v_cast[0], v_cast[1]/100, v_cast[2]/100
		r, g, b = hsl2rgb(v_cast)
		_, s_v, v = hsl2hsv(v_cast)
		hex = rgb2hex([]float64{r * 255, g * 255, b * 255})
	} else if f == HEX || f == HEXA {
		hex = vals.(string)
		r, g, b = hex2rgb(hex)
		h, s_v, v = rgb2hsv([]float64{r * 255, g * 255, b * 255})
		_, s_l, l = rgb2hsl([]float64{r * 255, g * 255, b * 255})
	} else {
		panic("Invalid color format")
	}
	a = 1
	if f == RGBA || f == HSVA || f == HSLA {
		a = recast(vals)[3] / 100
		hex += fmt.Sprintf("%02x", int(a*255))
	} else if f == HEXA {
		if alpha, err := strconv.ParseInt(hex[len(hex)-2:], 16, 32); err != nil {
			panic(err)
		} else {
			a = float64(alpha) / 255
		}
	}
	return Color{
		r:   r,
		g:   g,
		b:   b,
		h:   h,
		s_v: s_v,
		s_l: s_l,
		v:   v,
		l:   l,
		a:   a,
		hex: strings.ToLower(hex),
	}
}

// string
func (c Color) String() string {
	return fmt.Sprintf("Color{\n  rgb: %.2f, %.2f, %.2f\n  hsv: %.2f, %.2f, %.2f,\n  hsl: %.2f, %.2f, %.2f,\n  a: %.2f,\n  hex: %s\n}",
		c.r, c.g, c.b, c.h, c.s_v, c.v, c.h, c.s_l, c.l, c.a, c.hex)
}

func (c Color) As(f ColorFormat) string {
	switch f {
	case RGB:
		return fmt.Sprintf("rgb(%d, %d, %d)", int(c.r*255), int(c.g*255), int(c.b*255))
	case RGBA:
		return fmt.Sprintf("rgba(%d, %d, %d, %.2f)", int(c.r*255), int(c.g*255), int(c.b*255), c.a)
	case HSV:
		return fmt.Sprintf("hsv(%d, %d, %d)", int(c.h), int(c.s_v*100), int(c.v*100))
	case HSVA:
		return fmt.Sprintf("hsva(%d, %d, %d, %.2f)", int(c.h), int(c.s_v*100), int(c.v*100), c.a)
	case HSL:
		return fmt.Sprintf("hsl(%d, %d, %d)", int(c.h), int(c.s_l*100), int(c.l*100))
	case HSLA:
		return fmt.Sprintf("hsla(%d, %d, %d, %.2f)", int(c.h), int(c.s_l*100), int(c.l*100), c.a)
	case HEX:
		return c.hex[:7]
	case HEXA:
		return c.hex
	default:
		panic("Invalid color format")
	}
}
