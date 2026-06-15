SHOW USER;
SHOW CON_NAME;
---sys---
SELECT *
from dba_users;

---용어정리---
1. 데이터 - 컴퓨터에 입력된 값
2. 정보- 데이터로 부터 알아내는 정보
3. 데이터 베이스 (db) - 데이터를 모아둔 장소
4. DBMS (Database Management System)
  - 데이터베이스를 관리하는 프로그램(소프트웨어) EX) 엑셀
5. 테이블 (Table) - 데이터를 저장하는 기본 단위
   EX) 엑셀 시트(SHEET)
6. 스키마 (SCHEMA)   
SCOTT
│
├─ TABLE
│   ├─ EMP
│   ├─ DEPT
│   └─ BONUS
│
├─ VIEW
│   └─ V_EMP
│
├─ INDEX
│   └─ IDX_EMP_ENAME
│
├─ SEQUENCE
│   └─ EMP_SEQ
│
├─ PROCEDURE
│   └─ TEST_PROC
│
├─ FUNCTION
│   └─ ADD_NUM
│
└─ TRIGGER
    └─ TRG_EMP 
    
    등등
    
    scott 계정 소유의 DB 객체: 테이블 생성 (
    
    SELECT  *
FROM dba_tables;


-- XEPDB1 이동
SHOW CON_NAME;
alter session set container = XEPDB1;
SHOW_CONNAME;
SHOW CON_NAME;

SELECT *
FROM dba_users;
WHERE username IN ('SCOTT', 'HR');

