--- 1 simple if statement

DECLARE

    v_no NUMBER:=&v;
    
BEGIN

   IF v_no >=10 THEN
        dbms_output.put_line('The number you entered is >=10');
   END IF;
   
END;

-----------------------------------

--- 2 simple if statement with else

DECLARE

    v_no NUMBER := &v;
    
BEGIN

   IF v_no >=10 THEN
        dbms_output.put_line('The number you entered is >=10');
   ELSE
        dbms_output.put_line('The number you entered is less than 10');
   END IF;
   
END;

-------------------------------------

--if / elsif
--This logic needs enhancement
--Try to enter negative or value >100

DECLARE

    v_grade NUMBER := &v;
    
BEGIN

   IF v_grade BETWEEN 90 AND 100 THEN
        dbms_output.put_line('The grade is A');
   ELSIF v_grade BETWEEN 80 AND 89 THEN
        dbms_output.put_line('The grade is B');
   ELSIF v_grade BETWEEN 70 AND 79 THEN
        dbms_output.put_line('The grade is C');
   ELSIF v_grade BETWEEN 60 AND 69 THEN
        dbms_output.put_line('The grade is D');
   ELSE
        dbms_output.put_line('The grade is F');
   END IF;
   
END;

---------------------------------


DECLARE

    v_grade NUMBER := &v;
    
BEGIN

  IF v_grade BETWEEN 0 AND 100 THEN
  
     IF v_grade BETWEEN 90 AND 100 THEN
        dbms_output.put_line('The grade is A');
     ELSIF v_grade BETWEEN 80 AND 89 THEN
        dbms_output.put_line('The grade is B');
     ELSIF v_grade BETWEEN 70 AND 79 THEN
        dbms_output.put_line('The grade is C');
     ELSIF v_grade BETWEEN 60 AND 69 THEN
        dbms_output.put_line('The grade is D');
     ELSE
        dbms_output.put_line('The grade is F');
     END IF;
     
  ELSE
  
    dbms_output.put_line('The grade should be a number BETWEEN 0 and 100');
    
  END IF;

END;

------------------


/* Write a block the takes the employee id as a substitute variable
Output message: 'yes, the salary is >=15000' if the salary >=15000
Output message: 'No, the salary is <15000' if the salary <15000
*/

DECLARE
    v_sal employees.salary%TYPE;
BEGIN
    SELECT salary INTO v_sal
      FROM employees
     WHERE employee_id = &emp_id;

      IF v_sal >= 15000 THEN
            dbms_output.put_line('Yes, the salary is >= 15000');
      ELSE
            dbms_output.put_line('No, the salary is < 15000');
      END IF;
END;


DECLARE
    x NUMBER:=5;
    y NUMBER;
BEGIN

  IF x<>y THEN
        dbms_output.put_line('Welcome');
  ELSE
        dbms_output.put_line('Operator with null value is always = null');
  END IF;

END;

--- solution ---

DECLARE
    x NUMBER:=5;
    y NUMBER;
BEGIN

  IF NVL(x,0)<>NVL(y,0) THEN
        dbms_output.put_line('Welcome');
  ELSE
        dbms_output.put_line('Operator with null value is always = null');
  END IF;

END;

-------------------------

DECLARE
    x NUMBER;
    y NUMBER;
BEGIN

  IF x=y THEN
        dbms_output.put_line('Welcome');
  ELSE
        dbms_output.put_line('Operator with null value is always = null');
  END IF;

END;

--- solution ---

DECLARE

    x NUMBER;
    y NUMBER;

BEGIN

  IF x is NULL AND y IS NULL THEN
        dbms_output.put_line('Welcome');
  ELSE
        dbms_output.put_line('Operator with null value is always = null');
  END IF;

END;

--- Case Expression ---

SELECT 
    employee_id
   ,first_name
   ,salary
   ,department_id
   ,CASE department_id 
        WHEN 90 THEN salary*1.1
        WHEN 60 THEN salary*1.2
        WHEN 100 THEN salary*1.3
        ELSE salary
    END new_sal
  FROM  employees;

--- Case Expression more flexible ---

SELECT 
    employee_id
   ,first_name
   ,salary
   ,department_id
   ,CASE  
        WHEN department_id = 90 THEN salary*1.1
        WHEN department_id = 60 THEN salary*1.2
        WHEN department_id = 100 THEN salary*1.3
        ELSE salary
    END new_sal
  FROM  employees;
  
--------------------------------------

--- Case Expression ---

DECLARE

    v_sal  NUMBER;
    v_desc VARCHAR2(100);
    
BEGIN

  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = &emp_id;
  
  v_desc := CASE 
        WHEN v_sal IS NULL THEN 'No salay for the employee'
        WHEN v_sal BETWEEN 1000 AND 3000  THEN 'Salay is low'
        WHEN v_sal BETWEEN 3001 and 5000 THEN 'Salay is medium'
        WHEN v_sal BETWEEN 5001 and 10000 then 'Salay is good'
  ELSE 'Salay is High'
  END; --- Notice END not END CASE
    
        dbms_output.put_line(v_desc);
  
END;
------------------------

SELECT * 
  FROM employees;
    
--- Case Statement --- 

DECLARE

    v_sal NUMBER;
    v_desc VARCHAR2(100);
    
BEGIN

  SELECT salary 
    INTO v_sal
    FROM employees
   WHERE employee_id = &emp_id;
  
  CASE 
        WHEN v_sal IS NULL THEN 
            dbms_output.put_line('No salay for the employee');
        WHEN v_sal BETWEEN 1000 AND 3000  THEN
            dbms_output.put_line('Salay is low');
        WHEN v_sal BETWEEN 3001 AND 5000 THEN 
            dbms_output.put_line('Salay is medium');
        WHEN v_sal BETWEEN 5001 AND 10000 THEN 
            dbms_output.put_line('Salay is good');
  ELSE 
        dbms_output.put_line('Salay is High');
  END CASE; --Notice END CASE for Case Statement

END;


--basic loop
--write a basic loop to print welcome 3 times

DECLARE

    v_counter NUMBER := 0;
    
BEGIN
    LOOP
        v_counter := v_counter + 1;
        dbms_output.put_line('Welcome ' || v_counter);
 
        EXIT WHEN v_counter = 3;
    END LOOP;
END;

--------------------------------------

--- Another method ---

DECLARE

v_counter NUMBER := 0;

BEGIN
    LOOP
        v_counter := v_counter + 1;
            dbms_output.put_line('Welcome ' ||v_counter);
        IF v_counter = 3 THEN
            EXIT;
       END IF;
 
 END LOOP;
 
END;
-------------------------------------------

--- Print the employees first name for employee 100,101,102 
--- using basic loop

DECLARE

    v_empno NUMBER := 100;
    v_first_name employees.first_name%TYPE;
    
BEGIN
     LOOP
        EXIT WHEN v_empno > 102;
    
          SELECT first_name 
            INTO v_first_name
            FROM employees
           WHERE employee_id = v_empno;
          
            dbms_output.put_line(v_empno ||' '|| v_first_name);
  
            v_empno := v_empno + 1;

     END LOOP;
END;


DECLARE

    v_counter NUMBER := 1;
    
BEGIN

 WHILE v_counter <= 3
     LOOP
        dbms_output.put_line('Welcome');
        v_counter := v_counter + 1;
     END LOOP;
END;

--------

--Print the employees first name for employee 100,101,102 
--using while loop

DECLARE

    v_empno NUMBER := 100;
    v_first_name employees.first_name%TYPE;
    
BEGIN
      WHILE v_empno <= 102
      LOOP
          SELECT first_name 
            INTO v_first_name
            FROM employees
           WHERE employee_id = v_empno;
      
                dbms_output.put_line(v_empno ||' '|| v_first_name);
          
            v_empno := v_empno + 1; 
      
      END LOOP;
END;

------------------------
--- For Loop ---
BEGIN
  FOR i in 1..3
  LOOP
    dbms_output.put_line('welcome ' ||i);
  END LOOP;

END;
------------------------

BEGIN
  FOR i IN 1..1

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;


-- If the lower bound is greater than the upper band
-- then the for loop does not run.

BEGIN
  FOR i IN 2..1

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;

-- The following will print 4 Welcome lines
-- -2, -1, 0, and 1

BEGIN
  FOR i IN -2..1

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;

-- The following will print in reverse order

BEGIN
  FOR i IN REVERSE -2..1

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;

--------------------
BEGIN
  FOR i IN 3..5

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;
--------------------
BEGIN
  FOR i IN REVERSE 1..3

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;
----------------

BEGIN
  FOR i IN REVERSE 3..5

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;
-------------------------

-- The following will print the integer rounded
-- of 9/2, rounded (4.5) or 5 times

BEGIN
  FOR i IN 1..9/2

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;


DECLARE

-- The following will only print 1 time rounded
-- 11/8 or 1.375, 1 after rounding

BEGIN
  FOR i IN 1..11/8

  LOOP
    dbms_output.put_line('Welcome ' || i);
  END LOOP;

END;
------------------------------------------------

DECLARE
    v_name VARCHAR2(200);
BEGIN
FOR i IN 100..102
    LOOP
        SELECT first_name||' '||last_name
          INTO v_name
          FROM employees
         WHERE employee_id=i;
        
        dbms_output.put_line(i || ':' || v_name);
        
    END LOOP;
END;



/*
try to print the following

*
**
***
****
*****

*/

DECLARE
    v_star VARCHAR2(100);
BEGIN
FOR i IN 1..5
    LOOP
        FOR j IN 1..i
            LOOP
                v_star := v_star || '*';
            END LOOP;
    dbms_output.put_line(v_star); 
    v_star := null;
    END LOOP;
END;
--------------------------------


DECLARE
    v_star varchar2(100);
BEGIN
    <<outer_loop>>
    FOR i IN 1..5
    LOOP
        <<inner_loop>>
        FOR j In 1..i
        LOOP
            v_star := v_star || '*';
        END LOOP inner_loop;
    dbms_output.put_line(v_star); 
    v_star := NULL;
    END LOOP outer_loop;
END;
-----------------------------------------

DECLARE
v_star VARCHAR2(100);
BEGIN
<<outer_loop>>
FOR i IN 1..5
  LOOP
        <<inner_loop>>
        FOR j IN 1..i
        LOOP
        v_star := v_star || '*';
        EXIT;
        END LOOP inner_loop;
  dbms_output.put_line(v_star); 
  v_star:=NULL;
  END LOOP outer_loop;
END;

-------------------

--- Exit the outer loop from the inner loop ---

DECLARE
v_star VARCHAR2(100);
BEGIN
<<outer_loop>>
FOR i IN 1..5
  LOOP
        <<inner_loop>>
        FOR j IN 1..i
        LOOP
        v_star := v_star || '*';
        EXIT outer_loop WHEN i = 3;
        END LOOP inner_loop;
  dbms_output.put_line(v_star); 
  v_star:=NULL;
  END LOOP outer_loop;
END;



BEGIN

for i IN 1..10 
  LOOP
  dbms_output.put_line (i);
  
  END LOOP;

END;

-- We want to print the Symbol :) under each number 
-- but only for 1,2,3,4,5
-- there are many methods
-- method 1 
DECLARE

    v_sym VARCHAR2(100);
    
BEGIN

FOR i IN 1..10 
  LOOP
      If i BETWEEN 1 AND 5 THEN
      v_sym :=i || CHR(10) || ':)';
      ELSE
      v_sym := i;
      END IF;
  
        dbms_output.put_line (v_sym);
  
  END LOOP;

END;
---------------------------------------

--method 2
BEGIN
FOR i IN 1..10 
  LOOP
    dbms_output.put_line (i);
  CONTINUE when i>5; --This means to stop executing next statement(s) when i>5
    dbms_output.put_line (':)');
  END LOOP;

END;
