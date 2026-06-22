-- SCOTT --
-- ■ 풀이 1
SELECT * 
FROM (
    SELECT TRUNC( (no-1)/3 ) +1 s_id
          , name
          , jumsu
          , DECODE( MOD( no, 3), 1, '국어', 2, '영어', 0, '수학' ) AS subject
    FROM tbl_pivot
)
PIVOT(
   MAX(jumsu)
   FOR subject
   IN ( '국어', '영어', '수학'   )
);
-- ■ 풀이 2
SELECT * 
FROM (
  SELECT TRUNC( (no-1)/3 ) +1 s_id
          , name
          , jumsu
          , ROW_NUMBER() OVER( PARTITION BY name ORDER BY no ) subject
  FROM tbl_pivot
)
PIVOT(
   MAX(jumsu)
   FOR subject
   IN ( 1 AS "국어", 2 AS "영어", 3 AS "수학"   )
)
ORDER BY s_id ASC;
--------------------------------------------------------------------------------
-- ■ 부서별, 직무별, 사원수를 조회 쿼리 작성...
-- 1)
SELECT deptno, job,  COUNT(*)
FROM emp
GROUP BY deptno, job
ORDER BY deptno, job;
-- 2) 직무의 5종류
SELECT DISTINCT job
FROM emp;
-- 3)
WITH jobs AS (
  SELECT DISTINCT job
  FROM emp
)
SELECT deptno
      , j.job
      , COUNT(*)
FROM emp e RIGHT OUTER JOIN jobs j ON e.job = j.job
GROUP BY deptno, j.job
ORDER BY deptno, j.job; 
-- 4) 10(5)+ 20(5) + 30(5) UNION ALL
WITH jobs AS (
  SELECT DISTINCT job
  FROM emp
)
SELECT 10 
      , j.job
      , COUNT( empno )
FROM emp e RIGHT OUTER JOIN jobs j ON e.job = j.job AND e.deptno = 10
GROUP BY deptno, j.job
UNION ALL
SELECT 20 
      , j.job
      , COUNT( empno )
FROM emp e RIGHT OUTER JOIN jobs j ON e.job = j.job AND e.deptno = 20
GROUP BY deptno, j.job
UNION ALL
SELECT 30 
      , j.job
      , COUNT( empno )
FROM emp e RIGHT OUTER JOIN jobs j ON e.job = j.job AND e.deptno = 30
GROUP BY deptno, j.job;
-- 5) Oracle PARTITIONED RIGHT OUTER JOIN
--     ㄴ OUTER JOIN의 확장 기능
--     ㄴ 부서별로 각 10/20/30 등 파티션을 나누고 파티션 별로 OUTER JOIN .
--     ㄴ 각 부서별 직무가 없는 정보도 출력할 때 많이 사용한다. 
--    ㄴ 형식
--       FROM 사원 PARTITION BY(deptno 컬럼명)  RIGHT/LEFT/FULL OUTER JOIN 직문  ON 조인조건
WITH jobs AS (
  SELECT DISTINCT job
  FROM emp
)
SELECT deptno
      , j.job
      , COUNT( empno )
FROM emp e PARTITION BY(deptno) RIGHT OUTER JOIN jobs j ON e.job = j.job
GROUP BY deptno, j.job
ORDER BY deptno, j.job; 
WITH jobs AS (
  SELECT DISTINCT job
  FROM emp
)
SELECT deptno
      , j.job
      , COUNT( empno )
FROM emp e PARTITION BY(deptno) RIGHT OUTER JOIN jobs j ON e.job = j.job
GROUP BY deptno, j.job
ORDER BY deptno, j.job;
----------------------------------------------------------------------------------
--[ 실무 활용]
--partitioned Outer Join은 주로 데이터 웨어하우스(DW) 나 통계 보고서에서 사용됩니다.
--
--예시:
--월별 매출 집계
--일별 접속 통계
--부서별 직급 현황 ***
--상품별 월별 판매 실적
--고객별 구매 이력

-- ■ 문제: emp 테이블에서 각 년도별 입사한 사원수 조회
SELECT emp.*
      , TO_CHAR( hiredate, 'YYYY') h_year
FROM emp;
-- 풀이1) 
SELECT  TO_CHAR( hiredate, 'YYYY') h_year, COUNT(*) 
FROM emp
GROUP BY TO_CHAR( hiredate, 'YYYY')
ORDER BY h_year;

-- -- ■ 문제: emp 테이블에서 각 년도별, 월별 입사한 사원수 조회
-- 풀이1) 
SELECT  TO_CHAR( hiredate, 'YYYY') h_year
        , TO_CHAR( hiredate, 'MM') h_month
        , COUNT(*) 
FROM emp
GROUP BY TO_CHAR( hiredate, 'YYYY'), TO_CHAR( hiredate, 'MM')
ORDER BY h_year, h_month;

-- 풀이2)
SELECT e.h_year, m.month , COUNT(empno)
FROM (
          SELECT empno
                , TO_CHAR( hiredate, 'YYYY') h_year
                , TO_CHAR( hiredate, 'MM') h_month
          FROM emp
      ) e
      PARTITION BY ( e.h_year ) -- 년도별로
      RIGHT JOIN (            -- 1~12 월  
        SELECT LEVEL month
        FROM dual
        CONNECT BY LEVEL <= 12
      )  m
      ON e.h_month = m.month
GROUP BY e.h_year, m.month      
ORDER BY e.h_year, m.month;

-- 풀이 3)
WITH e AS (
        SELECT empno
                    , TO_CHAR( hiredate, 'YYYY') h_year
                    , TO_CHAR( hiredate, 'MM') h_month
              FROM emp
    )
    , m AS (
        SELECT LEVEL month
        FROM dual
        CONNECT BY LEVEL <= 12
    )
SELECT e.h_year, m.month , COUNT(empno)
FROM e PARTITION BY ( e.h_year ) RIGHT JOIN   m ON e.h_month = m.month
GROUP BY e.h_year, m.month      
ORDER BY e.h_year, m.month;
--------------------------------------------------------------------------------
-- ■ 오라클 자료형

-- 1) CHAR[(size [BYTE|CHAR])]:  고정길이, 1~2000 바이트
--CHAR
--CHAR(1)
--CHAR(1 BYTE)
--CHAR(1 CHAR)

-- 예) 고정길이       CHAR(100) == CHAR(100 BYTE)
--                   [a][b][][][][] ... []     
create table tbl_char (aa char, bb char(3), cc char(3 char));
-- CHAR == CHAR(1) == CHAR(1 BYTE)
-- CHAR(3) == CHAR(3 BYTE)
INSERT INTO tbl_char VALUES ( '한', 'abc', 'abc');
INSERT INTO tbl_char VALUES ( '한', 'abc', '홍길동');
-- CHAR(3)   CHAR(3 CHAR) 차이점

-- 2) NCHAR([SIZE]): N 유니코드 + CHAR, 고정길이, 1~2000 바이트
--  NCHAR == NCHAR(1)

-- 3) VARCHAR2(SIZE [BYTE|CHAR]):  VAR+CHAR, 가변길이, 1~4000 바이트
--    VARCHAR2(100) ==VARCHAR2(100 BYTE)
--    [a][b]
--    VARCHAR == VARCHAR2

-- 4) NVARCHAR2(SIZE): N(유니코드) + VAR(가변길이) + CHAR, 1~4000 바이트
DESC emp;
--ENAME             VARCHAR2(10) == VARCHAR2(10 BYTE)  '김홍길동님' 15바이트
--INSERT INTO emp ( empno, ename ) VALUES ( 9999, '김홍길동님' );
--JOB               VARCHAR2(9)  == VARCHAR2(9 BYTE)

-- 5) NUMBER[(p,[s])]   숫자( 정수, 실수 )
--            p: precision 정밀도     1~38  
--            s: scale               -84~127
--    NUMBER == NUMBER( 38, 127 )
CREATE TABLE tbl_number (
   kor NUMBER(3)  -- NUMBER(3,0) 
   , avg NUMBER(5,2)
);
INSERT INTO tbl_numer VALUES ( 9.72 , 88.78 ); -- 소수점 1번째 반올림
INSERT INTO tbl_numer VALUES ( 9.12 , 88.78 );
INSERT INTO tbl_numer VALUES ( 999.999 , 88.78 );
INSERT INTO tbl_numer VALUES ( 999 , 88.78 );
INSERT INTO tbl_numer VALUES ( -999 , -88.78 );
SELECT * FROM tbl_numer;
실제 데이터 NUMBER 선언 저장되는 값 
123.89 NUMBER 123.89 
123.89 NUMBER(3) 124 
123.89 NUMBER(3,2) precision을 초과 
123.89 NUMBER(4,2) precision을 초과 
123.89 NUMBER(5,2) 123.89 
123.89 NUMBER(6,1) 123.9 
123.89 NUMBER(6,-2) 100 
.01234 NUMBER(4,5) .01234 
.00012 NUMBER(4,5) .00012 
.000127 NUMBER(4,5) .00013 
.0000012 NUMBER(2,7) .0000012 
.00000123 NUMBER(2,7) .0000012 
1.2e-4 NUMBER(2,5) 0.00012 
1.2e-5 NUMBER(2,5) 0.00001 

-- 6) FLOAT[(p)]
-- 7) LONG :  가변길이 문자열, 2GB
--   c(2천) nc(2천)   vc2(4천) nvc2(4천)
--   예) 게시판
--       글내용  LONG  2GB 가변길이 문자열 저장
-- 8) DATE 날짜/시간: 년/월/일/시간/분/초  정보를 저장
--    TIMESTAMP    :              "    나노초 + 시간대

-- 9) RAW(size) : 이진데이터    2000 바이트
--    ,LONG RAW :               2GB

-- 10) LOB == Large OBject
CLOB   Char+ 문자열 
NCLOB  NC  + 문자열
BLOB   Binary  
-- 11) BFILE  : 2진 데이트  + 외부 파일형식으로 저장( 4GB )
DESC emp;
--------------------------------------------------------------------------------
-- ■ 테이블 생성, 수정, 삭제
--         DDL문:   CREATE, ALTER, DROP
--                 CREATE TABLE, ALTER TABLE, DROP TABLE
--                 CREATE USER,  ALTER USER,  DROP USER
--                 CREATE DB객체명, ALTER DB객체명, DROP DB객체명
-- 예) 아이디/이름/나이/연락처/생일/비고
-- 회원을 구분할 수 있는 고유한 키( PK ): 아이디
아이디 id     문자(가)    VARCHAR2(10)
이름  name    문자(가)    VARCHAR2(20)
나이  age     숫자(정수)  NUMBER(3)
연락처 tel    문자(가/고)  VARCHAR2(20)
생일  birth   날짜       DATE
비고  etc     문자(가)   LONG 
-- tbl_sample 테이블 생성
SELECT * 
FROM tabs
WHERE REGEXP_LIKE( table_name , '^tbl_sam', 'i' ) ;
WHERE table_name LIKE 'TBL\_SAM%' ESCAPE  '\';
-- 
CREATE TABLE tbl_sample(
    id VARCHAR2(10) PRIMARY KEY
    , name VARCHAR2(20)
    , age NUMBER(3)
    -- 연락처 tel    문자(가/고)  VARCHAR2(20)          테이블 생성 후  컬럼 추가
    , birth  DATE
    -- 비고  etc     문자(가)   LONG 
);
--
SELECT * 
FROM tbl_sample;

-- 테이블 생성 후에 컬럼을 추가( 연락처, 비고 컬럼 )
-- 테이블 수정: ALTER TABLE 문
• alter table ... add 컬럼/제약조건    : 컬럼, 제약조건 추가
• alter table ... modify 컬럼         : 컬럼 수정
• alter table ... drop[constraint] 제약조건 : 제약조건 삭제
• alter table ... drop column 컬럼    : 컬럼 삭제

-- 예) 연락처, 비고 2개의 컬럼 추가
ALTER TABLE tbl_sample
ADD ( 
        tel VARCHAR2(20)       --DEFAULT '000-0000-0000'
        , bigo VARCHAR2(255)
    );
DESC tbl_sample;
-- [ 컬러명  bigo -> memo 컬럼명을 수정]
--1) bigo 컬럼명을 memo 별칭으로 
SELECT name , bigo as memo
FROM tbl_sample
-- 2) 
ALTER TABLE tbl_sample
RENAME COLUMN bigo TO memo;
DESC tbl_sample;
-- [ memo 컬럼의    VARCHAR2(255)  -> 100 크기를 수정.]
ALTER TABLE tbl_sample
MODIFY ( memo VARCHAR2(100) );
-- MEMO           VARCHAR2(100)

-- [ 컬럼 삭제 - memo ]
ALTER TABLE tbl_sample
DROP COLUMN memo; -- 한 개씩 삭제 가능 
DESC tbl_sample;
-- [ 테이블이름  tbl_sample -> tbl_example 수정]
RENAME tbl_sample TO tbl_example;

-- 예) 게시판 테이블 생성 + CRUD 
DROP TABLE tbl_board PURGE;
-- NOT NULL 필수입력항목, 
CREATE TABLE tbl_board(
  seq NUMBER(38) NOT NULL PRIMARY KEY -- 글번호 NN제약조건  PK= UK + NN + 시퀀스 
  --  seq NUMBER GENERATED ALWAYS AS IDENTITY, 오라클 12C 이상에서 자동증가시킴. 
  , writer VARCHAR2(20) NOT NULL -- 작성자
  , password VARCHAR2(15) NOT NULL -- 비밀번호
  , title VARCHAR2(100) NOT NULL -- 제목
  , content CLOB -- 내용
  , regdate DATE DEFAULT SYSDATE -- 작성일
);
-- 조회수(readed) 컬럼 추가:  NUMBER(38) 기본값 0 
ALTER TABLE tbl_board
ADD ( readed NUMBER(38) DEFAULT 0 );
--
DESC tbl_board;
-- 새로운 게시글을 추가
INSERT INTO tbl_board (seq, writer, password, title) 
VALUES ( 1, '홍길동', '1234', '점심 뭐 먹지?' );
INSERT INTO tbl_board VALUES ( 2, '서무식', '1234', '강북 사람', null, SYSDATE, 0 );
-- 새로운 게시글을 추가: seq 글번호 컬럼값은 시퀀스 자동 증가...처리.
CREATE SEQUENCE seq_tblboard
START WITH 4;
-- Sequence SEQ_TBLBOARD이(가) 생성되었습니다.
SELECT seq_tblboard.CURRVAL
FROM dual;
-- 
DROP SEQUENCE seq_tblboard;
-- 
SELECT * 
FROM user_sequences;
-- 
INSERT INTO tbl_board VALUES ( SEQ_TBLBOARD.NEXTVAL , '홍기수', '1234', '오류처리', 'NEXT_VAL 아니라 NEXTVAL 의사컬럼', SYSDATE, 0 );
-- 
COMMIT;
--
SELECT * 
FROM tbl_board;
-- 글 목록
-- 샘플 100개의 게시글을 추가 
-- DECLARE
BEGIN
  FOR i IN 1..100 LOOP
      INSERT INTO tbl_board VALUES ( 
     SEQ_TBLBOARD.NEXTVAL 
     , '홍길동' || i
     , '1234'
     , '게시글 제목 ' || i
     , '게시글 내용 ' || i
     , SYSDATE, 0 
     );
  END LOOP;
-- EXCEPTION
END;
COMMIT;
--
SELECT COUNT( * ) -- 104
FROM tbl_board;
-- SELECT 문 9절: ORACLE 12C
-- WITH
-- SELECT 
-- FROM
-- WHERE
-- GROUP BY
-- HAVING
-- ORDER BY
-- OFFSET 절
-- FETCH 절

-- 현재 페이지 번호 : 1           currentPage
-- 한페이지에 출력할 게시글 수: 10  pageSize
SELECT seq, title, writer, regdate, readed
FROM tbl_board
ORDER BY seq DESC
OFFSET (:currentPage -1)* :pageSize ROWS
FETCH NEXT :pageSize ROWS ONLY;
SELECT '    [1] 2 3 4 5 6 7 8 9 10 > ' FROM dual;

-- 1) title 컬럼을    subject 컬러명으로 수정
ALTER TABLE tbl_board
RENAME COLUMN title TO subject;
-- 2) writer 컬럼 크기 20 -> 30 크기 확장
ALTER TABLE tbl_board
MODIFY ( writer VARCHAR2(30) );

-- [ 테이블 생성하는 방법 ]
-- 1) CREAE TABLE 문을 사용해서  테이블명 ();
-- 2) 서브쿼리를 사용해서 테이블 생성
CREATE TABLE emp_10 -- 컬럼명 명시 X
AS 
SELECT *
FROM emp
WHERE deptno = 10;
--
DESC emp_10;
-- 제약조건은 복제되지 않는다. 
-- (1) emp 테이블에 어떤 제약조건 확인
SELECT * 
FROM user_constraints
WHERE table_name = 'TBL_EMP';
WHERE table_name = 'EMP_10';
WHERE table_name = 'EMP';
FROM user_tables;
FROM user_sequences;
--
--SELECT *
--FROM emp_10;
-- 예) emp + dept + salgrade 테이블 3개를 조인...  -> 새로운 테이블 생성
emp: deptno, empno, ename, sal + NVL(comm,0) pay
dept: dname
salgrade: grade
--
CREATE TABLE empdeptgrade
AS 
SELECT empno, ename, sal + NVL(comm,0) pay, d.deptno, dname, sal, grade
FROM emp e JOIN dept d ON e.deptno = d.deptno
           JOIN salgrade s ON sal BETWEEN losal AND hisal;
--
SELECT * 
FROM      empdeptgrade; 
DESC empdeptgrade;

-- 생성한 테이블 삭제
DROP TABLE emp_10 PURGE;
DROP TABLE empdeptgrade PURGE;

-- 예) 서브쿼리를 사용해서 테이블 생성할 때 구조만 생성하고 데이터는 필요없는 경우
CREATE TABLE tbl_emp
AS 
SELECT * 
FROM emp
WHERE 1 = 0;
--
DESC tbl_emp;
--
SELECT * 
FROM tbl_emp;
-- 예) empno 컬럼에 PK 복제 X, tbl_emp 테이블에  PK 제약조건 추가
--【형식】constraint추가
--	ALTER TABLE 테이블명
--	ADD (컬럼명 datatype CONSTRAINT constraint명 constraint실제값
--	    [,컬럼명 datatype]...);
ALTER TABLE tbl_emp
ADD CONSTRAINT PK_tblemp_empno PRIMARY KEY (empno);
-- 확인)
SELECT * 
FROM tbl_emp;
-- 예) emp 테이블로 부터 30번 부서원 -> tbl_emp 테이블에 INSERT
--    ㄴ Subquery를 사용하여 행(row) 삽입
--    ㄴ • 다른 테이블로부터 서브쿼리를 사용하여 그 결과를 테이블에 삽입한다.
--    ㄴ • subquery를 이용한 행 삽입에서는 VALUES 절을 사용하지 않는다.
--    ㄴ • INSERT 절에 명시한 컬럼의 수는 subquery 절에 명시한 컬럼의 수와 일치해야 하고,
--    ㄴ 또한 각 컬럼의 데이터 타입도 일치해야 한다.
--    ㄴ • subquery에 의해 리턴되는 행의 수만큼 삽입된다.

INSERT INTO tbl_emp (
                        SELECT * 
                        FROM emp
                        WHERE deptno = 30
                    );
COMMIT;                    
SELECT * FROM tbl_emp;

-- 예)  emp 테이블의 20번 부서원들로 부터 empno, ename 2개의 컬럼만 가져와서 
--     tbl_Emp 테이블에 INSERT 하고자 한다.. 
INSERT INTo tbl_emp (empno, ename) (
                            SELECT empno, ename
                            FROM emp
                            WHERE deptno = 20
                        );
COMMIT;

SELECT *
FROM tbl_emp;
-- 예) 다중 INSERT 문 
-- 1) unconditional insert  all: 조건이 없는 다중 INSERT ALL 문
--【형식】
--	INSERT ALL | FIRST
--	  [INTO 테이블1 VALUES (컬럼1,컬럼2,...)]
--	  [INTO 테이블2 VALUES (컬럼1,컬럼2,...)]
--	  :
--    :
--	Subquery;
--tbl_emp10
--tbl_emp20
--tbl_emp30
--tbl_emp40

CREATE TABLE tbl_emp10 AS (  SELECT * FROM emp WHERE 1=0 ) ;
CREATE TABLE tbl_emp20 AS (  SELECT * FROM emp WHERE 1=0 ) ;
CREATE TABLE tbl_emp30 AS (  SELECT * FROM emp WHERE 1=0 ) ;
CREATE TABLE tbl_emp40 AS (  SELECT * FROM emp WHERE 1=0 ) ;

SELECT * FROM tbl_emp10;
SELECT * FROM tbl_emp20;
SELECT * FROM tbl_emp30;
SELECT * FROM tbl_emp40;
--
--INSERT INTO tbl_emp10 ( SELECT * FROM emp ); -- 12 명
--INSERT INTO tbl_emp20 ( SELECT * FROM emp ); -- 12 명
--INSERT INTO tbl_emp30 ( SELECT * FROM emp ); -- 12 명
--INSERT INTO tbl_emp40 ( SELECT * FROM emp ); -- 12 명
--ROLLBACK ;

INSERT ALL
    INTO tbl_emp10 ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp20 ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp30 ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    INTO tbl_emp40  (empno, ename, job, mgr) VALUES ( empno, ename, job, mgr )
SELECT * 
FROM emp;

-- 2) conditional insert  all  : 조건이 있는 다중 INSERT ALL 문
--INSERT INTO tbl_emp10 ( SELECT * FROM emp WHERE deptno=10 );  
--INSERT INTO tbl_emp20 ( SELECT * FROM emp WHERE deptno=20 );  
--INSERT INTO tbl_emp30 ( SELECT * FROM emp WHERE deptno=30 );  
--INSERT INTO tbl_emp40 ( SELECT * FROM emp WHERE deptno=40 ); 
--ROLLBACK ;
--【형식】
--	INSERT ALL
--	WHEN 조건절1 THEN
--	  INTO [테이블1] VALUES (컬럼1,컬럼2,...)
--	WHEN 조건절2 THEN
--	  INTO [테이블2] VALUES (컬럼1,컬럼2,...)
--	........
--	ELSE
--	  INTO [테이블3] VALUES (컬럼1,컬럼2,...)
--	Subquery;
 
INSERT ALL
	WHEN deptno=10 THEN
	  INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
	WHEN deptno=20 THEN
	  INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN deptno=30 THEN
	  INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno ) 
	WHEN deptno=40 THEN
	  INTO tbl_emp40 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT * 
FROM emp;
ROLLBACK;

-- 3) conditional first insert 문
INSERT FIRST
    WHEN deptno=10 THEN
	  INTO tbl_emp10 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    WHEN sal >=1500 THEN
      INTO tbl_emp20 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
    ELSE
      INTO tbl_emp30 VALUES ( empno, ename, job, mgr, hiredate, sal, comm, deptno )
SELECT * FROM emp;
--
SELECT * 
FROM emp
WHERE deptno=10 AND sal >=1500;

-- 완전히 테이블을 삭제..
DROP TABLE 테이블명 PURGE;

--  테이블 안에 있는 행(데이터)만 삭제
TRUNCATE TABLE 테이블명   -- 커밋 필요 없다.
--
DELETE FROM 테이블명; -- 모든 행들을 삭제

--------------------------------------------------------------------------------
-- 문제) insa 테이블의  num, name 컬럼을 복사해서 tbl_score 테이블 생성
--     (  기존에 insa 테이블의 위의 2개의 컬럼만 복사해서 테이블 생성 )
--     ( num <= 1005 )
CREATE TABLE tbl_score
AS 
  SELECT num, name
  FROM insa
  WHERE num <= 1005;
--
DESC tbl_score;
--
SELECT * 
FROM tbl_score;
-- 문제2) tbl_score 테이블에 PK_TBLSCORE_NUM 이름의 PK 제약조건을 설정...하고  확인.
-- (     PK는 num 컬럼 )
SELECT *
FROM user_constraints
WHERE table_name LIKE 'TBL_S%';
--
ALTER TABLE tbl_score
ADD CONSTRAINT PK_TBLSCORE_NUM PRIMARY KEY( num );

-- 문제3) tbl_score 테이블에 kor, eng, mat, tot, avg, grade,      rank 컬럼 추가.
--                                                  CHAR(1 CHAR) N(3)  수/~가
-- kor, eng, mat, tot, avg : 기본값을 0으로 설정.
ALTER TABLE tbl_score
ADD (
         kor NUMBER(3) DEFAULT 0
       , eng NUMBER(3) DEFAULT 0
       , mat NUMBER(3) DEFAULT 0
       , tot NUMBER(3) DEFAULT 0
       , avg NUMBER(5,2) DEFAULT 0
       , grade CHAR(1 CHAR)
       , rank  NUMBER(3) 
     );
-- 컬럼 삭제
--ALTER TABLE tbl_score
--DROP ( 컬럼1, 컬럼2,... );

-- 실무에서 바로 삭제하기 전에 컬럼을 사용하지 못하다도록 설정
--ALTER TABLE 테이블명
--SET UNUSED ( 컬럼명 );

DESC tbl_Score;

-- 문제4) DBMS_RANDOM 패키지 안에   VALUE  랜덤한 실수 
--                                       로또번호 출력
--   1) 0~100 정수를 랜덤하게 출력하는 쿼리 작성
SELECT
--       DBMS_RANDOM.VALUE
--      , DBMS_RANDOM.VALUE(0, 101)
        TRUNC( DBMS_RANDOM.VALUE(0, 101) )
        , FLOOR( DBMS_RANDOM.VALUE(0, 101) )
FROM dual;
-- 
SELECT * 
FROM tbl_score;
-- 모든 학생들의 kor, eng, mat 점수를 랜덤하게 채워넣고   
UPDATE tbl_Score
SET  kor = TRUNC( DBMS_RANDOM.VALUE(0, 101) )
    , eng = TRUNC( DBMS_RANDOM.VALUE(0, 101) )
    , mat = TRUNC( DBMS_RANDOM.VALUE(0, 101) )
;
COMMIT;

-- 문제) 1005 번 학생의 국,영 점수가 잘못되어서 1점씩 깍을께요... 
UPDATE tbl_score
SET  (kor, eng ) = ( SELECT kor-1 , eng-1 FROM tbl_score WHERE num = 1005 )
WHERE num = 1005;

-- 문제) 수학이 3문제가 정답이 없어서 15 점을 모든 학생들의 수학점수를 추가.. 
UPDATE tbl_score
SET mat = CASE
             WHEN mat + 15 > 100 THEN 100
             ELSE                     mat + 15
          END;
COMMIT;          
--SET  mat = mat + 15;
-- 수정된 수학 점수가 100점 초과되면 100점으로 업데이트가 되도록 처리..
ROLLBACK;
--
SELECT * FROM tbl_score;
-- 문제) 총점, 평균 수정...
UPDATE tbl_score
SET tot = kor + eng + mat
   , avg = ( kor + eng + mat ) / 3;

-- 문제) 순위 매기기 
-- ㄱ. 
SELECT num , tot
   , ( SELECT COUNT(*)+1 FROM tbl_score WHERE tot > s.tot ) rank
FROM tbl_Score s;
--  상관 서브 쿼리를 사용해서 순위 UPDATE
UPDATE tbl_Score s
SET rank = (SELECT COUNT(*)+1 FROM tbl_score WHERE tot > s.tot ) ;

-- ㄴ. 
SELECT num , tot
    , RANK() OVER( ORDER BY tot DESC ) r
FROM tbl_score;
-- 
UPDATE tbl_score s
SET rank = (
    SELECT r
     FROM (
         SELECT num, tot
           , RANK() OVER( ORDER BY tot DESC ) r
         FROM tbl_score 
     )WHERE num = s.num
);

COMMIT;
--
SELECT * FROM tbl_score;

-- 문제) avg 90 수, 80 우, 70 미, 60 양, 가
UPDATE tbl_score
SET  grade = CASE 
                WHEN avg BETWEEN 90 AND 100 THEN '수'
                WHEN avg >= 80  THEN '우'
                WHEN avg >= 70  THEN '미'
                WHEN avg >= 60  THEN '양'
               ELSE '가'
            END
;
UPDATE tbl_score
SET  grade = DECODE(  TRUNC(avg/10) , 10, '수', 9, '수', 8, '우', 7, '미', 6, '양', '가'   )
;
COMMIT;
-- 다중 INSERT 문  -> 등급 수정.
INSERT FIRST
  WHEN avg >= 90 THEN
   INTO tbl_score(num, grade) VALUES (num, '수') 
  WHEN avg >= 80 AND  
   INTO  tbl_score(grade) VALUES ('우')
  WHEN avg >= 70 THEN  
   INTO   tbl_score(grade) VALUES ('미')
  WHEN avg >= 60 THEN 
   INTO  tbl_score(grade) VALUES ('양')
  ELSE
   INTO  tbl_score(grade) VALUES ('가')
SELECT avg
FROM tbl_score;

-- 기관평가 : 10시~ 13시      쉬는 시간: 50~00
--          비밀번호 설정/해제

-- 문제) tbl_score 테이블에서 남학생들만 국어점수를 30점 증가( update) 
--     ( 문제점)tbl_score 테이블에서 주민등록번호 X +   insa 테이블 조인

SELECT num
FROM insa
WHERE MOD( SUBSTR(ssn, -7, 1), 2 ) = 1 AND num <= 1005;
--
UPDATE tbl_score s
SET kor = CASE 
             WHEN  kor + 30 > 100 THEN 100
             ELSE  kor + 30
          END
WHERE num = ANY(SELECT num
                FROM insa
                WHERE MOD( SUBSTR(ssn, -7, 1), 2 ) = 1 AND num <= 1005);
--
WHERE num IN (
                SELECT num
                FROM insa
                WHERE MOD( SUBSTR(ssn, -7, 1), 2 ) = 1 AND num <= 1005
);          
COMMIT;
--
SELECT  * FROM  tbl_score;

-- 문제) result 컬럼 추가 (  '합격' , '불합격', '과락' )
--     합격: 평균 60점이상이고, 40 미만 X
--    불합격: 평균 60점 미만
--     과락: 40점 미만
ALTER TABLE tbl_score
ADD result VARCHAR2(9);
-- 문제)  result컬럼값 UPDATE 쿼리 작성
UPDATE tbl_score
SET result = CASE
               WHEN kor < 40 OR eng < 40 OR mat < 40 THEN '과락'
               WHEN avg >= 60 THEN '합격'
               ELSE '불합격'
             END
;
COMMIT;
SELECT * FROM tbl_score;

--------------------------------------------------------------------------------
-- ■ 병합(Merge)
--------------------------------------------------------------------------------
-- ■ 제약조건

--------------------------------------------------------------------------------
-- ■ 데이터베이스 모델링

--------------------------------------------------------------------------------
-- ■ 조인 정리
--------------------------------------------------------------------------------
-- ■ 뷰
--------------------------------------------------------------------------------
-- ■ PL/SQL
-- 목 프로젝트 / 금/토/일/월/화/수/목            금 발표 

















