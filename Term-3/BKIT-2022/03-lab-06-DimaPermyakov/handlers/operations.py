# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram import Dispatcher, types
from aiogram.dispatcher.filters.state import State, StatesGroup
from aiogram.dispatcher import FSMContext
import aiogram.utils.markdown as md
from keyboards.menu_bts import *
from create_bot import dp, bot
from utils.db_management import *


class FSMUsers(StatesGroup):
    id_user = State()
    photo = State()
    name = State()
    age = State()
    place = State()
    university = State()
    department = State()
    description = State()


async def handler_start(message: types.Message):
    # Если пользователь уже зарегистрирован.
    user_data = get_user_data(message.chat.id)
    if user_data is not None:
        text = "Класс! Вы уже зарегистрированы!"
        await message.answer(text=text)
        await message.answer_photo(
            photo=user_data[7],
            caption=md.text(
                md.text('Так выглядит Ваша анкета:\n'),
                md.text(user_data[1] + ", " + str(user_data[2]) + ", " + user_data[3]),
                md.text(user_data[4] + ", " + user_data[5]),
                md.text('О себе:\n'),
                md.text(user_data[6]),
                sep='\n',
            )
        )
        await message.answer('Выберите дальнейший сценарий:', reply_markup=start_markup)

    else:
        await message.answer("О, новичок!\nДавайте Вас зарегистрируем!")
        await FSMUsers.photo.set()
        await message.answer("Отправьте ваше фото:")


async def catch_photo(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['photo'] = message.photo[0].file_id
    await FSMUsers.next()
    await message.reply('Теперь введите Ваше имя:')


async def catch_name(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['name'] = message.text
    await FSMUsers.next()
    await message.reply('Введите ваш возраст:')


async def catch_age(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['age'] = message.text
    await FSMUsers.next()
    await message.reply('Введите ваш город:')


async def catch_place(message: types.Message, state: FSMContext):
    async with state.proxy() as data:
        data['place'] = message.text
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
                md.text('Так выглядит Ваша анкета:\n'),
                md.text(data['name'] + ", " + data['age'] + ", " + data['place']),
                md.text(data['university'] + ", " + data['department']),
                md.text('О себе:\n'),
                md.text(data['description']),
                sep='\n',
            )
        )
        # Добавляет в SQL таблицу.
        if user_presents(message.chat.id):
            update_user_data(message.chat.id, dict(data))
        else:
            set_user_date(message.chat.id, dict(data))

    await state.finish()


async def all_msg_handler(message: types.Message):
    button_text = message.text

    if button_text == 'Заполнить анкету заново':
        await FSMUsers.photo.set()
        await message.answer("Отправьте ваше фото:", reply_markup=types.ReplyKeyboardRemove())

    elif button_text == 'Изменить текст анкеты':
        reply_text = "В разработке"
        await message.reply(reply_text)

    elif button_text == 'Искать друзей 🤝':
        reply_text = "В разработке"
        await message.reply(reply_text)

    else:
        reply_text = "Keep calm... Everything is fine, you just a silly"
        await message.reply(reply_text)
        await message.delete()


def register_handlers(dp_main: Dispatcher):
    dp_main.register_message_handler(handler_start, commands=['start'])
    dp_main.register_message_handler(catch_photo, content_types=['photo'], state=FSMUsers.photo)
    dp_main.register_message_handler(catch_name, state=FSMUsers.name)
    dp_main.register_message_handler(catch_age, lambda message: message.text.isdigit(), state=FSMUsers.age)
    dp_main.register_message_handler(catch_place, state=FSMUsers.place)
    dp_main.register_message_handler(catch_university, state=FSMUsers.university)
    dp_main.register_message_handler(catch_department, state=FSMUsers.department)
    dp_main.register_message_handler(catch_description, state=FSMUsers.description)
    # Last point!! Important!
    dp_main.register_message_handler(all_msg_handler)
