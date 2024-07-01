RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/* && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

