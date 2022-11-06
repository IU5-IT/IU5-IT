# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

from aiogram.utils import executor
from create_bot import dp


async def on_startup(_):
    print('The bot was included.')


if __name__ == '__main__':
    from handlers import operations

    operations.register_handlers(dp)
    executor.start_polling(dp, skip_updates=True, on_startup=on_startup)
