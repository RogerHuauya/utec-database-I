SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito_1m';

SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito_100k';

SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito_10k';

SELECT
    schemaname AS table_schema,
    relname AS table_name,
    n_live_tup AS row_count
FROM
    pg_stat_user_tables
WHERE
    schemaname = 'condorito_1k';