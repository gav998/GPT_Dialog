import os

# Функция для запроса данных у пользователя и их записи
def request_and_write_env():
    keys = [
        "TG_API_ID",
        "TG_API_HASH",
        "YANDEX_OAUTH_TOKEN",
        "YANDEX_FOLDER_ID",
        "OPENAI_API_KEY"
    ]

    # Путь к файлу .env
    env_path = '.env'
    
    # Проверка существования файла .env и создание в случае отсутствия
    if not os.path.exists(env_path):
        with open(env_path, 'w'): pass
    
    # Открытие файла .env для записи
    with open(env_path, 'a') as env_file:
        for key in keys:
            # Запрашиваем у пользователя данные
            value = input(f'Введите значение для {key}: ')
            # Формируем строку для записи в файл
            env_line = f'{key}={value}\n'
            # Записываем строку в файл
            env_file.write(env_line)
    
    print(".env файл успешно обновлен")

# Вызов функции
request_and_write_env()