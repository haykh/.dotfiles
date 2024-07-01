RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 17 && \
    apt-get update && \
    apt-get install -y clang-format-17 && \
    ln -s $(which clang-format-17) /usr/bin/clang-format && \
    ln -s $(which clangd-17) /usr/bin/clangd
