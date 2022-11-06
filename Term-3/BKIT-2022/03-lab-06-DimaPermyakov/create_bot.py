# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>
from aiogram import Bot, Dispatcher
from aiogram.contrib.fsm_storage.memory import MemoryStorage

TOKEN = '5618479465:AAFefyhHZJ_7hd7jii0Jo9I1dorODPzEm9Q'

bot = Bot(TOKEN)
storage = MemoryStorage()
dp = Dispatcher(bot, storage=MemoryStorage())
