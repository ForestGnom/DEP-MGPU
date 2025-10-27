-- =====================================================================
-- Система аналитики управления затратами в системах работы с данными

-- =====================================================================
-- Автор: Трухачев Никита
-- Назначение: Создание структуры БД для аналитики затрат
-- =====================================================================
-- Подключение к базе данных superstore:
-- Host: localhost
-- Port: 5432
-- Database: superstore
-- User: postgres
-- Password: post1616!

-- =====================================================
-- 1. СОЗДАНИЕ СХЕМ
-- =====================================================

-- Создание схемы для сырых данных
CREATE SCHEMA IF NOT EXISTS raw_data;

-- Создание схемы для аналитических витрин
CREATE SCHEMA IF NOT EXISTS analytics;

-- Проверка создания схем
SELECT schema_name 
FROM information_schema.schemata 
WHERE schema_name IN ('raw_data', 'analytics')
ORDER BY schema_name;

-- =====================================================
-- 2. СОЗДАНИЕ ТАБЛИЦЫ ДЛЯ СЫРЫХ ДАННЫХ
-- =====================================================

DROP TABLE IF EXISTS raw_data.cost_management_survey;

CREATE TABLE raw_data.cost_management_survey (
    record_id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP,
    department VARCHAR(100),
    systems_used VARCHAR(150),
    efficiency VARCHAR(50),
    cost_practices VARCHAR(150),
    storage_cost_share_pct DECIMAL(5,2),
    automation_level VARCHAR(100),
    budget_deviation_pct DECIMAL(6,2),
    maturity_level VARCHAR(100),
    key_metrics VARCHAR(255)
);

COMMENT ON TABLE raw_data.cost_management_survey IS 'Результаты опроса по управлению затратами в системах работы с данными';
COMMENT ON COLUMN raw_data.cost_management_survey.department IS 'Подразделение респондента';
COMMENT ON COLUMN raw_data.cost_management_survey.systems_used IS 'Используемая система или платформа (облачная, локальная, гибридная и т.д.)';
COMMENT ON COLUMN raw_data.cost_management_survey.efficiency IS 'Самооценка эффективности управления затратами';
COMMENT ON COLUMN raw_data.cost_management_survey.cost_practices IS 'Применяемые практики управления затратами';
COMMENT ON COLUMN raw_data.cost_management_survey.storage_cost_share_pct IS 'Доля затрат на хранение данных (%)';
COMMENT ON COLUMN raw_data.cost_management_survey.automation_level IS 'Уровень автоматизации мониторинга и отчётности';
COMMENT ON COLUMN raw_data.cost_management_survey.budget_deviation_pct IS 'Отклонение фактических затрат от плановых (%)';
COMMENT ON COLUMN raw_data.cost_management_survey.maturity_level IS 'Уровень зрелости управления затратами';
COMMENT ON COLUMN raw_data.cost_management_survey.key_metrics IS 'Ключевые метрики, используемые для анализа затрат';


-- =====================================================
-- 3. СОЗДАНИЕ АНАЛИТИЧЕСКИХ ВИТРИН
-- =====================================================

-- =====================================================
-- 3.1 Витрина по департамента
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_department_summary;

CREATE TABLE analytics.mart_department_summary AS
SELECT 
    department,
    COUNT(*) AS total_records,
    AVG(storage_cost_share_pct) AS avg_storage_share,
    AVG(budget_deviation_pct) AS avg_budget_deviation,
    MODE() WITHIN GROUP (ORDER BY efficiency) AS most_common_efficiency,
    MODE() WITHIN GROUP (ORDER BY automation_level) AS most_common_automation,
    MODE() WITHIN GROUP (ORDER BY maturity_level) AS most_common_maturity
FROM raw_data.cost_management_survey
GROUP BY department;

COMMENT ON TABLE analytics.mart_department_summary IS 'Агрегированные данные по департаментам для анализа эффективности затрат';
COMMENT ON COLUMN analytics.mart_department_summary.department IS 'Департамент';
COMMENT ON COLUMN analytics.mart_department_summary.total_records IS 'Количество записей по департаменту';
COMMENT ON COLUMN analytics.mart_department_summary.avg_storage_share IS 'Средняя доля затрат на хранение данных (%)';
COMMENT ON COLUMN analytics.mart_department_summary.avg_budget_deviation IS 'Среднее отклонение бюджета (%)';
COMMENT ON COLUMN analytics.mart_department_summary.most_common_efficiency IS 'Наиболее часто встречаемый уровень эффективности';
COMMENT ON COLUMN analytics.mart_department_summary.most_common_automation IS 'Преобладающий уровень автоматизации';
COMMENT ON COLUMN analytics.mart_department_summary.most_common_maturity IS 'Типичный уровень зрелости управления затратами';


-- =====================================================
-- 3.2 Витрина по системам и платформам
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_systems_summary;

CREATE TABLE analytics.mart_systems_summary AS
SELECT 
    systems_used,
    COUNT(*) AS total_records,
    AVG(storage_cost_share_pct) AS avg_storage_share,
    AVG(budget_deviation_pct) AS avg_budget_deviation,
    MODE() WITHIN GROUP (ORDER BY efficiency) AS most_common_efficiency,
    MODE() WITHIN GROUP (ORDER BY maturity_level) AS most_common_maturity
FROM raw_data.cost_management_survey
GROUP BY systems_used;

COMMENT ON TABLE analytics.mart_systems_summary IS 'Аналитика по типам систем и платформ данных';
COMMENT ON COLUMN analytics.mart_systems_summary.systems_used IS 'Тип системы или платформы';
COMMENT ON COLUMN analytics.mart_systems_summary.total_records IS 'Количество записей по системе';
COMMENT ON COLUMN analytics.mart_systems_summary.avg_storage_share IS 'Средняя доля затрат на хранение данных';
COMMENT ON COLUMN analytics.mart_systems_summary.avg_budget_deviation IS 'Среднее отклонение бюджета';
COMMENT ON COLUMN analytics.mart_systems_summary.most_common_efficiency IS 'Преобладающий уровень эффективности';
COMMENT ON COLUMN analytics.mart_systems_summary.most_common_maturity IS 'Типичный уровень зрелости';


-- =====================================================
-- 3.3 Витрина по уровню зрелости управления затратами
-- =====================================================

DROP TABLE IF EXISTS analytics.mart_maturity_summary;

CREATE TABLE analytics.mart_maturity_summary AS
SELECT 
    maturity_level,
    COUNT(*) AS total_records,
    AVG(storage_cost_share_pct) AS avg_storage_share,
    AVG(budget_deviation_pct) AS avg_budget_deviation,
    MODE() WITHIN GROUP (ORDER BY automation_level) AS common_automation,
    MODE() WITHIN GROUP (ORDER BY efficiency) AS common_efficiency
FROM raw_data.cost_management_survey
GROUP BY maturity_level;

COMMENT ON TABLE analytics.mart_maturity_summary IS 'Аналитика по уровням зрелости управления затратами';
COMMENT ON COLUMN analytics.mart_maturity_summary.maturity_level IS 'Уровень зрелости управления затратами';
COMMENT ON COLUMN analytics.mart_maturity_summary.total_records IS 'Количество записей по уровню зрелости';
COMMENT ON COLUMN analytics.mart_maturity_summary.avg_storage_share IS 'Средняя доля затрат на хранение данных (%)';
COMMENT ON COLUMN analytics.mart_maturity_summary.avg_budget_deviation IS 'Среднее отклонение бюджета (%)';
COMMENT ON COLUMN analytics.mart_maturity_summary.common_automation IS 'Преобладающий уровень автоматизации';
COMMENT ON COLUMN analytics.mart_maturity_summary.common_efficiency IS 'Преобладающий уровень эффективности';


-- =====================================================
-- 3.4 Витрина для стратегического анализа
-- =====================================================
DROP TABLE IF EXISTS analytics.mart_company_strategy_metrics;

CREATE TABLE analytics.mart_company_strategy_metrics AS
SELECT 
    department,
    systems_used,
    cost_practices,
    AVG(storage_cost_share_pct) AS avg_storage_share,
    AVG(budget_deviation_pct) AS avg_budget_deviation,
    COUNT(*) AS total_records,
    CASE 
        WHEN AVG(budget_deviation_pct) < -5 THEN 'Высокая эффективность'
        WHEN AVG(budget_deviation_pct) BETWEEN -5 AND 5 THEN 'Средняя эффективность'
        ELSE 'Низкая эффективность'
    END AS cost_management_effectiveness,
    CASE
        WHEN systems_used ILIKE '%облач%' THEN 'Облачные решения'
        WHEN systems_used ILIKE '%локаль%' THEN 'Локальные решения'
        WHEN systems_used ILIKE '%гибрид%' THEN 'Гибридные решения'
        WHEN systems_used ILIKE '%озеро%' THEN 'Озера данных'
        ELSE 'Прочие системы'
    END AS system_category,
    CASE 
        WHEN AVG(budget_deviation_pct) > 10 THEN 'Требуется пересмотр стратегии управления затратами'
        WHEN AVG(budget_deviation_pct) BETWEEN 0 AND 10 THEN 'Оптимизация возможна'
        WHEN AVG(budget_deviation_pct) < 0 THEN 'Эффективные практики — можно масштабировать'
        ELSE 'Поддерживать текущий уровень'
    END AS strategic_recommendation
FROM raw_data.cost_management_survey
GROUP BY department, systems_used, cost_practices;

COMMENT ON TABLE analytics.mart_company_strategy_metrics IS 'Стратегическая витрина по управлению затратами и эффективности';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.department IS 'Департамент компании';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.systems_used IS 'Тип используемой системы';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.cost_practices IS 'Применяемая практика управления затратами';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.avg_storage_share IS 'Средняя доля затрат на хранение данных (%)';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.avg_budget_deviation IS 'Среднее отклонение бюджета (%)';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.total_records IS 'Количество записей';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.cost_management_effectiveness IS 'Оценка эффективности управления затратами';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.system_category IS 'Категория системы (облачная, локальная и т.д.)';
COMMENT ON COLUMN analytics.mart_company_strategy_metrics.strategic_recommendation IS 'Рекомендация по стратегии оптимизации';

-- =====================================================================
-- Структура базы данных успешно создана
-- =====================================================================

-- =====================================================
-- 7. ПРОВЕРКА СОЗДАННЫХ ОБЪЕКТОВ
-- =====================================================

-- Проверка создания таблиц
SELECT 
    schemaname, 
    tablename, 
    tableowner 
FROM pg_tables 
WHERE schemaname IN ('raw_data', 'analytics')
ORDER BY schemaname, tablename;

-- Проверка количества записей в таблицах
SELECT 'raw_data.cost_management_survey' as table_name, COUNT(*) as record_count FROM raw_data.cost_management_survey
UNION ALL
SELECT 'analytics.mart_department_summary' as table_name, COUNT(*) as record_count FROM analytics.mart_department_summary
UNION ALL
SELECT 'analytics.mart_systems_summary' as table_name, COUNT(*) as record_count FROM analytics.mart_systems_summary
UNION ALL
SELECT 'analytics.mart_maturity_summary' as table_name, COUNT(*) as record_count FROM analytics.mart_maturity_summary
UNION ALL
SELECT 'analytics.mart_company_strategy_metrics' as table_name, COUNT(*) as record_count FROM analytics.mart_company_strategy_metrics;


-- =====================================================
-- 5. ФИНАЛЬНАЯ ПРОВЕРКА
-- =====================================================

SELECT 
    'Таблицы' as object_type,
    COUNT(*) as count
FROM pg_tables 
WHERE schemaname IN ('raw_data', 'analytics')
UNION ALL
SELECT 
    'Представления' as object_type,
    COUNT(*) as count
FROM pg_views 
WHERE schemaname = 'analytics'
UNION ALL
SELECT 
    'Функции' as object_type,
    COUNT(*) as count
FROM pg_proc 
WHERE pronamespace = (SELECT oid FROM pg_namespace WHERE nspname = 'analytics');

SELECT 'Схема базы данных успешно создана!' as status;
SELECT 'Все таблицы, витрины и представления готовы к использованию в DataLens' as message;