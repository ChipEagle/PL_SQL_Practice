/*
Bind variables are:
    - Created in the environment
    - Also called host variables
     - Created with the VARIABLE keyword
     - Used in SQL statements and PL/SQL blocks
     - Accessed even after the PL/SQL block is executed
     - Referenced with a preceding colon
*/


VARIABLE b_result NUMBER

BEGIN

    SELECT (salary*12) + NVL(commission_pct,0) 
      INTO :b_result
      FROM employees 
     WHERE employee_id = 144;

END;
/

PRINT b_result


VARIABLE v_sal NUMBER
SET autoprint ON

BEGIN

    SELECT salary 
      INTO :v_sal
      FROM employees
     WHERE employee_id = 100;

END;



VAR v_name VARCHAR2(100)
SET autoprint ON

BEGIN

    SELECT first_name 
      INTO :v_name
      FROM employees
     WHERE employee_id = 100;

END;



