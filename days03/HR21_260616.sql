-- hr_main.sql 스크립트 파일 @ cmd 실행: 샘플 테이블 생성 확인.
SELECT *
FROM tabs;
--
--REGIONS
DESC regions;
컬럼	설명
REGION_ID	지역 번호 (PK)
REGION_NAME	지역 이름

SELECT * FROM regions;
--COUNTRIES
DESC COUNTRIES;
| 컬럼           | 설명         |
| ------------ | ---------- |
| COUNTRY_ID   | 국가 코드 (PK) |
| COUNTRY_NAME | 국가 이름      |
| REGION_ID    | 지역 FK      |
SELECT * FROM countries;
--LOCATIONS

DESC LOCATIONS;

컬럼	설명
LOCATION_ID	위치 ID (PK)
CITY	도시
COUNTRY_ID	국가 FK

SELECT * FROM LOCATIONS;

--DEPARTMENTS

DESC DEPARTMENTS;

| 컬럼              | 설명                 |
| --------------- | ------------------ |
| DEPARTMENT_ID   | 부서 ID (PK)         |
| DEPARTMENT_NAME | 부서명                |
| MANAGER_ID      | 부서장 (EMPLOYEES FK) |
| LOCATION_ID     | 위치 FK              |

SELECT * FROM DEPARTMENTS;

--JOBS

DESC JOBS;

| 컬럼         | 설명         |
| ---------- | ---------- |
| JOB_ID     | 직무 코드 (PK) |
| JOB_TITLE  | 직무명        |
| MIN_SALARY | 최소 급여      |
| MAX_SALARY | 최대 급여      |

SELECT * FROM JOBS;

--EMPLOYEES

DESC EMPLOYEES;

| 컬럼            | 설명         |
| ------------- | ---------- |
| EMPLOYEE_ID   | 직원 ID (PK) |
| FIRST_NAME    | 이름         |
| LAST_NAME     | 성          |
| EMAIL         | 이메일        |
| PHONE         | 전화         |
| HIRE_DATE     | 입사일        |
| JOB_ID        | 직무 FK      |
| SALARY        | 급여         |
| MANAGER_ID    | 상사         |
| DEPARTMENT_ID | 부서 FK      |

SELECT * FROM EMPLOYEES;

--JOB_HISTORY

DESC JOB_HISTORY;
| 컬럼            | 설명    |
| ------------- | ----- |
| EMPLOYEE_ID   | 직원 FK |
| START_DATE    | 시작일   |
| END_DATE      | 종료일   |
| JOB_ID        | 직무 FK |
| DEPARTMENT_ID | 부서 FK |

SELECT * FROM JOB_HISTORY;

SELECT department_id
FROM departments;

SELECT DISTINCT department_id
FROM employees;

SELECT COUNT(employee_id)
FROM employees;

--각 사원의 월급, 연봉을 출력하세요. 
SELECT employee_id,
       first_name || ' ' || last_name name ,
      CONCAT( CONCAT( first_name , ' ') ,  last_name ) FULL_NAME,
       NVL(commission_pct, 0) ,
       salary + salary * NVL(commission_pct, 0) ,
       12 * (salary + salary * NVL(commission_pct, 0)) 
FROM employees;

SELECT last_name || '님의 급여는 ' || salary || '입니다.' result
FROM employees;

-- NULL  처리 함수 : NVL(컬럼,0) , NVL2(컬럼,??,??)
SELECT employee_id, first_name ,NVL2( manager_id ,'Y','N') MGR_YN
      , NVL2( department_id ,'O','X') DEPT_OX

FROM employees;
