package menu

import (
	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	ui "github.com/haykh/.dotfiles/style"
	"github.com/haykh/.dotfiles/utils"
	"strings"
)

type keyMap struct {
	Up     key.Binding
	Down   key.Binding
	Left   key.Binding
	Right  key.Binding
	Select key.Binding
	Help   key.Binding
	Quit   key.Binding
}

func (k keyMap) ShortHelp() []key.Binding {
	return []key.Binding{k.Help, k.Quit}
}

func (k keyMap) FullHelp() [][]key.Binding {
	return [][]key.Binding{
		{k.Left, k.Right, k.Up, k.Down},
		{k.Select, k.Help, k.Quit},
	}
}

type Menu struct {
	TabLabels []string
	Tabs      []tea.Model
	activeTab int

	quitting bool

	help help.Model
	keys keyMap

	dbg debugger
}

func (m Menu) Init() tea.Cmd {
	return nil
}

func (m Menu) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	switch msg := msg.(type) {
	case tea.KeyMsg:
		switch {
		case key.Matches(msg, m.keys.Left):
			m.activeTab = max(m.activeTab-1, 0)
			return m, cmd
		case key.Matches(msg, m.keys.Right):
			m.activeTab = min(m.activeTab+1, len(m.TabLabels)-1)
			return m, cmd
		case key.Matches(msg, m.keys.Up):
			m.Tabs[m.activeTab], cmd = m.Tabs[m.activeTab].Update(utils.UpMsg{})
			return m, cmd
		case key.Matches(msg, m.keys.Down):
			m.Tabs[m.activeTab], cmd = m.Tabs[m.activeTab].Update(utils.DownMsg{})
			return m, cmd
		case key.Matches(msg, m.keys.Select):
			m.Tabs[m.activeTab], cmd = m.Tabs[m.activeTab].Update(utils.SelectMsg{})
			return m, cmd
		case key.Matches(msg, m.keys.Help):
			m.help.ShowAll = !m.help.ShowAll
			return m, cmd
		case key.Matches(msg, m.keys.Quit):
			m.quitting = true
			return m, tea.Quit
		}
	case utils.DebugMsg:
		m.dbg.Log(msg.String())
		return m, nil
	default:
		m.Tabs[m.activeTab], cmd = m.Tabs[m.activeTab].Update(msg)
		return m, cmd
	}
	return m, nil
}

func (m Menu) View() string {
	if m.quitting {
		return "Bye!\n"
	}
	doc := strings.Builder{}

	var renderedTabs []string

	for i, t := range m.TabLabels {
		var style lipgloss.Style
		isFirst, isLast, isActive := i == 0, i == len(m.TabLabels)-1, i == m.activeTab
		if isActive {
			style = ui.ActiveTabStyle
		} else {
			style = ui.InactiveTabStyle
		}
		border, _, _, _, _ := style.GetBorder()
		if isFirst && isActive {
			border.BottomLeft = "│"
		} else if isFirst && !isActive {
			border.BottomLeft = "├"
		} else if isLast && isActive {
			border.BottomRight = "│"
		} else if isLast && !isActive {
			border.BottomRight = "┤"
		}
		style = style.Border(border).Width(len(t) + 10)
		renderedTabs = append(renderedTabs, style.Render(t))
	}

	row := lipgloss.JoinHorizontal(lipgloss.Top, renderedTabs...)
	style := ui.TabWindowStyle.Width(
		lipgloss.Width(row) - ui.TabWindowStyle.GetHorizontalFrameSize(),
	)
	doc.WriteString(row)
	doc.WriteString("\n")
	doc.WriteString(style.Render(m.Tabs[m.activeTab].View()))

	tabView := ui.TabContentStyle.Render(doc.String())
	helpView := m.help.View(m.keys)
	return "\n" + tabView + "\n\n" + helpView + "\n" + m.dbg.View()
}

func NewMenu(tabs map[string]tea.Model, debug bool) Menu {
	tabLabels := make([]string, 0, len(tabs))
	tabModels := make([]tea.Model, 0, len(tabs))
	for k := range tabs {
		tabLabels = append(tabLabels, k)
		tabModels = append(tabModels, tabs[k])
	}
	return Menu{
		TabLabels: tabLabels,
		Tabs:      tabModels,
		keys: keyMap{
			Left: key.NewBinding(
				key.WithKeys("[", "left"),
				key.WithHelp("←/[", "left tab"),
			),
			Right: key.NewBinding(
				key.WithKeys("]", "right"),
				key.WithHelp("→/]", "right tab"),
			),
			Up: key.NewBinding(
				key.WithKeys("k", "up"),
				key.WithHelp("↑/k", "up"),
			),
			Down: key.NewBinding(
				key.WithKeys("j", "down"),
				key.WithHelp("↓/j", "down"),
			),
			Select: key.NewBinding(
				key.WithKeys("enter", " "),
				key.WithHelp("󱁐/󰌑", "select/toggle"),
			),
			Help: key.NewBinding(
				key.WithKeys("h", "?"),
				key.WithHelp("h/?", "help"),
			),
			Quit: key.NewBinding(
				key.WithKeys("q", "esc", "ctrl+c"),
				key.WithHelp("q", "quit"),
			),
		},
		help: help.New(),
		dbg:  NewDebugger(debug),
	}
}
