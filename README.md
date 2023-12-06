# Экологический контроль предприятий края

## Требования
- docker
- docker-compose

## Запуск
`docker-compose up`

Создадутся два контейнера: приложение и бд. Свойства контейнеров можно посмотреть в docker-compose.yml.

## Использование
Перейдите по адресу http://localhost:8080

Приложение написано с использованием spring data rest. Работать с ним можно следующим образом:
1. Обращение к дефолтным методам: Spring Data REST автоматически экспонирует CRUD (создание, чтение, обновление, удаление) операции для репозиториев. Например, если есть репозиторий PersonRepository, можно выполнить следующие операции:
   * GET /people: Получить список всех людей. 
   * POST /people: Создать нового человека. 
   * GET /people/{id}: Получить информацию о человеке с определенным ID. 
   * PUT /people/{id} или PATCH /people/{id}: Обновить информацию о человеке с определенным ID. 
   * DELETE /people/{id}: Удалить человека с определенным ID.
2. Обращение к кастомным методам: Если в репозитории определены кастомные методы, они также будут автоматически доступны. Например, если есть метод findByLastName, можно обратиться к нему следующим образом: `GET /people/search/findByLastName?name={lastName}`.
3. Обращение к связанным сущностям: Если сущности имеют связи с другими сущностями, вы можете обращаться к ним напрямую. Например, если есть сущность Person со связью Address, можно получить адрес определенного человека следующим образом: `GET /people/{id}/address`.
4. Пагинация и сортировка: Spring Data REST поддерживает пагинацию и сортировку из коробки. Можно использовать параметры page, size и sort в ваших запросах для управления этими аспектами. Например: `GET /people?page=0&size=20&sort=lastName,asc`.

Репозитории - это интерфейсы, которые используются для работы с базой данных. Из можно найти в директории 
`src/main/java/com/example/environmentalcontrol/repository`.