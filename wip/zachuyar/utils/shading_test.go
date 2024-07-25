package utils

import (
	"testing"
)

func TestShading(t *testing.T) {
	white := ColorFrom(HEX, "#ffffff")
	black := ColorFrom(HEX, "#000000")
	if Mix(white, black, 0.5).As(HEX) != "#7f7f7f" {
		t.Errorf("Mix: expected #7f7f7f, got %s", Mix(white, black, 0.5).As(HEX))
	}
	if Mix(white, black, 0.0).As(HEX) != "#ffffff" {
		t.Errorf("Mix: expected #ffffff, got %s", Mix(white, black, 0.0).As(HEX))
	}
	if Mix(white, black, 1.0).As(HEX) != "#000000" {
		t.Errorf("Mix: expected #000000, got %s", Mix(white, black, 1.0).As(HEX))
	}
}
