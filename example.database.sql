create table employee (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender VARCHAR(50) NOT NULL,
	email VARCHAR(150),
	date_of_birth DATE NOT NULL,
	country_of_birth VARCHAR(50) NOT NULL
);

create table report (
	id BIGSERIAL NOT NULL PRIMARY KEY,
	report_title VARCHAR(50) NOT NULL,
    report_content VARCHAR(50) NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES employee (id)
);

\l Базы данных
CREATE DATABASE namebase;
\c Подключится к базе данных
CREATE TABLE tablename (

id BIGSERIAL NOT NULL PRIMARY KEY,
field1 VARCHAR(30) NOT NULL,
field2 VARCHAR(50) NOT NULL,
field3 DATE NOT NULL
);

\d посмотреть таблицы

DROP DATABASE basename Удалить базу данных

DROP TABLE tablename Удалить таблицу

INSERT INTO nametable (field1, field2, field3) VALUES('val1', 'val2', 'val3');


----------------------------------Выборка SELECT------------------------------
SELECT * FROM tablename;

SELECT field1, field2 FROM tablename;

SELECT field1, field2 FROM tablename ORDER BY filed3; сортировка по field3

INSERT INTO tablename(f1, f2, f3) VALUES(v1, v2, v3) вставка даных

SELECT field1, field2 FROM tablename ORDER BY filed3 DESC; СОРТИРОВКА НАОБОРОТ

SELECT DISTINCT f1 FROM table ORDER BY f2; Сортировка без повторений


SELECT * FROM table WHERE f1=<условие>;

SELECT * FROM table WHERE f1=<условие> AND f2=<условие>;

SELECT * FROM table LIMIT 10; Лиммит 10 элементов

SELECT * FROM table OFFSET 10 LIMIT 5; После 10 5 позиций

SELECT * FROM table OFFSET 10 FETCH FIRST 5 ROW ONLY; После 10 первых 5 позиций

SELECT * FROM table WHERE f1 IN(data1, data5); Выбор с диапазона

SELECT * FROM table WHERE f1 BETWEEN data1 AND data2;

SELECT * FROM table WHERE f1 LIKE '%условие'; Выбор по условию

SELECT * FROM table WHERE f1 iLIKE '%условие'; Нечуствительный к регистру

SELECT f1, COUNT(*) FROM table GROUP BY f1;  Подсчет

SELECT f1, COUNT(*) FROM table GROUP BY f1 HAVING COUNT(*) > 10 ORDER BY f2 DESC; выбрать те поля f1 и посчитать количество где их количество > 10,
 отсортировать по полю f2 в обратном порядке, ВАЖНО выводим f1 игруппируем f1;

SELECT field1 AS f1, filed2 AS f2 FROM table; Алиасы через AS

SELECT COALESCE(f1, 'no field') FROM table; Выбор не пустых полей

-----------------------------------Функции аггрегаторы-------------------------------------------

SELECT MAX(f1) FROM table; Максимальное значение

SELECT MIN(f1) FROM table; Минимальное значение  

SELECT AVG(f1) FROM table; Среднее значение

SELECT ROUND(AVG(f1)) FROM table; Округение

SELECT f1, f2, MAX(f3) FROM table GROUP BY f1, f2; Максимальное по полю f3 при группировке полей f1, f2, выборка и группировка по одинаковым полям;

SELECT SUM(f1) FROM table; Сумма 

SELECT f2 SUM(f1) FROM table GROUP BY f2; Сумма по полю f2 при группировке поля f1

----------------------------------------Дата и время------------------------------------------------

SELECT NOW(); Время

SELECT NOW()::DATE; Дата

SELECT NOW() - INERVAL '1 YEAR'; Назад на 1 год

SELECT NOW() - INERVAL '10 MOUNTHs'; Назад на 10 месяцев

SELECT NOW() + INERVAL '11 DAYS'; Вперед н 10 дней

SELECT EXTRACT(YEAR FROM NOW()); Только год

SELECT EXTRACT(DAY FROM NOW()); Только день

SELECT EXTRACT(DOW FROM NOW()); День недели

SELECT f1, f2, f3, AGE(NOW(), f1) FROM table; Время от даты f1;

------------------------------PRIMARY KEY---------------------------------------
ALTER TABLE holiday DROP CONSTRAINT holiday_pkey; изменить PRIMARY KEY

ALTER TABLE holiday ADD PRIMARY KEY(id); Добавить PRIMARY KEY

---------------------------------Ограничения------------------------------------

SELECT email, COUNT(*) FROM mytable GROUP BY email; # Подсчет по email

SELECT email, COUNT(*) FROM mytable GROUP BY email HAVING COUNT(*) > 1; Подсчет по email по количеству > 1

ALTER TABLE mytable ADD CONSTRAINT unique_email UNIQUE (email); Cделать уникальным поле email 

SELECT DISTINCT gender FROM mytable; Выбор без повторений

--------------------------------Удаление-----------------------------------------

DELETE FROM mytable; удалит все записи

DELETE FROM mytable WHERE id=100;

DELETE FROM mytable WHERE email LIKE '%google%' AND country_of_birth = 'China';

------------------------------- Обновление------------------------------------------

UPDATE mytable SET first_name='Tomas'; обновить все поля first_name='Tomas'

UPDATE mytable SET first_name='Tomas' WHERE id=1;

-------------------------------ForeignKey-------------------------------------------

ALTER TABLE mytable ADD bicycle_id BIGINT REFERENCES bicycle (id); Добавляем внешний ключ

ALTER TABLE mytable ADD UNIQUE(bicycle_id); Уникальное поле

------------------------------JOIN, UNION----------------------------------------------

SELECT * FROM mytable JOIN bicycle ON mytable.bicycle_id = bicycle.id; Inner join

SELECT mytable.first_name, bicycle.make, bicycle.type, bicycle.price FROM mytable JOIN bicycle ON mytable.bicycle_id=bicycle.id;    Inner Join

SELECT * FROM mytable  LEFT JOIN bicycle ON bicycle_id = bicycle.id; Все слева и совпадение с права

SELECT * FROM mytable  LEFT JOIN bicycle ON bicycle_id = bicycle.id WHERE bicycle_id IS NOT NULL;

SELECT * FROM mytable
mybase-# RIGHT JOIN bicycle ON mytable.bicycle_id = bicycle.id; ВСЕ СПРАВА И СОВПАДЕНИЕ С ЛЕВА

SELECT * FROM mytable
mybase-# FULL OUTER JOIN bicycle ON mytable.bicycle_id = bicycle.id; ПОЛНОЕ СЛИЯНИЕ

--------------------------- CSV---------------------------------------------------------
\copy (SELECT * FROM mytable  LEFT JOIN bicycle  ON mytable.bicycle_id = bicycle.id WHERE bicycle_id IS NOT NULL) TO 'D:/CSV' DELIMITER ',' CSV HEADER;