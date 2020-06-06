-- Create a function to return the salary for an employee.
-- So we need one parameter (IN) number  ( employee_id )
-- The return value should be also a number because it is the salary

CREATE OR REPLACE FUNCTION get_sal
(p_emp_id NUMBER)
RETURN NUMBER
IS

v_sal NUMBER;

BEGIN 

  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = p_emp_id;
  
  RETURN v_sal;
  
END;


/* 
   Errors in a function can be seen via USER / ALL / DBA_
   ERRORS views
   
*/

------------------------------------------

-- We have many different methods to invoke the function

-- 1 as part of the expression
DECLARE
    v_sal NUMBER;
BEGIN
    v_sal := get_sal(100);
    dbms_output.put_line (v_sal);
END;

--------------

-- 2 as a parameter value

BEGIN
    dbms_output.put_line (get_sal(100));
END;

----------------

-- We can also invoke the function by executing the following

EXECUTE dbms_output.put_line (get_sal(100) );

-- 3 using a host variable

VARIABLE b_salary NUMBER;

EXECUTE :b_salary := get_sal(100);

PRINT b_salary;

----------------------------------

-- 4 as part of select statement

SELECT get_sal(100) FROM dual;

SELECT employee_id
      ,first_name
      ,get_sal(employee_id)
  FROM employees
 WHERE department_id = 20;
 
----------------

SELECT * 
  FROM USER_OBJECTS
 WHERE object_name = 'GET_SAL';

SELECT LINE, TEXT 
  FROM USER_SOURCE
  WHERE NAME='GET_SAL';
  
BEGIN
    dbms_output.put_line(get_sal(100))  ;
END;

--NOW LET'S TRY THIS 


-- no data found

BEGIN
    dbms_output.put_line(get_sal(9999))  ;
END;


-- No data found was NOT raised in the select query. 
-- Because the function does not have an exception clause

-- Select with an invalid employee_id will NOT give an error unless
-- you have an exception block in the function.

SELECT get_sal(9999) 
  FROM dual;


-- Now we will put an Exception block in the function

CREATE OR REPLACE FUNCTION get_sal
(p_emp_id NUMBER)
RETURN NUMBER
IS
    v_sal NUMBER;
BEGIN 
  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = p_emp_id;
  
  RETURN v_sal;
  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
  RETURN -1;
  
END;


SELECT get_sal(9999) 
  FROM dual;

-- Create a function to return the salary for an employee.
-- So we need one parameter (IN) NUMBER  ( employee_id )
-- The return value should also be a NUMBER because it is the salary

CREATE OR REPLACE FUNCTION get_sal
(p_emp_id NUMBER)
RETURN NUMBER
IS
    v_sal NUMBER;
BEGIN 
  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = p_emp_id;
  
  RETURN v_sal;
  
END;
------------------------------------------

BEGIN
    dbms_output.put_line (get_sal(100));
END;

--NOW LET'S TRY THIS 
BEGIN
    dbms_output.put_line(get_sal(9999))  ;
END;


SELECT get_sal(9999) 
  FROM dual;
-- No data found not raised in select query :) 

CREATE OR REPLACE FUNCTION get_sal
(p_emp_id NUMBER)
RETURN NUMBER
IS
    v_sal number;
BEGIN 
  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = p_emp_id;
  
  RETURN v_sal;
  EXCEPTION 
  WHEN NO_DATA_FOUND THEN
  RETURN -1;
  
END;


SELECT get_sal(9999) 
  FROM dual;


-- Create a function to calculate tax on the salary 
-- If the salary <5000 then tax equals 10%  else 15%

CREATE OR REPLACE FUNCTION get_sal_tax
(p_sal NUMBER)
RETURN NUMBER
IS

BEGIN

    IF p_sal<5000 THEN
        RETURN p_sal * (10/100);
    ELSE
        RETURN p_sal * (15/100);
    END IF;
 
END;
---------------------------------

-- Using positional notation method
SELECT employee_id, first_name, salary, get_sal_tax(salary)
  FROM employees;

-- Using naming notation method
SELECT employee_id, first_name, salary, get_sal_tax(p_sal=>salary)
  FROM employees;

SELECT employee_id, first_name, salary, get_sal_tax(salary)
  FROM employees
 WHERE get_sal_tax(salary) > 2000
ORDER BY get_sal_tax(salary);








CREATE OR REPLACE FUNCTION get_sal_tax
(p_sal NUMBER)
RETURN NUMBER
IS

BEGIN
    
    COMMIT;

    IF p_sal<5000 THEN
        RETURN p_sal * (10/100);
    ELSE
        RETURN p_sal * (15/100);
    END IF;
 
END;

--------

-- You cannot use a function in a select if the function contains 
-- COMMIT or ROLLBACK

-- 14552. 00000 -  "cannot perform a DDL, commit or rollback inside a query or DML "

SELECT employee_id, first_name, salary, get_sal_tax(salary)
  FROM employees
 WHERE get_sal_tax(salary) > 2000
ORDER BY get_sal_tax(salary);

-- But it won't work like this

DECLARE

    v NUMBER;
    
BEGIN

    v := get_sal_tax(5000);
    dbms_output.put_line(v);
END;

-------------------


CREATE OR REPLACE FUNCTION get_sal_tax
(p_sal NUMBER)
RETURN NUMBER
IS

BEGIN

INSERT 
  INTO departments(department_id,department_name)
VALUES (-99,'test');

    IF p_sal<5000 THEN
        RETURN p_sal * (10/100);
    ELSE
        RETURN p_sal * (15/100);
    END IF;
 
END;

--------
-- You cannot use a function in a select statement if the function 
-- contains DML (SELECT, INSERT, UPDATE, DELETE or MERGE)

-- 14551. 00000 -  "cannot perform a DML operation inside a query "

SELECT employee_id, first_name, salary, get_sal_tax(salary)
  FROM employees
 WHERE get_sal_tax(salary)>2000
ORDER BY get_sal_tax(salary);


-- But it will work like this, but this should not be used.

DECLARE
    v NUMBER;
BEGIN
    v := get_sal_tax(5000);
    dbms_output.put_line(v);
END;

SELECT * 
  FROM departments
 WHERE department_id= -99;
------------------

-- You can drop the function

DROP FUNCTION get_sal_tax;
