

--EX EMP TABLE-  SAL  TOP 5 

-- RANK 분석 함수
-- TOP N 방식
--1) FROM 서브쿼리 정렬

SELECT 
FROM EMP
ORDER BY SAL DESC;

--WEHRE ROWNUM

SELECT E.*, ROWNUM SEQ
FROM (
SELECT *
FROM EMP
ORDER BY SAL DESC
) E
WHERE ROWNUM <= 5; --중간에서부터는 못가져옴

-- TOP - N 
-- EMP 사원 수 가 가장 많은 부서번호, 사원 수 조회
-- TOP-N방식 오라클 11이하

SELECT E.*, ROWNUM SE1
FROM(
SELECT B.DEPTNO ,DNAME
, COUNT(*) EMP_C
FROM EMP A JOIN DEPT B ON A.DEPTNO = B.DEPTNO 
GROUP BY B.DEPTNO, DNAME
ORDER BY EMP_C DESC
) E
WHERE ROWNUM= 1;

--REPLACE TO RANK F

SELECT E.*
FROM(
SELECT DEPTNO 
, COUNT(*) EMP_C
,RANK() OVER (ORDER BY COUNT(*) DESC)
,DENSE_RANK() OVER (ORDER BY COUNT(*) DESC)
,ROW_NUMBER () OVER (ORDER BY COUNT(*) DESC)
FROM EMP E
GROUP BY DEPTNO
ORDER BY EMP_C DESC
) E
--WHERE RANK BETWEEN 2 AND 4 가능
-- FETCH 절: 오라클 12C 
--  ㄴ 정렬된 결과 집합에서 원하는 갯수의 행만 가져오는 절. 



SELECT DEPTNO
   ,COUNT(*) EMP_CNT
FROM EMP 
GROUP BY DEPTNO
ORDER BY EMP_CNT DESC
FETCH FIRST 2 ROW WITH TIES; --2등여러명
FETCH FIRST 2 ROW ONLY;-- 1등 한 명
FETCH FIRST 1 ROW ONLY;

SELECT *
FROM EMP
ORDER BY SAL DESC
FETCH FIRST 2 ROW WITH TIES; --2등여러명
FETCH FIRST 2 ROW ONLY;-- 1등 한 명
FETCH FIRST 1 ROW ONLY;

-- FETCH WITH OFFSET TO GET DATA 5-10TH
SELECT *
FROM EMP
ORDER BY SAL DESC
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY;

--WAY 4 ) KEEP F
SELECT 
MAX(E.DEPTNO)
KEEP (DENSE_RANK FIRST ORDER BY E.EC DESC) MAX_DEPTNO
 ,MAX(E.EC) MEC
FROM(
SELECT DEPTNO
    , COUNT (*) EC
FROM EMP
GROUP BY DEPTNO
) E;

--각 부서별 최고액, 최저액 사원 정보 조회


SELECT DEPTNO,
MAX(ENAME)
KEEP (DENSE_RANK FIRST ORDER BY SAL DESC) MAX_DEPTNO
 ,MAX(SAL) MAX_SAL
 ,MIN(ENAME)
KEEP (DENSE_RANK FIRST ORDER BY SAL ASC) MIN_DEPTNO
 ,MIN(SAL) MIN_SAL
FROM EMP;

--1) 가장 많이 사용됨. 권장

SELECT DEPTNO, ENAME, SAL
FROM(
SELECT DEPTNO, ENAME, SAL
      ,ROW_NUMBER() OVER (PARTITION BY DEPTNO ORDER BY SAL DESC) SDR
       ,ROW_NUMBER() OVER (PARTITION BY DEPTNO ORDER BY SAL ASC) SAR
FROM EMP
)
WHERE SDR =1 OR SAR =1;

--2) 


SELECT DEPTNO,
MAX(ENAME)
KEEP (DENSE_RANK FIRST ORDER BY SAL DESC) MAX_DEPTNO
 ,MAX(SAL) MAX_SAL
 ,MIN(ENAME)
 KEEP (DENSE_RANK FIRST ORDER BY SAL ASC) MIN_DEPTNO
 ,MIN(SAL) MIN_SAL
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO;

--3)

SELECT E.*
FROM emp E  JOIN (
SELECT DEPTNO
,MAX(SAL) MA
,MIN(SAL) MI
FROM EMP 
GROUP BY DEPTNO
) T
--ON NVL(T.DEPTNO,-1) = NVL(E.DEPTNO,-1) -- NULL = NULL X
ON T.DEPTNO = E.DEPTNO OR ( T.DEPTNO IS NULL AND E.DEPTNO IS NULL)
WHERE E.SAL = T.MA OR E.SAL = T.MI AND E.DEPTNO = T.DEPTNO
ORDER BY E.DEPTNO, E.SAL DESC;


-- 예) EMP TABLE 에서 SAL 컬럼을 기준으로 3등급(상/중/하)


SELECT *
FROM
(SELECT ENAME
 ,RANK () OVER (ORDER BY SAL DESC) RANKING
 ,RANKING / 3
 , FETCH FIRST 1 ROW ONLY 상
 , FETCH FIRST 2 ROW ONLY 중
  FETCH FIRST 3 ROW ONLY 하;

FROM EMP
)



SELECT ENAME, SAL, 
DENSE_RANK() OVER (ORDER BY SAL DESC) AS RANKING
,CASE WHEN RANKING > 3 THEN '상'
     WHEN RANKING > 6 THEN '중'
     ELSE '하'
     END
FROM EMP;


--1) 
SELECT ENAME, SAL
   ,CASE WHEN SAL >= 3000 THEN '상'
   WHEN SAL >= 1500 THEN '중'
   ELSE '하'
   END GRADE
FROM EMP
ORDER BY GRADE;

--2) 
SELECT ENAME, SAL, S.GRADE
FROM EMP E JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL

--3) NTILE 함수 , 정렬된 데이터를 N개 그룹으로 균등하게 나누는 분석함수
-- 번호 1/2/3 NTILE (3) OVER (ORDER BY 컬럼)
--최대한 균등하게 분배한다


SELECT ENAME, SAL,GRADE
   ,DECODE ( GRADE, 1, '상', 2, '중', 3, '하')
FROM (
SELECT ENAME, SAL
, NTILE(3) OVER (ORDER BY SAL DESC) GRADE
   
   FROM EMP) ;
   
   
--4) PERCENT_RANK

SELECT ENAME,SAL, TRUNC (PR,4)
,CASE WHEN PR <0.33 THEN '상' 
WHEN PR BETWEEN 0.33 AND 0.66 THEN '중'
ELSE '하'
END GRADE
FROM (
SELECT ENAME, SAL
  , PERCENT_RANK() OVER (ORDER BY SAL DESC) PR
  FROM EMP
) T;

-- EX) 인사테이블에서 오늘을 기준으로 생일이 지났다 오늘이 생일이다 생일이 지나지 않았다 출력 6/19 1001 1002 번 사원 생일 월 , 일 을 6/19 로 업데이트

UPDATE 
SET DATE = 0619

--6/19 1001 1002 번 사원 생일 월 , 일 을 6/19 로 업데이트

UPDATE INSA
SET 'MMDD'= '0619'
WHERE NUM IN (1001,1002)

--1)
UPDATE insa
SET ssn = SUBSTR(ssn, 1, 2) || TO_CHAR(SYSDATE, 'MMDD') || SUBSTR(ssn, 7)
WHERE num IN (1001,1002);
COMMIT;

SET ssn = REGEXP_REPLACE( ssn, '^(\d{2})(\d{4})(-\d{7})$', '\1' || TO_CHAR( SYSDATE, 'MMDD') || '\3')


COMMIT;

SELECT SYSDATE
 ,TO_CHAR(SYSDATE, 'MMDD')
FROM DUAL;


SELECT *
FROM INSA 
WHERE NUM IN (1001,1002)

SELECT NAME,SSN
, SUBSTR (SSN,3,4) 
   ,CASE WHEN BD > SYSDATE THEN '생일이 지났다.'
         WHEN BD = SYSDATE THEN '오늘이 생일이다.'
         WHEN BD < SYSDATE THEN '생일이 지나지 않았다.'
FROM INSA;

--1)
SELECT NAME,SSN
  ,TO_CHAR(SYSDATE, 'MMDD')
  ,SUBSTR (SSN,3,4)
  ,SIGN(TO_CHAR(SYSDATE, 'MMDD')-SUBSTR (SSN,3,4) )
  , DECODE ( SIGN(TO_CHAR(SYSDATE, 'MMDD')-SUBSTR (SSN,3,4) ),0,'오늘' , -1 ,'지나지 않음' , 1 , '지남') BDSTATUS
FROM INSA;


--ON INSA TABLE, USING SSN 만나이 출력
--올해 연도 가져오기 2026 년도  , 생일 년도 2027 
-- 만나이 생일년도 - 올해년도  생일이 지나지 않으면 -1 
-- 성별 1/2/5/6 1900년대생
--      3/4/7/8/ 2000년대생
--          9/0 1800년대생

SELECT NAME,SSN,SYSDATE
,TO_CHAR(SYSDATE, 'YYYY')
,CASE WHEN SUBSTR(SSN,-7,1) IN('1','2','5','6') THEN SUBSTR (SSN,1,2)+1900
 WHEN SUBSTR(SSN,-7,1) IN('3','4','7','8') THEN SUBSTR (SSN,1,2)+2000
 ELSE SUBSTR(SSN,1,2)+1800
 END BORNYEAR,
 TO_CHAR(SYSDATE, 'YYYY')-
 
FROM INSA;

--1)

-- 풀이 1)
SELECT name, ssn, current_year, birth_year
    ,  current_year - birth_year + birthday_status age
FROM  (
    SELECT i.*
         , TO_CHAR( SYSDATE, 'YYYY' ) current_year
    --     , SUBSTR( ssn, -7, 1) gender
         ,  CASE
               WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6 ) THEN 1900
               WHEN REGEXP_LIKE( SUBSTR( ssn, -7, 1), '[3478]' ) THEN 2000
               ELSE 1800
            END +  SUBSTR( ssn, 1, 2 ) birth_year
        , DECODE( SIGN(  TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( ssn, 3, 4 ) ),  -1, -1,  0 ) birthday_status   
    FROM insa i
);


--2) 실무+ 오라클 : 만나이
-- 주민등록번호 -> 생일 날짜 생성
SELECT name, ssn
     ,  FLOOR(  MONTHS_BETWEEN(SYSDATE, birthday)/12 ) 만나이
FROM ( 
    SELECT 
          insa.* 
         , TO_DATE(  -- '19770619'
               CASE
                       WHEN SUBSTR( ssn, -7, 1) IN ( 1,2,5,6 ) THEN 19
                       WHEN REGEXP_LIKE( SUBSTR( ssn, -7, 1), '[3478]' ) THEN 20
                       ELSE 18
               END || SUBSTR( ssn, 1, 6 )
           ) birthday
    FROM insa
) t;

-- EX) ON INSA TABLE SELECT RAMDOMLY 5 EMP

SELECT *
FROM(
SELECT I.*
  , DBMS_RANDOM.VALUE RV
FROM INSA I
ORDER BY RV
)
WHERE ROWNUM <=5;

--- DBMS_RANDOM.VALUE
-- 0.0<= 실수 DBMS_RANDOM.VALUE < 1.0
-- 0.0<= 실수 DBMS_RANDOM.VALUE (1,46) < 46.0
SELECT DBMS_RANDOM.VALUE
     ,FLOOR(DBMS_RANDOM.VALUE(1,46))
FROM DUAL;

--
SELECT *
FROM(
SELECT *
FROM EMP
ORDER BY  DBMS_RANDOM.VALUE
)
WHERE ROWNUM < 5;

--

SELECT DBMS_RANDOM.STRING('X', 10)  -- 대문자 + 숫자
     , DBMS_RANDOM.STRING('U', 10)  -- 대문자
     , DBMS_RANDOM.STRING('L', 10)  -- 소문자 
     , DBMS_RANDOM.STRING('P', 10)  -- 대문자 + 소문자 + 숫자 + 특수문자
     , DBMS_RANDOM.STRING('A', 10)  -- 알파벳(대+소문자)
FROM dual;

--- LISTAGG //여러 행(ROW)의 값을 하나의 문자열로 집계하는 함수 
-- LISTAGG (컬럼명 , 구분자) WITHIN GROUP (ORDER BY 컬럼명)

--1) 모든 사원 이름 출력
SELECT ENAME FROM EMP;

SELECT LISTAGG(ENAME, ', ') WITHIN GROUP (ORDER BY SAL DESC) 
FROM EMP;

--2) 부서별로 사원명 출력 

SELECT D.DEPTNO,
       COUNT(E.ENAME) AS CNT,
       NVL(
           LISTAGG(E.ENAME, ', ')
               WITHIN GROUP (ORDER BY E.SAL DESC),
           'EMPTY'
       ) AS EMP_LIST
FROM EMP E
FULL OUTER JOIN DEPT D
    ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO
ORDER BY D.DEPTNO;

--2-2
SELECT DISTINCT DEPTNO, LISTAGG(ENAME, ', ')
               WITHIN GROUP (ORDER BY SAL DESC)
               OVER (PARTITION BY DEPTNO) EMPLIST
               FROM EMP;

SELECT LIS
-- 부서별 직무 목록 출력



SELECT  D.DEPTNO
  , LISTAGG(E.JOB, ', ')
               WITHIN GROUP (ORDER BY E.JOB ASC) 
               FROM EMP E 
               FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO
               GROUP BY D.DEPTNO
               ORDER BY D.DEPTNO;


-- 관리자 별 부하 직원 목록 + 관리자명

SELECT MGR , LISTAGG(ENAME, ', ')
               WITHIN GROUP (ORDER BY ENAME ASC) 
FROM EMP 
JOIN 
WHERE MGR IS NOT NULL
GROUP BY MGR;

--SELF JOIN

SELECT A.EMPNO , A.ENAME, A.MGR, B.ENAME
, LISTAGG(A.ENAME, ', ')
  WITHIN GROUP (ORDER BY A.ENAME ASC)
  , LISTAGG(B.ENAME, ', ')
  WITHIN GROUP (ORDER BY B.ENAME ASC)
FROM EMP A JOIN EMP B ON A.MGR = B.MGR
WHERE MGR IS NOT NULL
GROUP BY A.MGR, B.MGR;

--
SELECT a.mgr
    , b.ename
    ,LISTAGG(a.ename,', ') WITHIN GROUP (ORDER BY a.ename) "emp_list" 
FROM  emp a JOIN emp b ON a.mgr = b.empno
WHERE a.mgr IS NOT NULL
GROUP BY a.mgr, b.ename

--
SELECT A.MGR, B.ENAME, A.EL
FROM (
SELECT MGR , LISTAGG(ENAME, ', ')
               WITHIN GROUP (ORDER BY ENAME ASC) EL
FROM EMP 
JOIN 
WHERE MGR IS NOT NULL
GROUP BY MGR) A JOIN EMP B ON A.MGR = B.EMPNO;

-- 입사 년도 별 사원 목록

SELECT TO_CHAR(HIREDATE, 'YYYY') ,COUNT(*)
,LISTAGG(ENAME,', ') WITHIN GROUP (ORDER BY ename) "emp_list" 
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY')
ORDER BY 1;

-- 급여 등급별로 사원목록

   
   SELECT T.GRADE, LISTAGG(ENAME,', ') WITHIN GROUP (ORDER BY ENAME) "emp_list" 
   FROM(
   SELECT E.*, GRADE
   
--ENAME, SAL, LOWSAL ||  '~' ||HISAL 
FROM EMP E JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL )T
GROUP BY GRADE
ORDER BY GRADE;


-- 문제) 사원수가 가장 많은 부서 및 가장 적은 부서 정보 출력

    DEPTNO DNAME                 CNT   CNT_RANK
---------- -------------- ---------- ----------
        30 SALES                   6          1
        40 OPERATIONS              0          4

WITH A AS(
    SELECT D.DEPTNO,
           D.DNAME,
           COUNT(EMPNO) CNT,
           RANK() OVER (ORDER BY COUNT(*) DESC) CNT_RANK
    FROM DEPT D
    LEFT JOIN EMP E
    ON D.DEPTNO = E.DEPTNO
    GROUP BY D.DEPTNO, D.DNAME
), B AS( 
SELECT MAX(CNT) MAXCNT , MIN (CNT) MINCNT
FROM A 
)
SELECT A.*
FROM A JOIN B ON A.CNT IN (B.MAXCNT , B.MINCNT);


-- 피봇 (PIVOT) / 언피봇 (UNPIVOT) 설명~
--피봇: 행 데이터를 열로 회전시켜 보여주는 기능    
--1단계 ) 대상 쿼리, 원본 쿼리

SELECT JOB
FROM EMP;
--CLERK
--SALESMAN
--SALESMAN
--MANAGER
--SALESMAN
--MANAGER
--MANAGER
--ANALYST
--PRESIDENT
--SALESMAN
--CLERK
--CLERK
--ANALYST
--CLERK


--SELECT *
--FROM (
--   --1)  원본쿼리(대상퀄) : 결과가 행으로 출력되는 대상쿼리
--)
--PIVOT (
--    집계함수 COUNT (* ,JOB)
--    FOR 회전할컬럼
--    IN (값1, 값2, 값3 ...직무 리스트)
--);



SELECT *
FROM (
    SELECT  D.deptno, DNAME,job
    FROM EMP E FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO
)
PIVOT(
  COUNT(*)
  FOR job
  IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
)
ORDER BY deptno;



-- UNPIVOT 예제
A)
   'CLERK' 'SALESMAN' 'PRESIDENT'  'MANAGER'  'ANALYST'
---------- ---------- ----------- ---------- ----------
         4          4           1          3          2
B)
JOB          EMP_CNT
--------- ----------
CLERK              4
SALESMAN           4
PRESIDENT          1
MANAGER            3
ANALYST            2
;

SELECT *
FROM (
    SELECT *
    FROM (
        SELECT job
        FROM emp
    )
    PIVOT (
        COUNT(*)
        FOR job IN (
            'CLERK'     AS CLERK,
            'SALESMAN'  AS SALESMAN,
            'PRESIDENT' AS PRESIDENT,
            'MANAGER'   AS MANAGER,
            'ANALYST'   AS ANALYST
        )
    )
) t
UNPIVOT (
    emp_cnt --수량
    FOR job IN (
        CLERK,
        SALESMAN,
        PRESIDENT,
        MANAGER,
        ANALYST
    )
);

--UNPIVOT 구문 

UNPIVOT (
    값컬럼명
    FOR 구분컬럼명
    IN (
        컬럼1,
        컬럼2,
        컬럼3
    )
)


SELECT *
FROM (
    SELECT  D.deptno, DNAME,job
    FROM EMP E FULL JOIN DEPT D ON E.DEPTNO = D.DEPTNO
)
PIVOT(
  COUNT(*)
  FOR job
  IN('CLERK','SALESMAN','PRESIDENT','MANAGER','ANALYST')
)
ORDER BY deptno;

-- EX) PIVOT 
-- EMP 에서 각 월별 입사한 사원 수 조회
-- 1단계) 피봇 대상 쿼리
SELECT TO_CHAR (HIREDATE, 'YYYY') YEAR
      , TO_CHAR (HIREDATE, 'MM') MONTH 
 FROM EMP; 
--2) PIVOT 

SELECT *
FROM( 
SELECT
 TO_CHAR (HIREDATE, 'YYYY') YEAR
SELECT TO_CHAR (HIREDATE, 'MM') MONTH 
FROM EMP
)
PIVOT(
COUNT(*)
FOR MONTH
IN('01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12') )
)

--
SELECT *
FROM (
    SELECT 
        TO_CHAR(HIREDATE, 'YYYY') AS YEAR,
        TO_CHAR(HIREDATE, 'MM') AS MONTH
    FROM EMP
)
PIVOT (
    COUNT(*)
    FOR MONTH IN (
       '01' AS "1월",'02','03','04','05','06','07','08','09','10','11','12') )
ORDER BY YEAR;

-- PIVOT EX

--1) DECODE 집계
WITH T AS(SELECT SSN , TO_CHAR(SYSDATE, 'MMDD') CM
  ,SUBSTR (SSN,3,4) BM
  ,SIGN( TO_CHAR(SYSDATE, 'MMDD')-SUBSTR (SSN,3,4)) BS
FROM INSA)
SELECT
COUNT (DECODE (BS,0,'I')) 오늘생일
,COUNT (DECODE (BS,1,'I')) 생일지남
,COUNT (DECODE (BS,-1,'I')) 안지남
FROM T;
--

SELECT *
FROM  (
         SELECT SIGN(TO_CHAR(SYSDATE, 'MMDD') - SUBSTR(SSN, 3, 4)) AS BS
          FROM INSA
)
PIVOT (
    COUNT(*)
    FOR BS IN (
     0 AS "오늘생일",1 AS "지남",-1 AS "안지남"
    )
);

-------------
---- [ 피봇의 실무 사용  ]
--1. 월별 매출 보고서
--2. 부서별 직급 인원 현황
--3. 설문조사 결과 집계
--4. 병원 진료 통계
----> DBMS 호환성과 유지보수 때문에 X.


SELECT *
FROM (
SELECT DEPTNO,SAL+NVL(COMM,0) PAY
FROM EMP
)
PIVOT(
SUM(PAY)
,MAX(PAY) AS 최고액
,MIN(PAY) AS 최저액
FOR DEPTNO
IN(10,20,30,40,NULL)
);

-- WIDTH_BUCKET(expression, min_value, max_value, num_buckets)
-- 숫자값을 지정된 범위 (MIN_VALUE ~ MAX) 를 균등한 구간을 나누어서 해당하는 숫자값이 어떤 구간 (버킷) 에 해당하는지 반환하는 함수 


SELECT ENAME, SAL
, WIDTH_BUCKET(SAL,0,5000,5) WB
,COUNT(*)
FROM EMP;
GROUP BY WIDTH_BUCKET(SAL,0,5000,5);

--실무 활용 사례 1. 고객 구매금액 등급
-- 실무 활용 사례 2. 연령대 분석
-- 실무 활용 사례 3. 시험 점수 분포
-- 실무 활용 사례 4. 급여 구간 분석


-- NTILE (N) OVER (ORDER BY SAL) 레코드 행 수를 균등하게 분배해서 구간을 나눔

--SET 연산자 SQL 연산자 ( ANY SOME HOW EXISTS) 
-- EMP TABLE, 사원 존재 안하는 부서번호 부서명


WITH t AS (
    SELECT deptno
    FROM dept
    MINUS
    SELECT DISTINCT deptno
    FROM emp 
)
SELECT t.deptno, d.dname
FROM t JOIN dept d ON t.deptno = d.deptno;
-- EXISTS 연산자..
SELECT deptno
FROM dept m
WHERE  NOT EXISTS  (  SELECT empno FROM emp WHERE deptno = m.deptno  );
-- 
SELECT d.deptno, COUNT(empno)
FROM emp e RIGHT JOIN dept d ON e.deptno = d.deptno
GROUP BY d.deptno
HAVING COUNT(empno) = 0;


-- ■ [문제] 
-- DDL 문 : CREATE 
CREATE TABLE tbl_pivot
(
--    컬럼명 자료형(크기)       제약조건...
     no    NUMBER            PRIMARY KEY -- 고유한키(PK) 제약조건 = UK + NN
   , name  VARCHAR2(20 BYTE) NOT NULL    -- NN 제약조건(== 필수입력사항)
   , jumsu NUMBER(3)         -- NULL 허용
); 
-- Table TBL_PIVOT이(가) 생성되었습니다.
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 1, '박예린', 90 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 2, '박예린', 89 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 3, '박예린', 99 );  -- mat
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 4, '안시은', 56 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 5, '안시은', 45 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 6, '안시은', 12 );  -- mat 
 
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 7, '김민', 99 );  -- kor
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 8, '김민', 85 );  -- eng
INSERT INTO TBL_PIVOT ( no, name, jumsu ) VALUES ( 9, '김민', 100 );  -- mat 

COMMIT; 
---
SELECT * 
FROM tbl_pivot;
--( 피봇되어져서 결과 출력)
--번호 이름 국 영 수
--1 박예린 90 89 99
--2 안시은 56 45 12
--3 김민   99 85 100

