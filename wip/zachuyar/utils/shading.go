package utils

func Mix(c1, c2 Color, percent float64) Color {
	return ColorFrom(HSLA, []float64{
		c1.h + (c2.h-c1.h)*percent,
		100 * (c1.s_l + (c2.s_l-c1.s_l)*percent),
		100 * (c1.l + (c2.l-c1.l)*percent),
		100 * (c1.a + (c2.a-c1.a)*percent),
	})
}

func Darken()
