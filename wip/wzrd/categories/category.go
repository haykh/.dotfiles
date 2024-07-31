package categories

import (
	"fmt"
	"github.com/charmbracelet/bubbles/help"
	"github.com/charmbracelet/bubbles/key"
	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/lipgloss"
	ui "github.com/haykh/.dotfiles/style"
	"github.com/haykh/.dotfiles/utils"
)

type keyMap struct {
	Up     key.Binding
	Down   key.Binding
	Select key.Binding
}

func (k keyMap) ShortHelp() []key.Binding {
	return []key.Binding{k.Up, k.Down, k.Select}
}

func (k keyMap) FullHelp() [][]key.Binding {
	return nil
}

type Category struct {
	Items  []tea.Model
	active int

	help help.Model
	keys keyMap
}

func (c Category) Init() tea.Cmd {
	return nil
}

func (c Category) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	switch msg := msg.(type) {
	case utils.SelectMsg:
		c.Items[c.active], cmd = c.Items[c.active].Update(msg)
	case utils.UpMsg:
		c.active = max(c.active-1, 0)
		cmd = utils.DebugCmd(fmt.Sprintf("active: %d", c.active))
	case utils.DownMsg:
		c.active = min(c.active+1, len(c.Items)-1)
		cmd = utils.DebugCmd(fmt.Sprintf("active: %d", c.active))
	}
	return c, cmd
}

func (c Category) View() string {
	s := []string{}
	for i, item := range c.Items {
		if i == c.active {
			s = append(s, ui.ActiveItemStyle.Render(item.View()))
		} else {
			s = append(s, ui.ItemStyle.Render(item.View()))
		}
	}
	s = append(s, c.help.View(c.keys))
	return lipgloss.JoinVertical(lipgloss.Left, s...)
}

func NewCategory(items []tea.Model) Category {
	return Category{Items: items}
}
