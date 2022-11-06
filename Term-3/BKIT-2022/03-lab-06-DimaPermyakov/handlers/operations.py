# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram import Dispatcher, types
from aiogram.dispatcher.filters.state import State, StatesGroup
from aiogram.dispatcher import FSMContext
from utils.manage_db import write_data
import aiogram.utils.markdown as md
from create_bot import dp, bot
from utils.get_data import *
from utils.manage_db import load_data


class FSMUsers(StatesGroup):
    id_user = State()
    status_present = State()
    photo = State()
    name = State()
    university = State()
    department = State()
    description = State()


async def handler_start(message: types.Message):
    # Если пользователь уже зарегистрирован.
    if get_status(str(message.chat.id)):
        id_temp: str = str(message.chat.id)
        text = f"Класс! Вы уже зарегистрированы! Вот ваши данные:\n" \
               f"Имя: {get_name(id_temp)}\n" \
               f"Университет: {get_university(id_temp)}\n" \
               f"Факультет: {get_department(id_temp)}\n" \
               f"О себе: {get_description(id_temp)}\n"
        await message.answer(text=text)
        # TODO: А что дальше? Придумать.

    else:
        await message.answer("Давайте Вас зарегистрируем!")
        await FSMUsers.photo.set()
        await message.answer("Отправьте фото")


async def catch_photo(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['photo'] = message.photo[0].file_id
    await FSMUsers.next()
    await message.reply('Теперь введите Ваше имя:')


async def catch_name(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['name'] = message.text
    await FSMUsers.next()
    await message.reply('Введите название вашего университета:')


async def catch_university(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['university'] = message.text
    await FSMUsers.next()
    await message.reply('Введите название вашего факультета:')


async def catch_department(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['department'] = message.text
    await FSMUsers.next()
    await message.reply('Расскажите что-то о себе:')


async def catch_description(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['description'] = message.text
    async with state.proxy() as data:
        await message.answer_photo(
            photo=data['photo'],
            caption=md.text(
                md.text('Так выглядит твоя анкета:\n'),
                md.text(data['name'] + ", " + data['university'] + ", " + data['department']),
                md.text(data['description']),
                sep='\n',
            )
        )
        res = dict()
        res[str(message.chat.id)] = dict(data).copy()
        write_data(res)
    await state.finish()


def register_handlers(dp_main: Dispatcher):
    dp_main.register_message_handler(handler_start, commands=['start'])
    dp_main.register_message_handler(catch_photo, content_types=['photo'], state=FSMUsers.photo)
    dp_main.register_message_handler(catch_name, state=FSMUsers.name)
    dp_main.register_message_handler(catch_university, state=FSMUsers.university)
    dp_main.register_message_handler(catch_department, state=FSMUsers.department)
    dp_main.register_message_handler(catch_description, state=FSMUsers.description)
