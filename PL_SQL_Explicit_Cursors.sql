/*

Explicit Cursor Functions:
    - Can perform row-by-row processing beyond the first row returned by a query
    - Keeps track of the row that is currently being processed
    - Enables the programmer to manually control explicit cursors in the PL/SQL Block

*/




SELECT * 
  FROM employees
 WHERE department_id = 30;


----------------------
/* 
  Create a cursor to print employee_id, first_name  
  for department_id = 30 
*/  
  
--- Method 1

DECLARE
  CURSOR c_emp_dept30 IS
  SELECT employee_id
        ,first_name 
    FROM employees
   WHERE department_id = 30;
  
  v_empno employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;

BEGIN
OPEN c_emp_dept30;

  LOOP
      FETCH c_emp_dept30 
       INTO v_empno
           ,v_first_name;
      EXIT WHEN c_emp_dept30%NOTFOUND;
      dbms_output.put_line(v_empno||' '||v_first_name); -- The exit should be before the output
  END LOOP;
CLOSE c_emp_dept30;
END;

----------------------------------------------------

--- Method 2

DECLARE
  CURSOR c_emp_dept30 is
  SELECT  employee_id
         ,first_name 
    FROM employees
   WHERE department_id = 30;
  
   v_emp_rec employees%ROWTYPE;
  
BEGIN
OPEN c_emp_dept30;

  LOOP
      FETCH c_emp_dept30 
       INTO v_emp_rec.employee_id
           ,v_emp_rec.first_name ;
      EXIT WHEN c_emp_dept30%NOTFOUND;
      dbms_output.put_line(v_emp_rec.employee_id||' '||v_emp_rec.first_name);
  END LOOP; 
  CLOSE c_emp_dept30;
END;
----------------------------------------------------

--- Method 3
/*
    PL/SQL records based on cursor, this is the 3rd method for creating pl/sql records
    1 is programmer, 2 is %rowtype, 3rd is cursor records
*/

-- PL/SQL records based on a cursor

DECLARE
  CURSOR c_emp_dept30 IS
  SELECT  employee_id
         ,first_name 
    FROM employees
  WHERE department_id = 30;
  
   v_emp_rec c_emp_dept30%ROWTYPE; 
   
BEGIN
OPEN c_emp_dept30;

  LOOP
      FETCH c_emp_dept30 
       INTO v_emp_rec;
      EXIT WHEN c_emp_dept30%NOTFOUND;
      dbms_output.put_line(v_emp_rec.employee_id||' '||v_emp_rec.first_name);
  END LOOP;
CLOSE c_emp_dept30;
END;

------------------------------------------------------
/*
  Update the salaries for employees in dept30 using cursor
  ( +100 for each one )
*/

DECLARE
  CURSOR c_emp_dept30 IS
  SELECT employee_id
        ,first_name
        ,salary 
    FROM employees
  WHERE department_id = 30;
  
  v_empno employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;
  v_salary employees.salary%TYPE;
  
BEGIN
OPEN c_emp_dept30;
 LOOP
      FETCH c_emp_dept30 
       INTO v_empno
           ,v_first_name
           ,v_salary;
      EXIT WHEN c_emp_dept30%NOTFOUND;
      UPDATE employees
         SET salary=salary+100
       WHERE employee_id = v_empno;
  END LOOP; 
  CLOSE c_emp_dept30;
  COMMIT;
END;
---------

SELECT * 
  FROM employees
 WHERE department_id = 30;

/* using c_emp%notfound, c_emp%isopen,c_emp%rowcount */

DECLARE
  CURSOR c_emp IS
  SELECT employee_id
        ,first_name 
    FROM employees;
  v_empno employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;

BEGIN
 IF c_emp%isopen THEN
    null;
 ELSE
 OPEN c_emp;
 END IF;
    dbms_output.put_line('The counter for cursor now is '||c_emp%ROWCOUNT);
  LOOP
      FETCH c_emp 
       INTO v_empno
           ,v_first_name;
      EXIT WHEN c_emp%NOTFOUND OR  c_emp%ROWCOUNT>10 ;
      dbms_output.put_line(v_empno||' '||v_first_name);
  END LOOP;
    dbms_output.put_line('The counter for cursor now is '||c_emp%ROWCOUNT);
  CLOSE c_emp;
END;

---------------------------

/* Basic loop cursor */

DECLARE
  CURSOR c_emp_dept30 IS
  SELECT employee_id
        ,first_name 
    FROM employees
   WHERE department_id = 30;
  
  v_empno employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;

BEGIN
OPEN c_emp_dept30;

  LOOP
      FETCH c_emp_dept30 
       INTO v_empno
           ,v_first_name;
      EXIT WHEN c_emp_dept30%NOTFOUND;
      dbms_output.put_line(v_empno||' '||v_first_name);
  END LOOP;
CLOSE c_emp_dept30;
END;
--------------------------
/* We will use same example above but using for loop cursor */

DECLARE
  CURSOR c_emp_dept30 IS
  SELECT employee_id
        ,first_name 
    FROM employees
   WHERE department_id = 30;


BEGIN

  FOR i IN c_emp_dept30
  LOOP
    dbms_output.put_line(i.employee_id||' '||i.first_name);
  END LOOP;

END;
-----------------------

/* Another way is use the select inside the for */

DECLARE

BEGIN

  FOR i IN (  SELECT employee_id
                    ,first_name 
                FROM employees
               WHERE department_id = 30)
  
  LOOP
    dbms_output.put_line(i.employee_id||' '||i.first_name);
  END LOOP;

END;





DECLARE
  CURSOR c_emp_dept(v_dept NUMBER) --Here we defined the parameter without size
  IS
  SELECT employee_id
        ,first_name 
    FROM employees
   WHERE department_id = v_dept;
  
  v_empno employees.employee_id%TYPE;
  v_first_name employees.first_name%TYPE;

BEGIN
OPEN c_emp_dept(10);
  dbms_output.put_line('dept 10 contains:');
  LOOP
      FETCH c_emp_dept 
       INTO v_empno
           ,v_first_name;
      EXIT WHEN c_emp_dept%NOTFOUND;
      dbms_output.put_line(v_empno||' '||v_first_name);
  END LOOP;
CLOSE c_emp_dept;

OPEN c_emp_dept(20);
  dbms_output.put_line('dept 20 contains:');
  LOOP
      FETCH c_emp_dept 
       INTO v_empno
           ,v_first_name;
      EXIT WHEN c_emp_dept%NOTFOUND;
      dbms_output.put_line(v_empno||' '||v_first_name);
  END LOOP;
CLOSE c_emp_dept;
END;
-------------------------------------------------------

/* We will do the same exmple using the for loop cursor */

DECLARE
  CURSOR c_emp_dept(v_dept NUMBER) --Here we defined the parameter without size
  IS
  SELECT employee_id id 
        ,first_name 
    FROM employees
   WHERE department_id = v_dept;

BEGIN

  dbms_output.put_line('dept 10 contains:');
  FOR i IN c_emp_dept (10)
  LOOP
      dbms_output.put_line(i.id||' '||i.first_name);
  END LOOP;


  dbms_output.put_line('dept 20 contains:');
  FOR j IN c_emp_dept (20)
  LOOP

    dbms_output.put_line(j.id||' '||j.first_name);
  END LOOP;
END;




/* This a normal select */

SELECT * FROM employees
WHERE employee_id IN (100,200)
ORDER BY 1;

/*when you put for update, then no one can do any DML(I,U,D)
for theses records, untill you finish your transaction ( commit, update ) 
after you execute the next statement try to open another session 
and do like the following:
  UPDATE
  EMPLOYEES
  SET SALARY = salary + 100;
*/

SELECT * FROM employees
WHERE employee_id in (100,200)
ORDER BY 1
FOR UPDATE;

COMMIT;


DECLARE
  CURSOR c_emp_dept30 is
  SELECT employee_id
        ,first_name
        ,salary 
    FROM employees
  WHERE department_id=30
  FOR UPDATE;
  
BEGIN

 FOR i IN c_emp_dept30
 LOOP
      UPDATE employees
         SET salary=salary+1
       WHERE employee_id = i.employee_id;
      
  END LOOP; 
  COMMIT;
END;
---
SELECT * FROM employees
 WHERE department_id = 30;

-----------
---current of  ------
DECLARE
  CURSOR c_emp_dept30 is
  SELECT employee_id
        ,first_name
        ,salary 
    FROM employees
   WHERE department_id = 30
  FOR UPDATE;
  
BEGIN

 FOR i IN c_emp_dept30
 LOOP
      UPDATE employees
         SET salary=salary-1
       WHERE CURRENT OF c_emp_dept30;   
  END LOOP; 
  COMMIT;
END;
---
SELECT * FROM employees
 WHERE department_id = 30;




