/* Creating procedure IN Parameters 
   (If no mode is specified the IN mode is the default mode)
*/

CREATE OR REPLACE PROCEDURE UPDATE_SAL
(P_EMP_ID IN NUMBER, P_AMOUNT IN NUMBER)
IS

BEGIN

  UPDATE employees
     SET salary = salary + P_AMOUNT
   WHERE employee_id = P_EMP_ID;
   
 COMMIT;
 
EXCEPTION

WHEN OTHERS THEN

    DBMS_OUTPUT.PUT_LINE (SQLCODE);
    DBMS_OUTPUT.PUT_LINE (SQLERRM);

END;

/* 
Example
Execute UPDATE_SAL (100,50);
*/

/* 
   If there is an error the error can be found in the 
   user_errors table
*/

SELECT * FROM user_errors
WHERE name = 'UPDATE_SAL';

/* 
In SQLPLUS
show errors

**** Edit the code in the buffer ****
SQL> ed
Wrote file afiedt.buf

  1  CREATE OR REPLACE PROCEDURE UPDATE_SAL
  2  (P_EMP_ID IN NUMBER, P_AMOUNT IN NUMBER)
  3  IS
  4  BEGIN
  5    UPDATE employees
  6	  SET salary=salary + P_AMOUNT
  7	WHERE employee_id = P_EMP_ID;
  8   COMMIT;
  9  EXCEPTION
 10  WHEN OTHERS THEN
 11	 DBMS_OUTPUT.PUT_LINE (SQLCODE);
 12	 DBMS_OUTPUT.PUT_LINE (SQLERRM)
 13* END;
SQL> /

Warning: Procedure created with compilation errors.

SQL> show errors
Errors for PROCEDURE UPDATE_SAL:

LINE/COL ERROR
-------- -----------------------------------------------------------------
13/1	 PLS-00103: Encountered the symbol "END" when expecting one of the
	 following:
	 := . ( % ;
	 The symbol ";" was substituted for "END" to continue.



Fix the error then

  1  CREATE OR REPLACE PROCEDURE UPDATE_SAL
  2  (P_EMP_ID IN NUMBER, P_AMOUNT IN NUMBER)
  3  IS
  4  BEGIN
  5    UPDATE employees
  6	  SET salary=salary + P_AMOUNT
  7	WHERE employee_id = P_EMP_ID;
  8   COMMIT;
  9  EXCEPTION
 10  WHEN OTHERS THEN
 11	 DBMS_OUTPUT.PUT_LINE (SQLCODE);
 12	 DBMS_OUTPUT.PUT_LINE (SQLERRM);
 13* END;

Save the changes

:wq

SQL> /

Procedure created.

SQL> show errors
No errors.

SQL> SELECT * FROM user_errors
WHERE name='UPDATE_SAL';  2  

no rows selected


SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.3.0.0.0

*/

-----------------------------------------------------------------------------------------
SELECT * FROM employees
WHERE employee_id = 100;

-- Calling the PROCEDURE alone --
EXECUTE UPDATE_SAL (100,50);

SELECT * FROM employees
WHERE employee_id = 100;
----------------------------------------------------------------------------------------

-- Calling the PROCEDURE in a block -- 

BEGIN

    UPDATE_SAL (&emp_id,&amount); -- UPDATE_SAL (100,50)
    
END;

SELECT * FROM employees
WHERE employee_id = 100;

/*
  The procedure source code is stored in the database
*/

SELECT * FROM USER_OBJECTS
WHERE object_name='UPDATE_SAL';

SELECT * FROM USER_SOURCE
 WHERE name='UPDATE_SAL'
ORDER BY LINE;

-- To drop the procedure -- 

DROP PROCEDURE UPDATE_SAL;


/* Creating procedure OUT Parameters  */


/* 
   1-  Create a procedure that takes emp_id as a parameter and 
       returns the first_name and salary

   Note: Use a bind variable to print the first_name and salary

*/

CREATE OR REPLACE PROCEDURE query_emp
(P_EMP_ID IN employees.employee_id%TYPE
,P_F_NAME OUT employees.first_name%TYPE
,P_SAL OUT employees.salary%TYPE
 )
IS

BEGIN
   SELECT first_name
         ,salary
     INTO P_F_NAME
         ,P_SAL
     FROM employees
    WHERE employee_id = P_EMP_ID;

EXCEPTION

WHEN OTHERS THEN 

    dbms_output.put_line(sqlcode);
    dbms_output.put_line(sqlerrm);

END;

-----------------------------------------------------------------------
-- We declare 2 bind variables

VARIABLE B_FIRST_NAME VARCHAR2(100);
VARIABLE B_SAL NUMBER;

EXECUTE query_emp(105,:B_FIRST_NAME,:B_SAL );

PRINT B_FIRST_NAME B_SAL ;

-----------------------------------------------------------------------

/* 
   2 Another way to print out the parameter 
     this is the more common approach
     
*/

DECLARE

    V_FIRST_NAME employees.first_name%TYPE;
    V_SAL employees.salary%TYPE;
    
BEGIN

     query_emp(105,V_FIRST_NAME,V_SAL );
     dbms_output.put_line(V_FIRST_NAME);
     dbms_output.put_line(V_SAL);
     
END;

/*
  The procedure source code is stored in the database
*/

SELECT * FROM USER_OBJECTS
WHERE object_name='QUERY_EMP';

SELECT * FROM USER_SOURCE
 WHERE name='QUERY_EMP'
ORDER BY LINE;

-- To drop the procedure -- 

DROP PROCEDURE QUERY_EMP;

--SELECT * FROM USER_SOURCE
-- WHERE name='SECURE_DML'
--ORDER BY LINE;

/* Creating a procedure with IN OUT parameter
   The IN OUT parameter is NOT commonly used
*/

--Assume the length for tel is 10 
--Example 3035555489
--We need a procedure to format the 3035555489 like (303) 555-5489 

CREATE OR REPLACE PROCEDURE format_tel
(P_TEL IN OUT VARCHAR2)

IS

BEGIN

    P_TEL:='('||SUBSTR(P_TEL,1,3)||') '||SUBSTR(P_TEL,4,3)||'-'||SUBSTR(P_Tel,-4);

END;

----------------

VARIABLE b_telephone VARCHAR2(20);

EXECUTE :b_telephone:='3035555489';

EXECUTE format_tel(:b_telephone);

PRINT b_telephone;

------------------------------------------------------------------------

/*
   2 Another way (and more common way) to print the 
     formatted telephone number.
*/

DECLARE

    V_TEL VARCHAR2(100):='3035555489';
    
BEGIN

    format_tel(V_TEL);
    dbms_output.put_line(V_TEL);
    
END;


/*
   Available notations for passing parameters
*/

DROP TABLE products;

CREATE TABLE products
( prod_id NUMBER
 ,prod_name VARCHAR2(20)
 ,prod_type VARCHAR2(20)
 ,CONSTRAINT products_pk PRIMARY KEY (prod_id)
);

----------------------------------------------------------------
CREATE OR REPLACE PROCEDURE add_products
(p_prod_id NUMBER,p_prod_name VARCHAR2,p_prod_type VARCHAR2)

IS

BEGIN

  INSERT 
    INTO products 
  VALUES 
  (
    p_prod_id
   ,p_prod_name
   ,p_prod_type
  );
  
 COMMIT;

EXCEPTION

WHEN OTHERS THEN

    dbms_output.put_line ('Error in insert ');
    dbms_output.put_line (sqlcode);
    dbms_output.put_line (sqlerrm);

END;

-- Look at how it is stored in the database

SELECT * 
  FROM USER_SOURCE
 WHERE name = UPPER('add_products')
ORDER BY LINE;

-- Lets try to call the procedure by many different methods

-- 1 Positional 

EXECUTE add_products (1,'Laptop','SW');

SELECT * FROM products;

-- Try to miss one parameter 
-- it will give an error
-- wrong number or types of arguments in call to 'ADD_PRODUCTS'
EXECUTE add_products (2,'PC');

-- Try to enter an existing product
-- this will go to the exception clause
EXECUTE add_products (1,'Laptop','SW');

-- 2 Named

EXECUTE add_products (p_prod_id=>2,p_prod_name=>'PC',p_prod_type=>'SW');

SELECT * FROM products;

EXECUTE add_products (p_prod_name=>'Keyboard',p_prod_id=>3,p_prod_type=>'HD');

SELECT * FROM products;

-- 3 Mixed

EXECUTE add_products (4,p_prod_type=>'SW',p_prod_name=>'Windows 10');

SELECT * FROM products;

/*  
   Using the default options for Parameters
*/

-- Using the default value 
--   2 ways ( default value or  := )

CREATE OR REPLACE PROCEDURE add_products
(p_prod_id NUMBER,p_prod_name VARCHAR2:='Unknown',p_prod_type VARCHAR2 DEFAULT 'Unknown')
IS

BEGIN

  INSERT INTO products 
  VALUES (
            p_prod_id
           ,p_prod_name
           ,p_prod_type
         );
 COMMIT;

EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line ('error in insert ');
    dbms_output.put_line (sqlcode);
    dbms_output.put_line (sqlerrm);
END;

EXECUTE add_products(10);

SELECT * FROM products;

/*  
   Exception handling in multiple blocks
*/

DELETE products;
SELECT * FROM products;

CREATE OR REPLACE PROCEDURE add_products
(p_prod_id NUMBER,p_prod_name VARCHAR2:='Unknown',p_prod_type VARCHAR2 DEFAULT 'Unknown')
IS
BEGIN

  INSERT INTO products 
  VALUES (
            p_prod_id
           ,p_prod_name
           ,p_prod_type
         );
            dbms_output.put_line(p_prod_id||' '||p_prod_name||'  inserted ' );
 COMMIT;

EXCEPTION
WHEN OTHERS THEN
    dbms_output.put_line ('Error in insert '||p_prod_id||' '||p_prod_name);
    dbms_output.put_line (sqlcode);
    dbms_output.put_line (sqlerrm);
END;

-----------

BEGIN
    add_products(10,'PC');
    add_products(10,'Laptop');
    add_products(20,'Keyboard');
END; 

SELECT * FROM products;

-----------------------------------------------------------------------------------------------

DELETE products;
SELECT * FROM products;


CREATE OR REPLACE PROCEDURE add_products
(p_prod_id NUMBER,p_prod_name VARCHAR2:='Unknown',p_prod_type VARCHAR2 DEFAULT 'Unknown')
IS
BEGIN

  INSERT INTO products 
  VALUES (
            p_prod_id
           ,p_prod_name
           ,p_prod_type
          );
            dbms_output.put_line(p_prod_id||' '||p_prod_name||'  inserted ' );
 COMMIT;
END;
-----------

BEGIN
    add_products(10,'PC');
    add_products(10,'Labtop');
    add_products(20,'Keyboard');
END;

SELECT * FROM products;

----------------------------------------------------------------

DELETE products;
SELECT * FROM products;


CREATE OR REPLACE PROCEDURE add_products
(p_prod_id NUMBER,p_prod_name VARCHAR2:='Unknown',p_prod_type VARCHAR2 DEFAULT 'Unknown')
IS
BEGIN

  INSERT INTO products 
  VALUES (
            p_prod_id
           ,p_prod_name
           ,p_prod_type
         );
            dbms_output.put_line(p_prod_id||' '||p_prod_name||'  inserted ' );

END;
-----------

/*
   The following will be rolled back because 
   the exception was not caught in the procedure 
   before a commit was made to the database.
*/

BEGIN
    add_products(10,'PC');
    add_products(10,'Labtop');
    add_products(20,'Keyboard');
 COMMIT;
END;

SELECT * FROM products;


/* 
   Using Boolean and PL/SQL records as parameters
*/


CREATE OR REPLACE PROCEDURE p(x BOOLEAN)
IS

BEGIN

    IF x THEN
        dbms_output.put_line('x is true');
    END IF;
    
END;

-----

DECLARE
    v BOOLEAN;
BEGIN

    v := TRUE;
    p(v);

END;

----------------

CREATE OR REPLACE PROCEDURE test_plsql_records
( rec IN departments%ROWTYPE )
IS

BEGIN

    INSERT INTO departments 
    VALUES rec;

END;

-------

DECLARE
    v departments%ROWTYPE;
BEGIN
    v.DEPARTMENT_ID := 3;
    v.DEPARTMENT_NAME := 'v dept';

    test_plsql_records (v);

END;

SELECT * FROM departments


