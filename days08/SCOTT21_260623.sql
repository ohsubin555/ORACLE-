-- SCOTT --
--------------------------------------------------------------------------------
-- ■ 병합(Merge)
CREATE TABLE emp_sal (
    empno NUMBER PRIMARY KEY,
    sal   NUMBER
);

CREATE TABLE emp_new (
    empno NUMBER,
    sal   NUMBER
);

INSERT INTO emp_sal VALUES(7369, 800);  -- 7369 사원번호
INSERT INTO emp_sal VALUES(7499, 1600);

INSERT INTO emp_new VALUES(7369, 1000); -- 7369 사원번호
INSERT INTO emp_new VALUES(7521, 1250);

COMMIT;
--
MERGE INTO emp_sal t
USING emp_new s
ON ( t.empno = s.empno )
WHEN MATCHED THEN
  UPDATE SET t.sal = s.sal
WHEN NOT MATCHED THEN
  INSERT ( empno, sal ) VALUES ( s.empno, s.sal );
-- 
SELECT * FROM emp_sal;
SELECT * FROM emp_new;

-- 예)  DELETE 도 가능하다: 급여가 2000이하가 되면 삭제.
MERGE INTO emp_sal t
USING emp_new s
ON (t.empno = s.empno)
WHEN MATCHED THEN
    UPDATE                  -- UPDATE
       SET t.sal = s.sal
    DELETE                  -- s.sal <= 2000 조건을 만족한다면 삭제
     WHERE s.sal <= 2000;
     
-- 예)     ORA_HELP 예제
DROP TABLE tbl_emp PURGE;
-- 
CREATE TABLE  tbl_emp(
    id number primary key, 
    name varchar2(10) not null,
    salary  number,
    bonus number default 100
);
-- Table TBL_EMP이(가) 생성되었습니다.
INSERT INTO tbl_emp(id,name,salary) VALUES (1001,'jijoe',150);
INSERT INTO tbl_emp(id,name,salary) VALUES(1002,'cho',130);
INSERT INTO tbl_emp(id,name,salary) VALUES(1003,'kim',140);
COMMIT;
--
Select * 
from tbl_emp;
-- 
CREATE TABLE  tbl_bonus(
  id number
 , bonus number default 100
);
-- Table TBL_BONUS이(가) 생성되었습니다.
INSERT INTO tbl_bonus VALUES ( 1004, 50 );   
--
INSERT INTO  tbl_bonus(id)
   (SELECT  e.id from tbl_emp e);
   COMMIT;
SELECT * 
FROM tbl_bonus;
-- tbl_emp
1001   jijoe   150   100
1002   cho   130   100
1003   kim   140   100
-- tbl_bonus
1001   100
1002   100
1003   100
1004   50
--
MERGE INTO tbl_bonus b
USING ( SELECT id, salary FROM  tbl_emp ) e
ON ( b.id = e.id )
WHEN MATCHED THEN
    UPDATE SET b.bonus = b.bonus + e.salary * 0.01
WHEN NOT MATCHED THEN
    INSERT (b.id, b.bonus) VALUES ( e.id, e.salary * 0.01 );
--
COMMIT;
1001   101.5
1002   101.3
1003   101.4
1004   50
-- 한 문장으로 처리 가능하며, 데이터 동기화 작업(ETL, DW, 배치 프로그램)에서 매우 많이 사용됩니다.
--------------------------------------------------------------------------------
-- ■ 제약조건
-- 1) 제약 조건 확인:    user_constraints 뷰(View) 확인 가능
SELECT * 
FROM user_constraints
WHERE table_name = 'EMP';
-- 2) 정의: 데이터 무결성(정확성, 일관성)을  보장하기 위해 설정하는 규칙.
-- 3) CREATE TABLE 문:  제약 조건을 설정하는 2가지 방법
--    (1) IN-LINE constraint 방법(column level에서의 제약조건)
--    (2) OUT-OF-LINE constraint 방법(Table level에서의 제약조건)
-- 4) 제약 조건의 5가지 종류 
--    (1) PRIMARY KEY(PK) 해당 컬럼 값은 반드시 존재해야 하며, 유일해야 함
--         (NOT NULL과 UNIQUE 제약조건을 결합한 형태) 
--    (2) FOREIGN KEY(FK) 해당 컬럼 값은 참조되는 테이블의 컬럼 값 중의 하나와 일치하거나 NULL을 가짐 
--    (3) UNIQUE KEY(UK) 테이블내에서 해당 컬럼 값은 항상 유일해야 함 
--    (4) NOT NULL(NN) 컬럼은 NULL 값을 포함할 수 없다. 
--    (5) CHECK(CK) 해당 컬럼에 저장 가능한 데이터 값의 범위나 조건 지정 

-- 실습) tbl_constraint
CREATE TABLE tbl_constraint(
     empno  NUMBER(4)
   , ename  VARCHAR2(20)
   , deptno NUMBER(2)
   , kor    NUMBER(3)
   , email  VARCHAR2(250)
   , city   VARCHAR2(20)
);
--
INSERT INTO tbl_constraint ( empno, ename, deptno, kor, email, city )
VALUES ( null, null, null, null, null, null );
--
INSERT INTO tbl_constraint ( empno, ename, deptno, kor, email, city )
VALUES ( 1111, '홍길동', null, null, null, null );
--
INSERT INTO tbl_constraint ( empno, ename, deptno, kor, email, city )
VALUES ( 1111, '서무식', null, null, null, null );
--
SELECT *
FROM tbl_constraint;
--
UPDATE tbl_constraint
SET ename = '정기수'
WHERE empno = 1111;
-- 
DELETE FROM tbl_constraint
WHERE empno = 1111;
-- 데이터의 무결성을 보장하는 규칙: 제약조건을 설정...
DROP TABLE tbl_constraint PURGE;
--
CREATE TABLE tbl_constraint(
--  컬럼명   타입(크기)     [CONSTRAINT 제약조건명]  
     empno  NUMBER(4) NOT NULL CONSTRAINT PK_tblconstraint_empno PRIMARY KEY
   , ename  VARCHAR2(20) NOT NULL
   -- dept(deptno참조키) -> tbl_constraint(deptno외래키FK)
   , deptno NUMBER(2) CONSTRAINT FK_tblconstraint_deptno REFERENCES dept(deptno) -- ON DELETE CASCADE | ON DELETE SET NULL
   , kor    NUMBER(3) CONSTRAINT CK_tblconstraint_kor CHECK ( kor BETWEEN 0 AND 100 )
   , email  VARCHAR2(250) CONSTRAINT UK_tblconstraint_email UNIQUE
   , city   VARCHAR2(20) CONSTRAINT CK_tblconstraint_city CHECK ( city IN ('서울','경기','인천','부산') ) 
);
-- Table TBL_CONSTRAINT이(가) 생성되었습니다.
-- empno (PK)   : null
INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city )
VALUES ( null, 'kim', 10, 90, 'kim@naver.com', '서울');

-- dept(deptno) 참조
-- ORA-02291: 무결성 제약조건(SCOTT.FK_TBLCONSTRAINT_DEPTNO)이 위배되었습니다- 부모 키가 없습니다
INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city )
VALUES ( 1001, 'kim', 90, 90, 'kim@naver.com', '서울');

--  ORA-02290: 체크 제약조건(SCOTT.CK_TBLCONSTRAINT_CITY)이 위배되었습니다
INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city )
VALUES ( 1001, 'kim', 10, 90, 'kim@naver.com', '대전');

--  ORA-02290: 체크 제약조건(SCOTT.CK_TBLCONSTRAINT_KOR)이 위배되었습니다
INSERT INTO tbl_constraint (empno, ename, deptno, kor, email, city )
VALUES ( 1001, 'kim', 10, 190, 'kim@naver.com', '서울');

-- INDEX: PK(empno), UK(email) 인덱스 생성된다. ( 암기 )
SELECT * 
FROM user_indexes
WHERE table_name LIKE 'TBL_CON%';

--[급여 지급 테이블]  사원번호  +  급여일자 
--사원번호    급여일자    지급액
--1001      26.5.25     50000000        
--1002      26.5.25     40000000        
--1001      26.6.25     50000000

-- 테이블 삭제 후에 복사 + 붙이기: 테이블 레벨 방식으로 제약조건 설정
CREATE TABLE tbl_constraint( 
     empno  NUMBER(4) NOT NULL 
   , ename  VARCHAR2(20) NOT NULL 
   , deptno NUMBER(2) 
   , kor    NUMBER(3) 
   , email  VARCHAR2(250) 
   , city   VARCHAR2(20) 
   
   -- 제약조건 설정...
   , CONSTRAINT PK_tblconstraint_empno PRIMARY KEY (empno)
   , CONSTRAINT FK_tblconstraint_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno) -- ON DELETE CASCADE | ON DELETE SET NULL
   , CONSTRAINT CK_tblconstraint_kor CHECK ( kor BETWEEN 0 AND 100 )
   , CONSTRAINT UK_tblconstraint_email UNIQUE (email)
   , CONSTRAINT CK_tblconstraint_city CHECK ( city IN ('서울','경기','인천','부산') ) 
   
);
-- 제약조건 확인
SELECT * 
FROM user_constraints
WHERE table_name LIKE 'TBL_CON%';
-- 제약조건은 수정할 수 없다:   삭제 -> 생성
FK_TBLCONSTRAINT_DEPTNO
SYS_C008330
SYS_C008331
CK_TBLCONSTRAINT_KOR
CK_TBLCONSTRAINT_CITY
PK_TBLCONSTRAINT_EMPNO
UK_TBLCONSTRAINT_EMAIL
-- 예) PK 제약조건을 삭제
ALTER TABLE tbl_constraint
DROP PRIMARY KEY;
DROP CONSTRAINT PK_TBLCONSTRAINT_EMPNO;
--DROP CONSTRAINT 제약조건명;

-- 예) UK 제약조건 삭제
ALTER TABLE tbl_constraint
DROP UNIQUE( email );
DROP CONSTRAINT UK_TBLCONSTRAINT_EMAIL;

-- 제약조건 PK, UK 삭제 ~

-- 예) 기존 테이블에 PK, UK 제약조건을 다시 추가.
ALTER TABLE tbl_constraint
ADD (
        CONSTRAINT PK_tblconstraint_empno PRIMARY KEY (empno)
        , CONSTRAINT UK_tblconstraint_email UNIQUE (email)
     );
-- Table TBL_CONSTRAINT이(가) 변경되었습니다.

-- 제약조건 비활성화/활성화
ALTER TABLE 테이블명
DISABLE CONSTRAINT 제약조건명;
-- 
ALTER TABLE 테이블명
ENABLE CONSTRAINT 제약조건명;

-- 예)    REFERENCES 참조테이블명 (참조컬럼명) 
--           [ON DELETE CASCADE | ON DELETE SET NULL]  옵션 설명...
-- 1) ON DELETE CASCADE
--   부모테이블의 참조키가 삭제될때 자동으로 자식테이블의 참조한 레코드도 동시에 삭제.
-- 2) ON DELETE SET NULL
--   부모테이블의 참조키가 삭제될때 자동으로 자식테이블의 참조한 컬럼값은 NULL로 설정된다.

-- 실습)   emp -> tbl_emp 생성  ( 서브쿼리 )
--        dept -> tbl_dept 생성

DROP TABLE tbl_emp PURGE;
DROP TABLE tbl_dept PURGE;
--
CREATE TABLE tbl_emp
AS
(  SELECT * FROM emp );
--
CREATE TABLE tbl_dept
AS
(  SELECT * FROM dept );
-- NN 제약조건을 제외한 그외 제약 조건은 복사되지 않는다. 
-- 1) emp, dept 제약조건 확인
SELECT * 
FROM user_constraints
WHERE table_name IN ('TBL_EMP', 'TBL_DEPT');
WHERE table_name IN ('EMP', 'DEPT');
-- 2) tbl_emp, tbl_dept 기존 테이블에 제약조건 추가 .
ALTER TABLE tbl_dept
ADD ( 
    CONSTRAINT PK_tbldept_deptno PRIMARY KEY(deptno)
);

ALTER TABLE tbl_emp
ADD ( 
      CONSTRAINT PK_tblemp_empno PRIMARY KEY(empno)
    , CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) REFERENCES tbl_dept(deptno)
);
-- ORA-02291: 무결성 제약조건(SCOTT.FK_TBLEMP_DEPTNO)이 위배되었습니다- 부모 키가 없습니다
-- INSERT INTO tbl_emp ( empno, deptno ) VALUES ( 9999, 90 ); 

-- ORA-02292: 무결성 제약조건(SCOTT.FK_TBLEMP_DEPTNO)이 위배되었습니다- 자식 레코드가 발견되었습니다
--DELETE FROM tbl_dept
--WHERE  deptno = 30;

-- ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다
-- DROP TABLE tbl_dept PURGE;

-- ORA-02292: 무결성 제약조건(SCOTT.FK_TBLEMP_DEPTNO)이 위배되었습니다- 자식 레코드가 발견되었습니다
--UPDATE tbl_dept
--SET   deptno = 50
--WHERE deptno = 10;

-- 예) FK 제약조건을 삭제, FK 제약조건 추가 + ON DELETE 옵션
ALTER TABLE tbl_emp
DROP CONSTRAINT FK_TBLEMP_DEPTNO;
--
ALTER TABLE tbl_emp
ADD (  
    CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) 
    REFERENCES tbl_dept(deptno) ON DELETE CASCADE
);
--
ALTER TABLE tbl_emp
ADD (  
    CONSTRAINT FK_tblemp_deptno FOREIGN KEY(deptno) 
    REFERENCES tbl_dept(deptno) ON DELETE SET NULL
);
--
DELETE tbl_dept
WHERE deptno = 30;
--
SELECT * FROM tbl_dept;
SELECT * FROM tbl_emp WHERE deptno = 30;
--
COMMIT;
----------------------------------------------------------------------------------
-- ■ 데이터베이스 모델링
-- [ DB(데이터 베이스) 모델링 ]
--1. 데이터베이스(Database) ?  서로 관련된 데이터의 모임(집합)
--2. DB 모델링? 현실 세계의 업무적인 프로세스를 물리적으로 DB화 시키는 과정.
--  예) 현실 세계의 업무적인 프로세스
--     ( 스타벅스에서 음료 주문   )
--     음료(상품) 검색 -> 주문 -> 결재 -> 대기 -> 상품 픽업...

3. DB 모델링 과정( 단계 , 순서)
   1)  업무 프로세스         →   2) 개념적 DB 모델링
    ( 요구분석서 작성 )             ( ERD 작성)            -- eXERD툴
         ↑ 일치성 검토                    ↓
   4) 물리적 DB 모델링      ←    3) 논리적 DB 모델링  
     DBMS                       ( 스키마, 정규화 과정)
     타입, 크기 등등
     인덱서
     역정규화
     등등
     
 4. 프로젝트 진행 과정
 ※ 계획 → 분석 → 설계 → 구현 → 테스트 → 유지보수
( 1년 프로젝트 중 DataBase 모델링 6개월 정도 소요됨. ) 

 5. DB 모델링 단계 ( 1 ) 업무 프로세스 분석 -> [ 요구사항명세서(분석서)] 작성.
   1) 관련 분야에 대한 기본 지식과 상식 필요. 
   2) 신입 사원의 입장에서 업무 자체와 프로세스 파악, 분석 필요.
   3) 우선, 실제 문서( 서류, 장표, 보고서 등등 )를 수집하고 분석.
   4) 담당자 인터뷰, 설문 조사 등등 요구사항 직접 수렴.
   5) 비슷한 업무 처리하는 DB 모델링 분석.
   6) 백그라운드 프로세스 파악.
   7) 사용자와의 요구 분석.
   등등...
   
   https://terms.naver.com/entry.naver?docId=3431222&ref=y&cid=58430&categoryId=58430   
   
6. DB 모델링 단계 ( 2 ) 개념적 DB 모델링 -> [  ERD ] 작성.   
1. 개념적 데이터 베이스 모델링이란 ?
   데이터 베이스 모델링을 함에 있어 가장 먼저 해야될 일은 사용자가 필요로 하는 데이터가 무엇이며
                      어떤 데이터를 데이터베이스에 담아야 하는 지에 대한 충분한 분석이다.
   이러한 것들은 업무 분석, 사용자 요구 분석 등을 통해 얻어지며 수집된 현실 세계의 정보들을 사람들이 이해할 수 있는 
   명확한 형태로 표현하는 단계를 '개념적 데이터베이스 모델링'이라고 한다.

2. ER-Diagram
   현실 세계를 좀 더 명확히 표현하기 위한 여러 방법 중 가장 널리 사용되고 있는 
    개체(E)-관계(R) 모델을 이용해
   개념적 데이터베이스 모델링에 대해 알아보자.

3. E-R Model
 1) 1976년 P.Chen이 제안한 것.
 2) 개체 관계 모델을 그래프 형식으로 알아보기 쉽게 표현한 것.
     개체  - 직사각형,
   속성  - 타원형,
   개체들 간의 관계 - 마름모
   이들을 연결하는 링크로 구성됨.

 3) 예 ( 학생과 과정 관계를 표현한 ER-Diagrm)

   학생(사) - 학번(타) 식별자속성    - 전화번호(타) - 이름(타)
      ↕
   등록(마) 다대다 관계(N:M)
       ↕
   과정(사) - 과정코드(타)식별자속성     - 과정명(타) - 과정내용(타)

4. ER - Diagrm 의 용어 
   1) 실체(Entity)
   2) 속성(Attribute)
   3) 식별자(Identifier)
   4) 관계(Relational)

   
   4-1.   실체(Entity)
   
   SELECT *
   FROM Emp;
   
   1) 업무 수행을 위해 데이터로 관리되어져야 하는 사람,사물,장소,사건등을 '실체'라 한다.
      이 때 구축하고자 하는 업무의 목적과 범위,전략에 따라 데이터로 관리되어져야 하는 항목을 파악하는 것이 매우 중요.
   2) 실체는 학생,교수 등과 같이 물리적으로 존재하는 유형
      과목,학과 등과 같이 개념적으로 존재하는 대상이 될 수 있다.
    3) 실체는 테이블로 정의된다.
   4) 실체는 인스턴스라 불리는 개별적인 객체들의 집합이다.
    예) 과목 : 자료 구조, 데이터베이스, 프로그래밍 등의 인스턴스들의 집합.
        학과 : 컴퓨터공학과, 전자공학, 국어교육학과 등의 인스턴스들의 집합.
   5) 실체를 파악하는 요령 
    - 관련 업무에 대한 지식( 가장 중요 )
    예)
     학원에서는 학생들의 출결상태와 성적들을 과목별로 관리하기를 원하고 있다.. (라고 업무 분석한 내용)
      
     - 실체(명사들 파악) : 학원(체인점이 아니라면 뺀다 ), 학생, 출결상태,성적, 과목
   -  각종 서류를 이용해서 실체 파악하는 것도 좋은 방법이다. 

   4-2.   속성(Attribute)
   1) 속성이란 ? 저장할 필요가 있는 실체에 대한 정보.
      즉, 속성은 실체의 성질, 분류, 수량, 상태, 특성, 특징 등을 나타내는 세부 항목을 의미한다. 
   2) 속성 설정 시 가장 중요한 부분은 관리의 목적과 활용 방향에 맞는 속성의 설정이다.
   3) 속성의 숫자는 10개 내외로 하는 것이 좋다.
   4) 속성은 컬럼으로 정의된다.
   예)
   학생이란 실체의 속성 ? 업무프로세스에 따라 달라짐.
          학번, 이름, 주민번호, 전화번호,주소...
   사원이란 실체의 속성 ?
         사원번호, 사원명, 주민번호, 전화번호, 주소, 입사일자, 퇴사일자, 부서명...
   5) 속성의 유형
      (1) 기초 속성 : 원래 갖고 있는 속성
      (2) 추출 속성 : 기초 속성으로 가공처리(계산)를 해서 얻어질 수 있는 속성
                자료의 중복성,무결성 확보를 위해 최호화시키는 것이 바람직하다.
      (3) 설계 속성 : 실제로 존재하지는 않으나 시스템의 효율성을 위해 설계자가 
       임의로 부여하는 속성.
   예)
   주문 Entity
   주문번호   고객   주문상품   주문일자   단가   수량   주문총금액   주문상태
   1   홍길동   H302   0204   10000   3   600000      1
   2   홍길동   H302   0204   10000   3   600000      1
   3   홍길동   H302   0204   10000   3   600000      1

   여기서)    추출속성 : 주문총금액 = 단가 * 수량    
      설계속성 : 주문상태( 주문의 진행 상태:주문,결제완료,배송완료,취소) 확인 위한 속성

   [쇼핑몰의 주문 프로세스]  
    주문->취소->주문처리 완료
        ->결제완료 -> 배송완료 -> 주문처리 완료.

   6) 속성 도메인의 설정
    - 속성이 가질 수 있는 값들의 범위, 다시 말해 속성에 대한 세부적인 업무 , 제약조건 및 특성을 
      전체적으로 정의해 주는 것을 '속성의 도메인 설정'이라 한다.
       kor   0~100
       
    - 도메인 설정은 추후 개발 및 실체를 데이터베이스로 생성할 때나 프로그램 구현 시 유용하게 사용하는 산출물이다.
    - 도메인 정의 시에는 속성의 이름, 자료의 형태, 길이, 형식, 허용되는 값의 제약 조건, 유일성(Unique), 널 여부,
      유효값,초기값들의 사항을 파악해주면 된다. 
    - 도메인 무결성. : 데이터의 입력 형식이나 입력값등을 정의함으로써
             잘못된 데이터가 입력되는 경우의 수를 방지    하기위해 설정하는 것. 

   4-3.   식별자(Identifier)
   1) 식별자란?
      한 실체 내에서 각각의 인스턴스를 유일(Unique)하게 구분할 수 있는 단일 속성 또는 속성 그룹.
        실체 무결성.
        학생(실체)- [학번],이름,주민번호,주소...
   2) 식별자가 없으면 데이터를 수정/삭제 못한다.
      그래서 모든 실체는 반드시 하나 이상의 식별자를 보여하여야하며 또한 여러 개의 식별자를 보유할 수 있다.
        
   3) 식별자의 종류
      (1) 후보키(Candidate Key)
         실체에서 각각의 인스턴스를 구분할 수 있는 속성( 사원번호,주민번호) 
      예) 사원 - [사원번호], [주민번호],사원명, 부서,주소
                     4   >   13
                         기본키가 될 수 있는 키
      (2) 기본키(Primary Key)
         후보키 중 가장 적합한 키. ( 사원번호 )
         - 해당 실체를 대표할 수 있나? 
              업무적으로 활용도가 높나? 
              길이가 짧나? 
              등등의 만족하는 후보키 중 하나 선택.
         ( 중요 )
           기본키는 not null, no duplicate(중복성),unique,clusterd index 설정됨.

      (3) 대체키(Alternate Key)
         후보키 중 기본키로 설정되지 않은 속성( 주민번호 )
         - index(인덱스)로 활용됨. 

      (4) 복합키(Composite Key)
         하나의 속성으로 기본키가 될 수 없는 경우 둘 이상의 컬럼을 묶어서 식별자로 정의한 경우.
         - 복합키 구성시 고려사항. : 복합키 중 어떤 컬럼을 먼저 둘것이냐? 
            이유: 복합키 중 먼저 오는 컬럼에 index,unique가 적용되기에 성능 고려 때문.
      예) 급여 내역 실체
        식별자
        (급여지급일+사번)  복합키
      급여지급일   사번    지금일자   급여액
      200901      1   30   10000   
      200901      2   30   10000   
      200902      1   30   10000   
      200902      2   30   10000   
      
      위의 기본키는 ? 없다. 
      복합키 : 급여지급일 + 사번 
      고려할 점 ) 어떠한 컬럼(속성)을 먼저 둘까? 
         - 조회의 경우 : 사번, 급여지급일 중 어느 컬럼으로 조회가 많나? 
         - 조회수가 비슷하다면 데이터의 입력 순서로 결정 : 당연 급여지급일자  우선 
            ( 아마 입력은 년/월/일 지급일자 순으로 계속 저장 될 것이다...)


      (5) 대리키(Surrogate Key:서러게이트)
         - 식별자가 너무 길거나 여러 개의 복합키로 구성되어 있는 경우 인위적으로 추가한 식별자(인공키).
         - 이것도 역정규화 작업이다. 
      예) 급여 내역 실체
           PK
      (일련번호)       급여지급일   사번    지금일자   급여액
      1           200901      1   30   10000   
      2           200901      2   30   10000   
      3           200902      1   30   10000   
      4           200902      2   30   10000   
   
      - 일련번호라는 대리키를 추가해서 식별자로 사용. ( 성능,효율성 때문에 ) 

   4-4.   관계(Relational)
   - 관계란? 업무의 연관성이다.  실체를 정의하다보면 서로 연관되는 실체들이 있다. 
   예)
   비디오테이프      회원
   관계) 
      [대여관계]
      회원은 비디오테이프를 대여한다.
             비디오테이프는 회원에게 대여된다.
      [가르침관계]
      학생은 교수에게 가르침을받는다.
      교수는 학생을 가르친다.

   - 관계 표현(부여)
   
      회원(사)    실선   대여(마)  실선   비디오(사)
      1) 관계가 있는 두 실체를 실선으로 연결하고 관계를 부여한다.
     2) 관계 차수를 표현한다. ( 1:1, 1:N, N:M관계)
     3) 선택성을 표시한다.    부서 1    0 사원
                            40

   4-4-1) 관계 차수
      1) 1:1 관계
       각각의 부서와 관리하는 부서장과의 관계.
 
      1) 1:N 관계
       각각의 부서와 사원과의 관계

      1) N:M 관계
        고객과 상품 실체 간에는 주문이라는 관계. 
       ( 한 고객은 여러 상품을 주문할 수 있고, 한 상품은 여러 고객에게 주문될 수 있다.)

       다대다 관계는 여러 문제점 때문에
         논리적 데이터베이스 모델링 단계를 거치면서 1:N 관계로 바꾼다. 

      실제 데이터베이스는 1:1과 1:다 관계만 존재한다. 
-------------------------------------------------------------------------------
        □ 실무자와 같이 업무적인 설명을 듣고 모델링을 시작해 보자.

   1. 회원제를 실시하는 비디오 상점.
   2. 회원 관리
      ㄱ) 회원이름, 주민번호, 전화번호, 휴대폰번호, 우편번호, 주소, 등록일 등 .
   3. 비디오 테이프 관리
      ㄱ) 장르별, 등급별로 나누어 관리.
      ㄴ) 고유한 일련번호를 부여해서 비디오 테이프를 관리. 
      ㄷ) 영화제목, 제작자, 제작 국가, 주연배우, 감독, 개봉일자, 비디오 출시일 등 상세 정보 관리.
      ㄹ) 파손 여부와 대여 여부 관리.      
   4. 비디오 테이프 대여
      ㄱ) 회수일이 기본 이틀
      ㄴ) 미납 회원들의 목록을 자동으로 관리.
      ㄷ) 연체되었을 경우에는 연체료를 받는다.
      ㄹ) 대여료 신/구 차등 관리.
   5. 포인터 관리 서비스
      ㄱ) 회원에게 대여 1회당 1점씩 포인트 점수를 부여하여 10점이 되면 무료로 TAPE 하나 대여 서비스
   6. 관리자 관리
      ㄱ) 일별 , 월별, 년별 매출액 손쉽게 파악.
      ㄴ) 비디오 테이프의 대여 회수 파악.
      ㄷ) 연체료 관리
      ㄹ) 미납 회원 관리.
      ㅂ) 직원 관리( 근무 시간, 임금 자동 계산 )
      ㅅ) 체인점을 확장해 운영하고 자 함. 


   Entity 파악
   Atrribute 파악
   Indentifier 파악
   Relational /차수/선택성

7. DB 모델링 과정(3단계) - 논리적 DB 모델링(  논리적 스키마 생성, 정규화 ) 
  1) ERD -> 릴레이션(테이블) 스키마 변환 규칙
     ㄱ. 규칙1: 모든 개체는 릴레이션으로 변환한다
     ㄴ. 규칙2: 다대다(n:m) 관계는 릴레이션으로 변환한다
     ㄷ. 규칙3: 일대다(1:n) 관계는 외래키로 표현한다
     ㄹ. 규칙4: 일대일(1:1) 관계를 외래키로 표현한다
        규칙4-3 : 모든 개체가 일대일 관계에 필수적으로 참여하면 릴레이션 하나로 합친다
     ㅁ. 규칙5: 다중 값 속성은 릴레이션으로 변환한다
  2) 이상현상   
    ㄱ. 정규화 ? 이상 현상이 발생하지 않도록 하려면,
           관련 있는 속성들로만 릴레이션을 구성해야 하는데 
           이를 위해 필요한 것이 정규화
    ㄴ. 함수적 종속성 :   속성들 간의 관련성
       예) emp 사원테이블
           empno(PK)  ename, sal, hidedate, job 등등
           sal 은 empno 에 함수적으로 종속이된다. 
            Y       X
            X  ->   Y
           결정자    종속자
           예) ename   empno
           ename(종속자) 은 empno (결정자)에 함수적으로 종속이된다.
              Y      X
              X ->   Y
       (1) 완전 함수적 종속
            여러 개의 속성이 모여 하나의 기본키가 될때 == 복합키
            [급여지급일 +  사원번호]   급여액   컬럼
            
       (2) 부분 함수적 종속
          여러 개의 속성이 모여 하나의 기본키가 될때 == 복합키
          [급여지급일 +  사원번호]   급여액   사원명
       
       (3) 이행 함수적 종속
          X  ->   Y  ->  Z
        empno  deptno   dname
        결      종
               결      종
               
        BCNF   
        [ X   +    Y ]  -> Z
                    Y <-  Z
                    
                    SELECT * FROM emp;
-------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- ■ 조인 정리
--------------------------------------------------------------------------------
-- ■ 뷰
--------------------------------------------------------------------------------
-- ■ PL/SQL
-- 목 프로젝트 / 금/토/일/월/화/수/목            금 발표 

















