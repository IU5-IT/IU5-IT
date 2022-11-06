# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram.types import ReplyKeyboardMarkup, KeyboardButton

markup = ReplyKeyboardMarkup(resize_keyboard=True)
b1 = KeyboardButton('')
b2 = KeyboardButton('')
markup.row(b1, b2)
