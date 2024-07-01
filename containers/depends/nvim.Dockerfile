RUN wget https://github.com/neovim/neovim/releases/download/v0.10.0/nvim-linux64.tar.gz && \
    tar xvf nvim-linux64.tar.gz -C /opt && \
    rm nvim-linux64.tar.gz && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/bin/nvim && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/bin/vim && \
    ln -s /opt/nvim-linux64/bin/nvim /usr/bin/vi
