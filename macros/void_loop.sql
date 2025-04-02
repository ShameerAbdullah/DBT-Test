{% macro run_void_merge_loop() %}
{% set dates_query %}
    WITH TopDates AS (
        SELECT reporting_date
        FROM ADLAB_DEV.WORKSPACE.SALES_REPORTING_VIEW
        GROUP BY reporting_date
        ORDER BY reporting_date DESC
        LIMIT 5
    )
    SELECT reporting_date
    FROM TopDates
    WHERE reporting_date <> (SELECT MAX(reporting_date) FROM TopDates)
    ORDER BY reporting_date DESC
{% endset %}

{% set results = run_query(dates_query).columns[0].values() %}

{% for date in results %}
    {{ log("Running MERGE for reporting_date: " ~ date, info=True) }}
    {% set sql = generate_void_merge_sql(date) %}
    {% do run_query(sql) %}
{% endfor %}
{% endmacro %}