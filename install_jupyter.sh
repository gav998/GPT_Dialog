#!/usr/bin/env bash

# Получаем имя текущего пользователя
echo "USER_NAME=$(whoami)"
USER_NAME=$(whoami)

# Получаем директорию, где лежит скрипт
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
echo "SCRIPT_DIR=$SCRIPT_DIR"

# Запрашиваем пароль для JupyterLab
echo "Set password for JupyterLab admin panel:"
read -s PASSWORD

# Устанавливаем необходимые системные пакеты
echo "Installing system requirements..."
sudo apt update
sudo apt -y upgrade
sudo apt -y install gcc python3-dev git

# Создаем виртуальное окружение
echo "Creating virtual environment..."
python3 -m venv --system-site-packages "${SCRIPT_DIR}/venv"

# Активируем виртуальное окружение
source "${SCRIPT_DIR}/venv/bin/activate"

echo "Installing python requirements from requirements.txt..."
pip install -r "${SCRIPT_DIR}/requirements.txt"

JUPYTER_PASSWORD_HASH=$(python -c "from jupyter_server.auth import passwd; print(passwd('$PASSWORD'))")

# Создаем сервис автозапуска JupyterLab 8888
SERVICE_FILE="/etc/systemd/system/jupyterlab.service"
echo "Creating systemd service at $SERVICE_FILE..."
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=JupyterLab Autostart
After=network.target

[Service]
Type=simple
ExecStart=/bin/bash -c 'sleep 5 && source "${SCRIPT_DIR}/venv/bin/activate" && python -m jupyterlab --ip=0.0.0.0 --no-browser --NotebookApp.password='\''$JUPYTER_PASSWORD_HASH'\'
WorkingDirectory=${SCRIPT_DIR}
User=${USER_NAME}

[Install]
WantedBy=default.target
EOF

# Включаем и запускаем сервис
sudo systemctl stop jupyterlab.service
sudo systemctl disable jupyterlab.service
sudo systemctl daemon-reload
sudo systemctl enable jupyterlab.service
sudo systemctl start jupyterlab.service