everything here is compiled and installed locally (either `/usr/local/` or `$HOME/.local/` or something similar).

## `python`

```shell
$ git clone https://github.com/python/cpython
$ cd cpython
$ git checkout <PYTHON_VERSION>
$ ./configure --enable-optimizations --prefix=<PATH_TO>/.local/
$ make -s -j<NCORES>
$ make install
```

## `pip` and `virtualenv`

make sure `<PATH_TO>/.local` is in the `PATH` and check `which python` to ensure the correct python is being used.

```shell
$ python -m ensurepip
$ which pip
# make sure the correct `pip` is used
$ pip install virtualenv
$ pip install virtualenvwrapper 
$ echo "export WORKON_HOME=~/<VENV_PATH>" >> ~/.zshrc
$ echo "source "<PATH_TO>/.local/bin/virtualenvwrapper.sh" >> ~/.zshrc
$ source ~/.zshrc
$ mkvirtualenv <PYTHON_ENV>
```

## `nodejs`

for node source see [here](https://nodejs.org/dist/v14.17.0/node-v14.17.0.tar.gz).

```shell
$ wget <URL_NODE_SOURCE>.tar.gz
$ tar -xvf <NODE_SOURCE>.tar.gz
$ cd <NODE_SOURCE>
$ ./configure --prefix=<PATH_TO>/.local
$ make -j <NCORES>
$ make install
```

