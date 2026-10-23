--SCOTT

--미리 정의된 에러 처리방법
--오라클에서 제공하는 예측하여 정의한 오류 목록은 다음과 같다.
--
--항목 에러 코드 설명 
--NO_DATE_FOUND ORA-01403  SQL문에 의한 검색조건을 만족하는 결과가 전혀 없는 조건의 경우 
--NOT_LOGGED_ON ORA-01012  데이터베이스에 연결되지 않은 상태에서 SQL문 실행하려는 경우 
--TOO_MANY_ROWS ORA-01422  SQL문의 실행결과가 여러 개의 행을 반환하는 경우, 스칼라 변수에 저장하려고 할 때 발생 
--VALUE_ERROR ORA-06502  PL/SQL 블럭 내에 정의된 변수의 길이보다 큰 값을 저장하는 경우 
--ZERO_DEVIDE ORA-01476  SQL문의 실행에서 컬럼의 값을 0으로 나누는 경우에 발생 
--INVALID_CURSOR ORA-01001  잘못 선언된 커서에 대해 연산이 발생하는 경우 
--DUP_VAL_ON_INDEX ORA-00001  이미 입력되어 있는 컬럼 값을 다시 입력하려는 경우에 발생 
--

CREATE OR REPLACE PROCEDURE up_exception_test  
(
psal emp.sal%TYPE
)
IS
 vename emp.ename%TYPE;
BEGIN
 SELECT ename INTO vename 
 FROM emp
 WHERE sal = psal;
 DBMS_OUTPUT.PUT_LINE('>ename+' || vename);
EXCEPTION

 WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20001, '>SAL 사원 찾지 못했습니다.');
 WHEN TOO_MANY_ROWS THEN
   RAISE_APPLICATION_ERROR(-20002, '>SAL 여러명의 사원 찾았습니다.');
 WHEN OTHERS THEN 
   RAISE_APPLICATION_ERROR(-20009, '>기타예외가 발생했습니다.');


END;

-- Procedure UP_EXCEPTION_TEST이(가) 컴파일되었습니다.
EXEC UP_EXCEPTION_TEST(800);
EXEC UP_EXCEPTION_TEST(9000);
--ORA-01403: 데이터를 찾을 수 없습니다. 미리 정의된 에러(예외)

EXEC UP_EXCEPTION_TEST(3000);
--ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
SELECT *
FROM EMP
WHERE SAL = 3000;

--
--S.미리 정의되지 않은 에러 처리방법 미리 정의된 에러 처리방법외에 사용자가 직접 에러 처리에 대한 논리적 흐름을 구현할 수 있다.
--[PRAGMA EXCEPTION]절은 오라클 서버에서 어떤 에러 코드가 발생할 때 정의한 조건명을 지정할 것인지를 정의하는 절이다.
-- PK = NN+UK

INSERT INTO emp (empno, ename) VALUES (7369, 'HONG');
--ORA-00001: 무결성 제약 조건(SCOTT.PK_EMP)에 위배됩니다

INSERT INTO emp (empno, ename,deptno) VALUES (9000, 'HONG', 90);
--ORA-02291: 무결성 제약조건(SCOTT.FK_DEPTNO)이 위배되었습니다- 부모 키가 없습니다
--예)
CREATE OR REPLACE PROCEDURE up_insert_emp
(
pempno emp.empno%TYPE
,pename emp.ename%TYPE
,pdeptno emp.deptno%TYPE

)
IS 
BEGIN
INSERT INTO emp (empno, ename,deptno) 
VALUES (pempno, pename, pdeptno);
COMMIT;

EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20001, '>SAL 사원 찾지 못했습니다.');
 WHEN TOO_MANY_ROWS THEN
   RAISE_APPLICATION_ERROR(-20002, '>SAL 여러명의 사원 찾았습니다.');
 WHEN OTHERS THEN 
 IF SQLCODE = -2291 THEN
     DBMS_OUTPUT.PUT_LINE(SQLCODE);
      RAISE_APPLICATION_ERROR(-20001, '>SAL 사원 찾지 못했습니다.');

 ELSE
  RAISE_APPLICATION_ERROR(-20009, '>기타예외가 발생했습니다.');
 END IF;
  
END;

-- Procedure UP_INSERT_EMP이(가) 컴파일되었습니다.
EXEC UP_INSERT_EMP(9000, 'HONG', 90);

-- PRAGMA EXCEPTION 절 사용해서 예외처리 

CREATE OR REPLACE PROCEDURE up_insert_emp
(
pempno emp.empno%TYPE
,pename emp.ename%TYPE
,pdeptno emp.deptno%TYPE

)
IS 
--1) 사용자 정의 예외 변수 (객체) 선언
   PARENT_KEY_NOT_FOUND EXCEPTION;
--2) -2291 이 발생하면 PARENT_KEY_NOT_FOUND 예외객체와 연결 (MAPPING)
PRAGMA EXCEPTION_INIT (PARENT_KEY_NOT_FOUND, -2291);
BEGIN
INSERT INTO emp (empno, ename,deptno) 
VALUES (pempno, pename, pdeptno);
COMMIT;

EXCEPTION
 WHEN PARENT_KEY_NOT_FOUND THEN 
      DBMS_OUTPUT.PUT_LINE(SQLCODE);
   RAISE_APPLICATION_ERROR(-20008, '>부서가 존재하지 않습니다. .');
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20001, '>SAL 사원 찾지 못했습니다.');
 WHEN TOO_MANY_ROWS THEN
   RAISE_APPLICATION_ERROR(-20002, '>SAL 여러명의 사원 찾았습니다.');
 WHEN OTHERS THEN 
  RAISE_APPLICATION_ERROR(-20009, '>기타예외가 발생했습니다.');

END;

EXEC UP_INSERT_EMP(9000, 'HONG', 90);

-- ㄷ. 사용자가 정의한 에러 처리방법
--사용자가 미리 에러에 대한 정의를 하는 경우이며, EXCEPTION 키워드에 의해 에러 조건명을 정의하고 
--RAISE 명령어에 의해 에러가 발생되면 exception 절에서 에러가 처리된다.

CREATE OR REPLACE PROCEDURE up_user_exception 
(
  plosal NUMBER
  ,phisal NUMBER
)
IS
 vcount NUMBER;
 --1) 사용자 정의 예외 변수(객체) 선언
   ZERO_EMP_COUNT EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO vcount 
  FROM emp
  WHERE sal BETWEEN plosal AND phisal ;
  
  -- 사원수가 0인 경우에는 강제로 예외를 발생시키겠다. 
  IF vcount = 0 THEN
  RAISE ZERO_EMP_COUNT;
  ELSE
     DBMS_OUTPUT.PUT_LINE('>사원수 : '|| vcount );

  END IF;

EXCEPTION
 WHEN ZERO_EMP_COUNT THEN 
      RAISE_APPLICATION_ERROR(-20002, '>범위의 사원수가 0 이다.');

 WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20009, '>기타예외가 발생했습니다.');
END;    
--Procedure UP_USER_EXCEPTION이(가) 컴파일되었습니다.

EXEC UP_USER_EXCEPTION (800,1200);
EXEC UP_USER_EXCEPTION (6000,9000);

--<동적 쿼리를 사용하는 3가지 경우>
--1)쿼리 미완성일 경우 가장 많이 사용한다. 
-- WHERE 조건절 - 미리 정해지지 않은 경우
--2) PL/SQL 블럭 안에서 DDL문을 사용하는 경우
--                        (자동 COMMIT 된다.)
--3) PL/SQL 블럭 안에서 ALTER SESSION/SYSTEM  명령어를 사용하는 경우
--             ALTER SESSION : 현재 내가 접속한 세션에서만 설정 변경 명령어
--             ALTER SYSTEM : DB 전체에 영향을 주는 설정 변경 명령어
--[PL/SQL 동적쿼리를 사용하는 2가지 방법] 
--1) DBMS_SQL 패키지
--2) EXECUTE IMMEDIATE 문 ***
--
--EXEC[UTE] IMMEDIATE 동적쿼리문 
--                   [INTO 변수명....]
--                   [USING IN/OUT/INOUT 파라미터 ,,,] 

--예) 익명프로시저 (: 문법)
DECLARE
 vsql VARCHAR2(1000);
 
 vdeptno emp.deptno%TYPE;
vempno emp. empno%TYPE;
 vename emp.ename%TYPE;
  vjob emp.job%TYPE;

BEGIN
-- 동적쿼리 작성
vsql := 'SELECT deptno, empno, ename,job ';
vsql := vsql || 'FROM emp ' ;
vsql := vsql || 'WHERE EMPNO = 7369' ;

EXECUTE IMMEDIATE vsql 
        INTO vdeptno, vempno, vename,vjob;
        
      DBMS_OUTPUT.PUT_LINE(vdeptno|| ', ' || vempno|| ', ' || vename|| ', ' || vjob);
--EXECPTION
END;

--예) 저장프로시저 

CREATE OR REPLACE PROCEDURE up_ds_emp
(
pempno emp. empno%TYPE

)
IS
 vsql VARCHAR2(1000);
 
 vdeptno emp.deptno%TYPE;
vempno emp. empno%TYPE;
 vename emp.ename%TYPE;
  vjob emp.job%TYPE;    

BEGIN
-- 동적쿼리 작성
vsql := 'SELECT deptno, empno, ename,job ';
vsql := vsql || 'FROM emp ' ;
vsql := vsql || 'WHERE EMPNO = ' || pempno ;

EXECUTE IMMEDIATE vsql 
        INTO vdeptno, vempno, vename,vjob;
        
      DBMS_OUTPUT.PUT_LINE(vdeptno|| ', ' || vempno|| ', ' || vename|| ', ' || vjob);
--EXECPTION
END;

-- 
--Procedure UP_DS_EMP이(가) 컴파일되었습니다.
EXEC UP_DS_EMP(7369);


--저장프로시저: 동적 쿼리 실행시  USING 문 사용해서 파라미터 설정.
CREATE OR REPLACE PROCEDURE up_ds_emp
(
pempno emp. empno%TYPE

)
IS
 vsql VARCHAR2(1000);
 
 vdeptno emp.deptno%TYPE;
vempno emp. empno%TYPE;
 vename emp.ename%TYPE;
  vjob emp.job%TYPE;

BEGIN
-- 동적쿼리 작성
vsql := 'SELECT deptno, empno, ename,job ';
vsql := vsql || 'FROM emp ' ;
vsql := vsql || 'WHERE EMPNO = :pem' ;

EXECUTE IMMEDIATE vsql 
        INTO vdeptno, vempno, vename,vjob
        USING IN pempno;
        
      DBMS_OUTPUT.PUT_LINE(vdeptno|| ', ' || vempno|| ', ' || vename|| ', ' || vjob);
--EXECPTION
END;

-- 문제) EXEC up_ds_insert_dept('QC', 'SEOUL');
--동적 쿼리를 사용하는 저장 프로시저 작성
CREATE OR REPLACE PROCEDURE up_ds_insert_dept
(
    pdname IN dept.dname%TYPE,
    ploc   IN dept.loc%TYPE
)
IS
    vsql    VARCHAR2(1000);
    vdeptno dept.deptno%TYPE;
BEGIN
    -- 새로운 부서번호 생성
    SELECT NVL(MAX(deptno),0) + 10
    INTO vdeptno
    FROM dept;

    -- 동적 SQL 작성
    vsql := 'INSERT INTO dept (deptno, dname, loc)
             VALUES (:1, :2, :3)';

    -- 동적 SQL 실행
    EXECUTE IMMEDIATE vsql
        USING vdeptno, pdname, ploc;

    DBMS_OUTPUT.PUT_LINE('부서가 추가되었습니다. DEPTNO = ' || vdeptno);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

DECLARE
    v_sql VARCHAR2(1000);
    v_col1 테이블.컬럼%TYPE;
BEGIN
    v_sql := 'SELECT 컬럼명
              FROM 테이블명
              WHERE 컬럼명 = :1';

    EXECUTE IMMEDIATE v_sql
        INTO v_col1
        USING 변수;
END;
/

 CREATE SEQUENCE SEQ_DEPT
 START WITH 50
 INCREMENT BY 10
 NOCACHE;
 
 
 EXEC up_ds_insert_dept('QC', 'SEOUL');
 
 SELECT *
FROM dept;

CREATE OR REPLACE PROCEDURE up_ds_insert_dept
 (
 pname IN dept.dname%TYPE
 ,ploc IN dept.loc%TYPE := NULL
 )
 IS
  vsql VARCHAR2 (1000);
 BEGIN
  VSQL := 'INSERT INTO DEPT (DEPTNO,DNAME, LOC)';
  VSQL := VSQL || 'VALUES (SEQ_DEPT.NEXTVAL, :1, :2)';
  
 EXECUTE IMMEDIATE VSQL
  USING pname, ploc;
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('> 부서 추가 완료');
  DBMS_OUTPUT.PUT_LINE('> 부서 번호: ' || SEQ_DEPT.NEXTVAL);
 EXCEPTION
  WHEN VALUE_ERROR THEN 
        ROLLBACK;
  DBMS_OUTPUT.PUT_LINE('> 입력 값의 길이 또는 자료형이 올바르지 않습니다.');
  WHEN OTHERS THEN 
  ROLLBACK;
  DBMS_OUTPUT.PUT_LINE(SQLCODE || ', ' || SQLERRM);
 END;
 
 SELECT *
FROM dept;

SELECT deptno, dname, loc
FROM dept
WHERE dname = 'QC';

EXEC up_ds_insert_dept('QC', 'SEOUL');
 
 --예) 동적쿼리: SELECT + 여러개의 조회
 -- EXECUTE IMMEDIATE 동적쿼리 문: SELECT 1개행
-- ***OPEN 커서명 FOR 동적쿼리 ***
 
CREATE OR REPLACE PROCEDURE up_ds_select_emp
(
    pdeptno emp.deptno%TYPE
)
IS
    vsql VARCHAR2(1000);

    TYPE rc IS REF CURSOR;
    vecursor rc;

    empno emp.empno%TYPE;
    ename emp.ename%TYPE;
BEGIN
    vsql := 'SELECT empno, ename
             FROM emp
             WHERE deptno = :1';

    OPEN vecursor FOR vsql USING pdeptno;

    LOOP
        FETCH vecursor INTO empno, ename;
        EXIT WHEN vecursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(empno || ', ' || ename);
    END LOOP;

    CLOSE vecursor;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' - ' || SQLERRM);
END;
/
 
 EXEC up_ds_select_emp(10);
 
 SELECT empno, ename
FROM emp
WHERE deptno = 10;
 
--풀이 2) 2가지 예외 처리..코딩 추가...
--(주의) OPEN ... FOR SELECT + FETCH 사용시 에는 조회 결과가 없어도 NO_DATA_FOUND 예외가 발생하지 않습니다.

CREATE OR REPLACE PROCEDURE up_ds_select_emp
(
    pdeptno emp.deptno%type
)
IS
    vsql VARCHAR2(1000);
    vecursor SYS_REFCURSOR;
    verow emp%ROWTYPE;
    vdeptcnt NUMBER;
    NO_EXIST_DEPTNO EXCEPTION;
BEGIN
    SELECT COUNT (*) INTO vdeptcnt
    FROM dept
    WHERE deptno = pdeptno;
    
    IF vdeptcnt = 0 THEN
    --강제예외 발생
    RAISE NO_EXIST_DEPTNO;
    END IF;
    
    vsql := 'SELECT * ';
    vsql := vsql || 'FROM emp ';
    vsql := vsql || 'WHERE deptno = :1';
    
    OPEN vecursor FOR vsql USING pdeptno;
    --사원이 존재하지 않는 경우 처리....
    FETCH vecursor INTO verow; --첫번째 사원정보 가져와서..변수에 저장.
    If vecursor%NOTFOUND THEN
        DBMS_OUTPUT.put_line('해당부서에 샤원없음');
        CLOSE vecursor;
        --프로시저 여기서 종료
        RETURN;
    END IF;
    DBMS_OUTPUT.PUT_LINE(verow.empno || ',' ||verow.ename);
    --두번째 사원부터 출력...
    LOOP
        FETCH vecursor INTO verow;
            EXIT WHEN vecursor%NOTFOUND;
                DBMS_OUTPUT.PUT_LINE(verow.empno || ',' ||verow.ename);
                
    END LOOP;
    CLOSE vecursor;
    EXCEPTION
    WHEN NO_EXIST_DEPTNO THEN --부서존재 x
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('존재하지않는 부서ㅈ번호.');
    WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE(SQLCODE || ',' || SQLERRM);
ENd;


exec up_ds_select_emp(40);
exec up_ds_select_emp(90);

-- emp 테이블에서 검색 구현 - 동적쿼리
-- 검색 조건 1.부서번호 2. 사원명 3.잡
-- 검색어

CREATE OR REPLACE PROCEDURE UP_SEARCH_EMP
(
PSEARCHCONDITION NUMBER, --검색조건
PSEARCHWORD VARCHAR2
)
IS
 VSQL VARCHAR2(1000);
 VCUR SYS_REFCURSOR;
 VROW EMP%ROWTYPE;
BEGIN

   VSQL := 'SELECT * FROM EMP WHERE 1=1 ';

    IF PSEARCHCONDITION = 1 THEN
        VSQL := VSQL || ' AND DEPTNO = :1';

    ELSIF PSEARCHCONDITION = 2 THEN
        VSQL := VSQL || ' AND REGEXP_LIKE(ENAME, :1, ''i'')';

    ELSIF PSEARCHCONDITION = 3 THEN
        VSQL := VSQL || ' AND REGEXP_LIKE(JOB, :1, ''i'')';
    END IF;

   OPEN VCUR FOR VSQL USING PSEARCHWORD;
   
     LOOP
   
   FETCH VCUR INTO VROW;
   EXIT WHEN VCUR%NOTFOUND;
   
       DBMS_OUTPUT.PUT_LINE(VROW.DEPTNO || ', ' || VROW.ENAME || ', ' || VROW.JOB);
 END LOOP;

    CLOSE VCUR;
--EXCEPTION
END;



--
EXEC UP_CREATE_TABLE('TBL_DS');

SELECT * FROM USER_TABLES;

GRANT UP_CREATE_TABLE


CREATE OR REPLACE PROCEDURE up_create_table
(
    p_table_name IN VARCHAR2
)
IS
    vsql VARCHAR2(1000);
    vcnt NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO vcnt
      FROM user_tables
     WHERE table_name = UPPER(p_table_name);

    IF vcnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('이미 존재하는 테이블입니다.');
        RETURN;
    END IF;
-- 테이블 뿐 아니라 컬럼명+ 자료형 도 동적으로 생성가능
-- 테이블 명 매개변수로 받고 , 여러개의 컬럼명 + 자료형을 하나의 문자열로 받아서 VSQL 연결해서 처리한다. 
--(주의) 테이블 명, 컬럼명, 자료형은 USING 문을 사용해 파라미터 전달 받을 수 없다. 
    vsql :=
        'CREATE TABLE ' || p_table_name || '
        (
            id NUMBER PRIMARY KEY,
            name VARCHAR2(100),
            regdate DATE DEFAULT SYSDATE
        )';

    EXECUTE IMMEDIATE vsql;

    DBMS_OUTPUT.PUT_LINE('테이블 생성 완료.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/