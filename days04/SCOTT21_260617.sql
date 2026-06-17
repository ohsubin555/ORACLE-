/*
오라클 연산자
1. 비교연산자: WHERE절 사용, 숫자 날짜 문자 비교
*/

--입사일자를 기준으로 3분기에 입사한 사원들을 조회. 

SELECT e.*  

FROM emp 
WHERE EXTRACT(MONTH FROM hiredate) BETWEEN 7 AND 9; 
-- TO_CHAR (hiredate, 'Q' ) =3; 분기
--TO_CHAR(hiredate,'MM IN (7,8,9); h_month

-- ename C~S 시작 출력


SELECT ename
FROM emp
WHERE ename BETWEEN 'C' AND 'T'
WHERE REGEXP_LIKE(ename, '^[C-S]', 'i');
--ORDER BY ename ASC;

-- 1981 년 6월 1일 이후 입사한 30번 부서원 사원 정보 조회
SELECT *
FROM emp
--WHERE hiredate > DATE '1981-06-01'
--WHERE hiredate >= TO_DATE ('1981-06-01','YYYY.MM.DD') AND deptno = 30 
WHERE hiredate > '1981.06.01'
ORDER BY hiredate ASC;

--2. 논리연산자: AND OR NOT 

--3. SQL 연산자
-- 수도권 아닌 사원정보
SELECT *
FROM insa
WHERE city NOT IN ('경기', '서울', '인천')
ORDER BY city ASC;

--3. SET (집합) 연산자
--합집합 (UNION, UNION ALL) 
--교집합(INTERSECT)
--차집합(MINUS)

SELECT COUNT (*) -- 60명
FROM insa
WHERE city ='인천'; --9


SELECT COUNT (*)
FROM insa
WHERE buseo = '개발부';


SELECT name, ibsadate, buseo,city
FROM insa
WHERE city ='인천' --9
UNION ALL --중복되는 레코드도 합침
--UNION : 중복제거
SELECT name, ibsadate, buseo,city 
FROM insa
WHERE buseo = '개발부';

SELECT name, ibsadate, buseo,city
FROM insa
WHERE city ='인천' --9
INTERSECT
SELECT name, ibsadate, buseo,city 
FROM insa
WHERE buseo = '개발부';


SELECT name, ibsadate, buseo,city
FROM insa
WHERE city ='인천' --9
MINUS
SELECT name, ibsadate, buseo,city 
FROM insa
WHERE buseo = '개발부';




SELECT name ,ibsadate, city , MOD(SUBSTR(ssn,-7,-2),2)gen
FROM insa
UNION
SELECT ename, hiredate, null, null
FROM emp;

--
--ORA-01789: 질의 블록은 부정확한 수의 결과 열을 가지고 있습니다.
--https://docs.oracle.com/error-help/db/ora-01789/01789. 00000 -  "query block has incorrect number of result columns"
--*Cause:    All of the queries participating in a set expression do
--           not contain the same number of SELECT list columns.
--*Action:   Check that all the queries in the set expression have
--           the same number of SELECT list columns.

--계층적 질의 연산자 PRIOR, CONNECT_BY_ROOT
-- 계층적 질의(hierarchical query)
-- STAR WITH 어디서 부터 조직도 시작?

SELECT *
FROM emp;
-- 조인 문제 : deptno ,enname, sal, dname, hiredate
SELECT e.deptno, e.ename, e.sal, d.dname, e.hiredate
FROM emp e
JOIN dept d
ON e.deptno = d.deptno;

--형식】 
--	SELECT 	[LEVEL] {*,컬럼명 [alias],...}
--	FROM	테이블명
--	WHERE	조건
--	START WITH 조건
--	CONNECT BY [PRIOR 컬럼1명  비교연산자  컬럼2명]
--		또는 
--		   [컬럼1명 비교연산자 PRIOR 컬럼2명]
--의사칼럼 : LEVEL
SELECT empno, ename, mgr, LEVEL 
FROM emp

START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr ;

drop table tbl_test;

create table tbl_test(
    deptno number(3) not null primary key,
    dname varchar2(24) not null,
    college number(3),
    loc varchar2(10));
 
-- inser문
--   DEPTNO DNAME                   COLLEGE LOC
------------ -------------------- ---------- ----------
--       101 컴퓨터공학과                100 1호관
--       102 멀티미디어학과              100 2호관
--       201 전자공학과                  200 3호관
--       202 기계공학과                  200 4호관
--       100 정보미디어학부               10
--       200 메카트로닉스학부             10
--        10 공과대학


INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (101, '컴퓨터공학과', 100, '1호관');

INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (102, '멀티미디어학과', 100, '2호관');

INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (201, '전자공학과', 200, '3호관');

INSERT INTO tbl_test (deptno, dname, college, loc)  
VALUES (202, '기계공학과', 200, '4호관');

INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (100, '정보미디어학부', 10, NULL);

INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (200, '메카트로닉스학부', 10, NULL);

INSERT INTO tbl_test (deptno, dname, college, loc)
VALUES (10, '공과대학', NULL, NULL);

COMMIT;

SELECT *
FROM TBL_TEST ;


SELECT deptno,dname,college,LEVEL
    FROM TBL_test
    START WITH deptno=10
    CONNECT BY PRIOR deptno=college;

SELECT LPAD(' ', (LEVEL-1)*2) || dname 조직도
    FROM TBL_test
   -- WHERE dname != '정보미디어학부' -- 정보미디어 제거
    START WITH dname='공과대학'
    CONNECT BY PRIOR deptno=college AND dname != '정보미디어학부';
 
 -------------------------------------------------------------------------------
 
-- 5. 연결 연산자( ¦¦ )
-- 6. 산술 연산자 
SELECT 3+5, 3-5, 3*5 ,3/5
FROM dual;
--DUAL : public 시노님 

SELECT *
FROM USER_TABLES
WHERE table_name like 'EMP';

--OWNER 소유자 SCOTT -> HR EMP테이블 조회할 수 있도록 권한 부여..
--DCL 
GRANT SELECT ON emp TO hr; 
REVOKE 
--
--grant select on emp to public;

------------------------------------------------------------------------

--복잡한 쿼리문을 간단하게 해주고 데이터의 값을 조작하는데 사용되는 것을 함수라함 : function
--ROUND(number or date) 숫자값을 특정 위치에서 반올림하여 리턴한다. 
SELECT 1.67895
,ROUND (1.67895)--2
,ROUND (1.67895,3)--소수점 b+1 자리에서 반올림. 
,12345
,ROUND (12345, -2)-- 소수점 왼쪽에서 반올림. -2 -> 십의자리.
FROM dual;

--TRUNC(number or date) 함수.  절삭+ 지정한 위치
--FLOOR 함수
SELECT 1.67895
, TRUNC (1.67895)
, TRUNC (1.67895,3) -- b+1 위치에서 절삭이 일어남
, TRUNC (1.67895,-2)
, FLOOR (1.67895)-- 무조건 첫째자리
-------------------------------------------------------------------------------

SELECT SYSDATE
 ,TO_CHAR (SYSDATE,'DS TS')
 ,ROUND (SYSDATE)
 ,ROUND (SYSDATE, 'year')
 ,ROUND (SYSDATE, 'day')
FROM dual;



SELECT SYSDATE
,TO_CHAR (SYSDATE,'DS TS')
 ,TRUNC (SYSDATE,'DS TS')
 ,TRUNC (SYSDATE)
 ,TRUNC (SYSDATE, 'year')
 ,TRUNC (SYSDATE, 'day')
FROM dual;

--CEIL 함수는 지정한 숫자보다 크거나 같은 정수 중에서 최소 값을 출력하는 함수이다. 절상. 소수점 1자리
SELECT CEIL (12.345) --13
FROM dual;

--MOD 나머지 함수

--ABS 절대치
SELECT ABS (3) , ABS (-3)-- 3
FROM dual; 

--SIGN () 함수: 숫자가 양수: 1 음수 : -1

SELECT 
SUM (sal+NVL(comm,0)) pay
, avg  (sal+NVL(comm,0)) pay
,ROUND ( avg  (sal+NVL(comm,0)),2)
FROM emp;

SELECT ename,
       pay,
       avg_pay,
       SIGN(pay - avg_pay) AS result
FROM (
    SELECT ename,
           sal + NVL(comm, 0) AS pay,
           AVG(sal + NVL(comm, 0)) OVER () AS avg_pay
    FROM emp
);

--POWER () : 누승

SELECT POWER(2, 2) FROM dual;

-- 문자함수 '' 
-- LOWER UPPER INITCAP-첫문자 대문자  LENGTH-길이 CPMCAT-문자열 연결 
-- SUBSTR - 문자열 자르기 (ename,1,2)  (ename,3) .. 등

-- INSTR --원하는 문자 위치 
SELECT ename,
INSTR (ename , 'N') 
FROM emp


SELECT 'ABCDEABCDEABCDE'
,INSTR ('ABCDEABCDEABCDE' , 'CD')-- 앞에서부터 찾은 첫번째 CD 위치값 반환
,INSTR ('ABCDEABCDEABCDE' , 'CD', 1,2)-- 앞에서 발생하는 2번째 위치값 
,INSTR ('ABCDEABCDEABCDE' , 'CD', -1,1)--뒤에서 찾은 첫번째..
FROM dual;


SELECT NAME, SSN
,SUBSTR(SSN, 1,8) || '*****'
,SUBSTR(SSN, 1,INSTR(SSN, '-')+1) || '*****'
FROM INSA;

SELECT NAME, SSN,
       REGEXP_REPLACE(SSN, '.{5}$', '*****') 
FROM INSA;


SELECT name, ssn
     , SUBSTR( ssn, 1, 8) || '******' rrn
     , SUBSTR( ssn, 1, INSTR(ssn, '-')+1 ) || '******' rrn
     , REGEXP_REPLACE( ssn, '(\d{6}-\d)\d{6}' , '\1' || '******' )
FROM insa;

--LPAD () / RPAD)() 함수 설명

SELECT ename
 ,RPAD (ename,10, '*')
 ,LPAD (ename,10, '*')
FROM emp;

-- ASCII (char) , CHR()
SELECT ename
      ,ASCII( SUBSTR (ename,-1))
      ,CHR(72)
FROM emp;

--나열한 세 숫자 중에 가장 큰 값을 반환하는 함수 GREATEST(1,2,3)
SELECT GREATEST (100,75,120)
FROM dual;
-- 작은 값 LEAST 

-- VSIZE(char) 지정된 문자열의 크기를 반환하는 함수 
SELECT VSIZE ('a') ,VSIZE ('한')
FROM dual;

-- RTRIM() / LTRIM ()/ TRIM()
SELECT '[   ADMIN   ]'
     ,'[' ||  LTRIM('  ADMIN  ' ) || '  ]'
      ,'[' ||  RTRIM('  ADMIN  ' ) || '  ]'
       ,'[' ||  TRIM (' ' FROM '  ADMIN  ' ) || '  ]'
       --TRIM(제거 할 문자열 FROM 대상문자열)
FROM dual;
--
select RTRIM('BROWINGyxXxxyxyxyxyy','xy') "RTRIM example" 
from dual;
--날짜 다루는 함수 : SYSDATE, ROUND(), TRUNC(date)

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual;

--MONTH_BETWEEN 함수: 두 날짜간의 달 차이를 리턴하는 함수
SELECT SYSDATE
, '2026.05.11'
, MONTHS_BETWEEN (SYSDATE, '2026.05.11')
FROM dual;

--예) emp 테이블 에서 모든 사원들의 근무개월 수, 근무 년 수, 근무 일 수 를 조회
SELECT ROUND (MONTHS_BETWEEN (SYSDATE, HIREDATE),2) MONTH
, ROUND (MONTHS_BETWEEN (SYSDATE, HIREDATE)/12,2) YEAR
, ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12 * 365, 2) DAY   
,ROUND(SYSDATE - hiredate ,2) DAY
FROM emp;


SELECT SYSDATE + 10
,SYSDATE -5
,TO_CHAR(SYSDATE +3/24, 'DS TS')
,ADD_MONTHS(SYSDATE ,3)-- 3 개월 후 
,ADD_MONTHS(SYSDATE ,-2) -- 2개월 전 
FROM dual;

--예 ) 이번 달 마지막 날짜가 몇일 인지 조회
SELECT SYSDATE 
,ADD_MONTHS(SYSDATE,1)
,TO_CHAR(TRUNC (ADD_MONTHS(SYSDATE,1),'MONTH')-1,'DD') -- 6월 마지막날

,LAST_DAY(SYSDATE)

FROM dual;

--예 다음주 월요일은 휴강입니다 6/22
SELECT SYSDATE +5
,TO_CHAR(SYSDATE, 'DY')
,NEXT_DAY(SYSDATE,'월')
FROM dual;

--7월 첫번째 목요일날 휴강입니다. 
SELECT SYSDATE
,NEXT_DAY(TRUNC(ADD_MONTHS(SYSDATE,1),'MONTH'),'목')
FROM dual;

SELECT NEXT_DAY(TO_DATE('2026.07' , 'YYYY.MM')-1,'수')
FROM dual;

-- 날짜/시간 함수

SELECT 
   SYSDATE--날짜,시간            DB서버 날짜,시간
   ,CURRENT_DATE--날짜,시간      현재 세션(SESSION) 날짜 시간
   ,CURRENT_TIMESTAMP
FROM dual;
--------------------------------------------------------------
--변환 함수

--1) TO_NUMBER() 문자를 숫자로 변환하는 함수 
SELECT '123' - 123 -- 자동으로 변환
  ,'100.98' -50 
FROM dual

--2) TO_CHAR(날짜): 날짜로부터 내가 원하는 형식의 정보를 문자로 변환할때 
--  TO_CHAR (숫자)
-- 예 

SELECT num, name
     ,TO_CHAR(basicpay, '99,999,999')
     ,TO_CHAR(sudang, '999,999')
     ,TO_CHAR(basicpay + sudang, 'L99G999G999') pay
FROM insa;

SELECT TO_CHAR( 100, 'S9999')  AS S_POS,
       TO_CHAR(-100, 'S9999')  AS S_NEG,
       TO_CHAR( 100, '9999S')  AS TRAIL_S_POS,
       TO_CHAR(-100, '9999S')  AS TRAIL_S_NEG,
       TO_CHAR( 100, '9999MI') AS MI_POS,
       TO_CHAR(-100, '9999MI') AS MI_NEG,
       TO_CHAR( 100, '9999PR') AS PR_POS,
       TO_CHAR(-100, '9999PR') AS PR_NEG
FROM dual;

--소수점 2자리까지 연봉 출력

SELECT ename,
       TO_CHAR((sal + NVL(comm, 0)) * 12,
               'L9,999,999.00') 
FROM emp;

-- '1998년 10월 11일 일요일' 형식으로 출력. 날짜-> 문자 변환: TO_CHAR


SELECT ename, hiredate
       , TO_CHAR(hiredate, 'YYYY"년" MM"월" DD "일" DAY')
FROM emp;


-----------------------------------------------------------------------------

--일반함수
SELECT NVL(COMM,0)
,COALESCE(comm,0) -- 나열해 놓은 값을 순차적으로 체크하여  NULL 아닌 값을 리턴하는 함수
FROM emp

SELECT 
FROM dual;

-------------------------------------------------------------------------------
--그룹함수 : COUNT() - null 값을 제외한 집계를 함. 

SELECT COUNT(comm)
 ,COUNT(*)-- NULL 유무와 상관 없이 카운팅
 , SUM(SAL)
 ,SUM(COMM)
 ,AVG(SAL)
 ,AVG(COMM)
 ,SUM(COMM)/COUNT(*)
 ,MAX(COMM),MAX(SAL)
 ,MIN(COMM),MIN(SAL)
FROM emp;

--예 emp에서 pay를 최대 최소 조회


SELECT
MAX(sal+ NVL(comm, 0))
,MIN(sal+ NVL(comm, 0))
FROM emp;

-- PAY를 가장 많이 받는 사원 이름, 번호, pay 출력

SELECT empno, ename,
       sal + NVL(comm, 0)  pay
FROM emp
WHERE sal + NVL(comm, 0) = (
    SELECT MAX(sal + NVL(comm, 0))
    FROM emp
);

--예 max_ppay, min_pay 사원정보

SELECT empno, ename,
       sal + NVL(comm, 0)  pay
FROM emp
WHERE sal + NVL(comm, 0) = (
    SELECT MAX(sal + NVL(comm, 0))
    FROM emp
)
UNION---병합
SELECT empno, ename,
       sal + NVL(comm, 0)  pay
FROM emp
WHERE sal + NVL(comm, 0) = (
    SELECT MIN(sal + NVL(comm, 0))
    FROM emp
);

SELECT *
FROM emp
WHERE sal + NVL(comm, 0) >=ALL ( SELECT (sal + NVL(comm, 0)) FROM emp);

SELECT *
FROM emp
WHERE sal + NVL(comm, 0) = (
    SELECT MIN(sal + NVL(comm, 0)) FROM emp
)
OR sal + NVL(comm, 0) = (
    SELECT MAX(sal + NVL(comm, 0)) FROM emp
);

SELECT *
FROM emp
WHERE sal + NVL(comm, 0) IN (
    (SELECT MIN(sal + NVL(comm, 0)) FROM emp),
    (SELECT MAX(sal + NVL(comm, 0)) FROM emp)
);


-- 예)
SELECT *
FROM emp
WHERE sal + NVL(comm, 0 ) IN ( (SELECT MAX( sal + NVL(comm, 0 ) ) FROM emp), (SELECT MIN( sal + NVL(comm, 0 ) ) FROM emp) );

WHERE sal + NVL(comm, 0 ) IN (  SELECT MAX( sal + NVL(comm, 0 ) ),MIN( sal + NVL(comm, 0 ) )  FROM emp );--이거 안됨
WHERE sal + NVL(comm, 0 ) IN ( 5000, 800 );
