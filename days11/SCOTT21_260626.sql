-- [문제] 서점별 구매현황 구하기
--서점코드  서점명  판매금액합  비율(소수점 둘째반올림)  
-- g_id    g_name
------------ -------------------------- ----------------
--7       강북서점    15300      26%
--4       서울서점    11551      19%
--2       도시서점    6000      10%
--6       강남서점    18060      30%
--1       우리서점    8850      15%

--p_su, d.b_id
SELECT g.g_id, g_name, SUM (price*p_su)
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON g.g_id = p.g_id
GROUP BY g.g_id, g_name;

--2 단계
SELECT g_id,g_name,"서점별 총구매금액" , ROUND("서점별 총구매금액"/"전체 총구매금액"*100 ,2) || '%'
FROM(
SELECT g.g_id, g_name, SUM (price*p_su) "서점별 총구매금액" , 
--ROUND(((SUM (price*p_su)/SUM(SUM (price*p_su)))OVER()*100 ),2) 이건 오답
( SELECT SUM(price* p_su) FROM panmai a JOIN danga b ON a.b_id = b.b_id ) "전체 총구매금액"
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              JOIN gogaek g ON g.g_id = p.g_id
GROUP BY g.g_id, g_name
);

--2-2

WITH gogaek_sales AS (
    SELECT
          g.g_id , g.g_name
        , NVL(SUM(p_su * price), 0) total_amt
        , COUNT(p_date) total_cnt
    FROM panmai p JOIN danga d ON p.b_id = d.b_id
             RIGHT JOIN gogaek g  ON g.g_id = p.g_id
    GROUP BY  g.g_id , g.g_name
)
SELECT 
g_id,g_name, 
 SUM(total_amt) OVER () -- SUM(total_amt) OVER () 고객 전체 합+ 행의 수는 유지
,ROUND( total_amt / SUM(total_amt) OVER ()*100,2)
FROM gogaek_sales;

--2-3 RATIO_TO_REPORT() 함수: 전체 합계의 각 행이 차지하는 비율을 계산하는 분석함수.


SELECT g.g_id, g_name,NVL( SUM (price*p_su),0)  "서점별 총구매금액" 
    ,ROUND(RATIO_TO_REPORT(NVL(SUM(p_su * price),0))OVER()*100,2) "구매 비율"
FROM panmai p JOIN danga d ON p.b_id = d.b_id
              RIGHT JOIN gogaek g ON g.g_id = p.g_id
GROUP BY g.g_id, g_name;

 -- VIEW
 --형식
 
-- CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름
--		[(alias[,alias]...]
--	AS subquery
--	[WITH CHECK OPTION]
--	[WITH READ ONLY];

-- 고객의 구매 정보 조회
SELECT b.b_id,title, price, g.g_id, g_name, p_date, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id
            JOIN gogaek g ON p.g_id = g.g_id;

-- 예)  VIEW로 작성

CREATE OR REPLACE VIEW uvpan 
AS
SELECT b.b_id 책ID,title, price, g.g_id, g_name, p_date, p_su
FROM book b JOIN danga d ON b.b_id = d.b_id
            JOIN panmai p ON b.b_id = p.b_id 
            JOIN gogaek g ON p.g_id = g.g_id;
--View UVPAN이(가) 생성되었습니다.
-- 권한 확인
SELECT *
FROM user_sys_privs;

--
SELECT *
FROM user_views;
--
SELECT *
FROM uvpan;
--
--FROM 뷰 명 또는 테이블 명
-- 예) 연도 별, 월 별, 고객코드, 고객명, 판매 금액 합
-- (연도 별 , 월 오름 차순 , 뷰 명 uvgogaek)

SELECT TO_CHAR(p_date, 'YYYY-MM')날짜, g.g_id, g.g_name,SUM( p.p_su*d.price)
FROM gogaek g JOIN panmai p ON g.g_id = p.g_id
              JOIN danga d ON p.b_id = d.b_id
GROUP BY TO_CHAR(p_date, 'YYYY-MM'), g.g_id, g.g_name        
ORDER BY 날짜;


CREATE OR REPLACE NOFORCE VIEW uvgogaek
AS
SELECT g.g_id, g_name
     -- , p_date
     , TO_CHAR(p_date, 'YYYY') p_year
     , TO_CHAR(p_date, 'MM') p_month
     , SUM ( price * p_su ) 총판매금액합
FROM gogaek g JOIN panmai p ON g.g_id= p.g_id
              JOIN danga d  ON p.b_id = d.b_id
GROUP BY  TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM'), g.g_id, g_name
ORDER BY  TO_CHAR(p_date, 'YYYY'), TO_CHAR(p_date, 'MM')
;

SELECT *
FROM uvgogaek;

--뷰 삭제
DROP VIEW uvgogaek;

-- 실무) 회원 정보 조회 2) 주문 현황 3) 게시판 목록 4)매출 현황... 등등

----PL/SQL

[DECLARE]
 변수, 상수 선언
BEGIN
 실행문
 SELECT
 INSERT
 DELETE
 SELECT
 :
 -- 투표 (트랜잭션 처리 - 다 되던지 안되던지)
 INSERT 투표     o
 UPDATE 설문 총 투표자수  o
 UPDATE 항목 항목투표자수 x 
 
 COMMIT;
 
[EXCEPTION]
 예외 발생 강제로 발생시키고 ROLLBACK ;
END;

--PL/SQL 작성


DECLARE 
-- 변수 상수 선언 블럭
 vename  VARCHAR2(10) ;
 vpay NUMBER;
 
 -- final double PI = 3.141592;
 -- vpi CONSTANT NUMBER := 3.141592
BEGIN
-- 실행블럭

SELECT ename, sal + NVL(comm,0) pay
      INTO vename, vpay 
FROM emp
WHERE empno = 7369;

--출력작업

--자바: SYSOUT;
--DEMS_OUTPUT.PUT(', ')
DBMS_OUTPUT.PUT_LINE(vename || ', ' || vpay);

--EXCEPTION
END;


DESC emp;
DESC dept;

--예 ) 30번 부서의 지역명을 얻어와서 10번 부서의 지역명으로 설정 

select * from dept;

--10	ACCOUNTING	NEW  <- CHICAGO
--20	RESEARCH	DALLAS
--30	SALES	CHICAGO <- NEWYORK
--40	OPERATIONS	BOSTON

DECLARE

VLOC10 dept.loc%TYPE;
VLOC30 dept.loc%TYPE;--타입 변수
BEGIN
SELECT LOC INTO VLOC10 
FROM DEPT
WHERE DEPTNO = 10;

SELECT LOC INTO VLOC30 
FROM DEPT
WHERE DEPTNO = 30;

 UPDATE dept
 SET loc = vloc30
 WHERE deptno = 10;

 UPDATE dept
 SET loc = vloc10
 WHERE deptno = 30;

  COMMIT;

-- ex 30번 부서원들 중 최고 급여 받는 사원 정보, 익명프로시저
-- --  ( empno, ename, hiredate, job, sal, comm )

SELECT empno, ename, hiredate, job, SUM(sal + NVL(comm,0)) S
FROM emp 
WHERE deptno = 30
GROUP BY  empno, ename, hiredate, job
ORDER BY S DESC
FETCH FIRST 1 ROW ONLY;
-- FETCH FIRST 1 ROW WITH TIES; 공동 일위


DECLARE 

 vempno emp.empno%TYPE; 
   vename emp.ename%TYPE; 
   vhiredate emp.hiredate%TYPE;  
   vjob emp.job%TYPE;  
   vsal emp.sal%TYPE;  
   vcomm emp.comm%TYPE; 
BEGIN
    
SELECT empno, ename, hiredate, job, sal, comm
INTO vempno, vename, vhiredate, vjob, vsal, vcomm
FROM emp 
WHERE deptno = 30
ORDER BY  sal + NVL(comm, 0) DESC
FETCH FIRST 1 ROW ONLY;

DBMS_OUTPUT.PUT_LINE(vempno|| ', ' || vename|| ', ' || vhiredate|| ', ' || vjob|| ', ' || vsal|| ', ' || vcomm);

--EXCEPTION
END;



  --2
  
DECLARE 

   vdeptno dept.deptno%TYPE := 30;
   vemprow emp%ROWTYPE;
BEGIN
    --vdeptno := 30;
SELECT empno, ename, hiredate, job, sal, comm
INTO    vemprow.empno, 
        vemprow.ename, 
        vemprow.hiredate,
        vemprow.job, 
        vemprow.sal, 
        vemprow.comm
FROM emp 
WHERE deptno = vdeptno
ORDER BY  sal + NVL(comm, 0) DESC
FETCH FIRST 1 ROW ONLY;

DBMS_OUTPUT.PUT_LINE( vemprow.empno|| ', ' ||  vemprow.ename);

--EXCEPTION
END;



  --3 30 번 모든 사원 정보를 조회 -> 출력
  -- PL /SQL 에서 여러개의 행을 처리할 때는 커서 (CURSOR)를 사용해야 함.
  
  
DECLARE 
   vemprow emp%ROWTYPE;
BEGIN
  
SELECT empno, ename, hiredate, job, sal, comm
INTO    vemprow.empno, 
        vemprow.ename, 
        vemprow.hiredate,
        vemprow.job, 
        vemprow.sal, 
        vemprow.comm
FROM emp 

ORDER BY  sal + NVL(comm, 0) DESC;

DBMS_OUTPUT.PUT_LINE( vemprow.empno|| ', ' ||  vemprow.ename);

--EXCEPTION
END;

---------------------------------

-- 1. 대입 연산자 :=
DECLARE
va NUMBER(10) := 10;
vb NUMBER(10);
vc NUMBER(10);

BEGIN

vb := 20;
vc := va +vb;
DBMS_OUTPUT.PUT_LINE(va ||'+' || vb || '=' || vc);
--EXCEPTION
END;


--2 IF문
if (조건식){}
else if(c) {}


--PL/SQL문
IF 조건식 THEN 
  --명령코딩
END IF;
  
IF C THEN 
-- ORDER
END IF;

IF C THEN 
ELSIF C THEN
ELSIF C THEN
ELSIF C THEN
ELSIF C THEN
ELSE
END IF;

-- 수우미양가 출력


DECLARE 
 vscore NUMBER(3);
 vgrade CHAR(1 CHAR);
BEGIN
vscore := :score ;
IF vscore BETWEEN 90 AND 100 THEN
vgrade := '수';
ELSIF  vscore BETWEEN 80 AND 89 THEN
vgrade := '우';
ELSIF  vscore BETWEEN 70 AND 79 THEN
vgrade := '미';
ELSIF  vscore BETWEEN 60 AND 69 THEN
vgrade := '양';
ELSIF  vscore BETWEEN 0 AND 59 THEN
vgrade := '가';
ELSE 
DBMS_OUTPUT.PUT_LINE('입력잘못');
END IF;
DBMS_OUTPUT.PUT_LINE(vgrade);
--EXCEPTION
-- 예외 처리
--WHEN OTHERS THEN
--
--DBMS_OUTPUT.PUT_LINE(SQLERRM);
--DBMS_OUTPUT.PUT_LINE(SQLERRM);

END;


-- 


DECLARE 
 vscore NUMBER(3);
 vgrade CHAR(1 CHAR);
BEGIN
vscore := :score ;

IF vscore BETWEEN 0 AND 100 THEN
vgrade := CASE TRUNC (vscore/10)
     WHEN 10 THEN '수'
     WHEN 9 THEN '수'
     WHEN 8 THEN '우'
     WHEN 7 THEN '미'
     WHEN 6 THEN '양'
ELSE '가'
   END;
   ELSE
RAISE_APPLICATION_ERROR(-20009, '>>점수의 범위 벗어남');
END IF;
  DBMS_OUTPUT.PUT_LINE(vgrade);
-- EXCEPTION
--     -- 2) 예외 처리... 
--   WHEN OTHERS THEN
--      DBMS_OUTPUT.PUT_LINE(SQLCODE);
--      DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

vgrade := DECODE();

