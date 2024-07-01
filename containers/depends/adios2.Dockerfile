RUN git clone https://github.com/ornladios/ADIOS2.git /opt/adios2-src && \
    cd /opt/adios2-src && \
    cmake -B build \
      -D CMAKE_CXX_STANDARD=17 \
      -D CMAKE_CXX_EXTENSIONS=OFF \
      -D CMAKE_POSITION_INDEPENDENT_CODE=TRUE \
      -D BUILD_SHARED_LIBS=ON \
      -D ADIOS2_USE_HDF5=ON \
      -D ADIOS2_USE_Python=OFF \
      -D ADIOS2_USE_Fortran=OFF \
      -D ADIOS2_USE_ZeroMQ=OFF \
      -D BUILD_TESTING=OFF \
      -D ADIOS2_BUILD_EXAMPLES=OFF \
      -D ADIOS2_USE_MPI=OFF \
      -D ADIOS2_HAVE_HDF5_VOL=OFF \
      -D CMAKE_INSTALL_PREFIX=/opt/adios2 && \
    cmake --build build -j && \
    cmake --install build && \
    rm -rf /opt/adios2-src
ENV PATH=/opt/adios2/bin:$PATH
ENV ADIOS2_DIR=/opt/adios2
