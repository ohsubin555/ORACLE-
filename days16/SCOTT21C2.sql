--로그인 처리 / emp 테이블
-- 아이디 [  ] : empno
--비번 [ ] : ename
--[로그인] [회원가입]




CREATE OR REPLACE PROCEDURE up_idcheck
(
  pid IN emp.empno%TYPE
)
IS
vcheck NUMBER(1);
ex_duplicate_id EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO vcheck
  FROM emp
  WHERE empno = pid;
  
  IF vcheck > 0 THEN
  RAISE ex_duplicate_id;
  END IF;
EXCEPTION
WHEN ex_duplicate_id THEN RAISE_APPLICATION_ERROR ( -20001, '이미 사용중인 번호입니다.');
WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            '예상하지 못한 오류가 발생했습니다. (' || SQLCODE || ') ' || SQLERRM
        );
END;

DECLARE
  vcheck NUMBER(1);
BEGIN
  UP_IDCHECK(9999, vcheck);
  DBMS_OUTPUT.PUT_LINE( vcheck );
END;





CREATE OR REPLACE PROCEDURE up_selectdept
(
   pdeptcursor OUT SYS_REFCURSOR 
)
IS
 
    
BEGIN
   OPEN pdeptcursor FOR 
   
    select *
    from dept
    where deptno > 0;
 
--    EXCEPTION
  
END;
/

Create 

-- up_updatedept 수정할 부서번호, 부서명, 지역명 

CREATE OR REPLACE PROCEDURE up_updatedept
(
    p_deptno IN dept.deptno%TYPE,
    p_dname  IN dept.dname%TYPE,
    p_loc    IN dept.loc%TYPE
)
IS
    vcheck NUMBER;
BEGIN
    -- 부서 존재 여부 확인
    SELECT COUNT(*)
    INTO vcheck
    FROM dept
    WHERE deptno = p_deptno;

    IF vcheck = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, '존재하지 않는 부서번호입니다.');
    END IF;

    -- NULL이 전달되면 기존 값 유지
    UPDATE dept
    SET dname = NVL(p_dname, dname),
        loc   = NVL(p_loc, loc)
    WHERE deptno = p_deptno;

    COMMIT;
END;



CREATE OR REPLACE PROCEDURE up_insertdept
(
    pdname IN dept.dname%TYPE := null,
    ploc   IN dept.loc%TYPE := null
)
IS
    ex_duplicate_dname EXCEPTION;
    vcnt NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO vcnt
    FROM dept
    WHERE dname = pdname;

    IF vcnt > 0 THEN
        RAISE ex_duplicate_dname;
    END IF;

    INSERT INTO dept(deptno, dname, loc)
    VALUES (seq_dept.NEXTVAL, pdname, ploc);
    
    commit;

EXCEPTION
    WHEN ex_duplicate_dname THEN
        raise_application_error(-20001, '동일한 부서명이 존재합니다.');
        WHEN OTHERS THEN 
        RAISE;
END;

DROP PROCEDURE up_updatedept;

--

CREATE OR REPLACE PROCEDURE up_updatedept 
(
    pdeptno dept.deptno%TYPE, 
    pdname  dept.dname%TYPE  DEFAULT NULL,
    ploc    dept.loc%TYPE  DEFAULT NULL
)
IS
    vcnt NUMBER;
    ex_invalid_deptno EXCEPTION;
    ex_invalid_dname_loc EXCEPTION;
BEGIN


    SELECT COUNT(*) INTO vcnt
    FROM dept 
    WHERE deptno = pdeptno;
    
    IF vcnt = 0 THEN
        RAISE ex_invalid_deptno;
    ELSE 
        UPDATE dept 
        SET dname = NVL(pdname, dname), 
            loc   = NVL(ploc, loc) 
        WHERE deptno = pdeptno;    
    END IF; 
EXCEPTION
    WHEN ex_invalid_deptno THEN
      RAISE_APPLICATION_ERROR(
            -20001,
            '존재하지 않는 부서입니다.'
        );    
    
    WHEN OTHERS THEN
        RAISE ;    
END; 

-- TEST CODE
EXEC up_updatedept(pdeptno => 40, pdname=>'OPERATIONS',  ploc => 'BOSTON');
EXEC up_updatedept(pdeptno => 40, pdname=>'SALES');
EXEC up_updatedept(pdeptno => 40, ploc => 'SEOUL');
EXEC up_updatedept(pdeptno => 40, pdname=>'SALES',  ploc => 'SEOUL');
EXEC up_updatedept(pdeptno => 40);


CREATE OR REPLACE PROCEDURE up_searchdept
(
psearchCondition VARCHAR2,
psearchKeyword VARCHAR2,
pcur OUT SYS_REFCURSOR
)
IS
 vsql VARCHAR2(1000); --동적쿼리
BEGIN
vsql := 'SELECT * FROM dept WHRER';
IF psearchCondition = 'd' THEN
    vsql := vsql || 'deptno = :1';
  ELSIF psearchCondition = 'n' THEN
    vsql := vsql || 'REGEXP_LIKE( dname, :1, ''i'') ';
  ELSIF psearchCondition = 'l' THEN
    vsql := vsql || 'REGEXP_LIKE( loc, :1, ''i'') ';
  ELSIF psearchCondition = 'nl' THEN
    vsql := vsql || 'REGEXP_LIKE( dname, :1, ''i'') OR REGEXP_LIKE( loc, :2, ''i'') ';
    ELSE 
            RAISE_APPLICATION_ERROR(
            -20002,
            '잘못된 검색조건입니다.'
        );
  END IF;
  vsql := vsql || ' ORDER BY deptno ASC ';
  
   IF psearchCondition = 'nl' THEN
    OPEN pcur FOR vsql USING psearchKeyword, psearchKeyword;
  ELSE
    OPEN pcur FOR vsql USING psearchKeyword;
  END IF; 
  
EXCEPTION
 WHEN OTHERS THEN
   RAISE;
END;