import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Встановлення розміру графіків
plt.figure(figsize=(12, 8))

# Завантаження даних
print("Завантаження даних...")
df = pd.read_csv('Smart Mobility new.csv')

# Перегляд перших рядків
print("\nПерші 5 рядків даних:")
print(df.head())

# Огляд інформації про набір даних
print("\nІнформація про набір даних:")
print(df.info())

# Перевірка на пропущені значення
print("\nКількість пропущених значень у кожному стовпці:")
print(df.isnull().sum())

# Перевірка на дублікати
duplicates = df.duplicated().sum()
print(f"\nКількість дублікатів: {duplicates}")

# Очищення даних
print("\nОчищення даних...")

# Заповнення пропущених значень середнім для числових стовпців
df_numeric = df.select_dtypes(include=[np.number])
for col in df_numeric.columns:
    if df[col].isnull().sum() > 0:
        df[col].fillna(df[col].mean(), inplace=True)

# Перетворення категоріальних змінних
df_categorical = df.select_dtypes(include=['object'])
print("\nКатегоріальні змінні:")
print(df_categorical.columns.tolist())

# Перетворення категоріальних змінних на числові (для аналізу)
df_encoded = df.copy()
for col in df_categorical.columns:
    df_encoded[col] = df_encoded[col].astype('category').cat.codes

# Описова статистика
print("\nОписова статистика:")
print(df.describe())

# Створення директорії для збереження графіків
import os
if not os.path.exists('plots'):
    os.makedirs('plots')

# Візуалізація даних
print("\nСтворення візуалізацій...")

# Вибір числових стовпців для візуалізації (перші 5)
numeric_cols = df_numeric.columns[:5].tolist()

# Гістограми для числових змінних
for col in numeric_cols:
    plt.figure(figsize=(10, 6))
    sns.histplot(df[col].dropna(), bins=20, kde=True)
    plt.title(f'Розподіл {col}')
    plt.tight_layout()
    plt.savefig(f'plots/histogram_{col}.png')
    plt.close()

# Коробкові діаграми для аналізу викидів
plt.figure(figsize=(12, 8))
sns.boxplot(data=df[numeric_cols])
plt.title('Коробкові діаграми для числових змінних')
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig('plots/boxplot_numeric.png')
plt.close()

# Діаграми розсіювання для перших двох числових змінних
if len(numeric_cols) >= 2:
    plt.figure(figsize=(10, 6))
    sns.scatterplot(x=df[numeric_cols[0]], y=df[numeric_cols[1]])
    plt.title(f'Діаграма розсіювання: {numeric_cols[0]} vs {numeric_cols[1]}')
    plt.tight_layout()
    plt.savefig('plots/scatterplot.png')
    plt.close()

# Кореляційний аналіз
print("\nКореляційний аналіз...")

# Обчислення кореляційної матриці для числових змінних
correlation_matrix = df_encoded.corr()

# Візуалізація кореляційної матриці
plt.figure(figsize=(14, 10))
sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', linewidths=0.5, fmt='.2f')
plt.title('Кореляційна матриця')
plt.tight_layout()
plt.savefig('plots/correlation_matrix.png')
plt.close()

# Збереження очищених даних
df.to_csv('cleaned_data.csv', index=False)
print("\nОчищені дані збережено у файлі 'cleaned_data.csv'")

print("\nАналіз даних завершено. Результати візуалізації збережено у директорії 'plots'")