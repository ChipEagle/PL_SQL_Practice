/*
Write a PL/SQL block to print the first name and last name for employee_id 100
*/

SELECT first_name
     , last_name
  FROM employees
 WHERE employee_id=100;
 
DECLARE

    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;

BEGIN

    -- The select statement should retrieve 1 record, otherwise it will be an exception
    SELECT first_name
         , last_name
      INTO v_fname
         , v_lname
      FROM employees
     WHERE employee_id=100;
     
     dbms_output.put_line('first_name: ' || v_fname);
     dbms_output.put_line('last_name: ' || v_lname);

END;


/* Exception "no data found" will be thrown */

DECLARE

    v_fname employees.first_name%TYPE;
    v_lname employees.last_name%TYPE;

BEGIN

    -- The select statement should retrieve 1 record, otherwise it will be an exception
    SELECT first_name
         , last_name
      INTO v_fname
         , v_lname
      FROM employees
     WHERE employee_id=9000;
     
     dbms_output.put_line('first_name: ' || v_fname);
     dbms_output.put_line('last_name: ' || v_lname);

END;
