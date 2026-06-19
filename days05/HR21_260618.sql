SELECT *
FROM EMPLOYEES;
------------------------------
--분기별 입사한 사원 수 파악


SELECT COUNT(*) AS cnt,
       CASE
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '01' AND '03' THEN '1분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '04' AND '06' THEN '2분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '07' AND '09' THEN '3분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '10' AND '12' THEN '4분기'
       END AS quarter
FROM employees
GROUP BY CASE
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '01' AND '03' THEN '1분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '04' AND '06' THEN '2분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '07' AND '09' THEN '3분기'
           WHEN TO_CHAR(hire_date, 'MM') BETWEEN '10' AND '12' THEN '4분기'
         END
         , TO_CHAR(HIRE_DATE, 'Q')
ORDER BY quarter;

-- EXTRACT (MONTH FROM HIRE_DATE)
--DECODE 사용

SELECT COUNT (DECODE (TO_CHAR(HIRE_DATE, 'Q'),1,'O')) 
, COUNT (DECODE (TO_CHAR(HIRE_DATE, 'Q'),2,'O')) 
, COUNT (DECODE (TO_CHAR(HIRE_DATE, 'Q'),3,'O')) 
, COUNT (DECODE (TO_CHAR(HIRE_DATE, 'Q'),4,'O')) 
FROM EMPLOYEES;