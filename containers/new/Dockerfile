FROM ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0.0

ENV LC_ALL=C.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

ENV VIRTUAL_ENV=/opt/venv

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        sudo locales rsync unzip libssl-dev pkg-config \
        build-essential g++ cmake \
        openmpi-bin libopenmpi-dev \
        zsh curl wget git python3.12 python3.12-venv \
        ca-certificates fonts-powerline && \
        apt-get clean && \
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen && \
    dpkg-reconfigure locales && locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

RUN wget https://raw.githubusercontent.com/haykh/.dotfiles/refs/heads/master/scripts/minrc.sh -O $HOME/minrc.sh && \
    chmod +x $HOME/minrc.sh && bash $HOME/minrc.sh --unattended && \
    git clone https://github.com/haykh/.dotfiles.git $HOME/.dotfiles && \
    ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim && \
    ln -s $HOME/.dotfiles/.config/starship.toml $HOME/.config/starship.toml 

RUN python3.12 -m venv /opt/venv && \
    $VIRTUAL_ENV/bin/python -m pip install --upgrade pip && \
    $VIRTUAL_ENV/bin/python -m pip install matplotlib numpy scipy jupyterlab ipykernel && \
    echo "export PATH=$VIRTUAL_ENV/bin:\$PATH" >> $HOME/.zshrc && \
    echo "source $VIRTUAL_ENV/bin/activate" >> $HOME/.zshrc && \
    $HOME/.local/bin/nvim --headless "+Lazy! sync" +qa && \
    $HOME/.local/bin/nvim --headless "+MasonInstall all" +qa

RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf $HOME/.cache

ARG HOME=/root
WORKDIR $HOME
