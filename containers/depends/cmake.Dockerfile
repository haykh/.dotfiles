RUN wget "https://github.com/Kitware/CMake/releases/download/v3.29.6/cmake-3.29.6-linux-x86_64.tar.gz" -P /opt && \
    tar xvf /opt/cmake-3.29.6-linux-x86_64.tar.gz -C /opt && \
    rm /opt/cmake-3.29.6-linux-x86_64.tar.gz
ENV PATH=/opt/cmake-3.29.6-linux-x86_64/bin:$PATH
