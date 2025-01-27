CREATE TABLE Mobilization_Reserves (
    reserve_id SERIAL PRIMARY KEY,  -- використовуємо SERIAL для автоматичної інкрементації
    reserve_type VARCHAR(50),
    reserve_status VARCHAR(50),
    reserve_description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE Personnel (
    personnel_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    rank VARCHAR(50),
    reserve_id INT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserve_id) REFERENCES Mobilization_Reserves(reserve_id)
);
CREATE TABLE Equipment (
    equipment_id SERIAL PRIMARY KEY,
    equipment_name VARCHAR(100),
    equipment_type VARCHAR(50),
    reserve_id INT,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserve_id) REFERENCES Mobilization_Reserves(reserve_id)
);
-- Вставка тестових даних для таблиці Mobilization_Reserves
INSERT INTO Mobilization_Reserves (reserve_type, reserve_status, reserve_description)
VALUES 
('Людські', 'Готовий', 'Людський мобілізаційний резерв, готовий до розгортання'),
('Технічні', 'Частково готовий', 'Мобілізаційний резерв технічного обладнання, частково готовий'),
('Людські', 'Неготовий', 'Неготовий людський резерв через відсутність частини особового складу'),
('Технічні', 'Готовий', 'Готове обладнання для мобілізації, техніка повністю працездатна');
-- Вставка тестових даних для таблиці Personnel
INSERT INTO Personnel (first_name, last_name, rank, reserve_id, status)
VALUES 
('Іван', 'Іванов', 'Сержант', 1, 'Готовий'),
('Петро', 'Петров', 'Капітан', 1, 'На навчаннях'),
('Олексій', 'Олексієнко', 'Лейтенант', 2, 'На відпустці'),
('Марія', 'Марченко', 'Сержант', 3, 'Готовий'),
('Олена', 'Олененко', 'Капітан', 4, 'На ремонті');
-- Вставка тестових даних для таблиці Equipment
INSERT INTO Equipment (equipment_name, equipment_type, reserve_id, status)
VALUES 
('Танк Т-72', 'Техніка', 2, 'На ремонті'),
('Автомобіль КамАЗ', 'Автомобіль', 4, 'Готове'),
('Радіолокаційна станція', 'Обладнання', 2, 'Готове'),
('Система ППО С-300', 'Техніка', 4, 'Частково готове');
SELECT * FROM Mobilization_Reserves;
SELECT equipment_name, equipment_type
FROM Equipment
WHERE status = 'На ремонті';
SELECT 
    first_name, 
    last_name, 
    rank, 
    status
FROM Personnel
WHERE status = 'Готовий';
SELECT reserve_type, reserve_status, reserve_description
FROM Mobilization_Reserves
WHERE reserve_type = 'Технічні' AND reserve_status = 'Готовий';
SELECT reserve_type, reserve_status, reserve_description
FROM Mobilization_Reserves
WHERE reserve_description ILIKE '%готовий%';
SELECT first_name, last_name, rank
FROM Personnel
WHERE status = 'На відпустці';
SELECT 
    M.reserve_type, 
    COUNT(P.personnel_id) AS personnel_count
FROM Personnel P
JOIN Mobilization_Reserves M ON P.reserve_id = M.reserve_id
GROUP BY M.reserve_type;
SELECT * 
FROM Mobilization_Reserves 
WHERE reserve_type = 'Людські';
SELECT equipment_name, equipment_type, status
FROM Equipment
WHERE status = 'Частково готове';
SELECT first_name, last_name, rank
FROM Personnel
WHERE reserve_id = 3;
SELECT reserve_type, reserve_status, reserve_description
FROM Mobilization_Reserves
WHERE reserve_type IN ('Технічні', 'Людські');
SELECT first_name, last_name, rank
FROM Personnel
WHERE rank = 'Сержант';
SELECT first_name, last_name, rank, status
FROM Personnel
WHERE status = 'На ремонті';
SELECT first_name, last_name, rank, status
FROM Personnel
WHERE status = 'На навчаннях';
SELECT reserve_type, reserve_status, reserve_description
FROM Mobilization_Reserves
WHERE reserve_description ILIKE '%відсутність%';
SELECT M.reserve_type, COUNT(E.equipment_id) AS equipment_count
FROM Equipment E
JOIN Mobilization_Reserves M ON E.reserve_id = M.reserve_id
GROUP BY M.reserve_type;
SELECT equipment_name, equipment_type, status
FROM Equipment
WHERE status IN ('Готове', 'Частково готове');
SELECT first_name, last_name, rank, status
FROM Personnel
WHERE status IN ('На ремонті', 'На навчаннях');
SELECT reserve_type, reserve_status, reserve_description
FROM Mobilization_Reserves
WHERE reserve_type IN ('Людські', 'Технічні') AND reserve_status = 'Готовий';
-- Підрахунок кількості технічного та людського персоналу для кожного мобілізаційного резерву, згрупованих за статусом
SELECT
    M.reserve_type,
    M.reserve_status,
    COUNT(P.personnel_id) AS personnel_count
FROM
    Personnel P
JOIN Mobilization_Reserves M ON P.reserve_id = M.reserve_id
GROUP BY
    M.reserve_type,
    M.reserve_status
ORDER BY
    M.reserve_type, M.reserve_status;
