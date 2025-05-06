-- Практичне резервне копіювання, відновлення та міграція бази даних MS SQL Server
-- (адаптовано з прикладів для MySQL)

-- 1. РЕЗЕРВНЕ КОПІЮВАННЯ (BACKUP)

-- 1.1. Повне резервне копіювання бази даних за допомогою mysqldump
-- Команда для виконання в терміналі (не в MySQL):
-- mysqldump -u admin_user -p --databases test_db > test_db_backup.sql

-- 1.2. Резервне копіювання окремої таблиці
-- mysqldump -u admin_user -p test_db employees > employees_backup.sql

-- 1.3. Резервне копіювання структури без даних
-- mysqldump -u admin_user -p --no-data test_db > test_db_schema.sql

-- 1.4. Резервне копіювання з компресією
-- mysqldump -u admin_user -p test_db | gzip > test_db_backup.sql.gz

-- 1.5. Планування автоматичного резервного копіювання (приклад для cron в Linux)
-- 0 2 * * * mysqldump -u admin_user -p'secure_admin_password' --databases test_db > /backup/test_db_$(date +\%Y\%m\%d).sql

-- Для Windows можна використовувати Task Scheduler з подібною командою в batch-файлі


-- 2. ВІДНОВЛЕННЯ (RESTORE)

-- 2.1. Відновлення бази даних з резервної копії
-- mysql -u admin_user -p test_db < test_db_backup.sql

-- 2.2. Відновлення з компресованої резервної копії
-- gunzip < test_db_backup.sql.gz | mysql -u admin_user -p test_db

-- 2.3. Відновлення окремої таблиці
-- mysql -u admin_user -p test_db < employees_backup.sql


-- 3. МІГРАЦІЯ БАЗИ ДАНИХ

-- 3.1. Міграція між серверами MySQL
-- (Виконується в два етапи: спочатку резервне копіювання, потім відновлення на новому сервері)

-- На вихідному сервері:
-- mysqldump -u admin_user -p --databases test_db > test_db_migration.sql

-- На цільовому сервері:
-- mysql -u admin_user -p < test_db_migration.sql

-- 3.2. Міграція з MySQL до іншої СУБД (наприклад, PostgreSQL)
-- Для цього можна використовувати спеціалізовані інструменти, такі як:
-- - pgloader (для міграції з MySQL до PostgreSQL)
-- - AWS Database Migration Service (для міграції між різними СУБД в хмарі)
-- - Інструменти ETL, такі як Talend або Pentaho

-- Приклад використання pgloader (команда виконується в терміналі):
-- pgloader mysql://admin_user:password@localhost/test_db postgresql://postgres:password@localhost/test_db

-- 3.3. Міграція схеми бази даних (оновлення структури)

-- Створення нової версії таблиці
CREATE TABLE employees_v2 (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name NVARCHAR(50) NOT NULL,
    last_name NVARCHAR(50) NOT NULL,
    email NVARCHAR(100) UNIQUE,
    position NVARCHAR(100),
    department NVARCHAR(100), -- Нове поле
    salary DECIMAL(10, 2),
    hire_date DATE,
    manager_id INT, -- Нове поле
    FOREIGN KEY (manager_id) REFERENCES employees_v2(id)
);

-- Міграція даних зі старої таблиці до нової
-- Примітка: В MS SQL Server при вставці в таблицю з IDENTITY потрібно використовувати SET IDENTITY_INSERT
SET IDENTITY_INSERT employees_v2 ON;
INSERT INTO employees_v2 (id, first_name, last_name, email, position, salary, hire_date)
SELECT id, first_name, last_name, email, position, salary, hire_date FROM employees;
SET IDENTITY_INSERT employees_v2 OFF;

-- Оновлення нових полів
UPDATE employees_v2 SET department = 'IT' WHERE position = 'Розробник';
UPDATE employees_v2 SET department = 'Менеджмент' WHERE position = 'Менеджер';
UPDATE employees_v2 SET department = 'Аналітика' WHERE position = 'Аналітик';

-- Встановлення менеджера для співробітників
UPDATE employees_v2 SET manager_id = 1 WHERE position != 'Менеджер';

-- Перейменування таблиць для завершення міграції (синтаксис MS SQL Server)
-- EXEC sp_rename 'employees', 'employees_old';
-- EXEC sp_rename 'employees_v2', 'employees';

-- Видалення старої таблиці після успішної міграції
-- DROP TABLE employees_old;

-- 4. ДОДАТКОВІ КОРИСНІ КОМАНДИ

-- 4.1. Перевірка цілісності бази даних
-- mysqlcheck -u admin_user -p --check test_db

-- 4.2. Оптимізація таблиць після відновлення
-- mysqlcheck -u admin_user -p --optimize test_db

-- 4.3. Експорт результатів запиту в CSV-файл (для MS SQL Server)
-- BCP "SELECT * FROM test_db.dbo.employees" queryout "C:\temp\employees.csv" -c -t, -S localhost -T

-- 4.4. Імпорт даних з CSV-файлу (для MS SQL Server)
-- BULK INSERT employees FROM 'C:\temp\new_employees.csv' WITH (FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');