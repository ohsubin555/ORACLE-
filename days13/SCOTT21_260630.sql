
CREATE OR REPLACE PROCEDURE updeletetbldept  
(
    pdeptno tbl_dept.deptno%TYPE := NULL
)
IS
BEGIN
    IF pdeptno IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000, '>> 부서번호를 입력해주세요.');
    END IF;
    DELETE FROM tbl_dept
    WHERE deptno = pdeptno;
    COMMIT;        
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE);
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
        ROLLBACK;
END;



EXEC upupdatetbldept( 80, 'X', 'Y' );  -- 이름 지역명 다 수정
EXEC upupdatetbldept( pdeptno=>80,  pdname=>'QC3' );  -- 부서명 수정
EXEC upupdatetbldept( pdeptno=>80,  ploc=>'SEOUL' );  -- 지역명 수정


CREATE OR REPLACE PROCEDURE upupdatetbldept
(
    pdeptno tbl_dept.deptno%TYPE,
    pdname  tbl_dept.dname%TYPE DEFAULT NULL,
    ploc    tbl_dept.loc%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE tbl_dept
    SET dname = NVL(pdname, dname),
        loc   = NVL(ploc, loc)
    WHERE deptno = pdeptno;

    COMMIT;
END;
-- 풀이 1번

CREATE OR REPLACE PROCEDURE upupdatetbldept
(
   pdeptno IN tbl_dept.deptno%TYPE, 
   pdname IN tbl_dept.dname%TYPE := null, 
   ploc IN tbl_dept.loc%TYPE := null
)
IS
   vdname tbl_dept.dname%TYPE;
   vloc  tbl_dept.loc%TYPE;
BEGIN
  SELECT dname, loc INTO vdname, vloc  -- 수정 전 원래 부서명, 지역명 
  FROM tbl_dept
  WHERE deptno = pdepto;
  
  IF pdname IS NULL THEN
     pdname := vdname;
  END IF;
  
  IF ploc IS NULL THEN
     ploc := vloc;
  END IF;
  
  UPDATE tbl_dept
  SET dname = pdname, loc = ploc
  WHERE deptno = pdeptno;
   
  COMMIT;
--EXCEPTION
--    ROLLBACK;
END;

--2번 
CREATE OR REPLACE PROCEDURE upupdatetbldept
(
   pdeptno IN tbl_dept.deptno%TYPE, 
   pdname IN tbl_dept.dname%TYPE := null, 
   ploc IN tbl_dept.loc%TYPE := null
)
IS
   
BEGIN
 
  UPDATE tbl_dept
  SET dname = CASE WHEN pdname IS NULL THEN dname
  ELSE pdname
  END , loc = NVL(ploc,loc)
  WHERE deptno = pdeptno;
   
  COMMIT;
--EXCEPTION
--    ROLLBACK;
END;

SELECT *
FROM tbl_dept;

----------------
-- 예) 명시적 커서를 사용해서 모든 부서원 출력(조회)  upselecttblemp
CREATE OR REPLACE PROCEDURE upupdatetbldept
(
   pdeptno IN tbl_dept.deptno%TYPE := null
)
IS 
  --1) 커서 선언
  CURSOR vecursor IS (
                   SELECT *
                   FROM tbl_emp
                   WHERE deptno = NVL( pdeptno, 10 )
  );
  
  verow tbl_emp%ROWTYPE;
BEGIN  
  --2) 커서 실행 OPEN
  OPEN vecursor;  
  -- 3) FETCH 반복 처리
  LOOP
     FETCH vecursor INTO verow;
     EXIT WHEN vecursor%NOTFOUND;
     DBMS_OUTPUT.PUT( vecursor%ROWCOUNT || ' : '  );
     DBMS_OUTPUT.PUT_LINE( verow.deptno || ', ' || verow.ename 
      || ', ' ||  verow.hiredate);  
  END LOOP;
  -- 4) 커서 CLOSE
  CLOSE vecursor;
--EXCEPTION
--    ROLLBACK;
END;

--
EXEC UPUPDATETBLDEPT;
EXEC UPUPDATETBLDEPT(30);
EXEC UPUPDATETBLDEPT(90); --  없는 부서를 매개변수로 호출하면 예외 처리...
--



-- 풀이 2

CREATE OR REPLACE PROCEDURE upselecttblemp
(
   pdeptno IN tbl_emp.deptno%TYPE := NULL
)
IS
   -- 🔷 커서에 파라미터 선언
   CURSOR vecursor (v_deptno tbl_emp.deptno%TYPE) IS
      SELECT *
      FROM tbl_emp
      WHERE deptno = v_deptno;

   verow tbl_emp%ROWTYPE;
BEGIN
   -- 커서 OPEN 할 때 값 전달
   OPEN vecursor(NVL(pdeptno, 10));

   LOOP
      FETCH vecursor INTO verow;
      EXIT WHEN vecursor%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE(
         vecursor%ROWCOUNT || ' : ' ||
         verow.deptno || ', ' ||
         verow.ename || ', ' ||
         verow.hiredate
      );
   END LOOP;

   CLOSE vecursor;
END;


-- 풀이3 


CREATE OR REPLACE PROCEDURE upselectinsa
(
 pnum IN insa.num%TYPE,
 pname OUT insa.name%TYPE
, pSSNOUT insa.deptno%TYPE 
)
IS
 VSSN INSA.SSN%TYPE;
BEGIN
   select NAME, SSN INTO PNAME , PSSM
   FROM INSA
   WHERE NUM = PNUM;

RPAD(SUBSTR(VSSN,0,8),14,'*');

END;


-- 예) IN, OUT, IN OUT
--     사원번호를 입력용 파라미터로 넘겨서 저장 프로시저를 호출하면 
--    사원이름과 주민번호를 출력용 파라미터로 반환하는 저장 프로시저를 생성.
CREATE OR REPLACE PROCEDURE upselectinsa
(
   pnum IN insa.num%TYPE,
   pname OUT insa.name%TYPE,
   pssn OUT insa.ssn%TYPE
)
IS  
  vssn insa.ssn%TYPE;
BEGIN 
  -- 000000-******
   SELECT name, ssn INTO pname, vssn
   FROM insa
   WHERE num = pnum;   
   pssn := RPAD(SUBSTR(vssn, 0, 8), 14, '*');
--EXCEPTION 
END;

-- 출력용 파라미터 확인
DECLARE
   vname insa.name%TYPE;
   vssn insa.ssn%TYPE;
BEGIN
   UPSELECTINSA(1001, vname, vssn);
   DBMS_OUTPUT.PUT_LINE( vname || ' , ' || vssn );
END;

--
-- 테스트
DECLARE
  vssn VARCHAR2(14) := '910223-1700001';
BEGIN
   UPIOTEST(vssn);
   DBMS_OUTPUT.PUT_LINE( vssn ); 
END;




DROP TABLE tbl_score PURGE;
CREATE TABLE tbl_score
(
     num   NUMBER(4) PRIMARY KEY
   , name  VARCHAR2(20)
   , kor   NUMBER(3)  
   , eng   NUMBER(3)
   , mat   NUMBER(3)  
   , tot   NUMBER(3)
   , avg   NUMBER(5,2)
   , rank  NUMBER(4) 
   , grade CHAR(1 CHAR)
);


--
CREATE SEQUENCE seq_tbl_score;

EXEC up_insertscore( '홍길동', 89,44,55 );
EXEC up_insertscore( '윤재민', 49,55,95 );
EXEC up_insertscore( '김도균', 90,94,95 );
EXEC up_insertscore( '이시훈', 89,75,15 );
EXEC up_insertscore( '송세호', 67,44,75 );
EXEC up_insertscore( '서영학', 100,100,100 );

CREATE OR REPLACE PROCEDURE up_insertscore
(
      pname VARCHAR2
    , pkor  NUMBER := 0
    , peng  NUMBER := 0
    , pmat  NUMBER := 0
)
IS 
   vtot NUMBER(3) := 0;
   vavg NUMBER(5,2) ;
   vgrade tbl_score.grade%TYPE;
BEGIN
    vtot := pkor + peng + pmat;
    vavg := vtot/3;
    -- 평균이 90이상 A, 80 이상 B, 70 C  ~ F
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;

    INSERT INTO tbl_score (num, name, kor, eng, mat, tot, avg, rank, grade )
    VALUES ( SEQ_TBL_SCORE.NEXTVAL, pname, pkor, peng, pmat, vtot,vavg, 1, vgrade );
    
    -- 등수처리하는 프로시저 또는 함수를 호출
--    UP_RANKSCORE;
    
    COMMIT;
-- EXCEPTION
END;

SELECT *
FROM TBL_SCORE;

EXEC up_updateScore( 6, 0, 0, 0 );
EXEC up_updateScore( 1, 100, 100, 100 );
EXEC up_updateScore( 1, pkor =>34 );
EXEC up_updateScore( 1, pkor =>34, pmat => 90 );
EXEC up_updateScore( 1, peng =>45, pmat => 90 );

create or replace PROCEDURE up_updateScore
(
      pnum  NUMBER
    , pkor  NUMBER := NULL
    , peng  NUMBER := NULL
    , pmat  NUMBER := NULL
)
IS 
   vtot NUMBER(3) := 0;
   vavg NUMBER(5,2) ;
   vgrade tbl_score.grade%TYPE;

   vkor NUMBER(3); -- 수정 전의 원래 점수값
   veng NUMBER(3); -- 수정 전의 원래 점수값
   vmat NUMBER(3); -- 수정 전의 원래 점수값
BEGIN
    SELECT kor, eng, mat INTO vkor, veng, vmat
    FROM tbl_score
    WHERE num = pnum;

    vtot := NVL( pkor, vkor ) + NVL( peng, veng) + NVL(pmat, vmat);
    vavg := vtot/3;
    -- 평균이 90이상 A, 80 이상 B, 70 C  ~ F
    IF vavg >= 90 THEN vgrade := 'A';
    ELSIF vavg >= 80 THEN vgrade := 'B';
    ELSIF vavg >= 70 THEN vgrade := 'C';
    ELSIF vavg >= 60 THEN vgrade := 'D';
    ELSE vgrade := 'F';
    END IF;

    UPDATE tbl_score
    SET kor = NVL( pkor, vkor ), eng=NVL( peng, veng)
    , mat = NVL(pmat, vmat), tot = vtot, avg = vavg, grade=vgrade
    WHERE num = pnum;

    -- 등수처리하는 프로시저 또는 함수를 호출
--    UP_RANKSCORE;
    
    COMMIT;
-- EXCEPTION
END;


CREATE OR REPLACE PROCEDURE up_rankscore
IS
BEGIN
  UPDATE tbl_score p
  SET rank = ( SELECT COUNT(*)+1 FROM tbl_score WHERE p.tot < tot );
  COMMIT;
-- EXCEPTION
END;

EXECUTE UP_RANKSCORE;

---------------

DECLARE
  CURSOR c IS
    SELECT empno, ename FROM emp;

  vempno emp.empno%TYPE;
  vename emp.ename%TYPE;

BEGIN
  OPEN c;

  LOOP
    FETCH c INTO vempno, vename;
    EXIT WHEN c%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(vempno || ' ' || vename);
  END LOOP;

  CLOSE c;
END;
/

--

DECLARE
  CURSOR up_selecttblscore IS
   SELECT NUM,NAME,KOR,ENG,MAT,TOT,AVG,RANK,GRADE
  FROM TBL_SCORE ;
 v_name VARCHAR2(20);
  VNUM NUMBER(1);
  VNAME VARCHAR2(10);
  VKOR NUMBER(3);
  VENG NUMBER(3);
  VMAT NUMBER(3);
  VAVG NUMBER(3);
  VTOT NUMBER(3);
  VRANK NUMBER(3);
  VGRADE CHAR(1);
  
BEGIN
  OPEN up_selecttblscore;

  LOOP
    FETCH up_selecttblscore INTO VNUM,VNAME,VKOR,VENG,VMAT,VTOT,VAVG,VRANK,VGRADE;

    EXIT WHEN up_selecttblscore%NOTFOUND;

 DBMS_OUTPUT.PUT_LINE(VNUM  || ' ' || VNAME  || ' ' || VKOR  || ' ' || VENG  || ' '|| VMAT  || ' ' || VTOT   || ' '|| VAVG  || ' ' ||  VRANK  || ' ' || VGRADE);
  END LOOP;

  CLOSE up_selecttblscore;
END;



CREATE OR REPLACE PROCEDURE up_selectscore
(
PECURSOR OUT SYS_REFCURSOR
)
IS 
BEGIN
OPEN PECURSOR FOR
 SELECT * FROM tbl_score ORDER BY rank;
END;

 -- CUR: HOST VARIABLE (:)
VARIABLE CUR REFCURSOR
EXEC UP_SELECTSCORE(:CUR);
PRINT CUR;
  
  
  SELECT NAME, UF_GENDER(SSN) GENDER, UF_AGE(SSN) 만나이
  FROM INSA;
  
  --
  
  CREATE OR REPLACE FUNCTION UF_GENDER 
  (  
  PSSN VARCHAR2)
  
  RETURN VARCHAR2
  IS
  VGENDER VARCHAR2(6) := '남자';
  
  BEGIN
  IF  MOD(  SUBSTR( pssn, -7, 1 ), 2 ) = 0 THEN
     vgender := '여자';
  END IF;
  RETURN vgender;  
--  EXCEPTION
  END;
------------------------------------



   CREATE OR REPLACE FUNCTION UF_AGE 
  (  
  PSNN VARCHAR2,
  PTYPE NUMBER
  
  RETURN NUMBER
   IS
   VCURRENT_YEAR NUMBER(4) := TO_CHAR( SYSDATE, 'YYYY' );
    Vbirth_year NUMBER(4)
 BEGIN
 CREATE OR REPLACE FUNCTION uf_age
(
   pssn VARCHAR2, 
   ptype NUMBER   -- 0 세는 나이, 1 만 나이
)
RETURN NUMBER
IS
   vcurrent_year NUMBER(4) := TO_CHAR( SYSDATE, 'YYYY' );
   vbirth_year NUMBER(4);
    vcountingage NUMBER(3);  -- 세는 나이
    vamericanage NUMBER(3);  -- 만 나이
BEGIN
   vbirth_year := CASE
                       WHEN SUBSTR( pssn, -7, 1) IN ( 1,2,5,6 ) THEN 1900
                       WHEN REGEXP_LIKE( SUBSTR( pssn, -7, 1), '[3478]' ) THEN 2000
                       ELSE 1800
                  END +  SUBSTR( pssn, 1, 2 ) ;
                  
  vcountingage := vcurrent_year - vbirth_year + 1;
  IF ptype = 0 THEN  -- 세는 나이 반환
    return  vcountingage;
  ELSIF ptype = 1 THEN -- 만나이 반환   
   vamericanage :=   vcountingage -1 + 
   
--   DECODE( SIGN(  TO_CHAR( SYSDATE, 'MMDD' ) - SUBSTR( ssn, 3, 4 ) ),  -1, -1,  0 )
   CASE SIGN(TO_CHAR(SYSDATE, 'MMDD') -SUBSTR(PSSN, 3, 4)
   WHEN -1 THEN -1
   ELSE 0
   END;
   return vcountingage;
  END IF;
   
  -- 세는 나이 = 올해년도 - 생일년도 + 1
  -- 만   나이 = 세는나이 - 생일지나지않으면 1

--EXCEPTION
END;
 
 
   RETURN;
   END;
   
   CREATE OR REPLACE FUNCTION uf_age
(
   pssn VARCHAR2,
   ptype NUMBER
)
RETURN NUMBER
IS
   vcurrent_year NUMBER := TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'));
   vbirth_year   NUMBER;

   vcountingage  NUMBER;
   vamericanage  NUMBER;
BEGIN
   vbirth_year :=
      CASE
         WHEN SUBSTR(pssn, 7, 1) IN ('1','2','5','6') THEN 1900
         WHEN SUBSTR(pssn, 7, 1) IN ('3','4','7','8') THEN 2000
         ELSE 1800
      END
      + SUBSTR(pssn, 1, 2);

   vcountingage := vcurrent_year - vbirth_year + 1;

   IF ptype = 0 THEN
      RETURN vcountingage;

   ELSIF ptype = 1 THEN
      vamericanage :=
         vcountingage - 1 +
         DECODE(SIGN(TO_CHAR(SYSDATE,'MMDD') - SUBSTR(pssn,3,4)),
                -1, -1,
                 0, 0,
                 1, 0);

      RETURN vamericanage;
   END IF;

   RETURN NULL;
END;
/


 -- [문제] ssn ->  "1998.01.20(화)"  uf_birth
CREATE OR REPLACE FUNCTION uf_birth
(  
   pssn VARCHAR2
)
RETURN VARCHAR2
IS 
   vcentry NUMBER(2);  -- 18, 19, 20
   vbirth VARCHAR2(20); -- "1998.01.20(화)"
BEGIN      
   vbirth := SUBSTR(pssn, 0, 6);  --  771212
   vcentry := CASE 
               WHEN SUBSTR(pssn, -7,1) IN (1,2,5,6) THEN 19
               WHEN SUBSTR(pssn, -7,1) IN (3,4,7,8) THEN 20
               ELSE 18 
             END;
  vbirth :=  vcentry ||  vbirth;  -- '19771212'
  vbirth :=  TO_CHAR( TO_DATE( vbirth ), 'YYYY.MM.DD(DY)');
  RETURN (vbirth);
--EXCEPTION
END;    
