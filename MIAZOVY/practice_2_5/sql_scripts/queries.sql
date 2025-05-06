-- 1. Базові запити

-- Отримати всі дані з таблиці Logistics_Personnel
SELECT * FROM Logistics_Personnel;

-- Отримати імена та посади персоналу
SELECT Name, Position FROM Logistics_Personnel;

-- Знайти персонал, призначений після 1 березня 2022 року
SELECT Name, Position, Date_Assigned FROM Logistics_Personnel WHERE Date_Assigned > '2022-03-01';

-- Оновити базу розташування для логістичного підрозділу
UPDATE Logistics_Units SET Base_Location = 'Запоріжжя' WHERE Logistics_Unit_ID = 3;

-- 2. JOIN-запити

-- Зробити вибірку імен персоналу та назв підрозділів за допомогою JOIN
SELECT Logistics_Personnel.Name, Logistics_Units.Logistics_Unit_Name 
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID;

-- Вибрати персонал із конкретного підрозділу (наприклад, 'Склад №1')
SELECT Logistics_Personnel.Name, Logistics_Personnel.Position 
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID
WHERE Logistics_Units.Logistics_Unit_Name = 'Склад №1';

-- 3. Агрегація

-- Підрахувати кількість персоналу в кожному підрозділі
SELECT Logistics_Unit_ID, COUNT(*) as Personnel_Count 
FROM Logistics_Personnel
GROUP BY Logistics_Unit_ID;

-- Знайти підрозділи з більш ніж 1 працівником
SELECT Logistics_Units.Logistics_Unit_Name, COUNT(*) as Personnel_Count 
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID
GROUP BY Logistics_Units.Logistics_Unit_Name
HAVING COUNT(*) > 1;

-- Знайти найбільшу кількість доступних запасів серед підрозділів
SELECT MAX(Supplies_Available) FROM Logistics_Units;

-- 4. Інші запити

-- Отримати імена персоналу, які працюють у підрозділах з запасами більше 1000
SELECT Logistics_Personnel.Name 
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID
WHERE Logistics_Units.Supplies_Available > 1000;

-- Видалити запис про працівника з певним ID
DELETE FROM Logistics_Personnel WHERE ID = 10;

-- Вивести імена персоналу в алфавітному порядку
SELECT Name FROM Logistics_Personnel ORDER BY Name ASC;

-- Знайти підрозділи з найбільшою кількістю запасів
SELECT Logistics_Unit_Name, Supplies_Available 
FROM Logistics_Units 
WHERE Supplies_Available = (SELECT MAX(Supplies_Available) FROM Logistics_Units);

-- Порахувати загальну кількість персоналу в компанії
SELECT COUNT(*) FROM Logistics_Personnel;

-- Вивести імена персоналу, які працюють у підрозділах з базою в Києві
SELECT Logistics_Personnel.Name 
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID
WHERE Logistics_Units.Base_Location = 'Київ';

-- Додати нового працівника в таблицю
INSERT INTO Logistics_Personnel (ID, Name, Position, Logistics_Unit_ID, Date_Assigned)
VALUES (11, 'Литвиненко Олексій', 'Логіст', 2, '2022-06-01');

-- Вивести кількість персоналу в кожному підрозділі з назвою підрозділу
SELECT Logistics_Units.Logistics_Unit_Name, COUNT(*) AS Personnel_Count
FROM Logistics_Personnel
JOIN Logistics_Units ON Logistics_Personnel.Logistics_Unit_ID = Logistics_Units.Logistics_Unit_ID
GROUP BY Logistics_Units.Logistics_Unit_Name;

-- Знайти підрозділи без персоналу
SELECT Logistics_Units.Logistics_Unit_Name
FROM Logistics_Units
LEFT JOIN Logistics_Personnel ON Logistics_Units.Logistics_Unit_ID = Logistics_Personnel.Logistics_Unit_ID
WHERE Logistics_Personnel.ID IS NULL;

-- Оновити назву підрозділу
UPDATE Logistics_Units SET Logistics_Unit_Name = 'Центральний склад' WHERE Logistics_Unit_Name = 'Склад №1';

-- Знайти загальну кількість запасів по всіх підрозділах
SELECT SUM(Supplies_Available) AS Total_Supplies FROM Logistics_Units;