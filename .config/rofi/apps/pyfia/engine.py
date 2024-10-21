import sys
import time
import logging
from io import StringIO
from contextlib import redirect_stdout
import threading
from oompy import Constants as c, Units as u

__logger = logging.getLogger(__name__)

if __name__ == '__main__':
    assert len(sys.argv) == 5, "usage: python engine.py CMD_FILE OUT_FILE ERR_FILE LOG_FILE"
    CMD_FILE = sys.argv[1]
    OUT_FILE = sys.argv[2]
    ERR_FILE = sys.argv[3]
    LOG_FILE = sys.argv[4]

    logging.basicConfig(filename=LOG_FILE, level=logging.INFO)

    __logger.info("python engine started")

    __timer = threading.Event()
    __timer.set()
    if __timer.is_set():
        __logger.info("timer start")
    else:
        __logger.error("timer failed to start")
        sys.exit(1)

    __interval = 0.1

    if not open(CMD_FILE, 'a').closed:
        __logger.info(f"created {CMD_FILE}")
    if not open(OUT_FILE, 'a').closed:
        __logger.info(f"created {OUT_FILE}")
    if not open(ERR_FILE, 'a').closed:
        __logger.info(f"created {ERR_FILE}")

    __fcmd = open(CMD_FILE, 'r+')
    __logger.info(f"opened {CMD_FILE}")
    __fout = open(OUT_FILE, 'w')
    __logger.info(f"opened {OUT_FILE}")
    __ferr = open(ERR_FILE, 'w')
    __logger.info(f"opened {ERR_FILE}")

    __id = 1
    
    while __timer.is_set():
        __fcmd.seek(0)
        if __fcmd.read() != '':
            __fcmd.seek(0)
            try:
                __command = __fcmd.read().strip('\n')
            except Exception as __e:
                __logger.error(f"ERROR [{__id}]: {__e}")
                __ferr.seek(0)
                __ferr.write(f"{__e}\n")
                __ferr.flush()
            else:
                __fcmd.seek(0)
                __fcmd.truncate()
                __fout.seek(0)
                __fout.truncate()

                __logger.info(f"IN [{__id}]: {__command}")
                if __command == 'exit':
                    break
                try:
                    with redirect_stdout(StringIO()) as __rstdout:
                        exec(__command)
                    __fout.seek(0)
                    if (__out := __rstdout.getvalue().strip('\n')) != '':
                        __logger.info(f"OUT [{__id}]: {__out}")
                        __fout.write(f"{__out}")
                    else:
                        __fout.write(f"None\n")
                    __fout.flush()
                except Exception as __e:
                    __logger.error(f"ERROR [{__id}]: {__e}")
                    __ferr.seek(0)
                    __ferr.write(f"{__e}\n")
                    __ferr.flush()
                else:
                    __id += 1
        time.sleep(__interval)
     
    __fcmd.close()

    if __fcmd.closed:
        __logger.info("Cmd file closed")

    __fout.close()

    if __fout.closed:
        __logger.info("Output file closed")

    __timer.clear()

    if not __timer.is_set():
        __logger.info("timer stopped")

    __logger.info("python engine stopped")
