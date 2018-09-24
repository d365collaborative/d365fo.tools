SELECT 
--s.object_id AS sequence_object_id,
s.name AS sequence_name,
SCHEMA_NAME(oParent.schema_id) +'.'+ oParent.name AS table_name,
--SCHEMA_NAME(o.schema_id) AS referencing_schema_name,
--o.name AS referencing_entity_name,
--dep.referencing_id,
--dep.referencing_class,
--dep.referencing_class_desc,
--dep.is_caller_dependent,
s.start_value,
s.increment,
s.minimum_value,
s.maximum_value,
s.is_cached,
s.cache_size,
s.current_value

FROM sys.objects AS o
INNER JOIN sys.sql_expression_dependencies AS dep on dep.referencing_id = o.object_id
INNER JOIN sys.sequences AS s ON dep.referenced_id = s.object_id
INNER JOIN sys.objects AS oParent ON o.parent_object_id = oParent.object_id
WHERE oParent.name LIKE @TableName