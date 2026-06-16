SELECT *
FROM user_tables;
WHERE 

SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R%'
ORDER BY salary;


SELECT last_name, salary 
FROM employees
WHERE last_name LIKE 'R___'
ORDER BY last_name;


select last_name from employees
where REGEXP_LIKE (last_name, '([aeiou])\1','i')-- 똑같은 모음 2개 연달아
ORDER BY last_name;


SELECT first_name, last_name 
FROM employees
WHERE REGEXP_LIKE (first_name, '^Ste(v|ph)en$')
ORDER BY first_name, last_name;


select last_name, salary from employees
  2  where last_name LIKE '%A\_B%' ESCAPE '\'  ☜ last_name문자중에 ...A_B...와 같은 경우
  3  order by salary;

------------------------------------------------------------------------------

사원번호 154번 정보조회
SELECT *
FROM employees
WHERE employee_id = 154;
--154	Nanette	Cambrault	NCAMBRAU	011.44.1344.987668	06/12/09	SA_REP	7500	0.2	145	80
--                     last_name 컬럼 값을 수정(DML-UPDATE) : 	C_ambrault 
UPDATE employees
SET last_name ='C_ambrault'
WHERE employee_id = 154;

-- [문제] 100,101,102 사원의 last_name 이름을 변경
--100   Steven   K%ing
--101   Neena   Koch%har
--102   Lex   De Ha%an

SELECT *
FROM employees
WHERE employee_id IN (100, 101, 102);

UPDATE employees
SET last_name =' K%ing' , first_name =  'Steven'
WHERE employee_id = 100;

UPDATE employees
SET last_name =' Koch%har' , first_name =  ' Neena'
WHERE employee_id = 101;

UPDATE employees
SET last_name ='De Ha%an' , first_name =  'Lex'
WHERE employee_id = 102;

UPDATE employees
SET last_name = SUBSTR( last_name, 1, LENGTH(last_name)-2) || '%' || SUBSTR( last_name,-2 )  
WHERE employee_id IN (  100, 101, 102 );

-- 문자열 속에  '%' 포함 자 사원 조회
SELECT last_name
FROM employees
--WHERE last_name LIKE '%\%%' ESCAPE '\';
WHERE last_name LIKE '%\_%' ESCAPE '\';

ROLLBACK; -- 기본 커밋 안되기 떄문에.. 

----------------------------------------

SELECT department_id
FROM employees
where department_id IS NOT NULL;


SELECT COUNT  (department_id)
FROM (
SELECT department_id
FROM departments
MINUS
SELECT d
epartment_id
FROM employees
where department_id IS NOT NULL;
)D;

SELECT COUNT(department_id )
FROM departments
WHERE department_id NOT IN (
    SELECT department_id
    FROM employees
    WHERE department_id IS NOT NULL
);



-- 다른 풀이 . LEFT OUTER JOIN , GROUP BY + HAVING // NOT IN 연산자

--NOT EXITS(권장)

SELECT  department_id
FROM departments d
WHERE NOT EXISTS (--상관서브커리 
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);
                 



