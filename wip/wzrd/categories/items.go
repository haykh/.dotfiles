package categories

import (
	"fmt"
	tea "github.com/charmbracelet/bubbletea"
	ui "github.com/haykh/.dotfiles/style"
	"github.com/haykh/.dotfiles/utils"
)

type Checkbox struct {
	Text    string
	Checked bool
}

func (c Checkbox) Init() tea.Cmd {
	return nil
}

func (c Checkbox) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	var cmd tea.Cmd
	switch msg.(type) {
	case utils.SelectMsg:
		c.Checked = !c.Checked
		cmd = utils.DebugCmd(fmt.Sprintf("checked: %t", c.Checked))
	}
	return c, cmd
}

func (c Checkbox) View() string {
	if c.Checked {
		return ui.CheckboxStyle.Render("[] " + c.Text)
	}
	return fmt.Sprintf("[ ] %s", c.Text)
}

func NewCheckbox(text string) Checkbox {
	return Checkbox{Text: text}
}
