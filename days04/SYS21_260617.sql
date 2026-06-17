
SELECT *
FROM ALL_TABLES
WHERE table_name like 'emp';

DELETE PUBLIC SYNONYM semp
 FOR scott.emp;


CREATE PUBLIC SYNONYM semp
 FOR scott.emp;
 
 SHOW CON_NAME;
-- XEPDB1 컨테이너 이동 후 시노님 생성
ALTER SESSION SET CONTAINER = XEPDB1; 