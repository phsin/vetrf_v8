# [Создание ветсправок в ГИС Меркурий из 1С Предприятие 8.2 / 8.3](http://xn----ctbjbnchgq5bbglv.xn--p1ai/)

Интеграция 1С:Комплексная с государственной информационной системой “Меркурий” предназначен для обеспечения взаимодействия учетной системы заказчика, созданной на базе конфигурации Управление Торговлей, ред. 10\11 системы программ "1С:Предприятие 8.2", с ГИС "Меркурий".

* автоматическое создание входящих ВСД из 1С
* групповое создание исходящих (транспортных) ВСД, заполненных на основании введенных документов Реализация товаров
* получение ответа о создании документа (принят / отклонен), с указанием причины отказа.
* получение списка площадок и ХозСубъектов из ГИС Меркурий
* создание новых площадок и хоз. субъектов в ГИС Меркурий из 1С

ВСД = Ветеринарно сопроводительная документация = Ветсправка форма 2 или форма 4

## Установка

Конфигурацию можно использовать только объединив с рабочей базой. Работа в отдельной конфигурации не предусмотрена.

1. Сравнить объединить с конфигурацией из файла
2. Отменить все галки
3. Отметить по подсистемам файла - отметить ВСД
4. Объединить конфигурации
5. (не обязательно) В конфигурации *добавить документы ВСД* в 
* Критерии отбора - Связанные документы
* Общие команды - Структура подчиненности.

Рекомендуется использовать последнюю версию платформы 8.3.14

Внешняя_Форма_ВСД.epf - работает как с OcvitaBarCode, так и со встроенным функционалом БП 3.0 - писалась для Управляемого приложения Бухгалтерия Предприятия 3.*
Например для Комплексной 1.1  не требуется никаких доработок - работает штатно с оквитой (автоматически выбирает макет).

[*Подробное описание*](https://redmine.kb99.pro/projects/vsd_v8/wiki)
