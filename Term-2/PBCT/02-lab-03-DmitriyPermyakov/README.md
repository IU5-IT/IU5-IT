# Laboratory work 3.
<img src="https://img.shields.io/github/license/mightyK1ngRichard/IU5?color=brightgreen" alt="MIT License"> <img src="https://img.shields.io/badge/language-C++-purple.svg" alt="Python C++">

# Задание. 
1. 
    Создать класс для работы с обыкновенными дробями. Все операции, которые должны выполняться с дробями, включены в программу в приложении 1. 
Числитель и знаменатель дроби имеют тип int.
Дроби вводятся как строка, имеющая вид:
- для дробей с целой частью: знак, целая часть, пробел, числитель, слэш (‘/’), знаменатель,. например: -2 6/18,  5 9/3, 2 4/1. 
- для дробей без целой части: знак, числитель, слэш (‘/’), знаменатель,
например: 3/4,  -9/3,  -8/6 (знаменатель всегда положительный).
Значения представленных выше дробей на экране при выводе должны иметь вид:
-2 1/3, 8, 6.
3/4, -3, -1 1/3. 
- При выводе и после выполнения арифметических операций дроби сокращаются, то есть числитель и знаменатель не должны иметь общих множителей.
Перегрузить операции '+', '+='  для сложения дробей и дроби и целого в любых сочетаниях (дробь+целое, целое+дробь, дробь+дробь).
- Перегрузить операции '+', '+='  для сложения дроби и double в любых сочетаниях (дробь+double, double+дробь). Преобразование double-дробь должно выполняться с точностью до N_DEC десятичных знаков после запятой, где N_DEC – целочисленная константа, задаваемая пользователем. Задайте значение по умолчанию N_DEC=4.
- Для инициализации объектов разрабатываемого класса обыкновенных дробей предусмотреть соответствующие конструкторы (с одним аргументом типа char*, с одним аргументом типа double и с двумя аргументами типа int, которые имеют значения по умолчанию).
- При перегрузке операций использовать функции - члены класса, а где это невозможно, то функции - друзья класса.
- Для обеспечения более удобного контроля результатов выполнения программы вставьте в конструкторы и перегруженные операции операторы вывода, идентифицирующие выполняемую функцию.
Выполните следующий эксперимент: закомментируйте операции дроби с int и повторно выполните программу. Объясните результаты сложения дробей с целыми числами.

2.
    2.1. Создать класс «Дроби» для выполнения арифметических операций над обыкновенными дробями. Внутреннее представление дробей (состав полей класса) должно обеспечивать эффективное выполнение операций над дробями и может отличаться от представления дробей на экране монитора, которое должно быть удобным для пользователя. Например, внутри объекта класса «Дроби» может храниться неправильная дробь. 
- Разработать конструктор по умолчанию и конструктор, который преобразует строку, содержащую внешнее представление дроби, в объект класса «Дроби». 
- Перегрузить операции потокового ввода дроби с клавиатуры и вывода ее на экран монитора. При вводе выполнять сокращение дроби.
- Создать много-файловый проект и отладить программу, которая создает один объект класса «Дроби» и выводит значения его полей на экран (эта программа состоит из 5 первых операторов программы, приведённой в Приложении 1).
    2.2. Дополнить класс функциями - членами класса и функциями - друзьями класса, которые необходимы для выполнения программы из Приложения 1. 
Выполнить программу из Приложения 1 и сравнить результаты с тестовым примером.
