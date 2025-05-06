-- Практичне створення користувачів та надання прав доступу до бази даних PostgreSQL

-- 1. Створення нової бази даних
CREATE DATABASE test_db;

-- 2. Створення користувачів з різними рівнями доступу

-- Адміністратор з повними правами
CREATE USER admin_user WITH PASSWORD 'secure_admin_password';
GRANT ALL PRIVILEGES ON DATABASE test_db TO admin_user;
-- Додаткові права на всі об'єкти в схемі public
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_user;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO admin_user;

-- Розробник з правами на читання, запис та модифікацію структури
CREATE USER developer WITH PASSWORD 'dev_password';
GRANT CONNECT ON DATABASE test_db TO developer;
GRANT USAGE ON SCHEMA public TO developer;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public TO developer;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO developer;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO developer;
GRANT CREATE ON SCHEMA public TO developer;

-- Аналітик з правами тільки на читання
CREATE USER analyst WITH PASSWORD 'analyst_password';
GRANT CONNECT ON DATABASE test_db TO analyst;
GRANT USAGE ON SCHEMA public TO analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;

-- Тестувальник з правами на читання та запис, але без можливості змінювати структуру
CREATE USER tester WITH PASSWORD 'tester_password';
GRANT CONNECT ON DATABASE test_db TO tester;
GRANT USAGE ON SCHEMA public TO tester;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO tester;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO tester;

-- 3. Створення тестової таблиці для демонстрації прав
-- Примітка: В PostgreSQL не потрібно вказувати USE для вибору бази даних
-- Підключення до бази даних виконується при запуску psql або через параметр -d

CREATE TABLE IF NOT EXISTS employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    position VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE
);

-- 4. Вставка тестових даних
INSERT INTO employees (first_name, last_name, email, position, salary, hire_date)
VALUES
    ('Іван', 'Петренко', 'ivan.petrenko@example.com', 'Менеджер', 50000.00, '2020-01-15'),
    ('Олена', 'Коваленко', 'olena.kovalenko@example.com', 'Розробник', 45000.00, '2020-03-10'),
    ('Михайло', 'Шевченко', 'mykhailo.shevchenko@example.com', 'Аналітик', 40000.00, '2020-05-22'),
    ('Наталія', 'Бондаренко', 'nataliia.bondarenko@example.com', 'Тестувальник', 38000.00, '2020-07-05');

-- 5. Перевірка прав доступу (приклади команд для виконання в psql)

-- Перевірка прав користувача
-- \du

-- Перевірка прав на таблиці
-- \dp

-- Перевірка прав на конкретну таблицю
-- \dp employees

-- 6. Відкликання прав (якщо потрібно)

-- Відкликання всіх прав у користувача
-- REVOKE ALL PRIVILEGES ON DATABASE test_db FROM tester;
-- REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM tester;

-- Відкликання конкретного права
-- REVOKE INSERT ON employees FROM tester;

-- 7. Видалення користувача (якщо потрібно)

-- DROP USER tester;