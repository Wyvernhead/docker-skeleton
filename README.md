# Logema's Docker project skeleton

## Краткое руководство по использованию

- Создать директорию проекта
- Склонировать репозиторий почти в директорию проекта:
  `git clone git@github.com:Wyvernhead/docker-skeleton.git ./docker`

- Создать свой compose.yaml файл в директории проекта, вдохновляясь compose.example.yaml (Не забывая, что он будет
  лежать на уровень выше, чем сейчас!)
- Скопировать ./docker/.env.example в .env и настроить переменные окружения
- Запустить проект через `docker compose up -d`

## Структура проекта
Ожидается, что проект будет иметь следующую структуру:
```
|-- project
    |-- docker - директория с данным репозиторием
    |-- backend - директория с бэкендом
    |-- frontend - директория с фронтендом
    |-- docker-custom - директория с модификациями образов
    |-- .env - файл с переменными окружения
    |-- compose.yaml - файл docker compose для запуска проекта
```

## Модификация

Для модификаций образов на уровне проекта рекомендую создать директорию docker-custom, в которой размещать свои
файлы, переопределяющие файлы из директории docker. Например, для переопределения конфигурации nginx, можно создать
файл docker-custom/nginx/sites/default.conf. Для добавления своих модификаций, достаточно создать директорию с
именем образа, в которой разместить необходимые файлы и указать их использование в унаследованном compose-файле, как это
указано для nginx в примере.
