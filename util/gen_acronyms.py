import logging
import sys
from argparse import ArgumentParser, Namespace
from csv import DictReader
from dataclasses import dataclass
from datetime import date
from typing import List


@dataclass
class Acronym:
    """LaTeX acronym dataclass"""

    ref: str
    short: str
    long: str

    def __str__(self) -> str:
        return (
            "{" + f"{self.ref}" + "}"
            "{" + f"{self.short}" + "}"
            "{" + f"{self.long}" + "}"
        )


def parse_args() -> Namespace:
    """CLI arguments parser"""

    parser = ArgumentParser(description="Parse acronyms CSV")
    parser.add_argument("csv_file", type=str, help="Path to the CSV file")
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        default="acronyms.tex",
        help="Path to the output file",
    )
    parser.add_argument(
        "-d", "--delimiter", type=str, default=",", help="CSV delimiter"
    )
    return parser.parse_args()


def parse_csv(csv_file: str, delimiter: str) -> List[Acronym]:
    """Parse a CSV containing acronyms"""

    acronyms: List[Acronym] = []
    with open(csv_file, newline="", mode="r") as f:
        csv_reader: DictReader = DictReader(f, delimiter=delimiter)
        try:
            for row in csv_reader:
                acronyms.append(
                    Acronym(ref=row["ref"], short=row["short"], long=row["long"])
                )
        except KeyError:
            logging.error(
                f"Wrong CSV format, header must be ['ref', 'short', 'long'] but {csv_reader.fieldnames} was read."
            )
            sys.exit(1)
    return acronyms


def sort_acronyms(acronyms: List[Acronym], attribute: str = "long") -> List[Acronym]:
    """Sort acronyms alphabetically"""
    return sorted(acronyms, key=lambda x: getattr(x, attribute))


def write_acronyms(acronyms: List[Acronym], tex_file: str, csv_file: str) -> None:
    """Write .tex file containing acronyms"""

    with open(tex_file, mode="w") as f:
        header: str = (
            f"%% Acronyms generated from CSV file {csv_file} - {date.today()}\n"
            "%% Format: {ref name when called in LaTeX}{short version}{long version}\n"
        )

        f.write(header)

        prev_letter: str = ""
        for acr in acronyms:
            letter: str = acr.long[0]
            if letter != prev_letter:
                prev_letter = letter
                f.write(f"\n% {letter}\n")
            f.write(f"\\newacronym{acr}\n")


def main() -> int:
    args: Namespace = parse_args()
    csv_file: str = args.csv_file
    tex_file: str = args.output
    delimiter: str = args.delimiter

    write_acronyms(sort_acronyms(parse_csv(csv_file, delimiter)), tex_file, csv_file)

    sys.exit(0)


if __name__ == "__main__":
    main()
