# Copyright © 2022 mightyK1ngRichard <dimapermyakov55@gmail.com>

def fibonacci(end_cycle):
    """
    Числа Фибоначчи.
    :param end_cycle: количество цифр.
    :return: генератор
    """
    if type(end_cycle) != int:
        raise TypeError('Incorrect type of the end cycle! Waiting: Int')
    old = 0
    res = 1
    for _ in range(end_cycle):
        yield old
        old, res = res, old + res
