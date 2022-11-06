# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

import json


def write_data(data: dict, filename: str = "data"):
    with open(f"data/{filename}.json", "w") as file:
        json.dump(data, file, indent=2, ensure_ascii=False)


def load_data(filename: str = "data") -> dict:
    with open(f"data/{filename}.json", "r") as file:
        data = json.load(file)
    return data
