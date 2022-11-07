# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

import sqlite3

# Теория.
'''
db = sqlite3.connect('../data/users.db')
cursor = db.cursor()

--- Создание.
db = sqlite3.connect('../data/users.db')
cursor = db.cursor()
cursor.execute("""CREATE TABLE users (
    id_user integer,
    name text,
    age integer,
    place text,
    university text,
    department text,
    description text,
    photo text
)""")
db.commit()
db.close()


--- Добавление данных.
cursor.execute(
    "INSERT INTO users VALUES (0, 'Richard', 19, 'Moscow', 'IU5', 'I like only two things: coffee and my GitHub: "
    "https://github.com/mightyK1ngRichard')")

--- Выборка данных.
ИЛИ cursor.execute("SELECT * FROM users")
cursor.execute("SELECT rowid, name FROM users")
cursor.execute("SELECT rowid, * FROM users")
for el in cursor.fetchall():
    print(el)

--- Условия выборки.
cursor.execute("SELECT rowid, * FROM users WHERE id_user = 0")
for el in cursor.fetchall():
    print(el)

--- Удаление данных.
cursor.execute("DELETE FROM users") - Удалить всё.
cursor.execute("DELETE FROM users WHERE id_user = 1 ") - Удалить по условию.

--- Обновление данных.
cursor.execute("UPDATE users SET name = 'mightyRichard' WHERE id_user = 0")

db.commit()
db.close() 
'''


def update_name(id_user: int, new_name: str, filename: str = 'data/users.db') -> None:
    db = sqlite3.connect(filename)
    cursor = db.cursor()
    cursor.execute(f"UPDATE users SET name = '{new_name}' WHERE id_user = {id_user}")
    db.commit()
    db.close()


def get_user_data(id_user: int, filename: str = 'data/users.db') -> tuple | None:
    db = sqlite3.connect(filename)
    cursor = db.cursor()
    cursor.execute(f"SELECT * FROM users WHERE id_user = {id_user}")
    res = cursor.fetchone()
    db.commit()
    db.close()
    return res


def set_user_date(id_user: int, data: dict, filename: str = 'data/users.db'):
    db = sqlite3.connect(filename)
    cursor = db.cursor()
    cursor.execute(
        "INSERT INTO users VALUES ({}, '{}', {}, '{}', '{}', '{}', '{}', '{}')".format(id_user, data['name'],
                                                                                       data['age'],
                                                                                       data['place'],
                                                                                       data['university'],
                                                                                       data['department'],
                                                                                       data['description'],
                                                                                       data['photo'])
    )
    db.commit()
    db.close()


def update_user_data(id_user: int, data: dict, filename: str = 'data/users.db'):
    db = sqlite3.connect(filename)
    cursor = db.cursor()
    cursor.execute(
        "UPDATE users SET name = '{}', age={}, place = '{}', university = '{}', department = '{}', description = '{}',"
        "photo = '{}'  WHERE id_user = {}".format(data['name'], data['age'], data['place'], data['university'],
                                                  data['department'],
                                                  data['description'],
                                                  data['photo'],
                                                  id_user))

    db.commit()
    db.close()


def user_presents(id_user: int, filename: str = 'data/users.db') -> bool:
    """Checking, is user in data or is not.
    :param id_user: id of the checking user.
    :param filename: way and name for file.
    :return: user status True/False.
    """
    db = sqlite3.connect(filename)
    cursor = db.cursor()
    cursor.execute(f"SELECT id_user FROM users WHERE id_user = {id_user}")
    lst = cursor.fetchall()
    db.commit()
    db.close()
    return False if len(lst) == 0 else True


# update_name(0, 'Richard', '../data/users.db') res = get_user_data(0, '../data/users.db') print(res) print((
# get_user_data(1, '../data/users.db'))) print(beautiful_tuple_of_user_data(0, '../data/users.db')) update_user_data(
# 709333344, {'name': 'Nick', 'age': '19', 'place': 'Москва', 'university': 'МГТУ', 'department': 'ФН2',
# 'description': '🤡', 'photo': 'AgACAgIAAxkBAAOfY2ghBK_eQjXsaOo8v80vZURijdkAAu--MRtUqEBL2ktqWFcO3ioBAAMCAANzAAMrBA
# '}, '../data/users.db')

# update_user_data(0, dict(name='Richard', age=19, place='Moscow', university='BMSTU', department='IU5',
# description='I like only two things: coffee and my GitHub: https://github.com/mightyK1ngRichard',
# photo='https://sun1.userapi.com/sun1-92/s/v1/ig2/lf3_ugEwdsFS8tmjqLxfFTM3Yax7_lZ7fU0840KOWVvgDOYNnwvS
# -zfZ3jj2g5p0YfITVkbNJ1V5Dvjj6naWUj6D.jpg?size=1080x1080&quality=95&type=album'), '../data/users.db')

# --- Удалил ласт чела.
# db = sqlite3.connect('../data/users.db')
# cursor = db.cursor()
# cursor.execute("DELETE FROM users WHERE rowid = 6")
# db.commit()
# db.close()

# print(user_presents(617139029, '../data/users.db'))
