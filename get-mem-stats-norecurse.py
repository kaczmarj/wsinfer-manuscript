"""Collect RSS memory of a process and its children."""

import argparse
import time

import psutil


def get_rss(proc: psutil.Process) -> int:

    mem = 0

    try:
        mem += proc.memory_full_info().uss
    except psutil.NoSuchProcess:
        pass

    return mem


def main(args):
    with open(args.path, "w") as f:
        f.write("timestamp\trss\n")

    proc = psutil.Process(args.pid)

    while True:
        mem = get_rss(proc)
        timestamp = time.time()
        with open(args.path, "a") as f:
            f.write(f"{timestamp}\t{mem}\n")
        time.sleep(5)


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("path", help="Path to output")
    p.add_argument("pid", type=int, help="Process ID")
    args = p.parse_args()
    main(args)

