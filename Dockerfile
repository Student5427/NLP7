FROM jupyter/datascience-notebook:latest

USER root

# Установка системных зависимостей для pymorphy3
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Копируем requirements и устанавливаем Python пакеты
COPY requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Загружаем данные NLTK
RUN python -c "import nltk; nltk.download('stopwords'); nltk.download('punkt')"

# Возвращаемся к пользователю jovyan
USER ${NB_UID}

WORKDIR /home/jovyan/work