# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from .manage_db import load_data


async def get_status(user_id: int, filename: str = 'data') -> bool:
    return load_data(filename)[user_id]['status_present']


async def get_name(user_id: int, filename: str = 'data') -> str:
    return load_data(filename)[user_id]['name']


async def get_university(user_id: int, filename: str = 'data') -> str:
    return load_data(filename)[user_id]['university']


async def get_department(user_id: int, filename: str = 'data') -> str:
    return load_data(filename)[user_id]['department']


async def get_description(user_id: int, filename: str = 'data') -> str:
    return load_data(filename)[user_id]['description']
