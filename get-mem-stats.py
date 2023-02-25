"""Collect RSS memory of a process and its children."""

import argparse
import time


def get_rss(pid: int) -> int:
    with open(f"/proc/{pid}/smaps") as f:
        mem = (l for l in f if "Rss" in l)
        # All units are in kB.
        return sum(int(m.split()[1]) for m in mem)


def main(args):
    with open(args.path, "w") as f:
        f.write("timestamp\trss_kB\n")

    while True:
        print("Getting memory usage")
        mem = get_rss(args.pid)
        timestamp = time.time()
        with open(args.path, "a") as f:
            f.write(f"{timestamp}\t{mem}\n")
        time.sleep(2)


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("path", help="Path to output")
    p.add_argument("pid", type=int, help="Process ID")
    args = p.parse_args()
    main(args)

