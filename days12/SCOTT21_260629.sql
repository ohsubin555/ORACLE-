--SCOTT
-- 예) WHILE 문 / FOR 문

--DECLARE 
BEGIN 
--EXCEPTION
FOR VI IN 1..10 LOOP
 DBMS_OUTPUT.PUT_LINE(VI);
END LOOP;
END;

--예

DECLARE
VI NUMBER(2) := 1;
BEGIN 
 WHILE VI<=10 LOOP
  DBMS_OUTPUT.PUT_LINE(VI);
--  VI++;
  VI := VI+1;

 END LOOP;
--EXCEPTION
END;

--EX

DECLARE
VI NUMBER(2) := 1;
BEGIN 
 LOOP
  EXIT WHEN VI>10;
  DBMS_OUTPUT.PUT_LINE(VI);
  VI := VI+1;
   END LOOP;

--EXCEPTION
END;

--예
DECLARE 
 SUM_NUM NUMBER := 0;
BEGIN 
--EXCEPTION
FOR VI IN 1..10 LOOP
SUM_NUM := SUM_NUM + VI;
 DBMS_OUTPUT.PUT(VI || '+');
END LOOP;
 DBMS_OUTPUT.PUT_LINE('=' || SUM_NUM );
END; 


--WHILE 

DECLARE
VI NUMBER(2) := 1;
 SUM_NUM NUMBER := 0;
BEGIN 
 WHILE VI<=10 LOOP
  DBMS_OUTPUT.PUT(VI || '+');
  SUM_NUM := SUM_NUM + VI;
  VI := VI+1;
 END LOOP;
  DBMS_OUTPUT.PUT_LINE('=' || SUM_NUM );
END;


DECLARE
VI NUMBER(2) := 2;
 DAN NUMBER := 1;
 RE NUMBER := 0;
BEGIN 
 WHILE VI<=9 LOOP
  DBMS_OUTPUT.PUT_LINE(VI || 'x' || DAN);
   VI := VI+1;
   DAN := DAN+1;
 RE := VI * DAN ;
 END LOOP;
  DBMS_OUTPUT.PUT_LINE('=' || RE );
END;


DECLARE
    VI NUMBER := 2;
    DAN NUMBER;
BEGIN
    WHILE VI <= 9 LOOP
        DAN := 1;

        WHILE DAN <= 9 LOOP
            DBMS_OUTPUT.PUT_LINE(VI || ' x ' || DAN || ' = ' || (VI * DAN));
            DAN := DAN + 1;
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('----------------');

        VI := VI + 1;
    END LOOP;
END;
/

DECLARE 
BEGIN 
 FOR VI IN 1..9 LOOP
 FOR VDAN IN 2..9 LOOP
DBMS_OUTPUT.PUT(VDAN || '*' || VI || '=' || RPAD(VDAN*VI,4,' '));
 END LOOP;
      DBMS_OUTPUT.NEW_LINE;   -- 또는 DBMS_OUTPUT.PUT_LINE('');
   END LOOP;
END;

DECLARE
  vdan NUMBER(2) := 2 ;
  vi NUMBER := 1;
BEGIN
  WHILE vdan <= 9 LOOP
    vi := 1;
    WHILE vi <= 9  LOOP    
      DBMS_OUTPUT.PUT( vdan || '*' || vi || '=' ||  RPAD( vdan*vi, 4, ' '));
      vi := vi+1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('');
    vdan := vdan + 1;
  END LOOP;
--EXCEPTION
END;

--EX

--EMP 에서 10번 20% 20 번 10퍼 그외부서 15 퍼 인상 -익명프로시저로 처리

DECLARE 
BEGIN
 UPDATE EMP
 SET SAL = CASE DEPTNO
           WHEN  10 THEN SAL*1.2
            WHEN 20 THEN SAL*1.1
           ELSE          SAL*1.15
            END;
--EXCEPTION
END;

ROLLBACK;

-- DECODE 함수 사용

DECLARE 
BEGIN
 UPDATE EMP
 SET SAL = DECODE(DEPTNO, 10, SAL*1.2, 20, SAL*1.1, 
 
            CASE DEPTNO
           WHEN  10 THEN SAL*1.2
            WHEN 20 THEN SAL*1.1
           ELSE          SAL*1.15
            END;
--EXCEPTION
END;


-- 
DECLARE 
-- VENAME EMP.ENAME%TYPE;
-- VHIREDATE EMP.HIREDATE%TYPE;
--VROW EMP%ROWTYPE;
BEGIN
FOR VROW IN ( SELECT VENAME, VHIREDATE  FROM EMP) LOOP
 DBMS_OUTPUT.PUT_LINE( VROW.ENAME || ', ' || VROW.HIREDATE);
END LOOP;


-- WHERE EMPNO = 7782;
--EXCEPTION
END;
-- 커서 - 여러행을 처리할 때 사용 
-- 묵시적 커서 



-- 1) %TYPE 변수 
DECLARE
  vdeptno dept.deptno%TYPE;
  vdname dept.dname%TYPE;
  vempno emp.empno%TYPE;
  vename emp.ename%TYPE;
  vpay NUMBER;
BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vdeptno, vdname, vempno, vename, vpay
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vdeptno || ', ' || vdname  
    || ', ' ||  vempno  || ', ' || vename  || ', ' ||  vpay );
--EXCEPTION
END;
-- 2) %ROWTYPE 변수
DECLARE
  vdrow dept%ROWTYPE;
  verow emp%ROWTYPE;
  vpay NUMBER;
BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vdrow.deptno, vdrow.dname, verow.empno, verow.ename, vpay 
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
    || ', ' ||  verow.empno  || ', ' || verow.ename  || ', ' ||  vpay );
--EXCEPTION
END;


--3 사용자 정의 구조체 타입 사용
DECLARE

--사용자 정의한 구조체 타입
 TYPE EMPDEPTTYPE IS RECORD (
 
deptno DEPT.DEPTNO%TYPE,
dname DEPT.DNAME%TYPE,
empno EMP.EMPNO%TYPE,
ename  EMP.ENAME%TYPE, 
pay  NUMBER
);

vedrow EmpDeptType;

BEGIN
  
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
      INTO vedrow.deptno, vedrow.dname, vedrow.empno, vedrow.ename, vedrow.pay 
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
   DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' ||  vedrow.dname  
    || ', ' ||  vedrow.empno  || ', ' || vedrow.ename  || ', ' ||  vedrow.pay  );
    
    
    
    DECLARE
  
  -- 사용자 정의한 구조체 타입
  TYPE EmpDeptType IS RECORD(
      deptno dept.deptno%TYPE,
      dname dept.dname%TYPE,
      empno emp.empno%TYPE,
      ename emp.ename%TYPE,
      pay NUMBER
  );
  
  vedrow EmpDeptType;
    BEGIN
   SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay
     INTO vedrow.deptno, vedrow.dname, vedrow.empno, vedrow.ename, vedrow.pay 
   FROM dept d JOIN emp e ON d.deptno = e.deptno
   WHERE empno = 7369;   
  DBMS_OUTPUT.PUT_LINE( vedrow.deptno || ', ' || vedrow.dname 
    || ', ' ||  vedrow.empno  || ', ' || vedrow.ename  || ', ' ||  vedrow.pay );
    END;
    
    -- 커서선언
    DECLARE
    -- 커서 선언
    CURSOR vedcursor IS
        SELECT d.deptno,
               d.dname,
               e.empno,
               e.ename,
               e.sal + NVL(e.comm, 0) AS pay
        FROM dept d
        JOIN emp e ON d.deptno = e.deptno;

    -- 레코드 선언
    vedrow vedcursor%ROWTYPE;

BEGIN
    -- 커서 OPEN
    OPEN vedcursor;

    -- FETCH LOOP
    LOOP
        FETCH vedcursor INTO vedrow;
        EXIT WHEN vedcursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            '읽어온 레코드 수: ' || vedcursor%ROWCOUNT || ' / ' ||
            vedrow.deptno || ', ' ||
            vedrow.dname  || ', ' ||
            vedrow.empno  || ', ' ||
            vedrow.ename  || ', ' ||
            vedrow.pay
        );
    END LOOP;

    -- 커서 CLOSE
    CLOSE vedcursor;
END;
/
    
    --DECLARE  
BEGIN
   FOR vrow IN (
      SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay     
      FROM dept d JOIN emp e ON d.deptno = e.deptno
   )
   LOOP
      DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
   END LOOP; 
--EXCEPTION
END;
    
    
    DECLARE  
  CURSOR vdecursor IS (
      SELECT d.deptno, dname, empno, ename, sal + NVL(comm,0) pay     
      FROM dept d JOIN emp e ON d.deptno = e.deptno
  );
BEGIN
   --OPEN vdecursor;
   FOR vrow IN vdecursor  
   LOOP
      DBMS_OUTPUT.PUT_LINE( vrow.deptno || ', ' || vrow.dname 
    || ', ' ||  vrow.empno  || ', ' || vrow.ename  || ', ' ||  vrow.pay );
   END LOOP; 
--EXCEPTION
END;



------------------------------------------ 저장 프로시저

CREATE OR REPLACE PROCEDURE up저장프로시저명
(
--파라미터 (매개변수, 인자) p 
PSSN VARCHAR2,
PSSN IN  VARCHAR2,
PSSN OUT VARCHAR2,
PSSN IN OUT VARCHAR2, --크기를 주지 않음. 뒤에 콤마를 찍음.  
)
IS

--변수 , 상수 선언
VENAME VARCHAR2(20); -- 변수선언시는 뒤에 세미콜론


BEGIN
-- 실행문 선언
--EXCEPTION 
--예외처리 선언
END;
EXCEPTION
END;

--저장 프로시저 실행 3법
--1 EXEC[UTX] 저장프로시명;
--2 익명 프로시저에서 호출해서 진행
--3 또 다른 저장 프로시저 안에서 실행

--EX ) COPY EMP TABLE, CREATE TBL_EMP

DROP TABLE TBL_EMP PURGE; 

CREATE  TABLE TBL_EMP 
AS SELECT * FROM EMP;

SELECT * FROM   TBL_EMP;

--저장 프로시저선언 사용
--TBL_EMP 테이블에서 사원 삭제...

EXEC UPDELETETBLEMP(7369);

CREATE OR REPLACE PROCEDURE UPDELETETBLEMP
(
--PEEMPNO NUMBER(4)
--PEEMPNO NUMBER
PEMPNO IN TBL_EMP.EMPNO%TYPE
)
IS -- AS DECLARE 선언 
BEGIN
 DELETE FROM TBL_EMP
 WHERE EMPNO = PEMPNO;
 COMMIT;
 

--EXCEPTION
ROLLBACK;
END;
 
 -- 익명프로시저에서 사용
 
 BEGIN 
 UPDELETETBLEMP(7499);
 END;
 
 -- 또다른 프로시저에서 호출
 
 CREATE OR REPLACE PROCEDURE UPOTHER
(
    PNO IN TBL_EMP.EMPNO%TYPE
)
IS
BEGIN
    -- 다른 프로시저 호출
    UPDELETETBLEMP(PNO);

    DBMS_OUTPUT.PUT_LINE('삭제 완료: ' || PNO);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
 
 --삭제
 DROP PROCEDURE UPDELETETBLEMP;
 
 --EX 테이블 생성
 
 DROP TABLE TBL_DEPT PURGE; 

CREATE  TABLE TBL_DEPT 
AS SELECT * FROM DEPT;

SELECT * FROM   TBL_EMP;
 
 
 ALTER TABLE TBL_DEPT
 ADD CONSTRAINT PK_TBLDEPT_DEPTNO PRIMARY KEY (DEPTNO);

 --
 
 upSelectTblDept TBL_DEPT
 
DECLARE
    -- 커서 선언
    CURSOR tbl_dept IS
        SELECT deptno, dname, loc
        FROM dept;

    -- 변수 선언 (커서와 구조 맞춰야 함)
    v_deptno dept.deptno%TYPE;
    v_dname  dept.dname%TYPE;
    v_loc    dept.loc%TYPE;

BEGIN
    OPEN tbl_dept;

    LOOP
        FETCH tbl_dept INTO v_deptno, v_dname, v_loc;
        EXIT WHEN tbl_dept%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_deptno || ', ' || v_dname || ', ' || v_loc
        );
    END LOOP;

    CLOSE tbl_dept;
END;


SELECT *
        FROM dept;
        
        --
CREATE OR REPLACE PROCEDURE upSelectTblDept  
IS
  CURSOR vdcursor IS (
               SELECT deptno, dname, loc 
               FROM tbl_dept
  );
  vdrow tbl_Dept%ROWTYPE;
BEGIN
  OPEN vdcursor;
  
  LOOP
    FETCH vdcursor INTO  vdrow;
    EXIT WHEN vdcursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
  END LOOP; 
  CLOSE vdcursor;
--EXCEPTION
END;

--

CREATE OR REPLACE PROCEDURE upSelectTblDept  
IS
--  CURSOR vdcursor IS (
--               SELECT deptno, dname, loc 
--               FROM tbl_dept
--  );

BEGIN

FOR  vdrow IN (SELECT deptno, dname, loc  FROM tbl_dept)LOOP 
 DBMS_OUTPUT.PUT_LINE( vdrow.deptno || ', ' || vdrow.dname 
      || ', ' ||  vdrow.loc);  
END LOOP;
--EXCEPTION 

END;

-- 시퀀스 생성 사용
-- TBL_DEPT 부서테이블에 새로운 부서를 추가하는 코딩


	CREATE SEQUENCE 시퀀스명
	[ INCREMENT BY 정수]
	[ START WITH 정수]
	[ MAXVALUE n ¦ NOMAXVALUE]
	[ MINVALUE n ¦ NOMINVALUE]
	[ CYCLE ¦ NOCYCLE]
	[ CACHE n ¦ NOCACHE];

CREATE SEQUENCE SEQ_TBLDEPT 
INCREMENT BY 10
START WITH 50
NOCYCLE 
NOCACHE;



CREATE OR REPLACE PROCEDURE upSelectTblDept  
(
PDNAME TBL_DEPT.DNAME%TYPE DEFAULT NULL,
PLOC TBL_DEPT.LOC%TYPE := NULL
)
IS
VDEPTNO TBL_DEPT.DEPTNO%TYPE;
BEGIN
SELECT MAX (DEPTNO) +10 INTO VDEPTNO FROM TBL_DEPT;

INSERT INTO TBL_DEPT(deptno, dname, loc )
VALUES (SEQ_TBLDEPT.NEXTVAL, PDNAME,PLOC);

COMMIT;
END;

SELECT *
        FROM dept;
EXEC upSelectTblDept(PDNAME => 'AAA');
EXEC upSelectTblDept;
