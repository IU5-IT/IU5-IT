# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

import json


def write_data(data: dict, filename: str = "data/data") -> None:
    with open(f"{filename}.json", "a+") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)


def load_data(filename: str = "data/data") -> dict:
    with open(f"{filename}.json", "r") as file:
        data = json.load(file)
    return data
