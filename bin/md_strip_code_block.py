#!/usr/bin/env python3

from pathlib import Path
import sys

def main(from_path: Path, out_path: Path):
    if not from_path.exists():
        # raise RuntimeError(f"src {from_path} should exist!")
        sys.exit(1)
    if out_path.exists():
        # raise RuntimeError(f"destination {out_path} should not exist!")
        sys.exit(2)

    out = out_path.open("w")

    with from_path.open("r") as f:
        lines = f.readlines()
        discard = False
        for line in lines:
            if line.startswith("```"):
                discard = not discard
                out.write("\n")
            else:
                # if "```" in line:
                #     sys.exit(2)
                if discard:
                    out.write("\n")
                else:
                    out.write(line)
    # print(out_path)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        sys.exit(1)
    main(Path(sys.argv[1]), Path(sys.argv[2]))
