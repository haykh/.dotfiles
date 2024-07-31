package style

import (
	"github.com/charmbracelet/lipgloss"
)

func tabBorderWithBottom(left, middle, right string) lipgloss.Border {
	border := lipgloss.RoundedBorder()
	border.BottomLeft = left
	border.Bottom = middle
	border.BottomRight = right
	return border
}

var (
	// tabs menu
	InactiveTabBorder = tabBorderWithBottom("┴", "─", "┴")
	ActiveTabBorder   = tabBorderWithBottom("┘", " ", "└")
	TabContentStyle   = lipgloss.NewStyle().Padding(1, 2, 1, 2)
	HighlightColor    = lipgloss.AdaptiveColor{Light: "#874BFD", Dark: "#7D56F4"}
	InactiveTabStyle  = lipgloss.NewStyle().
				Border(InactiveTabBorder, true).
				BorderForeground(HighlightColor).
				Padding(0, 1)
	ActiveTabStyle = InactiveTabStyle.Border(ActiveTabBorder, true)
	TabWindowStyle = lipgloss.NewStyle().
			BorderForeground(HighlightColor).
			Padding(2, 0).
			Align(lipgloss.Left).
			Border(lipgloss.NormalBorder()).
			UnsetBorderTop()

	// debugger
	DebugStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("241")).Padding(0, 1)

	// items
	ItemStyle = lipgloss.NewStyle().
			Align(lipgloss.Left, lipgloss.Top).
			Margin(0, 0, 1).
			Border(lipgloss.NormalBorder(), false, false, false, true).
			BorderStyle(lipgloss.HiddenBorder())
	ActiveItemStyle = ItemStyle.Copy().
			BorderStyle(lipgloss.NormalBorder()).
			BorderForeground(lipgloss.Color("69"))
	// keywordStyle  = lipgloss.NewStyle().Foreground(lipgloss.Color("211"))
	// subtleStyle   = lipgloss.NewStyle().Foreground(lipgloss.Color("241"))
	// ticksStyle    = lipgloss.NewStyle().Foreground(lipgloss.Color("79"))
	CheckboxStyle = lipgloss.NewStyle().Foreground(lipgloss.Color("212"))
	// progressEmpty = subtleStyle.Render(progressEmptyChar)
	// dotStyle      = lipgloss.NewStyle().Foreground(lipgloss.Color("236")).Render(dotChar)
	// mainStyle     = lipgloss.NewStyle().MarginLeft(2)
	//
	// // Gradient colors we'll use for the progress bar
	// ramp = makeRampStyles("#B14FFF", "#00FFA3", progressBarWidth)
)
