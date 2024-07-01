
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install -y python3.12-dev python3.12-venv && \
    ln -s $(which python3.12) /usr/bin/python
