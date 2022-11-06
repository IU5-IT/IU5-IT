# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram import Dispatcher, types
from aiogram.dispatcher.filters.state import State, StatesGroup
from aiogram.dispatcher import FSMContext
from create_bot import dp, bot
from utils.get_data import *
from utils.manage_db import load_data


class FSMUsers(State):
    id_user = State()
    status_present = State()
    photo = State()
    name = State()
    university = State()
    department = State()
    description = State()


async def handler_start(message: types.Message):
    # Если пользователь уже зарегистрирован.
    if get_status(message.chat.id):
        id_temp = message.chat.id
        text = f"Класс! Вы уже зарегистрированы! Вот ваши данные:\n"
        f"Имя: {get_name(id_temp)}\n"
        f"Имя: {get_university(id_temp)}\n"
        f"Имя: {get_department(id_temp)}\n"
        f"Имя: {get_description(id_temp)}\n"
        await message.answer(text=text)
        # TODO: А что дальше? Придумать.

    else:
        text = "Давайте Вас зарегистрируем!"
        await message.answer(text=text)


async def menu(message: types.Message):
    pass


async def register_handlers(dp_main: Dispatcher):
    dp_main.register_message_handler(handler_start, commands=['start'])
