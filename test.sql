SELECT  model 
FROM (SELECT  model, price FROM PC
      UNION
      SELECT  model,  price FROM Laptop
      UNION
      SELECT  model,  price FROM Printer
      ) AS All_prod WHERE price = (SELECT MAX(price) FROM (
        SELECT price FROM PC
        UNION 
        SELECT price FROM Laptop
        UNION 
        SELECT price FROM Printer
      ) AS All_price);

// 25 не верно
SELECT DISTINCT maker FROM Product 
LEFT JOIN PC ON Product.model = PC.model 
WHERE type = 'Printer' 
AND ram = (SELECT MIN(ram) FROM PC) 
AND speed = (SELECT MAX(speed) FROM PC)

// 25 не верно
SELECT DISTINCT maker FROM Product 
WHERE type = 'printer' 
AND 
maker IN(SELECT model FROM PC WHERE speed = (SELECT MAX(speed) FROM PC) AND ram = (SELECT MIN(ram) FROM PC )) AS z4;


// 25 не верно
SELECT DISTINCT maker FROM Product 
WHERE type = 'Printer' 
AND 
maker IN(
    SELECT maker FROM Product WHERE model IN(
        SELECT model FROM PC WHERE speed = (
            SELECT MAX(speed) FROM (
                SELECT speed FROM PC WHERE ram = (
                    SELECT MIN(ram) FROM PC)) AS z4)
                    ))


// 25 верно
// Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Make
SELECT DISTINCT maker FROM Product 
WHERE type = 'Printer' 
AND 
maker IN(
    SELECT maker FROM Product WHERE model IN (
        SELECT model FROM PC 
        WHERE 
        ram = (SELECT MIN(ram) FROM PC) 
AND 
        speed = (SELECT MAX(speed) FROM (
            SELECT speed FROM PC WHERE ram = (
                SELECT MIN(ram) FROM PC)) AS condition)))

                    

//26 не корректно
//Найдите среднюю цену ПК и ПК-блокнотов, выпущенных производителем A (латинская буква). Вывести: одна общая средняя цена.
SELECT AVG(price) AS AVG_price FROM (
SELECT price FROM PC
UNION ALL
SELECT price FROM Laptop
) AS Avg
WHERE price IN(
SELECT price FROM PC
UNION ALL
SELECT price FROM Laptop WHERE model IN (
SELECT model FROM Laptop
UNION ALL
SELECT model FROM Product 
WHERE maker = 'A'
))

// 26 корректно
SELECT AVG(price) AS AVG_price FROM (
SELECT price FROM PC WHERE model IN(
SELECT model FROM Product WHERE maker = 'A'
)
UNION ALL
SELECT price FROM Laptop WHERE model IN(
SELECT model FROM Product WHERE maker = 'A'
)
) as Res

// 27 корректно
// Найдите средний размер диска ПК каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.
SELECT DISTINCT maker, AVG(hd) AS Avg FROM PC
JOIN Product ON PC.model = Product.model
WHERE maker IN(SELECT maker FROM Product WHERE type = 'Printer')
GROUP BY maker

// 28 корректно
// Используя таблицу Product, определить количество производителей, выпускающих по одной модели.
SELECT COUNT(maker) FROM (
    SELECT maker, COUNT(model) AS model_count FROM Product 
    GROUP BY maker 
    HAVING COUNT(model) = 1
        ) AS single_model_count


// 29 
// Inside the предположении, что приход и расход денег на каждом пункте приема фиксируется не чаще одного раза в день [т.е. первичный ключ (пункт, дата)], написать запрос с выходными данными (пункт, дата, приход, расход). Использовать таблицы Income_o и Outcome_o.
SELECT i.point, i.date, i.inc, o.out FROM Income_o i
LEFT JOIN Outcome_o o ON i.point = o.point AND i.date = o.date
UNION
SELECT o.point,o.date,i.inc,o.out FROM Outcome_o o
LEFT JOIN Income_o i ON o.point = i.point AND o.date = i.date

//30 не корректно
// Inside the предположении, что приход и расход денег на каждом пункте приема фиксируется произвольное число раз (первичным ключом в таблицах является столбец code), требуется получить таблицу, в которой каждому пункту за каждую дату выполнения операций будет соответствовать одна строка.
Вывод: point, date, суммарный расход пункта за день (out), суммарный приход пункта за день (inc). Отсутствующие значения считать неопределенными (NULL).
SELECT point, date, SUM(Outcome) AS Outcome, SUM(income) AS income FROM
(
  SELECT i.point, i.date, NULL AS Outcome, i.inc AS income 
  FROM Income i
  LEFT JOIN Outcome o ON i.code = o.code
  UNION ALL
  SELECT o.point, o.date, o.out AS Outcome, NULL AS income 
  FROM Outcome o
  LEFT JOIN Income i ON o.code = i.code
) AS query
GROUP BY point, date

//32 решение
SELECT 
    country,
   CAST(AVG(POWER(bore, 3) / 2) AS DECIMAL(6, 2)) weight
FROM (SELECT country, bore, name FROM Classes JOIN ships ON Classes.class = ships.class
UNION
SELECT country, bore, ship FROM classes JOIN outcomes on class = ship)
this_table GROUP BY country

//34 правильно
//По Вашингтонскому международному договору от начала 1922 г. запрещалось строить линейные корабли водоизмещением более 35 тыс.тонн. Укажите корабли, нарушившие этот договор (учитывать только корабли c известным годом спуска на воду). Вывести названия кораблей.
SELECT name FROM Ships
JOIN Classes ON Ships.class = Classes.class
WHERE launched >= 1922
AND 
displacement > 35000
AND 
type = 'bb'


//35 REGEX
//Inside the таблице Product найти модели, которые состоят только из цифр или только из латинских букв (A-Z, без учета регистра).
//Вывод: номер модели, тип модели.
SELECT model, type FROM Product
WHERE model NOT LIKE '%[^0-9]%' OR model NOT LIKE '%[^A-Za-z]%'


//36
//Перечислите названия головных кораблей, имеющихся в базе данных (учесть корабли в Outcomes).
SELECT DISTINCT name FROM (
SELECT name FROM Classes JOIN Ships ON Classes.class = ships.class
UNION
SELECT ship FROM Outcomes
) this_table WHERE name IN(SELECT class FROM Classes)


//37 НЕ ВЕРНОЕ решение 
//Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
SELECT class FROM Ships
GROUP BY class HAVING COUNT(*) = 1
UNION ALL
SELECT ship FROM Outcomes
WHERE ship NOT IN (SELECT name FROM Ships)
GROUP BY ship
HAVING COUNT(*) = 1

//37 
//Найдите классы, в которые входит только один корабль из базы данных (учесть также корабли в Outcomes).
SELECT class FROM (SELECT Classes.class, name FROM Classes JOIN Ships ON Classes.class = Ships.class
UNION
SELECT class, ship FROM Classes JOIN Outcomes ON class = ship) 
this_table GROUP BY class HAVING COUNT(name) = 1


//38
//Найдите страны, имевшие когда-либо классы обычных боевых кораблей ('bb') и имевшие когда-либо классы крейсеров ('bc').
SELECT country FROM Classes
WHERE type = 'bb'
INTERSECT
SELECT country FROM Classes
WHERE type = 'bc'


//39 решение №1
// Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.
SELECT DISTINCT ship FROM (SELECT ship, result, [date] FROM Outcomes 
JOIN Battles bat ON battle = name
WHERE result = 'damaged'
AND SHIP IN (SELECT ship FROM outcomes JOIN Battles ON battle = name
WHERE bat.[date] < battles.[date])) this_table


//39 решение с правильным результатом, но не корректным условием
// Найдите корабли, `сохранившиеся для будущих сражений`; т.е. выведенные из строя в одной битве (damaged), они участвовали в другой, произошедшей позже.
SELECT DISTINCT ship FROM Outcomes 
JOIN Battles ON battle = name
WHERE result = 'damaged'
AND SHIP IN (SELECT ship FROM outcomes JOIN Battles ON battle = name
WHERE result = 'OK')

//40 решение
Найти производителей, которые выпускают более одной модели, при этом все выпускаемые производителем модели являются продуктами одного типа.
Вывести: maker, type
SELECT maker, type FROM product WHERE maker IN(SELECT maker FROM(
SELECT maker, type FROM Product GROUP BY maker, type
) this_table GROUP BY maker HAVING COUNT(maker) = 1
) GROUP BY maker, type HAVING COUNT(maker) > 1

//41 решение 
/// Для каждого производителя, у которого присутствуют модели хотя бы в одной из таблиц PC, Laptop или Printer,
определить максимальную цену на его продукцию.
Вывод: имя производителя, если среди цен на продукцию данного производителя присутствует NULL, то выводить для этого производителя NULL,
иначе максимальную цену.
SELECT maker, 
CASE
WHEN MAX(CASE WHEN price IS NULL THEN 1 ELSE 0 end) = 0
THEN MAX(price) end price
FROM (
SELECT maker, price FROM Product 
JOIN PC ON Product.model = PC.model
UNION
SELECT maker, price FROM Product
JOIN Laptop ON Product.model = Laptop.model
UNION
SELECT maker, price FROM Product
JOIN Printer ON Product.model = Printer.model
) this_table GROUP BY maker

//42 решение
//Найдите названия кораблей, потопленных в сражениях, и название сражения, в котором они были потоплены.
SELECT ship, battle from Outcomes
WHERE result = 'sunk'

//43
//Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
SELECT name FROM Battles WHERE YEAR(date) NOT IN (SELECT launched FROM ships
WHERE launched IS NOT NULL)

//44
//Найдите названия всех кораблей в базе данных, начинающихся с буквы R.
SELECT name FROM Ships
WHERE name LIKE 'R%'
UNION
SELECT ship FROM Outcomes
WHERE ship LIKE 'R%'


//45
//Найдите названия всех кораблей в базе данных, состоящие из трех и более слов (например, King George V).
Считать, что слова в названиях разделяются единичными пробелами, и нет концевых пробелов.
SELECT ship FROM Outcomes
WHERE ship LIKE '% % %'
UNION
SELECT name FROM Ships
WHERE name LIKE '% % %'

//46
//Для каждого корабля, участвовавшего в сражении при Гвадалканале (Guadalcanal), вывести название, водоизмещение и число орудий.
SELECT ship, displacement, numGuns FROM (SELECT o.ship, c.displacement, c.numGuns, o.battle FROM Outcomes o 
LEFT JOIN Ships s ON o.ship = s.name
LEFT JOIN Classes c ON s.class = c.class OR o.ship = c.class
WHERE battle = 'Guadalcanal') this_table

//47
//Определить страны, которые потеряли в сражениях все свои корабли.
WITH All_Ships AS (SELECT country, name FROM Classes
JOIN Ships ON Classes.class = Ships.class
UNION
SELECT country, ship FROM Classes
JOIN Outcomes ON class = ship)

SELECT DISTINCT country FROM ALL_Ships WHERE country NOT IN (SELECT country FROM ALL_ships
WHERE All_ships.name NOT IN (SELECT ship bane FROM Outcomes WHERE
result = 'sunk')
)

//48
//Найдите классы кораблей, в которых хотя бы один корабль был потоплен в сражении.
SELECT Classes.class FROM Classes
JOIN Ships ON Classes.class = Ships.class WHERE name IN (
SELECT ship FROM Outcomes WHERE result = 'sunk'
)
UNION 
SELECT class FROM Classes
JOIN Outcomes ON class = ship WHERE result = 'sunk'

//49
//Найдите названия кораблей с орудиями калибра 16 дюймов (учесть корабли из таблицы Outcomes).
SELECT name FROM (SELECT Classes.bore, name FROM Classes
JOIN Ships ON Classes.class = Ships.class
WHERE bore = 16
UNION
SELECT Classes.bore, ship FROM Classes
JOIN Outcomes ON class = ship
WHERE bore = 16
) this_table


//50
//Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
SELECT DISTINCT battle FROM Outcomes WHERE ship IN (
SELECT name FROM Ships WHERE class = 'Kongo')
