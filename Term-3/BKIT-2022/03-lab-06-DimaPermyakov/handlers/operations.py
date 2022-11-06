# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram import Dispatcher, types
from create_bot import dp, bot


async def handler_start(message: types.Message):
    pass


async def menu(message: types.Message):
    pass


async def register_handlers(dp_main: Dispatcher):
    dp_main.register_message_handler(handler_start, commands=['start '])
