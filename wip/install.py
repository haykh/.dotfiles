class PrecompiledBinary:
    def __init__(self, label: str, urls: dict[str, str], install_dir: str = "$HOME/.local/bin/"):
        self.label = label
        self.urls = urls
        self.install_dir = install_dir

    def install(self, os: str):
        url = self.urls[os]
        print(f"Installing {self.label} from {url} to {self.install_dir}")
    
    def uninstall(self):
        print(f"Uninstalling {self.label} from {self.install_dir}")

class ZshPlugin:
    def __init__(self, repo: str):
        self.label = repo.split('/')[-1].replace('.git', '')
        self.repo = repo
        self.install_dir = f"${{ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}}/plugins/{self.label}"

    def install(self):
        # git clone {self.repo} {self.install_dir}
        print(f"Installing {self.label} from {self.repo} to {self.install_dir}")

class InstallScript:
    def __init__(self, label: str, url: str):
        self.label = label
        self.url = url
        
    def install(self):
        # curl -o- {self.url} | bash
        print(f"Installing {self.label} from {self.url}")

OhMyZsh = {
    "installs": [
        InstallScript("oh-my-zsh", "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"),
        ZshPlugin("https://github.com/zsh-users/zsh-syntax-highlighting.git"),
        ZshPlugin("https://github.com/zsh-users/zsh-autosuggestions.git"),
    ]
}

install_options = [
    "oh-my-zsh", "ssh", "fonts", "exa", "nvim", "nvm",
]

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
# https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-gnu.tar.gz

class Prompt:
    def __init__(self, message: str):
        self.message = message
    
    def __enter__(self):
        print(self.message)
        user_input = input()
        return user_input
    
    def __exit__(self, exc_type, exc_value, traceback):
        ...

if __name__ == '__main__':
    with Prompt('What is your name?') as name:
        print(f'Hello, {name}!')