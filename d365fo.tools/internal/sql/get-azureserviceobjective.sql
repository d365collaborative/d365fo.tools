SELECT  d.name,   
   slo.edition,slo.service_objective  
FROM sys.databases d   
JOIN sys.database_service_objectives slo    
ON d.database_id = slo.database_id