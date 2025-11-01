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

# Создаем директорию для NLTK данных и устанавливаем права
RUN mkdir -p /home/jovyan/nltk_data && \
    chown -R ${NB_UID}:${NB_GID} /home/jovyan/nltk_data

# Переключаемся на пользователя jovyan для загрузки NLTK данных
USER ${NB_UID}

# Загружаем данные NLTK с правильными путями
RUN python -c "import nltk; nltk.download('stopwords', download_dir='/home/jovyan/nltk_data'); nltk.download('punkt', download_dir='/home/jovyan/nltk_data'); nltk.download('russian', download_dir='/home/jovyan/nltk_data')"

# Устанавливаем переменную окружения для NLTK
ENV NLTK_DATA /home/jovyan/nltk_data

WORKDIR /home/jovyan/work