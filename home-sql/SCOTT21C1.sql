

SELECT a.table_name 
     , a.index_name 
     , a.column_name 
  FROM all_ind_columns a 
 WHERE a.table_name = 'ORDERS' 
 ORDER BY a.index_name
        , a.column_position;
        
        
        RENAME RETURN TO PRODUCT_RETURN;
        
SELECT table_name
FROM user_tables
WHERE table_name = 'PRODUCT_RETURN';