#!/usr/bin/env bash

# Получаем директорию, где лежит скрипт
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "SCRIPT_DIR=$SCRIPT_DIR"

# Создаем виртуальное окружение
echo "Creating virtual environment..."
python3 -m venv --system-site-packages "${SCRIPT_DIR}/venv"

# Активируем виртуальное окружение
source "${SCRIPT_DIR}/venv/bin/activate"

echo "Installing python requirements from requirements.txt..."
pip install -r "${SCRIPT_DIR}/requirements.txt"