package utils

import (
	"fmt"
	"strings"
	"testing"
)

func check_colors(t *testing.T, c Color, r, g, b, h, s_v, v, s_l, l, a int, hex string) {
	if int(c.r*255) != r {
		t.Errorf("r: expected %d, got %d", r, int(c.r*255))
	}
	if int(c.g*255) != g {
		t.Errorf("g: expected %d, got %d", g, int(c.g*255))
	}
	if int(c.b*255) != b {
		t.Errorf("b: expected %d, got %d", b, int(c.b*255))
	}
	if int(c.h) != h {
		t.Errorf("h: expected %d, got %d", h, int(c.h))
	}
	if int(c.s_v*100) != s_v {
		t.Errorf("s_v: expected %d, got %d", s_v, int(c.s_v*100))
	}
	if int(c.s_l*100) != s_l {
		t.Errorf("s_l: expected %d, got %d", s_l, int(c.s_l*100))
	}
	if int(c.v*100) != v {
		t.Errorf("v: expected %d, got %d", v, int(c.v*100))
	}
	if int(c.l*100) != l {
		t.Errorf("l: expected %d, got %d", l, int(c.l*100))
	}
	if int(c.a*100) != a {
		t.Errorf("a: expected %d, got %d", a, int(c.a*100))
	}
	if c.hex != strings.ToLower(hex) {
		t.Errorf("hex: expected %s, got %s", hex, c.hex)
	}
	if c.As(RGB) != fmt.Sprintf("rgb(%d, %d, %d)", r, g, b) {
		t.Errorf("rgb: expected rgb(%d, %d, %d), got %s", r, g, b, c.As(RGB))
	}
	if c.As(HSV) != fmt.Sprintf("hsv(%d, %d, %d)", h, s_v, v) {
		t.Errorf("hsv: expected hsv(%d, %d, %d), got %s", h, s_v, v, c.As(HSV))
	}
	if c.As(HSL) != fmt.Sprintf("hsl(%d, %d, %d)", h, s_l, l) {
		t.Errorf("hsl: expected hsl(%d, %d, %d), got %s", h, s_l, l, c.As(HSL))
	}
	if c.As(HEXA) != strings.ToLower(hex) {
		t.Errorf("hexa: expected %s, got %s", hex, c.As(HEXA))
	}
}

func TestColors(t *testing.T) {
	check_colors(t,
		ColorFrom(RGB, []int{24, 198, 98}),
		24, 198, 98, // RGB
		145, 87, 77, // HSV
		78, 43, // _SL
		100, // A
		"#18c662")
	check_colors(t,
		ColorFrom(RGB, []int{247, 32, 25}),
		247, 32, 25,
		1, 89, 96,
		93, 53,
		100,
		"#f72019")
	check_colors(t,
		ColorFrom(RGBA, []int{174, 81, 234, 55}),
		174, 81, 234,
		276, 65, 91,
		78, 61,
		55,
		"#ae51eA8C")
	check_colors(t,
		ColorFrom(RGBA, []int{0, 0, 0, 0}),
		0, 0, 0,
		0, 0, 0,
		0, 0,
		0,
		"#00000000")
	check_colors(t,
		ColorFrom(HSV, []int{323, 75, 85}),
		216, 54, 154,
		323, 75, 85,
		68, 53,
		100,
		"#d8369a")
	check_colors(t,
		ColorFrom(HSV, []int{126, 85, 59}),
		22, 150, 35,
		126, 85, 59,
		73, 33,
		100,
		"#169623")
	check_colors(t,
		ColorFrom(HSV, []int{170, 45, 98}),
		137, 249, 231,
		170, 45, 98,
		91, 75,
		100,
		"#89f9e7")
	check_colors(t,
		ColorFrom(HSV, []int{22, 46, 57}),
		145, 103, 78,
		22, 46, 56,
		29, 43,
		100,
		"#91674e")
	check_colors(t,
		ColorFrom(HSV, []int{86, 39, 7}),
		14, 17, 10,
		86, 39, 7,
		24, 5,
		100,
		"#0e110a")
	check_colors(t,
		ColorFrom(HSVA, []int{300, 100, 100, 11}),
		255, 0, 255,
		300, 100, 100,
		100, 50,
		11,
		"#FF00FF1c")
	check_colors(t,
		ColorFrom(HSL, []int{72, 0, 0}),
		0, 0, 0,
		72, 0, 0,
		0, 0,
		100,
		"#000000")
	check_colors(t,
		ColorFrom(HSLA, []int{210, 40, 11, 30}),
		16, 28, 39,
		210, 57, 15,
		40, 11,
		30,
		"#101c274c")
	check_colors(t,
		ColorFrom(HEX, "#000c00"),
		0, 12, 0,
		120, 100, 4,
		99, 2,
		100,
		"#000c00")
	check_colors(t,
		ColorFrom(HEXA, "#ffffffaF"),
		255, 255, 255,
		0, 0, 100,
		0, 100,
		68,
		"#ffffffaF")
}
