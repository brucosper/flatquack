{{fq_sql_macros}}

SET VARIABLE fq_input_files = (
	SELECT coalesce(list(file), ['{{fq_input_dir}}/**/*{{fq_vd_resource}}*.ndjson'])
	FROM glob('{{fq_input_dir}}/**/*{{fq_vd_resource}}*.ndjson*')
	WHERE file LIKE '%.ndjson' OR file LIKE '%.ndjson.gz'
);

WITH transformed AS (
	SELECT {{fq_sql_transform_expression}} AS result 
	FROM read_json_auto(
		getvariable('fq_input_files')
		{{fq_sql_input_schema}}
	)
	{{fq_where_filter}}
	LIMIT 10
)
SELECT {{fq_sql_flattening_cols}}
FROM transformed
{{fq_sql_flattening_tables}}