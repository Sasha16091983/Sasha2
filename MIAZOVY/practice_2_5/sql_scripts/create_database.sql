-- Створення бази даних
CREATE DATABASE LogisticsDB;

-- Підключення до бази даних
\c LogisticsDB;

-- Створення таблиць
CREATE TABLE Logistics_Units (
    Logistics_Unit_ID INT PRIMARY KEY,
    Logistics_Unit_Name VARCHAR(100),
    Supplies_Available INT,
    Base_Location VARCHAR(100)
);

CREATE TABLE Logistics_Personnel (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Position VARCHAR(100),
    Logistics_Unit_ID INT,
    Date_Assigned DATE,
    FOREIGN KEY (Logistics_Unit_ID) REFERENCES Logistics_Units(Logistics_Unit_ID)
);

-- Додавання даних до таблиці Logistics_Units
INSERT INTO Logistics_Units (Logistics_Unit_ID, Logistics_Unit_Name, Supplies_Available, Base_Location)
VALUES 
(1, 'Склад №1', 1500, 'Київ'),
(2, 'Транспортний відділ', 800, 'Львів'),
(3, 'Склад №2', 2000, 'Одеса'),
(4, 'Відділ постачання', 1200, 'Харків'),
(5, 'Експедиційний центр', 950, 'Дніпро');

-- Додавання даних до таблиці Logistics_Personnel
INSERT INTO Logistics_Personnel (ID, Name, Position, Logistics_Unit_ID, Date_Assigned)
VALUES 
(1, 'Іванов Петро', 'Керівник складу', 1, '2022-01-15'),
(2, 'Петренко Марія', 'Логіст', 2, '2022-02-10'),
(3, 'Сидоренко Олег', 'Комірник', 1, '2022-03-05'),
(4, 'Коваленко Ірина', 'Експедитор', 5, '2022-01-20'),
(5, 'Шевченко Андрій', 'Менеджер постачання', 4, '2022-04-12'),
(6, 'Мельник Олена', 'Логіст', 2, '2022-05-03'),
(7, 'Бондаренко Василь', 'Комірник', 3, '2022-02-25'),
(8, 'Ткаченко Наталія', 'Керівник відділу', 4, '2022-03-15'),
(9, 'Савченко Ігор', 'Експедитор', 5, '2022-04-20'),
(10, 'Кравченко Тетяна', 'Комірник', 3, '2022-05-10');