-- Практичне завдання 4.1: Робота з процедурами, функціями та транзакціями

-- Створення необхідних таблиць для виконання завдань

-- Створення таблиці MilitaryUnit (Військовий підрозділ)
CREATE TABLE IF NOT EXISTS MilitaryUnit (
    unit_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    commander VARCHAR(100)
);

-- Створення таблиці Equipment (Військова техніка)
CREATE TABLE IF NOT EXISTS Equipment (
    equipment_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL,
    status VARCHAR(50) NOT NULL,
    unit_id INT REFERENCES MilitaryUnit(unit_id)
);

-- Додавання тестових даних
INSERT INTO MilitaryUnit (name, location, commander)
VALUES ('1-ша бригада', 'Київ', 'Полковник Петренко')
ON CONFLICT DO NOTHING;

INSERT INTO Equipment (name, type, status, unit_id)
VALUES 
('Т-64', 'Танк', 'Активна', 1),
('БТР-4', 'БТР', 'Активна', 1),
('Bayraktar TB2', 'БПЛА', 'Активна', 1)
ON CONFLICT DO NOTHING;


-- Завдання 1: Створення процедури для видалення техніки за її ID
/*
Створіть процедуру delete_equipment_by_id, яка:
1. Перевіряє, чи існує техніка з вказаним ID
2. Якщо техніка існує, видаляє її
3. Якщо техніка не існує, виводить повідомлення про помилку
*/

CREATE OR REPLACE PROCEDURE delete_equipment_by_id(
    p_equipment_id INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_equipment_name VARCHAR(100);
BEGIN
    -- Перевірка існування техніки
    SELECT name INTO v_equipment_name
    FROM Equipment
    WHERE equipment_id = p_equipment_id;
    
    IF v_equipment_name IS NULL THEN
        RAISE NOTICE 'Техніка з ID % не знайдена. Видалення не виконано', p_equipment_id;
    ELSE
        -- Видалення техніки
        DELETE FROM Equipment
        WHERE equipment_id = p_equipment_id;
        
        RAISE NOTICE 'Техніка "%" успішно видалена', v_equipment_name;
    END IF;
END;
$$;

-- Приклад виклику процедури:
-- CALL delete_equipment_by_id(1); -- Видалення техніки з ID 1
-- CALL delete_equipment_by_id(999); -- Спроба видалити неіснуючу техніку


-- Завдання 2: Створення функції для підрахунку кількості техніки певного типу
/*
Створіть функцію count_equipment_by_type, яка:
1. Приймає тип техніки як параметр
2. Повертає кількість одиниць техніки вказаного типу
*/

CREATE OR REPLACE FUNCTION count_equipment_by_type(
    p_type VARCHAR
)
RETURNS INT
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Equipment
    WHERE type = p_type;
    
    RETURN v_count;
END;
$$;

-- Приклад виклику функції:
-- SELECT count_equipment_by_type('Танк') AS кількість_танків;
-- SELECT count_equipment_by_type('БТР') AS кількість_бтр;


-- Завдання 3: Використання транзакцій для внесення кількох змін
/*
Напишіть скрипт, який:
1. Додає нову техніку до підрозділу
2. Створює контрольну точку
3. Змінює статус техніки
4. Створює ще одну контрольну точку
5. Видаляє техніку
6. Відкочує транзакцію до першої контрольної точки
7. Підтверджує транзакцію

Результат: техніка буде додана, але її статус не зміниться, і вона не буде видалена
*/

-- Приклад рішення:
BEGIN;

-- Додавання нової техніки
INSERT INTO Equipment (name, type, status, unit_id)
VALUES ('Javelin', 'Протитанковий ракетний комплекс', 'Активна', 1);

-- Створення першої контрольної точки
SAVEPOINT sp1;

-- Зміна статусу техніки
UPDATE Equipment
SET status = 'Резерв'
WHERE name = 'Javelin';

-- Створення другої контрольної точки
SAVEPOINT sp2;

-- Видалення техніки
DELETE FROM Equipment
WHERE name = 'Javelin';

-- Відкат до першої контрольної точки
ROLLBACK TO sp1;

-- Підтвердження транзакції
COMMIT;

-- Перевірка результату
-- SELECT * FROM Equipment WHERE name = 'Javelin';
-- Результат: техніка 'Javelin' буде додана зі статусом 'Активна'