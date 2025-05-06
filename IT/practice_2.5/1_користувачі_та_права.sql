-- Практичне створення користувачів та надання прав доступу до бази даних MySQL

-- 1. Створення нової бази даних
CREATE DATABASE IF NOT EXISTS test_db;

-- 2. Створення користувачів з різними рівнями доступу

-- Адміністратор з повними правами
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'secure_admin_password';
GRANT ALL PRIVILEGES ON test_db.* TO 'admin_user'@'localhost';

-- Розробник з правами на читання, запис та модифікацію структури
CREATE USER 'developer'@'localhost' IDENTIFIED BY 'dev_password';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, INDEX, DROP ON test_db.* TO 'developer'@'localhost';

-- Аналітик з правами тільки на читання
CREATE USER 'analyst'@'localhost' IDENTIFIED BY 'analyst_password';
GRANT SELECT ON test_db.* TO 'analyst'@'localhost';

-- Тестувальник з правами на читання та запис, але без можливості змінювати структуру
CREATE USER 'tester'@'localhost' IDENTIFIED BY 'tester_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON test_db.* TO 'tester'@'localhost';

-- 3. Створення тестової таблиці для демонстрації прав
USE test_db;

CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    position VARCHAR(100),
    salary DECIMAL(10, 2),
    hire_date DATE
);

-- 4. Додавання тестових даних
INSERT INTO employees (first_name, last_name, email, position, salary, hire_date)
VALUES 
    ('Іван', 'Петренко', 'ivan@example.com', 'Менеджер', 50000.00, '2020-01-15'),
    ('Олена', 'Коваленко', 'olena@example.com', 'Розробник', 45000.00, '2021-03-10'),
    ('Михайло', 'Шевченко', 'mykhailo@example.com', 'Аналітик', 40000.00, '2019-11-05');

-- 5. Перевірка прав користувачів (команди для виконання від імені різних користувачів)

-- Для адміністратора (має всі права):
-- mysql -u admin_user -p test_db
-- SHOW TABLES;
-- SELECT * FROM employees;
-- ALTER TABLE employees ADD COLUMN department VARCHAR(100);

-- Для розробника (може змінювати дані та структуру):
-- mysql -u developer -p test_db
-- SELECT * FROM employees;
-- INSERT INTO employees VALUES (...);
-- ALTER TABLE employees ADD COLUMN department VARCHAR(100);

-- Для аналітика (тільки читання):
-- mysql -u analyst -p test_db
-- SELECT * FROM employees;
-- Спроба INSERT поверне помилку доступу

-- Для тестувальника (може змінювати дані, але не структуру):
-- mysql -u tester -p test_db
-- SELECT * FROM employees;
-- INSERT INTO employees VALUES (...);
-- Спроба ALTER TABLE поверне помилку доступу

-- 6. Відкликання прав (приклад)
-- REVOKE INSERT, UPDATE, DELETE ON test_db.* FROM 'tester'@'localhost';

-- 7. Видалення користувача (приклад)
-- DROP USER 'analyst'@'localhost';

-- 8. Оновлення паролю користувача
-- ALTER USER 'developer'@'localhost' IDENTIFIED BY 'new_dev_password';

-- 9. Застосування змін
FLUSH PRIVILEGES;