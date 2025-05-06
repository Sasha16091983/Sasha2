import pandas as pd
import psycopg2
import os

# Шлях до файлу Excel
excel_file = os.path.join('..', 'data', 'employees_departments.xlsx')

# Підключення до бази даних
conn = psycopg2.connect(
    host="localhost",
    database="LogisticsDB",
    user="postgres",  # Замініть на свій логін
    password="postgres"  # Замініть на свій пароль
)
cursor = conn.cursor()

# Завантаження даних з Excel
try:
    # Завантаження даних з аркуша Logistics_Units
    units_df = pd.read_excel(excel_file, sheet_name='Logistics_Units')
    
    # Вставка даних в таблицю Logistics_Units
    for _, row in units_df.iterrows():
        cursor.execute(
            "INSERT INTO Logistics_Units (Logistics_Unit_ID, Logistics_Unit_Name, Supplies_Available, Base_Location) VALUES (%s, %s, %s, %s)",
            (row['Logistics_Unit_ID'], row['Logistics_Unit_Name'], row['Supplies_Available'], row['Base_Location'])
        )
    
    # Завантаження даних з аркуша Logistics_Personnel
    personnel_df = pd.read_excel(excel_file, sheet_name='Logistics_Personnel')
    
    # Вставка даних в таблицю Logistics_Personnel
    for _, row in personnel_df.iterrows():
        cursor.execute(
            "INSERT INTO Logistics_Personnel (ID, Name, Position, Logistics_Unit_ID, Date_Assigned) VALUES (%s, %s, %s, %s, %s)",
            (row['ID'], row['Name'], row['Position'], row['Logistics_Unit_ID'], row['Date_Assigned'])
        )
    
    # Підтвердження транзакції
    conn.commit()
    print("Дані успішно імпортовано в базу даних.")
    
except Exception as e:
    # Відкат транзакції у випадку помилки
    conn.rollback()
    print(f"Помилка при імпорті даних: {e}")
    
finally:
    # Закриття з'єднання
    cursor.close()
    conn.close()
    print("З'єднання з базою даних закрито.")