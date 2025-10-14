
-- STG СЛОЙ (Staging Layer)

-- Описание структуры таблиц staging-слоя

-- Таблица stg.orders - исходные данные заказов
DESCRIBE stg.orders;
/*
Структура:
- Row_ID (INTEGER) - уникальный идентификатор строки
- Order_ID (VARCHAR) - идентификатор заказа
- Order_Date, Ship_Date (DATE) - даты заказа и доставки
- Ship_Mode (VARCHAR) - способ доставки
- Customer_ID, Customer_Name - данные клиента
- Segment - сегмент клиента
- Country, City, State, Postal_Code, Region - географические данные
- Product_ID, Category, SubCategory, Product_Name - данные продукта
- Sales, Quantity, Discount, Profit - финансовые показатели
*/

-- Таблица stg.people - данные менеджеров и их регионов ответственности
DESCRIBE stg.people;
/*
Структура:
- Person (VARCHAR(17)) - имя менеджера (первичный ключ)
- Region (VARCHAR(7)) - регион ответственности менеджера
Назначение: связывает менеджеров с регионами для анализа эффективности
*/

-- Таблица stg.returns - данные о возвратах товаров
DESCRIBE stg.returns;
/*
Структура:
- Person (VARCHAR(17)) - флаг возврата (значения: 'Yes'/NULL)
- Region (VARCHAR(20)) - идентификатор заказа для возврата
Особенность: поле Person используется как флаг возврата, Region хранит Order_ID
*/

-- Связи между таблицами:
-- stg.orders.Order_ID ↔ stg.returns.Region (через поле Region в returns)
-- stg.orders.Region ↔ stg.people.Region
-- stg.people.Person ↔ stg.returns.Person (косвенная связь через регион)

-- Особенности первичных данных:
-- Данные денормализованы, содержат смешанную информацию
-- Поле Postal_Code имеет тип VARCHAR для сохранения ведущих нулей
-- Таблица returns имеет нестандартную структуру: Person как флаг, Region как Order_ID



-- DW СЛОЙ (Data Warehouse Layer)

-- Описание структуры таблиц витрин данных

-- Таблица фактов dw.sales_fact
DESCRIBE dw.sales_fact;
/*
Структура:
- sales_id (SERIAL) - суррогатный ключ
- cust_id, prod_id, ship_id, geo_id - внешние ключи к измерениям
- order_date_id, ship_date_id - ссылки на календарь
- order_id - бизнес-ключ заказа
- sales, profit, quantity, discount - метрики
*/

-- Таблица измерений dw.customer_dim
DESCRIBE dw.customer_dim;
/*
Структура:
- cust_id (SERIAL) - суррогатный ключ
- customer_id, customer_name - натуральные ключи
*/

-- Таблица измерений dw.product_dim
DESCRIBE dw.product_dim;
/*
Структура:
- prod_id (SERIAL) - суррогатный ключ
- product_id, product_name - натуральные ключи
- category, sub_category, segment - атрибуты продукта
*/

-- Таблица измерений dw.geo_dim (аналог location_dim)
DESCRIBE dw.geo_dim;
/*
Структура:
- geo_id (SERIAL) - суррогатный ключ
- country, city, state, postal_code - географические атрибуты
*/

-- Связи между таблицами:
-- sales_fact.cust_id → customer_dim.cust_id
-- sales_fact.prod_id → product_dim.prod_id
-- sales_fact.geo_id → geo_dim.geo_id
-- sales_fact.ship_id → shipping_dim.ship_id
-- sales_fact.order_date_id → calendar_dim.dateid
-- sales_fact.ship_date_id → calendar_dim.dateid

-- Описание трансформаций данных:
-- Денормализованные данные stg.orders разделяются на измерения и факты
-- Создаются суррогатные ключи для улучшения производительности
-- Добавляется календарное измерение для временных анализов
-- Таблицы people и returns используются для расширенной аналитики


-- СЛОВАРИ (DIMENSIONS)

-- Описание структуры справочников

-- Справочник способов доставки
DESCRIBE dw.shipping_dim;
/*
Структура:
- ship_id (SERIAL) - суррогатный ключ
- shipping_mode (VARCHAR) - способ доставки
*/

-- Справочник дат (календарь)
DESCRIBE dw.calendar_dim;
/*
Структура:
- dateid (SERIAL) - суррогатный ключ (формат YYYYMMDD)
- year, quarter, month, week - временные иерархии
- date (DATE) - полная дата
- week_day - день недели
- leap - признак високосного года
*/

-- Правила наполнения справочников:
-- shipping_dim: уникальные значения ship_mode из stg.orders
-- calendar_dim: генерация всех дат с 2000-01-01 по 2030-01-01
-- customer_dim: уникальные комбинации customer_id, customer_name
-- product_dim: уникальные комбинации атрибутов продукта
-- geo_dim: уникальные комбинации географических атрибутов

*/