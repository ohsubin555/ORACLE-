CREATE TABLE tbl_member (
    seq     NUMBER          CONSTRAINT pk_member_seq PRIMARY KEY,
    id      VARCHAR2(30)    CONSTRAINT uk_member_id UNIQUE NOT NULL,
    passwd  VARCHAR2(100)   NOT NULL,
    name    VARCHAR2(50)    NOT NULL,
    role    VARCHAR2(20)    DEFAULT 'USER' NOT NULL
);

CREATE SEQUENCE member_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

INSERT INTO tbl_member (seq, id, passwd, name, role)
VALUES (member_seq.NEXTVAL, 'hong', '1234', '홍길동', 'USER');

commit;

SELECT * 
FROM ( 
   SELECT empno, ename, sal 
            , RANK() OVER(ORDER BY sal DESC) r   
    FROM emp   
 )  
 WHERE r <= 5;
 
 
----
UPDATE emp
SET sal = 1000
WHERE empno = 7839;
UPDATE emp
SET sal = 1000
WHERE empno = 7788;
COMMIT;
--
UPDATE emp
SET sal =5000
WHERE empno = 7839;
COMMIT;
UPDATE emp
SET sal = 3000
WHERE empno = 7788;
COMMIT;

create table member
(
  memberid varchar2(50) primary key
  , name varchar2(50) not null
  , password varchar2(10) not null
  , regdate date not null 
);

create table article
(
  article_no number primary key
  , writer_id varchar2(50) not null
  , writer_name varchar2(50) not null
  , title varchar2(255) not null
  , regdate date not null
  , moddate date not null
  , read_cnt number
);
create sequence seq_article;

create table article_content
(
  article_no number primary key
  , content clob
  , constraint fk_article_content_article_no foreign key(article_no) references article(article_no)
);

select * from tabs;

DESC article;

create table member
(
  memberid varchar2(50) primary key
  , name varchar2(50) not null
  , password varchar2(10) not null
  , regdate date not null 
);

create table article
(
  article_no number primary key
  , writer_id varchar2(50) not null
  , writer_name varchar2(50) not null
  , title varchar2(255) not null
  , regdate date not null
  , moddate date not null
  , read_cnt number
);
create sequence seq_article;

create table article_content
(
  article_no number primary key
  , content clob
  , constraint fk_article_content_article_no foreign key(article_no) references article(article_no)
);

-- 1. 기존 테이블 및 시퀀스 삭제 (자식부터 삭제 또는 CASCADE 사용)
DROP TABLE article_content CASCADE CONSTRAINTS;
DROP TABLE article CASCADE CONSTRAINTS;
DROP TABLE member CASCADE CONSTRAINTS;
DROP SEQUENCE seq_article;

-- 2. member 테이블 생성
CREATE TABLE member (
    memberid VARCHAR2(50) PRIMARY KEY,
    name VARCHAR2(50) NOT NULL,
    password VARCHAR2(10) NOT NULL,
    regdate DATE NOT NULL 
);

-- 3. article 테이블 생성 (부모)
CREATE TABLE article (
    article_no NUMBER PRIMARY KEY,
    writer_id VARCHAR2(50) NOT NULL,
    writer_name VARCHAR2(50) NOT NULL,
    title VARCHAR2(255) NOT NULL,
    regdate DATE NOT NULL,
    moddate DATE NOT NULL,
    read_cnt NUMBER DEFAULT 0
);

-- 4. 시퀀스 생성
CREATE SEQUENCE seq_article;

-- 5. article_content 테이블 생성 (자식 - article 참조)
CREATE TABLE article_content (
    article_no NUMBER PRIMARY KEY,
    content CLOB,
    CONSTRAINT fk_article_content_article_no 
        FOREIGN KEY(article_no) REFERENCES article(article_no) ON DELETE CASCADE
);

SELECT password 
FROM member 
WHERE name = '홍길동';
commit;

-----

create table filetest(          
     num number not null primary key  
     , subject varchar2(50) not null     
     
     , filesystemname varchar2(100) -- 실제 저장되는 파일명       a1.txt
     , originalfilename varchar2(100) -- 저장할 때 파일명             a.txt
     , filelength number  -- 파일크기
);
    
create sequence seq_filetest;  

select * from filetest;

-- 기존 테이블 삭제 (필요 시 주석 해제)
 DROP TABLE ORDER_DETAIL CASCADE CONSTRAINTS;
 

CREATE TABLE ORDER_DETAIL (
    ORDER_DETAIL_NO  NUMBER(10, 0)  NOT NULL, -- 주문상세 기본키 (PK)
    ORDER_NO         NUMBER(10, 0)  NOT NULL, -- 주문번호 (FK)
    PRODUCT_NO       NUMBER(10, 0)  NOT NULL, -- 상품번호 (FK)
    ORDER_QTY        NUMBER(5, 0)   NOT NULL, -- 주문수량
    PRICE            NUMBER(10, 0)  NOT NULL, -- 구매 당시 단가
    OPTION_ID        NUMBER(10, 0)  NULL,     -- 옵션아이디 (FK, NULL 허용)
    
    -- 기본키 제약조건
    CONSTRAINT PK_ORDER_DETAIL PRIMARY KEY (ORDER_DETAIL_NO)

);

-- 기존 시퀀스 삭제
DROP SEQUENCE SEQ_ORDER_DETAIL_NO;
-- 시퀀스 생성 (주문상세 번호 자동 증가용)
CREATE SEQUENCE SEQ_ORDER_DETAIL_NO
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;



-- 1. 주문번호 1001번 (상품 3개 주문 : 옵션 있음 2개, 옵션 없음 1개)
INSERT INTO ORDER_DETAIL (ORDER_DETAIL_NO, ORDER_NO, PRODUCT_NO, ORDER_QTY, PRICE, OPTION_ID)
VALUES (SEQ_ORDER_DETAIL_NO.NEXTVAL, 1001, 10, 2, 15000, 501);

INSERT INTO ORDER_DETAIL (ORDER_DETAIL_NO, ORDER_NO, PRODUCT_NO, ORDER_QTY, PRICE, OPTION_ID)
VALUES (SEQ_ORDER_DETAIL_NO.NEXTVAL, 1001, 12, 1, 32000, 505);

INSERT INTO ORDER_DETAIL (ORDER_DETAIL_NO, ORDER_NO, PRODUCT_NO, ORDER_QTY, PRICE, OPTION_ID)
VALUES (SEQ_ORDER_DETAIL_NO.NEXTVAL, 1001, 20, 3, 8900, NULL); -- 단품 상품 (OPTION_ID = NULL)


-- 2. 주문번호 1002번 (상품 2개 주문)
INSERT INTO ORDER_DETAIL (ORDER_DETAIL_NO, ORDER_NO, PRODUCT_NO, ORDER_QTY, PRICE, OPTION_ID)
VALUES (SEQ_ORDER_DETAIL_NO.NEXTVAL, 1002, 15, 1, 129000, 602);

INSERT INTO ORDER_DETAIL (ORDER_DETAIL_NO, ORDER_NO, PRODUCT_NO, ORDER_QTY, PRICE, OPTION_ID)
VALUES (SEQ_ORDER_DETAIL_NO.NEXTVAL, 1002, 22, 5, 4500, NULL); -- 단품 상품 (OPTION_ID = NULL)



 DROP TABLE PRODUCT_OPTION CASCADE CONSTRAINTS;
  DROP TABLE PRODUCT CASCADE CONSTRAINTS;
-- 1. 상품 테이블 (PRODUCT)
CREATE TABLE PRODUCT (
    PRODUCT_NO    NUMBER(10, 0) NOT NULL,
    PRODUCT_NAME  VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_PRODUCT PRIMARY KEY (PRODUCT_NO)
);

-- 2. 상품 옵션 테이블 (PRODUCT_OPTION)
CREATE TABLE PRODUCT_OPTION (
    OPTION_ID     NUMBER(10, 0) NOT NULL,
    PRODUCT_NO    NUMBER(10, 0) NOT NULL,
    OPTION_NAME   VARCHAR2(100) NOT NULL,
    CONSTRAINT PK_PRODUCT_OPTION PRIMARY KEY (OPTION_ID)
);


-- ==========================================
-- PRODUCT 테이블 더미 데이터 (상품 5개)
-- ==========================================
INSERT INTO PRODUCT (PRODUCT_NO, PRODUCT_NAME) VALUES (10, '맛있는 탐사수 2L');
INSERT INTO PRODUCT (PRODUCT_NO, PRODUCT_NAME) VALUES (12, '쿠팡 브랜드 남성용 반팔티');
INSERT INTO PRODUCT (PRODUCT_NO, PRODUCT_NAME) VALUES (15, '로지텍 무선 게이밍 마우스');
INSERT INTO PRODUCT (PRODUCT_NO, PRODUCT_NAME) VALUES (20, '신선 유기농 바나나 1kg');
INSERT INTO PRODUCT (PRODUCT_NO, PRODUCT_NAME) VALUES (22, '제주 삼다수 500ml');

-- ==========================================
-- PRODUCT_OPTION 테이블 더미 데이터 (옵션 3개)
-- ==========================================
INSERT INTO PRODUCT_OPTION (OPTION_ID, PRODUCT_NO, OPTION_NAME) VALUES (501, 10, '6팩');
INSERT INTO PRODUCT_OPTION (OPTION_ID, PRODUCT_NO, OPTION_NAME) VALUES (505, 12, 'L / 화이트');
INSERT INTO PRODUCT_OPTION (OPTION_ID, PRODUCT_NO, OPTION_NAME) VALUES (602, 15, '블랙');


-- 변경사항 최종 저장
COMMIT;

SELECT table_name 
FROM user_tables 
WHERE table_name = 'CATEGORY';



create table googlemap
   (
       id number primary key  -- 100/101/102
      , type varchar2(20)     -- 레스토랑 /커피.. (맛집의 종류)
      , name varchar2(30)     -- 식당이름
      , lng number
      , lat number
      , address varchar2(255)  --식당 주소
   ); 


select * from googlemap


   CREATE TABLE "SCOTT"."REPLYBOARD" 
   (   
    "NUM" NUMBER NOT NULL ENABLE,     -- 글번호
   "WRITER" VARCHAR2(12 BYTE) NOT NULL ENABLE,  --작성자 
   "EMAIL" VARCHAR2(30 BYTE) NOT NULL ENABLE,   --이메일
   "SUBJECT" VARCHAR2(50 BYTE) NOT NULL ENABLE,  --제목
   "PASS" VARCHAR2(10 BYTE) NOT NULL ENABLE,  --비밀번호
   "READCOUNT" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE,  --조회수 
   "REGDATE" DATE DEFAULT sysdate NOT NULL ENABLE,   --작성일
   "CONTENT" CLOB NOT NULL ENABLE,  --글내용
   "IP" VARCHAR2(20 BYTE) NOT NULL ENABLE, --IP주소 
   
   "REF" NUMBER(5,0) DEFAULT 0 NOT NULL ENABLE,  --그룹 
   "STEP" NUMBER(3,0) DEFAULT 1 NOT NULL ENABLE,  --순번
   "DEPTH" NUMBER(3,0) DEFAULT 0 NOT NULL ENABLE,  --깊이
   
    PRIMARY KEY ("NUM")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" 
 LOB ("CONTENT") STORE AS BASICFILE (
  TABLESPACE "USERS" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
  NOCACHE LOGGING 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
       
  CREATE SEQUENCE SEQ_REPLYBOARD;
  
  commit;
  
  select * from dept
  
  delete dept where deptno = 50;