# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

import sqlite3

# Теория.
'''
db = sqlite3.connect('../data/users.db')
cursor = db.cursor()

--- Создание.
cursor.execute("""CREATE TABLE users (
    id_user integer,
    name text,
    age integer,
    place text,
    department text,
    description text
)""")

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
        "INSERT INTO users VALUES ({}, '{}', {}, '{}', '{}', '{}', '{}')".format(id_user, data['name'],
                                                                                 data['age'],
                                                                                 data['place'],
                                                                                 data['university'],
                                                                                 data['department'],
                                                                                 data['description'])
    )
    db.commit()
    db.close()


# update_name(0, 'Richard', '../data/users.db')
# res = get_user_data(0, '../data/users.db')
# print(res)
# print((get_user_data(1, '../data/users.db')))
# print(beautiful_tuple_of_user_data(0, '../data/users.db'))
