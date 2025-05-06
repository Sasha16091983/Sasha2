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
