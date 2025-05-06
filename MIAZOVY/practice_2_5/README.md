# Проект з логістичного забезпечення

Цей проект містить базу даних для управління логістичним забезпеченням з інформацією про персонал та логістичні підрозділи.

## Структура проекту

- **sql_scripts/** - SQL-скрипти для створення бази даних та запитів
  - `create_database.sql` - скрипт для створення бази даних та таблиць
  - `import_data.py` - Python-скрипт для імпорту даних з Excel
  - `queries.sql` - 20 SQL-запитів для роботи з базою даних
- **data/** - файли з даними
  - `employees_departments.xlsx` - Excel-файл з даними про персонал та підрозділи
- **results/** - папка для зберігання результатів запитів
- **docs/** - документація проекту

## Таблиці бази даних

### Logistics_Units
- Logistics_Unit_ID (INT) - первинний ключ
- Logistics_Unit_Name (VARCHAR) - назва логістичного підрозділу
- Supplies_Available (INT) - кількість доступних запасів
- Base_Location (VARCHAR) - місце розташування підрозділу

### Logistics_Personnel
- ID (INT) - первинний ключ
- Name (VARCHAR) - ім'я працівника
- Position (VARCHAR) - посада
- Logistics_Unit_ID (INT) - зовнішній ключ до таблиці Logistics_Units
- Date_Assigned (DATE) - дата призначення

## Інструкція з використання

1. Створіть базу даних PostgreSQL за допомогою скрипту `sql_scripts/create_database.sql`
2. Імпортуйте дані з Excel-файлу за допомогою скрипту `sql_scripts/import_data.py`
3. Використовуйте запити з файлу `sql_scripts/queries.sql` для роботи з базою даних

## SQL-запити

У файлі `queries.sql` містяться 20 різних SQL-запитів, включаючи:
- Базові запити SELECT, UPDATE, DELETE
- JOIN-запити для об'єднання таблиць
- Агрегаційні запити з GROUP BY та HAVING
- Підзапити та складні умови фільтрації