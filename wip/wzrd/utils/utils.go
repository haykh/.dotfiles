package utils

import (
	tea "github.com/charmbracelet/bubbletea"
)

type DownMsg struct{}
type UpMsg struct{}
type SelectMsg struct{}

type DebugMsg struct {
	msg string
}

func (dbg DebugMsg) String() string {
	return dbg.msg
}

func DebugCmd(msg string) tea.Cmd {
	return func() tea.Msg {
		return DebugMsg{msg}
	}
}
