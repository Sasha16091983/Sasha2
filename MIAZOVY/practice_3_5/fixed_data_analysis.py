# Імпорт необхідних бібліотек
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error, r2_score

# Налаштування відображення графіків
# Замість plt.style.use('seaborn'), що викликає помилку, використовуємо:
sns.set()  # Це встановлює стиль seaborn без використання plt.style.use
sns.set(font_scale=1.2)  # Налаштування розміру шрифту

# Відображення всіх стовпців датафрейму
pd.set_option('display.max_columns', None)

print("Налаштування стилю успішно застосовано!")
print("Доступні стилі matplotlib:", plt.style.available)
print("\nЯкщо ви хочете використати стиль seaborn через matplotlib, використовуйте один з цих варіантів:")
print("- plt.style.use('seaborn-v0_8')")
print("- plt.style.use('seaborn-v0_8-darkgrid')")
print("- plt.style.use('seaborn-v0_8-whitegrid')")
print("\nАбо просто використовуйте sns.set() як у цьому прикладі.")