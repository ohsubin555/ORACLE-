desc member;

username, password, enabled 컬럼

ID          VARCHAR2(50)  username
PWD         VARCHAR2(50)  password

alter table member 
add constraint pk_member_id primary key(id);

ALTER TABLE MEMBER 
MODIFY (PWD VARCHAR2(100));

select * from member

CREATE TABLE member_authorities
(
    username VARCHAR2(50) 
  , authority VARCHAR2(50) 
  , CONSTRAINT FK_memberauthorities_USERNAME  FOREIGN KEY(username) REFERENCES member(id)
);

insert into member (id,pwd,name) values ('admin', '1234' , 'admin')
insert into member (id,pwd,name) values ('kenik', '1234' , 'kenik')

SeLECT * From member_authorities;

INSERT INTO  member_authorities
VALUES ( 'kenik', 'ROLE_USER');

INSERT INTO  member_authorities
VALUES ( 'admin', 'ROLE_USER');
INSERT INTO  member_authorities
VALUES ( 'admin', 'ROLE_MANAGER');
INSERT INTO  member_authorities
VALUES ( 'admin', 'ROLE_ADMIN');

delete from member;
delete  From member_authorities;

COMMIT ;

--------------------------------

 create table persistent_logins
 (
     username varchar2(64) not null
   , series varchar2(64) primary key
   , token varchar2(64) not null
   , last_used date not null   
 );

select * from persistent_logins
