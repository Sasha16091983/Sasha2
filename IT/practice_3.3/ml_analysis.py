import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
from sklearn.metrics import accuracy_score, classification_report

# Функція для виведення результатів регресії
def print_regression_metrics(y_true, y_pred, model_name):
    mae = mean_absolute_error(y_true, y_pred)
    mse = mean_squared_error(y_true, y_pred)
    r2 = r2_score(y_true, y_pred)
    print(f"\nМетрики для {model_name}:")
    print(f"MAE: {mae:.4f}")
    print(f"MSE: {mse:.4f}")
    print(f"R²: {r2:.4f}")
    return mae, mse, r2

# Функція для виведення результатів класифікації
def print_classification_metrics(y_true, y_pred, model_name):
    acc = accuracy_score(y_true, y_pred)
    print(f"\nМетрики для {model_name}:")
    print(f"Accuracy: {acc:.4f}")
    print("\nДетальний звіт:")
    print(classification_report(y_true, y_pred))
    return acc

# ======= Завдання 1: Регресійний аналіз =======
print("\n===== ЗАВДАННЯ 1: РЕГРЕСІЙНИЙ АНАЛІЗ =====\n")

# Завантаження даних для регресії
regression_data = pd.read_csv('variant_14_regression.csv')
print("Перші 5 рядків даних для регресії:")
print(regression_data.head())
print("\nІнформація про дані:")
print(regression_data.info())
print("\nСтатистика даних:")
print(regression_data.describe())

# Перевірка пропущених значень
print("\nКількість пропущених значень:")
print(regression_data.isnull().sum())

# Визначення категоріальних і числових ознак
reg_categorical_cols = regression_data.select_dtypes(include=['object', 'category']).columns.tolist()
reg_numerical_cols = regression_data.select_dtypes(include=['int64', 'float64']).columns.tolist()
reg_numerical_cols.remove('target')  # Видаляємо цільову змінну зі списку ознак

print(f"\nКатегоріальні ознаки: {reg_categorical_cols}")
print(f"Числові ознаки: {reg_numerical_cols}")

# Підготовка даних для регресії
X_reg = regression_data.drop('target', axis=1)
y_reg = regression_data['target']

# Створення препроцесора для регресії
reg_preprocessor = ColumnTransformer(
    transformers=[
        ('num', Pipeline([
            ('imputer', SimpleImputer(strategy='median')),
            ('scaler', StandardScaler())
        ]), reg_numerical_cols),
        ('cat', Pipeline([
            ('imputer', SimpleImputer(strategy='most_frequent')),
            ('onehot', OneHotEncoder(handle_unknown='ignore'))
        ]), reg_categorical_cols)
    ])

# Розділення даних на тренувальну та тестову вибірки
X_reg_train, X_reg_test, y_reg_train, y_reg_test = train_test_split(
    X_reg, y_reg, test_size=0.2, random_state=42)

# Лінійна регресія
linear_reg = Pipeline([
    ('preprocessor', reg_preprocessor),
    ('regressor', LinearRegression())
])

linear_reg.fit(X_reg_train, y_reg_train)
y_reg_pred_linear = linear_reg.predict(X_reg_test)

# Random Forest регресія
rf_reg = Pipeline([
    ('preprocessor', reg_preprocessor),
    ('regressor', RandomForestRegressor(random_state=42))
])

rf_reg.fit(X_reg_train, y_reg_train)
y_reg_pred_rf = rf_reg.predict(X_reg_test)

# Оцінка моделей регресії
linear_metrics = print_regression_metrics(y_reg_test, y_reg_pred_linear, "Лінійна регресія")
rf_metrics = print_regression_metrics(y_reg_test, y_reg_pred_rf, "Random Forest регресія")

# Порівняння моделей регресії
print("\nПорівняння моделей регресії:")
if rf_metrics[2] > linear_metrics[2]:
    print("Random Forest регресія показує кращі результати.")
    print("Причини: Random Forest може моделювати нелінійні залежності та взаємодії між ознаками.")
else:
    print("Лінійна регресія показує кращі результати.")
    print("Причини: Дані можуть мати лінійну структуру або містити мало ознак.")

# ======= Завдання 2: Класифікація =======
print("\n\n===== ЗАВДАННЯ 2: КЛАСИФІКАЦІЯ =====\n")

# Завантаження даних для класифікації
classification_data = pd.read_csv('variant_14_classification.csv')
print("Перші 5 рядків даних для класифікації:")
print(classification_data.head())
print("\nІнформація про дані:")
print(classification_data.info())
print("\nСтатистика даних:")
print(classification_data.describe())

# Перевірка пропущених значень
print("\nКількість пропущених значень:")
print(classification_data.isnull().sum())

# Визначення категоріальних і числових ознак
cls_categorical_cols = classification_data.select_dtypes(include=['object', 'category']).columns.tolist()
cls_numerical_cols = classification_data.select_dtypes(include=['int64', 'float64']).columns.tolist()
cls_numerical_cols.remove('target')  # Видаляємо цільову змінну зі списку ознак

print(f"\nКатегоріальні ознаки: {cls_categorical_cols}")
print(f"Числові ознаки: {cls_numerical_cols}")

# Підготовка даних для класифікації
X_cls = classification_data.drop('target', axis=1)
y_cls = classification_data['target']

# Створення препроцесора для класифікації
cls_preprocessor = ColumnTransformer(
    transformers=[
        ('num', Pipeline([
            ('imputer', SimpleImputer(strategy='median')),
            ('scaler', StandardScaler())
        ]), cls_numerical_cols),
        ('cat', Pipeline([
            ('imputer', SimpleImputer(strategy='most_frequent')),
            ('onehot', OneHotEncoder(handle_unknown='ignore'))
        ]), cls_categorical_cols)
    ])

# Розділення даних на тренувальну та тестову вибірки
X_cls_train, X_cls_test, y_cls_train, y_cls_test = train_test_split(
    X_cls, y_cls, test_size=0.2, random_state=42)

# Логістична регресія
logistic_cls = Pipeline([
    ('preprocessor', cls_preprocessor),
    ('classifier', LogisticRegression(random_state=42, max_iter=1000))
])

logistic_cls.fit(X_cls_train, y_cls_train)
y_cls_pred_logistic = logistic_cls.predict(X_cls_test)

# Random Forest класифікація
rf_cls = Pipeline([
    ('preprocessor', cls_preprocessor),
    ('classifier', RandomForestClassifier(random_state=42))
])

rf_cls.fit(X_cls_train, y_cls_train)
y_cls_pred_rf = rf_cls.predict(X_cls_test)

# Оцінка моделей класифікації
logistic_acc = print_classification_metrics(y_cls_test, y_cls_pred_logistic, "Логістична регресія")
rf_acc = print_classification_metrics(y_cls_test, y_cls_pred_rf, "Random Forest класифікація")

# Порівняння моделей класифікації
print("\nПорівняння моделей класифікації:")
if rf_acc > logistic_acc:
    print("Random Forest класифікація показує кращі результати.")
    print("Причини: Random Forest може краще моделювати складні взаємодії між ознаками.")
else:
    print("Логістична регресія показує кращі результати.")
    print("Причини: Дані можуть мати просту структуру або містити мало ознак.")

# ======= Завдання 3: Оптимізація моделі =======
print("\n\n===== ЗАВДАННЯ 3: ОПТИМІЗАЦІЯ МОДЕЛІ =====\n")

# Визначаємо, яку модель оптимізувати (регресія чи класифікація)
if rf_metrics[2] > linear_metrics[2]:
    print("Оптимізуємо Random Forest Regressor, оскільки він показав кращі результати.")
    # Параметри для пошуку
    param_grid = {
        'regressor__n_estimators': [50, 100, 200],
        'regressor__max_depth': [None, 10, 20, 30],
        'regressor__min_samples_split': [2, 5, 10],
        'regressor__min_samples_leaf': [1, 2, 4]
    }
    
    # Створення GridSearchCV
    grid_search = GridSearchCV(
        rf_reg, param_grid, cv=5, scoring='r2', n_jobs=-1, verbose=1
    )
    
    # Навчання моделі з пошуком параметрів
    grid_search.fit(X_reg_train, y_reg_train)
    
    # Найкращі параметри
    print("\nНайкращі параметри:")
    print(grid_search.best_params_)
    
    # Оцінка оптимізованої моделі
    best_rf_reg = grid_search.best_estimator_
    y_reg_pred_best = best_rf_reg.predict(X_reg_test)
    
    print("\nРезультати до оптимізації:")
    print(f"MAE: {rf_metrics[0]:.4f}")
    print(f"MSE: {rf_metrics[1]:.4f}")
    print(f"R²: {rf_metrics[2]:.4f}")
    
    print("\nРезультати після оптимізації:")
    best_metrics = print_regression_metrics(y_reg_test, y_reg_pred_best, "Оптимізований Random Forest Regressor")
    
    # Порівняння результатів
    print("\nПокращення після оптимізації:")
    print(f"MAE: {rf_metrics[0] - best_metrics[0]:.4f} ({(1 - best_metrics[0]/rf_metrics[0])*100:.2f}%)")
    print(f"MSE: {rf_metrics[1] - best_metrics[1]:.4f} ({(1 - best_metrics[1]/rf_metrics[1])*100:.2f}%)")
    print(f"R²: {best_metrics[2] - rf_metrics[2]:.4f} ({(best_metrics[2]/rf_metrics[2] - 1)*100:.2f}%)")
    
else:
    print("Оптимізуємо Random Forest Classifier, оскільки він показав кращі результати.")
    # Параметри для пошуку
    param_grid = {
        'classifier__n_estimators': [50, 100, 200],
        'classifier__max_depth': [None, 10, 20, 30],
        'classifier__min_samples_split': [2, 5, 10],
        'classifier__min_samples_leaf': [1, 2, 4]
    }
    
    # Створення GridSearchCV
    grid_search = GridSearchCV(
        rf_cls, param_grid, cv=5, scoring='accuracy', n_jobs=-1, verbose=1
    )
    
    # Навчання моделі з пошуком параметрів
    grid_search.fit(X_cls_train, y_cls_train)
    
    # Найкращі параметри
    print("\nНайкращі параметри:")
    print(grid_search.best_params_)
    
    # Оцінка оптимізованої моделі
    best_rf_cls = grid_search.best_estimator_
    y_cls_pred_best = best_rf_cls.predict(X_cls_test)
    
    print("\nРезультати до оптимізації:")
    print(f"Accuracy: {rf_acc:.4f}")
    
    print("\nРезультати після оптимізації:")
    best_acc = print_classification_metrics(y_cls_test, y_cls_pred_best, "Оптимізований Random Forest Classifier")
    
    # Порівняння результатів
    print("\nПокращення після оптимізації:")
    print(f"Accuracy: {best_acc - rf_acc:.4f} ({(best_acc/rf_acc - 1)*100:.2f}%)")

print("\nВисновки:")
print("1. Для регресійного аналізу Random Forest зазвичай показує кращі результати, ніж лінійна регресія,")
print("   оскільки може моделювати нелінійні залежності та взаємодії між ознаками.")
print("2. Для класифікації Random Forest також часто перевершує логістичну регресію,")
print("   особливо на складних даних з багатьма ознаками.")
print("3. Оптимізація гіперпараметрів дозволяє значно покращити результати моделей,")
print("   але вимагає більше обчислювальних ресурсів.")