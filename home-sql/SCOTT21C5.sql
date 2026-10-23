CREATE TABLE NOTICES -- 공지사항 (게시판)
(
	"SEQ" VARCHAR2(10 BYTE), -- 글번호
	"TITLE" VARCHAR2(200 BYTE), -- 제목
	"WRITER" VARCHAR2(50 BYTE), -- 작성자
	"CONTENT" VARCHAR2(4000 BYTE), --내용
	"REGDATE" TIMESTAMP (6), --등록일
	"HIT" NUMBER, -- 조회수
	"FILESRC" VARCHAR2(500 BYTE) -- 첨부파일
);

CREATE TABLE "MEMBER"
(	
    "ID" VARCHAR2(50 BYTE), -- 회원아이디 UID x
    "PWD" VARCHAR2(50 BYTE), 
    "NAME" VARCHAR2(50 BYTE), 
    "GENDER" VARCHAR2(10 BYTE), 
    "BIRTH" VARCHAR2(10 BYTE), 
    "IS_LUNAR" VARCHAR2(10 BYTE), 
    "CPHONE" VARCHAR2(15 BYTE), 
    "EMAIL" VARCHAR2(200 BYTE), 
    "HABIT" VARCHAR2(200 BYTE), 
    "REGDATE" DATE
);
 


drop table MEMBER

delete from member
commit
select * from notices
select * from member
commit


A. notices , member 테이블 + 제약조건 설정 
     1) member 테이블에 point 컬럼 추가.
      ALTER TABLE member
      ADD (  point number(10) default(0) );
      template
      ALTER TABLE member
      ADD  CONSTRAINT ck_member_point CHECK ( point < 3 );
      
     2) notices 테이블에 title 컬럼을 유일성 제약 조건.
       uk_notices_title   -- 유일성 제약조건을 설정
      ALTER TABLE notices
     ADD CONSTRAINT uk_notices_title UNIQUE(title);
     
    3)  notices 테이블 제약조건 확인
      SELECT *
      FROM user_constraints
      WHERE table_name = 'NOTICES';
      -- PK 제약조건 추가
      ALTER TABLE notices
         ADD CONSTRAINT pk_notices_seq PRIMARY KEY(seq); 
         
 -- 
 
 
 SELECT id, point
 from member;
 
 update member 
 set point = 1;
 commit;
 
 
 ALTER TABLE MEMBER
DROP CONSTRAINT CK_MEMBER_POINT;

ALTER TABLE NOTICES
DROP CONSTRAINT UK_NOTICES_TITLE;
'------------





























 