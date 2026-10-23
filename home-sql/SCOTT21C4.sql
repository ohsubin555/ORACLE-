> 테이블, 시퀀스 생성   
CREATE TABLE tbl_board
 (
     bno        number(10)
   , title      varchar2(200) not null
   , content    varchar2(2000) not null
   , writer     varchar2(50) not null
   , regdate    date default sysdate
   , updatedate date default sysdate
 ); 
alter table tbl_board 
add constraint pk_tblboard_bno primary key(bno);
 
CREATE SEQUENCE seq_board;   

-- 1. 기존 시퀀스 삭제
DROP SEQUENCE seq_board;

-- 2. 기존 테이블 삭제 (외래키 제약조건까지 깔끔하게 일괄 삭제)
DROP TABLE tbl_board CASCADE CONSTRAINTS;

commit

DESC tbl_board;
BEGIN
    FOR i IN 30 .. 174
    LOOP 
      INSERT INTO tbl_board (bno, title, content, writer)
      VALUES (seq_board.nextval, '스프링-'||i, '스프링-'||i, '홍길동');
    END LOOP;  
END;


BEGIN
    FOR i IN 30 .. 174
    LOOP 
      IF MOD(i,5)=0 OR MOD(i, 17)=0 THEN
        UPDATE tbl_board
        SET title = '자바-' || i        
        WHERE bno = i;
      END IF; 
    END LOOP;  
END;
COMMIT;    


-------

create table tbl_reply (
  rno number(10,0), 
  bno number(10,0) not null,
  reply varchar2(1000) not null,
  replyer varchar2(50) not null, 
  replyDate date default sysdate, 
  updateDate date default sysdate
);
select * from emp
create sequence seq_reply;

alter table tbl_reply add constraint pk_reply primary key (rno);

alter table tbl_reply  add constraint fk_reply_board  
foreign key (bno)  references  tbl_board (bno); 

commit;

select * from tbl_reply
order by bno desc;

 SELECT rno, bno, reply, replyer, replyDate, updateDate
      FROM tbl_reply
      WHERE bno = 173
      ORDER BY rno ASC
      
         
select * from user_sequences
select * from tbl_emp
select * from tbl_dept

      commit
      
drop sequence SEQ_TBLDEPT_DEPTNO





      