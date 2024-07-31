package main

import (
	"fmt"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	cat "github.com/haykh/.dotfiles/categories"
	menu "github.com/haykh/.dotfiles/menu"
)

var (
	NO_DEBUG = false
	DEBUG    = true
)

func main() {
	m := menu.NewMenu(
		map[string]tea.Model{
			"shell": cat.NewCategory([]tea.Model{
				cat.NewCheckbox("zsh"),
				cat.NewCheckbox("starship"),
				cat.NewCheckbox("oh-my-zsh"),
			}),
			"hardware": cat.NewCategory([]tea.Model{
				cat.NewCheckbox("powerctl"),
				cat.NewCheckbox("bluetooth"),
				cat.NewCheckbox("network"),
			}),
			// cat.Category{Text: "shell"},
			// cat.Category{Text: "hardware"},
			// cat.Category{Text: "ui"},
			// cat.Category{Text: "utils"},
			// cat.Category{Text: "devtools"},
		},
		DEBUG,
	)
	if _, err := tea.NewProgram(m).Run(); err != nil {
		fmt.Println("Error running program:", err)
		os.Exit(1)
	}
}
