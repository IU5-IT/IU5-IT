# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from .manage_db import load_data


def get_status(user_id: str, filename: str = 'data/data') -> bool:
    return False if load_data(filename).get(user_id) is None else True


def get_name(user_id: str, filename: str = 'data/data') -> str:
    return load_data(filename)[user_id]['name']


def get_university(user_id: str, filename: str = 'data/data') -> str:
    return load_data(filename)[user_id]['university']


def get_department(user_id: str, filename: str = 'data/data') -> str:
    return load_data(filename)[user_id]['department']


def get_description(user_id: str, filename: str = 'data/data') -> str:
    return load_data(filename)[user_id]['description']
