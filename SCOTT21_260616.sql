-- [문제] emp 테이블에서 월급(pay=sal+comm)이
--        2000 이상  4000 이하를 받는 사원 정보 조회
--        ( 부서번호, 사원명, 잡, 월급 )

SELECT deptno, ename, job, sal+ NVL(comm,0) pay
FROM emp
--WHERE 2000 <=  sal+comm AND  sal+comm <=4000
WHERE sal+ NVL(comm,0) BETWEEN 2000 AND 4000
ORDER BY sal+ NVL(comm,0) DESC;


SELECT deptno, ename, job, sal+comm pay
FROM emp
WHERE 2000 <=  pay  AND  pay <=4000;

--ORA-00904: "PAY": 부적합한 식별자

--WITH empPay AS (
--SELECT deptno, ename, job, sal+ NVL(comm,0) pay
--FROM emp
--) --sub query
--SELECT  empPay. * --main query
--FROM empPay
--WHERE empPay.pay BETWEEN 2000 AND 4000


SELECT ename, LOWER (ename), UPPER (ename), INITCAP (ename)
--COUNT(*)
FROM emp;

--nsa 테이블에서 남자는 'X', 여자는 'O' 로 성별(gender) 출력하는 쿼리 작성   
    NAME                 SSN            GENDER
    -------------------- -------------- ------
    홍길동               771212-1022432    X
    이순신               801007-1544236    X
    이순애               770922-2312547    O
    김정훈               790304-1788896    X
    한석봉               811112-1566789    X 
    :
    /*
    SELECT name, ssn
    , TO_DATE (SUBSTR (ssn,1,6)) BIRTHDAY
   , TO_CHAR(TO_DATE (SUBSTR (ssn,1,6)), 'YYYY') YEAR
   , TO_CHAR(TO_DATE (SUBSTR (ssn,1,6)), 'MM') M
   , TO_CHAR(TO_DATE (SUBSTR (ssn,1,6)), 'DD') D
   , EXTRACT (YEAR FROM TO_DATE (SUBSTR (ssn,1,6)))Y
     , EXTRACT (MONTH FROM TO_DATE (SUBSTR (ssn,1,6))) M
      , EXTRACT (DAY FROM TO_DATE (SUBSTR (ssn,1,6))) D
      
      */
    
    SELECT name, ssn 
    , SUBSTR(ssn,-7,1) GENDER
    ,MOD(SUBSTR(ssn,-7,1),2) GE
    FROM insa;
    
    
--    , SUBSTR (ssn,8,7)
--    ,SUBSTR (ssn,8)
--    , SUBSTR (ssn,-7)
--    ,SUBSTR (ssn,0,2) YY
--    ,SUBSTR (ssn,3,2) MM
--    ,SUBSTR (ssn,5,2) DD
--    ,SUBSTR (ssn,-7,1)
    
 -------------------- -------------- ------ -------------- ------ -------------- ------
   SELECT DISTINCT 3+5  
   FROM emp; --사원수만큼
   
  SELECT  3+5 ,3-5,3*5 , 3/5 -- 나머지 연산자는 없음
   FROM dual;
   
   
   
    -------------------- -------------- ------ -------------- ------ -------------- ------
  
  
   SELECT name, ssn 
--    , SUBSTR(ssn,-7,1) GENDER
    ,MOD(SUBSTR(ssn,-7,1),2) GE
   ,REPLACE( REPLACE(MOD(SUBSTR(ssn,-7,1),2),1,'X'),0,'O') G
   FROM insa;
   
   
   SELECT name,
       ssn,
       NVL( NULLIF(
               REPLACE(TO_CHAR(MOD(SUBSTR(ssn,-7,1),2)), '1', 'X'),
               '0' ), 'O' )  G
FROM insa;

------------------------------------------------------------------------------

--insa 테이블에서 70년대 12월생 모든 사원 정보 조회

--    NAME                 SSN           
--    -------------------- --------------
--    문길수               721217-1951357
--    김인수               731211-1214576
--    홍길동               771212-1022432   


SELECT name, ssn
FROM insa
--WHERE ssn LIKE '7_12%'
WHERE REGEXP_LIKE (ssn, '^7.12')
WHERE REGEXP_LIKE (ssn, '^7\d12')
WHERE REGEXP_LIKE (ssn, '^7[0-9]12')
--WHERE SUBSTR(ssn, 1,1) = 7 AND SUBSTR(ssn, 3,2) = 12
ORDER BY ssn ASC;

--LIKE 연산자

SELECT deptno, sal +NVL(comm,0) pay, ename, hiredate
FROM emp
ORDER BY 1,2 DESC;
--ORDER BY deptno, pay DESC;

-- 인사 테이블에서 70년대 남자만 조회

SELECT name, ssn 
FROM insa
WHERE REGEXP_LIKE (ssn, '^7\d{5}-[13579]');
 
 --emp table ename la LA La lA 문자열 포함된 사원 조회

SELECT ename
FROM emp
--WHERE ename LIKE '%la%' OR ename LIKE '%LA%' OR ename LIKE '%lA%' OR ename LIKE '%La%';
WHERE UPPER(ename) LIKE '%LA%';


SELECT ename
FROM emp
WHERE REGEXP_LIKE (ename, 'la', 'i');


SELECT ename
FROM emp
WHERE ename LIKE '%LE%';

    
UPDATE emp
SET ename = REPLACE(ename, 'LL', '**')
WHERE ename IN ('ALLEN', 'MILLER');        M


select ename,job,sal,
FROM emp p
where deptno IN (
                 select deptno
                 from dept
                 where deptno=p.deptno
                  );
                  
                  
   select ename,job,sal,deptno
   FROM emp p
   where EXISTS (select 'x'
                from dept 
                where deptno=p.deptno);                

SELECT num,name
FROM insa
WHERE name LIKE '김_';
WHERE name LIKE '김%';

----조인 JOIN
--사원테이블
--사번 사원명 입사일자.... 부서명 부서번호 부서장
--1001 홍길동             영업부 101    김수구
SELECT emp.empno, emp.ename, dept.dname
FROM dept,emp --오라클 전통 조인 (old style join) FROM 8I VER.
WHERE dept.deptno = emp.deptno;

SELECT e.empno, e.ename, d.dname
FROM dept d,emp e --오라클 전통 조인 (old style join) FROM 8I VER.
WHERE d.deptno = e.deptno;

SELECT empno, ename, dname, d.deptno
FROM dept d,emp e --오라클 전통 조인 (old style join) FROM 8I VER.
WHERE d.deptno = e.deptno AND d.deptno = 10;

--ANSI JOIN (표준조인)
SELECT empno, ename, dname, e.deptno
FROM dept d JOIN emp e ON d.deptno = e.deptno; 
WHERE d.deptno = 10;

--오늘 날짜, 시간 정보 조회

SELECT SYSDATE, CURRENT_TIMESTAMP
FROM dual; 
--SYSDATE 함수 + TO_CHAR 함수: 내가 원하는 날짜/시간 정보 출력...
--TO_DATE() : 숫자, 날짜 -> 문자 형변환 하는 함수 
SELECT 100   ,       TO_CHAR(100) 
FROM dual;

SELECT TO_CHAR( SYSDATE, 'YYYY') YEAR
       ,TO_CHAR( SYSDATE, 'MON') M
     , TO_CHAR( SYSDATE, 'DD') D
     ,TO_CHAR( SYSDATE, 'DY') 요일
     ,TO_CHAR( SYSDATE, 'HH') H
     ,TO_CHAR( SYSDATE, 'MI') M
     ,TO_CHAR( SYSDATE, 'SS') S
      ,TO_CHAR( SYSDATE, 'AM') AM
       ,TO_CHAR( SYSDATE, 'DL') S
        ,TO_CHAR( SYSDATE, 'DS') S
        
        ,TO_CHAR( SYSDATE, 'W') 이번주 
        ,TO_CHAR( SYSDATE, 'WW') 연중
        ,TO_CHAR( SYSDATE, 'IW') 일년중
        // WWW IW 차이점? 
        FROM dual;
        
        ------------------------------------------------------------------
--       DML 문 : UPDATE 문
--                INSERT 문
      SELECT *
      FROM dept;
      DESC dept;
      
      ------ -------- ------------ 
--DEPTNO NOT NULL NUMBER(2)    
--DNAME           VARCHAR2(14) 
--LOC             VARCHAR2(13) 
-- 새로운 부서 한개 추가

     -- INSERT INTO VALUES
      INSERT INTO dept (deptno, dname, loc) VALUES (50, 'QC', 'SEOUL');
      INSERT INTO dept VALUES (60, 'Engineering', 'SEOUL');
      INSERT INTO dept VALUES (70,null,null);
       INSERT INTO dept (deptno) VALUES(70);
       
       COMMIT;
       
     SELECT *
      FROM dept
      ORDER BY deptno ASC;
     
       ROLLBACK
       
       
      UPDATE dept
      SET dname = 'Production' , loc = 'SEOUL'
      WHERE deptno = 70;
      COMMIT;
      
      DELETE dept 
      WHERE deptno >=50;
       
       
       -- [문제] 50번 새로운 부서를 추가할 예정
--      부서명   30번부서명의 +2 "SALES2"
--      지역명   40번 부서의 지역명과 동일하게... 

-- [문제] 50번 새로운 부서를 추가할 예정
--      부서명   30번 부서의 부서명, 지역명과 동일하게..
       
      SELECT *
      FROM dept
      WHERE UPPER(dname) LIKE '%PRO%'
      
        DELETE dept 
        WHERE  deptno = 10;
  --가장 큰 부서번호 +10 해서 50번 가능불가능 판단
 SELECT dname FROM dept WHERE deptno= 30;
--
SELECT loc 
FROM dept
WHERE deptno= 30;
--
SELECT dname, loc 
FROM dept
WHERE deptno= 30;
--
SELECT COUNT( deptno ), MAX( deptno ), MIN( deptno )
FROM dept;
--
SELECT MAX( deptno ) + 10
FROM dept;
-- 
INSERT INTO dept VALUES (  
  ( SELECT MAX( deptno ) + 10 FROM dept) ,
  ( SELECT dname FROM dept WHERE deptno= 30 ), 
  ( SELECT loc FROM dept WHERE deptno= 30 )
                          );
                          
 INSERT INTO dept (deptno, dname, loc) VALUES (50, 'SALES2', 'BOSTON');
 INSERT INTO dept (deptno, dname, loc) VALUES (50, 'SALES', 'CHICAGO');
 
 UPDATE dept
SET dname = dname || '2', loc = (SELECT loc FROM dept WHERE deptno= 40)
WHERE deptno = 50;
 
  UPDATE dept
SET (dname,loc)  = (SELECT dname, loc FROM dept WHERE deptno= 40)
WHERE deptno = 50
 commit;
 
INSERT INTO dept VALUES (  
  ( SELECT MAX( deptno ) + 10 FROM dept) ,
  ( SELECT dname FROM dept WHERE deptno= 30 ), 
  ( SELECT loc FROM dept WHERE deptno= 30 )
                          );
                          
   ------------------           
   
  DECLARE
  -- 변수 선언
  vdeptno NUMBER(2);
  vdname  VARCHAR2(14);
  vloc    VARCHAR2(10);
BEGIN
  --  실행명령문: INSERT, UPDATE, DELETE, SELECT 여러개...
  SELECT MAX( deptno ) + 10 INTO vdeptno FROM dept;
  SELECT dname || '2' INTO vdname  FROM dept WHERE deptno= 30;
  SELECT loc INTO vloc FROM dept WHERE deptno= 40;  
  INSERT INTO dept VALUES (  vdeptno, vdname, vloc   );
  COMMIT;
END;

 SELECT *
      FROM dept
      
      DELETE FROM dept
      WHERE deptno = 50;
      COMMIT;
      
      ---문제 EMP테이블의 모든 사원의 PAY 월급을 20% 인상하는 UPDATE 문을 작성하세요. 
      
UPDATE emp
SET sal  = sal*1.2;\

SELECT *
FROM tbl_Test;

UPDATE tbl_Test
SET email = REPLACE (email, '.co.kr' , '.com')
 
 
       