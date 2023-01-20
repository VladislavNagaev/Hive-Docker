# Образ на основе которого будет создан контейнер
FROM --platform=linux/amd64 hadoop-base:3.3.4

LABEL maintainer="Vladislav Nagaev <vladislav.nagaew@gmail.com>"

ENV \
    # Задание версий сервисов
    HIVE_VERSION=4.0.0-alpha-2 \
    POSTGRES_JDBC_VERSION=42.5.1

ENV \
    # Задание домашних директорий
    HIVE_HOME=${APPS_HOME}/hive \
    # Полные наименования сервисов
    HIVE_NAME=apache-hive-${HIVE_VERSION}-bin

ENV \
    # Директории конфигураций
    HIVE_CONF_DIR=${HIVE_HOME}/conf \
    HADOOP_CLASSPATH=${HADOOP_CLASSPATH}:${HIVE_HOME}/lib/* \
    # URL-адреса для скачивания
    HIVE_URL=https://downloads.apache.org/hive/hive-${HIVE_VERSION}/${HIVE_NAME}.tar.gz \
    POSTGRES_JDBC_URL=https://jdbc.postgresql.org/download/postgresql-${POSTGRES_JDBC_VERSION}.jar \
    # Обновление переменных путей
    PATH=${PATH}:${HIVE_HOME}/bin

RUN \
    # --------------------------------------------------------------------------
    # Установка Apache Hive
    # --------------------------------------------------------------------------
    # Скачивание GPG-ключа
    curl --remote-name --location https://downloads.apache.org/hive/KEYS && \
    # Установка gpg-ключа
    gpg --import KEYS && \
    # Скачивание архива Apache Hive
    curl --fail --show-error --location ${HIVE_URL} --output /tmp/${HIVE_NAME}.tar.gz && \
    # Скачивание PGP-ключа
    curl --fail --show-error --location ${HIVE_URL}.asc --output /tmp/${HIVE_NAME}.tar.gz.asc && \
    # Верификация ключа шифрования
    gpg --verify /tmp/${HIVE_NAME}.tar.gz.asc && \
    # Распаковка архива Apache Hive в рабочую папку
    tar -xvf /tmp/${HIVE_NAME}.tar.gz -C ${APPS_HOME}/ && \
    # Удаление исходного архива и ключа шифрования
    rm /tmp/${HIVE_NAME}.tar* && \
    # Создание символической ссылки на Apache Hive
    ln -s ${APPS_HOME}/${HIVE_NAME} ${HIVE_HOME} && \
    # Создание файла конфигурации
    echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>\n\n<configuration>\n</configuration>' >> ${HIVE_CONF_DIR}/hive-site.xml && \
    # Рабочая директория Apache Hive
    # mkdir -p ${HIVE_HOME}/logs && \
    chown -R ${USER}:${GID} ${HIVE_HOME} && \
    chmod -R a+rwx ${HIVE_HOME} && \
    # --------------------------------------------------------------------------
    # --------------------------------------------------------------------------
    # Установка PostgreSQL JDBC
    # --------------------------------------------------------------------------
    wget ${POSTGRES_JDBC_URL} --output-document=${HIVE_HOME}/lib/postgresql-jdbc.jar
    # --------------------------------------------------------------------------

# Копирование файлов проекта
COPY ./entrypoint/* /entrypoint/

# Точка входа
ENTRYPOINT ["/bin/bash", "/entrypoint/hive-entrypoint.sh"]
CMD []
