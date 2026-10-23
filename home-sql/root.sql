   1) 데이터베이스 생성
   CREATE DATABASE scottdb CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
   
   2) scott 계정 생성       
   CREATE USER 'scott'@'localhost' IDENTIFIED BY 'tiger';    
   CREATE USER 'scott'@'%' IDENTIFIED BY 'tiger';   

   3) scott에게 scottdb 권한 부여   
   GRANT ALL PRIVILEGES ON scottdb.* TO 'scott'@'localhost';
   GRANT ALL PRIVILEGES ON scottdb.* TO 'scott'@'%';

   4) 권한 적용/확인   
   FLUSH PRIVILEGES;

   5) 권한 확인:      
   SHOW GRANTS FOR 'scott'@'localhost';
   SHOW GRANTS FOR 'scott'@'%';