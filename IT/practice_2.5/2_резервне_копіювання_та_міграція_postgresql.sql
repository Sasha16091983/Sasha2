-- Практичне резервне копіювання, відновлення та міграція бази даних PostgreSQL
-- (адаптовано з прикладів для MS SQL Server)

-- 1. РЕЗЕРВНЕ КОПІЮВАННЯ (BACKUP)

-- 1.1. Повне резервне копіювання бази даних за допомогою pg_dump
-- Команда для виконання в терміналі:
-- pg_dump -U admin_user -W -F p test_db > test_db_backup.sql

-- 1.2. Резервне копіювання окремої таблиці
-- pg_dump -U admin_user -W -t employees test_db > employees_backup.sql

-- 1.3. Резервне копіювання структури без даних
-- pg_dump -U admin_user -W --schema-only test_db > test_db_schema.sql

-- 1.4. Резервне копіювання з компресією
-- pg_dump -U admin_user -W test_db | gzip > test_db_backup.sql.gz

-- 1.5. Планування автоматичного резервного копіювання (приклад для cron в Linux)
-- 0 2 * * * pg_dump -U admin_user -W test_db > /backup/test_db_$(date +\%Y\%m\%d).sql

-- Для Windows можна використовувати Task Scheduler з подібною командою в batch-файлі


-- 2. ВІДНОВЛЕННЯ (RESTORE)

-- 2.1. Відновлення бази даних з резервної копії
-- psql -U admin_user -W -d test_db < test_db_backup.sql

-- 2.2. Відновлення з компресованої резервної копії
-- gunzip < test_db_backup.sql.gz | psql -U admin_user -W -d test_db

-- 2.3. Відновлення окремої таблиці
-- psql -U admin_user -W -d test_db < employees_backup.sql


-- 3. МІГРАЦІЯ БАЗИ ДАНИХ

-- 3.1. Міграція між серверами PostgreSQL
-- (Виконується в два етапи: спочатку резервне копіювання, потім відновлення на новому сервері)

-- На вихідному сервері:
-- pg_dump -U admin_user -W test_db > test_db_migration.sql

-- На цільовому сервері:
-- psql -U admin_user -W -d test_db < test_db_migration.sql

-- 3.2. Міграція з іншої СУБД до PostgreSQL
-- Для цього можна використовувати спеціалізовані інструменти, такі як:
-- - pgloader (для міграції з MySQL до PostgreSQL)
-- - AWS Database Migration Service (для міграції між різними СУБД в хмарі)
-- - Інструменти ETL, такі як Talend або Pentaho

-- Приклад використання pgloader (команда виконується в терміналі):
-- pgloader mysql://admin_user:password@localhost/test_db postgresql://postgres:password@localhost/test_db

-- 3.3. Міграція схеми бази даних (оновлення структури)

-- Створення нової версії таблиці
CREATE TABLE employees_v2 (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    position VARCHAR(100),
    department VARCHAR(100), -- Нове поле
    salary DECIMAL(10, 2),
    hire_date DATE,
    manager_id INT, -- Нове поле
    FOREIGN KEY (manager_id) REFERENCES employees_v2(id)
);

-- Міграція даних зі старої таблиці до нової
-- Примітка: В PostgreSQL не потрібно вмикати/вимикати автоінкремент як в MS SQL Server
INSERT INTO employees_v2 (id, first_name, last_name, email, position, salary, hire_date)
SELECT id, first_name, last_name, email, position, salary, hire_date FROM employees;

-- Оновлення нових полів
UPDATE employees_v2 SET department = 'IT' WHERE position = 'Розробник';
UPDATE employees_v2 SET department = 'Менеджмент' WHERE position = 'Менеджер';
UPDATE employees_v2 SET department = 'Аналітика' WHERE position = 'Аналітик';

-- Встановлення менеджера для співробітників
UPDATE employees_v2 SET manager_id = 1 WHERE position != 'Менеджер';

-- Перейменування таблиць для завершення міграції (синтаксис PostgreSQL)
ALTER TABLE employees RENAME TO employees_old;
ALTER TABLE employees_v2 RENAME TO employees;

-- Видалення старої таблиці після успішної міграції
-- DROP TABLE employees_old;

-- 4. ДОДАТКОВІ КОРИСНІ КОМАНДИ

-- 4.1. Перевірка цілісності бази даних
-- В PostgreSQL можна використовувати:
-- VACUUM ANALYZE;

-- 4.2. Оптимізація таблиць після відновлення
-- VACUUM FULL employees;

-- 4.3. Експорт результатів запиту в CSV-файл (для PostgreSQL)
-- \copy (SELECT * FROM employees) TO 'C:\temp\employees.csv' WITH CSV HEADER DELIMITER ',';

-- 4.4. Імпорт даних з CSV-файлу (для PostgreSQL)
-- \copy employees FROM 'C:\temp\new_employees.csv' WITH CSV HEADER DELIMITER ',';

-- 4.5. Резервне копіювання в спеціальному форматі PostgreSQL (для більшої гнучкості)
-- pg_dump -U admin_user -W -F c test_db > test_db_backup.dump

-- 4.6. Відновлення з резервної копії в спеціальному форматі
-- pg_restore -U admin_user -W -d test_db test_db_backup.dump

-- 4.7. Резервне копіювання з паралельним виконанням (для великих баз даних)
-- pg_dump -U admin_user -W -j 4 -F d -f backup_directory test_db

-- 4.8. Відновлення з паралельним виконанням
-- pg_restore -U admin_user -W -j 4 -d test_db backup_directory