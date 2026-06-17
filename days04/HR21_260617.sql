 select * 
      from employees
       where salary NOT IN
     (select salary from employees
      where department_id = 30
      --비연관 쿼리 
      ); -- FROM scott.emp; --스키마.객체명 
      
      SELECT*
 FROM scott.emp;
     
 SELECT*
 FROM semp; 
      
      
    select last_name,salary,
    ROUND (salary/1000,0),
    RPAD(' ', ROUND (salary/1000,0)+1, '#') "Salary"
    from employees
    where department_id = 80
    order by last_name, "Salary";

 
    