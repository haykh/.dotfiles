package menu

import (
	ui "github.com/haykh/.dotfiles/style"
)

type debugger struct {
	msg     string
	enabled bool
}

func NewDebugger(on bool) debugger {
	return debugger{msg: "", enabled: on}
}

func (d *debugger) Log(msg string) {
	if d.enabled {
		d.msg = msg
	}
}

func (d debugger) View() string {
	if d.enabled {
		return ui.DebugStyle.Render("\nDEBUG: " + d.msg)
	}
	return ""
}
