--예 emp 에서 comm 400 미만 사원정보 조회 comm null 인사람도

SELECT *
FROM emp
WHERE comm < 400 OR comm IS NULL;
-- LNNVL () : Logically Negated NVL 함수
--  조건이     NULL 인 경우에 TRUE 반환
-- 조건이     false 인 경우에도 true 반환


SELECT *
FROM emp
WHERE LNNVL ( COMM >=400);

--SELCT 문
/*
WITH
  SELECT
FROM
WHERE
GROUP BY 
HAVING
ORDER BY
*/

-- 각 부서별 사원수 조회
SELECT 10 AS deptno, COUNT(*) AS cnt
FROM emp
WHERE deptno = 10

UNION ALL

SELECT 20, COUNT(*)
FROM emp
WHERE deptno = 20

UNION ALL

SELECT 30, COUNT(*)
FROM emp
WHERE deptno = 30

UNION ALL

SELECT 40, COUNT(*)
FROM emp
WHERE deptno = 40;
--
SELECT DISTINCT deptno,
( SELECT  COUNT(*)
FROM emp
WHERE deptno = e.deptno ) 사원수
FROM emp e

UNION ALL
SELECT NULL, COUNT(*)
FROM emp
ORDER BY deptno ASC;  -- 마지막에 와야함!

--GROUP BY 절
SELECT deptno, COUNT(*) ,SUM (sal+ NVL(comm, 0)),ROUND(AVG(sal+ NVL(comm, 0)),2)
FROM emp
GROUP BY deptno 
ORDER BY deptno ASC;
-- 직속상사 없는 사원번호  NULL로 수정
SELECT *
FROM EMP
WHERE MGR IS NULL;

UPDATE EMP 
SET DEPTNO = NULL
WHERE EMPNO = 7839;
WHERE ENAME ='KING';

COMMIT;




--사원이 존재 하지 않는 부서도 출력

--SELECT E.*,D.*
SELECT D.DEPTNO, COUNT(*)
FROM emp E RIGHT OUTER JOIN DEPT D ON D.DEPTNO = E.DEPTNO
GROUP BY D.DEPTNO;

SELECT *
FROM insa;
--------------------------
-- ex) 인사테이블에서 각 부서별 사원 수 조회
SELECT T.*
FROM (
    SELECT buseo, COUNT(*) AS CNT
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1
    GROUP BY buseo
) T
WHERE T.CNT >= 5
ORDER BY T.CNT DESC;

--
   SELECT buseo, COUNT(*)  CNT
    FROM insa
    WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 1
    GROUP BY buseo
    HAVING COUNT(*) >=5
    ORDER BY CNT DESC;
    
    
    SELECT  name, buseo, basicpay+sudang
    FROM insa i
    WHERE basicpay + sudang = 
    (
     SELECT MAX (basicpay + sudang)
     FROM insa
     WHERE buseo = i.buseo
    )
    union
     SELECT  name, buseo, basicpay+sudang
    FROM insa i
    WHERE basicpay + sudang = 
    (
     SELECT MAX (basicpay + sudang)
     FROM insa
     WHERE buseo is null)
     ORDER BY  buseo, NAME;
 
 
 SELECT  name, buseo, basicpay+sudang
    FROM insa i
    WHERE basicpay + sudang 
    >=ALL(
     SELECT MAX (basicpay + sudang)
     FROM insa
     WHERE buseo = i.buseo)
    ORDER BY  BUSEO;
    
    --GROUP BY, IN 연산자
    
    SELECT *
    FROM emp E
    WHERE( E.DEPTNO,sal+ NVL(comm, 0) ) IN(
     SELECT DEPTNO, MAX(sal+ NVL(comm, 0)) 
       FROM EMP
       GROUP BY DEPTNO
    );

--급여순 등수 RANK() 함수
SELECT *
FROM(
SELECT E.* 
  ,RANK () OVER (ORDER BY (sal+ NVL(comm, 0)) DESC) PAY_RANK 
 FROM emp E
) T
WHERE T.PAY_RANK BETWEEN 5 AND 10


SELECT T.*
FROM (
    SELECT E.*, 
           RANK() OVER (
               PARTITION BY deptno
               ORDER BY (sal + NVL(comm, 0)) DESC
           ) AS pay_rank
    FROM emp E
) T
WHERE T.pay_rank <= 2;
 
 
 --DECODE()
 
 IF (A=B){
 C
 }
 => DECODE (A,B,C)
 
 
 IF (A=B){
 C
 }ELSE{
 D
 }
 => DECODE (A,B,C,D)
 
 
 IF (A=B){
 ㄱ
 }ELSE IF(A=C){
 ㄴ
}ELSE IF(A=D){
 ㄷ
}ELSE {
 ㄹ
}
 => DECODE (A,B,ㄱ,C,ㄴ,D,ㄷ,ㄹ)
 
 
 SELECT
 COUNT(DECODE (DEPTNO,10,'O'))
 ,COUNT(DECODE (DEPTNO,20,'1000'))
 ,COUNT(DECODE (DEPTNO,30,'1'))
 ,COUNT(DECODE (DEPTNO,40,'F'))
-- ,COUNT(DECODE (DEPTNO,NULL,'7')) 비교연산자 = 만 사용가능
FROM emp;
 
 SELECT name,
       ssn,

       -- DECODE 방식 1
       DECODE(MOD(SUBSTR(ssn, -7, 1), 2),
              1, '남자',
              0, '여자') AS gender_decode1,

       -- DECODE 방식 2 (축약형)
       DECODE(MOD(SUBSTR(ssn, -7, 1), 2),
              1, '남자',
              '여자') AS gender_decode2,

       -- NVL2 + NULLIF 방식
       NVL2(NULLIF(MOD(SUBSTR(ssn, -7, 1), 2), 1),
            '여자',
            '남자') AS gender_nvl2,

       -- CASE (SIMPLE CASE)
       CASE MOD(SUBSTR(ssn, -7, 1), 2)
           WHEN 1 THEN '남자'
           ELSE '여자'
       END AS gender_case1,

       -- CASE (SEARCH CASE - 가장 표준)
       CASE
           WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN '남자'
           ELSE '여자'
       END AS gender_case2   

FROM insa;

SELECT name
      , ssn
      , CASE MOD(SUBSTR(ssn, -7, 1), 2)
            WHEN 1 THEN '남자'
            ELSE '여자'
        END  gender
      , CASE WHEN 
      MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN 'Male'
            ELSE 'feMale'
        END  gender2
FROM insa;
 
--CASE 선언형식
--
--CASE 컬럼명 | 수식
--    WHEN 조건1 THEN 결과1
--    WHEN 조건2 THEN 결과2
--    .
--    .
--    ELSE            결과
--END 별칭

 --- EMP 에서 모든 사원  PAY 10 인상 해서 출력
 
 SELECT E.*
  , (sal+ NVL(comm, 0)) *1.1
 FROM emp E;
 
 
UPDATE EMP
SET SAL = SAL*1.1;

-- EMP 테이블에서 10번 부서원은 SAL을 10% 인상, 20번은 25 % ,30번 15 % 인상, 그 외는 인상 X
SELECT ENAME, SAL
  , CASE DEPTNO 
       WHEN 10 THEN SAL*1.1
      WHEN 20 THEN SAL*1.25
      WHEN 30 THEN SAL*1.15
        ELSE SAL
        END P
       , DECODE (DEPTNO,10,SAL*1.1,20,SAL*1.25,30,SAL*1.15) P2 -- SAL 맨 앞에 빼도 O
 FROM emp;

 -- EX SAL 인상률 만큼 UPDATE
 
UPDATE EMP
SET SAL = sal *  CASE deptno
                WHEN 10 THEN 1.1
                WHEN 20 THEN 1.25
                WHEN 30 THEN 1.15        
             END ;
          
       ROLLBACK;   
 -- sal * DECODE( deptno, 10,  1.1, 20 , 1.25, 30,  1.15 )
 
 
 -- 설문조사 
 
-- 시작: 26.6.1. 오전 6:00 - 종료: 26.06.18 오후 12:00 지금 설문 가능한지 여부

SELECT SYSDATE
     ,TO_CHAR(SYSDATE, 'DS TS')
     , TO_CHAR(TO_DATE ('26/06/11 09:00' , 'TT/MM/DD HH24:MI'), 'DS TS')
FROM dual;

SELECT TO_CHAR(SYSDATE, 'DS TS') AS now_time,
       TO_DATE('26/06/11 09:00', 'YY/MM/DD HH24:MI') AS start_date,
       TO_DATE('26/06/18 18:00', 'YY/MM/DD HH24:MI') AS end_date,

       CASE
           WHEN SYSDATE BETWEEN TO_DATE('26/06/11 09:00', 'YY/MM/DD HH24:MI')
                            AND TO_DATE('26/06/18 18:00', 'YY/MM/DD HH24:MI')
                THEN '설문 가능'

           WHEN SYSDATE < TO_DATE('26/06/11 09:00', 'YY/MM/DD HH24:MI')
                THEN '설문 시작 전'

           WHEN SYSDATE > TO_DATE('26/06/18 18:00', 'YY/MM/DD HH24:MI')
                THEN '설문 종료'
       END AS survey_status

FROM dual;


END SURVEY_STATUS 
FROM dual;

---------------------
--집계함수 KEEP (DENSE_RANK FIRST | LAST ORDER BY  정렬컬럼)
MAX 급여, MIN급여 조회
SELECT MAX(SAL), MIN(SAL)
;


SELECT MAX (ENAME) KEEP 
DENSE_RANK FIRST ORDER BY NY SAL DSC)
FROM EMP
GROUP BY DEPTNO;



SELECT MIN (ENAME) KEEP 
DENSE_RANK LAST ORDER BY NY SAL DSC)
FROM EMP
GROUP BY DEPTNO;

SELECT TRUNC(SYSDATE,'MONTH') +LEVEL -1
FROM DUAL 
CONNECT BY LEVEL <= TO_CHAR (LAST_DAY (SYSDATE),'DD');


-- [문제] insa 테이블에서 총사원수, 남자사원수, 여자사원수를 조회.
-- 1)
SELECT 
     (SELECT COUNT(*) FROM insa) 총사원수
   , (SELECT COUNT(*) FROM insa WHERE MOD(SUBSTR(ssn,-7,1),2) = 1 ) 남자사원수
   , (SELECT COUNT(*) FROM insa WHERE MOD(SUBSTR(ssn,-7,1),2) = 0 ) 여자사원수
FROM dual;
--2) SET 연산자 ( UNION )
SELECT null gender,  COUNT(*) cnt
FROM insa
UNION
SELECT '남자',  COUNT(*) 
FROM insa 
WHERE MOD(SUBSTR(ssn,-7,1),2) = 1
UNION
SELECT '여자',  COUNT(*) 
FROM insa 
WHERE MOD(SUBSTR(ssn,-7,1),2) = 0; 
--3) DECODE
SELECT COUNT(*)
,COUNT(DECODE (MOD(SUBSTR(ssn,-7,1),2) , 1, 'O'))
,COUNT(DECODE (MOD(SUBSTR(ssn,-7,1),2) , 0, 'O'))
FROM insa;


SELECT COUNT(*) AS 총사원수,
       COUNT(
           CASE
               WHEN MOD(SUBSTR(ssn,-7,1),2) = 1
               THEN 'man'
           END
       ) AS 남자수,
       COUNT(
           CASE
               WHEN MOD(SUBSTR(ssn,-7,1),2) = 0
               THEN 'woman'
           END
       ) AS 여자수
FROM insa;

-- GROUP BY

SELECT DECODE(MOD(SUBSTR(ssn, -7, 1), 2),
              1, '남자',
              '여자') AS gender,
       COUNT(*) AS cnt
FROM insa
GROUP BY DECODE(MOD(SUBSTR(ssn, -7, 1), 2),
                1, '남자',
                '여자');
                
                
                SELECT CASE
           WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN '남자'
           ELSE '여자'
       END AS gender,
       COUNT(*) AS cnt
FROM insa
GROUP BY CASE
             WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN '남자'
             ELSE '여자'
         END
         
        UNION SELECT NULL, COUNT(*) FROM INSA;
        
        -- ROLLUP / CUBE
        
        SELECT MOD(SUBSTR(ssn, -7, 1), 2), COUNT (*)
        FROM INSA
        GROUP BY ROLLUP(MOD(SUBSTR(ssn, -7, 1), 2));
        
        -- GROUPING 함수 : 총계 행 구분하기 위해 사용
        
        SELECT -- MOD(SUBSTR(ssn, -7, 1), 2), 
        CASE
        -- ROLLUP / CUBE 가 생성한 집계행? -> 1번 아니면 0 반환
        WHEN GROUPING (MOD(SUBSTR(ssn, -7, 1), 2)) = 1 THEN 'TOTAL'
        WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN 'MAN'
        ELSE 'WOMAN'
        END GEN
        ,COUNT (*)
        FROM INSA
      GROUP BY ROLLUP(MOD(SUBSTR(ssn, -7, 1), 2));
      
      SELECT CASE
           WHEN GROUPING(MOD(SUBSTR(ssn, -7, 1), 2)) = 1 THEN 'TOTAL'
           WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 THEN 'MAN'
           ELSE 'WOMAN'
       END AS gen,
       COUNT(*) AS cnt
FROM insa
GROUP BY ROLLUP(MOD(SUBSTR(ssn, -7, 1), 2));


--------------------------------------

SELECT DEPTNO, JOB, SAL
FROM EMP
        
        
SELECT deptno, job
--       , COUNT(empno)
       , SUM(sal)
FROM emp
GROUP BY deptno, job
UNION
SELECT deptno, null, SUM(sal)
FROM emp
GROUP BY deptno
UNION
SELECT null, null, SUM(sal)
FROM emp;

---------------
SELECT deptno,job,
--    COUNT(empno),
    SUM(sal)
FROM emp
--WHERE deptno is not null
 GROUP BY ROLLUP(deptno,job)
-- GROUP BY ROLLUP(deptno,job)
--   1) deptno + job 집계
--   2) deptno 집계
--   3) () 집계

--GROUP BY ROLLUP(deptno),job
-- GROUP BY ROLLUP(deptno),job
--   1) deptno + job 집계
--   2) job 집계

-- 
GROUP BY GROUPING SET( (deptno,job), (job) )

-----------FIRST_VALUE / LAST_VALUE

--FIRST_VALUE OVER (ORDER BY DESC)
--LAST_VALUE OVER (ORDER BY DESC)

SELECT ename,sal
    , LAST_VALUE(sal) OVER(
        ORDER BY sal DESC
--        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )   
FROM emp;

 --------- 부서별 최고 급여자 표시
 SELECT DEPTNO,ENAME, SAL
 FIRST_VALUE(ename)OVER (ORDER BY DESC)  
 FROM 
 
 -- [문제] insa 테이블에서 여자사원수가 5명 이상인 부서명, 사원수 조회..
 
 SELECT BUSEO, CNT
 FROM(
 SELECT BUSEO, COUNT (BUSEO) CNT
 FROM INSA E
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0 
GROUP BY BUSEO
 ) T
 WHERE CNT >=5;
 

 SELECT BUSEO, COUNT (BUSEO) CNT
 FROM INSA E
WHERE MOD(SUBSTR(ssn, -7, 1), 2) = 0 
GROUP BY BUSEO
HAVING COUNT (BUSEO) >= 5;
 
 
 -- [문제] emp 테이블에서 (사원 전체 평균 급여)보다 사원의 급여(pay)가 많으면 "많다", "적다" 출력.
 
 
SELECT empno,
       sal + NVL(comm, 0) AS pp,
       CASE
           WHEN sal + NVL(comm, 0) >
                (SELECT AVG(sal + NVL(comm, 0)) FROM emp)
           THEN '많다'
           ELSE '적다'
       END AS result
FROM emp;
WHEN 
SELECT SAL+NVL(COMM,0) > (SELECT AVG(SAL+NVL(COMM,0) FROM EMP )
FROM EMP;
 
 
 - 1) UNION/UNION ALL
SELECT AVG(sal + NVL(comm,0)) avg_pag
FROM emp;
--
SELECT emp.*, '많다'
FROM emp
WHERE  sal + NVL(comm,0) > ( SELECT AVG(sal + NVL(comm,0)) avg_pag FROM emp )
UNION
SELECT emp.*, '작다'
FROM emp
WHERE  sal + NVL(comm,0) < ( SELECT AVG(sal + NVL(comm,0)) avg_pag FROM emp 

-- 2) DECODE, CASE 함수
        SELECT emp.*
            , sal + NVL(comm,0) pay
            , (SELECT AVG(sal + NVL(comm,0) ) FROM emp )  avg_pay
        FROM emp
 
 
  2) DECODE, CASE 함수
SELECT e.ename, e.pay, e.avg_pay
      , CASE
          WHEN e.pay > e.avg_pay THEN '많다'
          WHEN e.pay < e.avg_pay THEN '작다'
          ELSE '같다'
        END pay_status
FROM (
        SELECT emp.*
            -- 월급
            , sal + NVL(comm,0) pay
            -- 모든 행마다 평균값을 컬럼으로 추가
            , (SELECT AVG(sal + NVL(comm,0) ) FROM emp )  avg_pay
        FROM emp
) e;
  
- (3)
SELECT e.ename, e.pay, e.avg_pay
     --              음수(적다) 양수(많다)
      , NVL2(  NULLIF( SIGN(e.pay-avg_pay), 1 )    , '적다', '많다')  "평가"
FROM (
        SELECT emp.*
            , sal + NVL(comm,0) pay
            , (SELECT AVG(sal + NVL(comm,0) ) FROM emp )  avg_pay
        FROM emp
    ) e  ;
    
    
    -- [문제] insa 테이블에서
--   서울 출신 사원 중에 부서별 남자, 여자 사원수
--                           남자급여총합, 여자 급여총합 조회(출력)
-- [출력 형식]
--BUSEO                남자인원수   여자인원수   남자급여합      여자급여합     
----------------- ---------- ---------- ---------- ----------
--개발부                   0          2             1,790,000
--기획부                   2          1  5,060,000  1,900,000
--영업부                   4          5  6,760,000  6,400,000
--인사부                   1          0  2,300,000           
--자재부                   0          1               960,400
--총무부                   2          1  3,760,000    920,000
--홍보부                   0          1               950,000
SELECT *                                                                                                    
FROM INSA;

SELECT buseo,

       COUNT(CASE 
                WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 
                THEN 1 
            END) AS "남자인원수",

       COUNT(CASE 
                WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 0 
                THEN 1 
            END) AS "여자인원수",

       SUM(CASE 
              WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 1 
              THEN basicpay + sudang 
           END) AS "남자급여합",

       SUM(CASE 
              WHEN MOD(SUBSTR(ssn, -7, 1), 2) = 0 
              THEN basicpay + sudang 
           END) AS "여자급여합"

FROM insa
WHERE city = '서울'
GROUP BY buseo
ORDER BY buseo;


SELECT BUSEO,
 COUNT (CASE WHEN MOD(SUBSTR(SSN,-7,1),2)=1 THEN 1
       END) 남자인원수
       ,COUNT (CASE WHEN MOD(SUBSTR(SSN,-7,1),2)=0 THEN 0
       END) 여자인원수
        ,SUM (CASE WHEN MOD(SUBSTR(SSN,-7,1),2) = 1 THEN  basicpay + sudang 
       END) 남자급여합
         ,SUM (CASE WHEN MOD(SUBSTR(SSN,-7,1),2) = 0 THEN  basicpay + sudang 
       END) 여자급여합
FROM INSA
WHERE CITY = '서울'
GROUP BY BUSEO
ORDER BY BUSEO;

     



SELECT COUNT(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, 'O' )) FROM  temp WHERE buseo = t.buseo
, ( SELECT SUM(basicpay) FROM  temp WHERE buseo = t.buseo ) 총급여합
     , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 1, basicpay )) FROM  temp WHERE buseo = t.buseo ) 남급여합
     , ( SELECT SUM(DECODE( MOD(SUBSTR(ssn, -7, 1),2), 0, basicpay )) FROM  temp WHERE buseo = t.buseo ) 여급여합

