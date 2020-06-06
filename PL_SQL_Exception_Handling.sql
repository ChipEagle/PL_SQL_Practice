/* Predefined Oracle Server Error Exception */

/* 1 Try to execute one block without exception */

DECLARE

    v_first_name employees.first_name%TYPE;
    
BEGIN

    SELECT first_name
      INTO v_first_name
      FROM employees
     WHERE employee_id = 1; -- There is no emp_id = 1

END;

-------------------------------------------------
/* 2 The solution is to catch the exception */

DECLARE

    v_first_name employees.first_name%TYPE;
    
BEGIN
    SELECT first_name
      INTO v_first_name
      FROM employees
     WHERE employee_id = 1; -- There is no emp_id = 1
        dbms_output.put_line(v_first_name);
        
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line(q'{The query didn't retrieve any records}');

END;

---------------------------------------------------

/* 3 many exceptions */

DECLARE

    v_emp_id employees.employee_id%TYPE;
    
BEGIN

    SELECT employee_id
      INTO v_emp_id
      FROM employees
     WHERE first_name = &name; -- Try 'xyx' then try 'John' then try 1

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line(q'{The query didn't retrieve any records}');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('The query retrieved more than one record');
    WHEN OTHERS THEN
        dbms_output.put_line('Other ERROR');
        
END;

----------------------

        SELECT *
--          INTO v_first_name
          FROM employees
         WHERE employee_id BETWEEN 99 AND 102;
         
         
/*  The following code is not correct
    because there is no begin and end
    inside the loop.
*/

DECLARE

    v_first_name employees.first_name%TYPE;
    
BEGIN

    FOR i IN 99..102 
    LOOP
        SELECT first_name
          INTO v_first_name
          FROM employees
         WHERE employee_id = i;

        dbms_output.put_line(i || ' ' || v_first_name);
    END LOOP;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        NULL;
END;

/*  The following code is correct
    notice there is a begin and end
    inside the loop.
*/

DECLARE

    v_first_name employees.first_name%TYPE;
    
BEGIN
    FOR i IN 99..102 
    LOOP
        BEGIN
            SELECT first_name
              INTO v_first_name
              FROM employees
             WHERE employee_id = i;

                dbms_output.put_line(i || ' ' || v_first_name);
                
        EXCEPTION
        
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;
    END LOOP;
    
END;


/* Non Predefined Oracle Server Error Exception */

DESC departments;

INSERT INTO departments 
(
    department_id,
    department_name
) 
VALUES 
(
    1,
    NULL
);

--SQL Error: ORA-01400: cannot insert NULL into ("HR"."DEPARTMENTS"."DEPARTMENT_NAME")

BEGIN
    INSERT INTO departments (
        department_id,
        department_name
    ) VALUES (
        1,
        NULL
    );

END;

----------------------------------------------

DECLARE

    e_insert EXCEPTION;
    PRAGMA exception_init ( e_insert, -01400 );
    
BEGIN
    INSERT INTO departments 
    (
        department_id
       ,department_name
    ) 
    VALUES 
    (
        1
       ,NULL
    );

EXCEPTION

    WHEN e_insert THEN
        dbms_output.put_line('Insert failed');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
    WHEN OTHERS THEN
        NULL;
        
END;


------------------------------------------------

/* The following code is wrong
   the update will not be executed when there is 
   an exception in the first insert.
*/

DECLARE
    e_insert EXCEPTION;
    PRAGMA exception_init ( e_insert, -01400 );
BEGIN
    INSERT INTO departments (
        department_id,
        department_name
    ) VALUES (
        1,
        NULL
    );

    UPDATE employees
    SET
        employee_id = 'ss'
    WHERE
        employee_id = 100;

EXCEPTION
    WHEN e_insert THEN
        dbms_output.put_line('insert failed');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
END;

------------------------------------------------------------

/* The following code is the correct way,
   the update will be executed when there is 
   an exception in the first insert.
*/

DECLARE

    e_insert EXCEPTION;
    PRAGMA exception_init ( e_insert, -01400 );
    
BEGIN

    BEGIN
        INSERT INTO departments 
        (
            department_id
           ,department_name
        ) 
        VALUES 
        (
            1
           ,NULL
        );

    EXCEPTION
    
        WHEN e_insert THEN
            dbms_output.put_line('Insert failed');
            dbms_output.put_line(sqlcode);
            dbms_output.put_line(sqlerrm);
    END;

    BEGIN
        UPDATE employees
           SET employee_id = 'ss'
         WHERE employee_id = 100;

    EXCEPTION
    
        WHEN OTHERS THEN
            dbms_output.put_line('Update failed');
            dbms_output.put_line(sqlcode);
            dbms_output.put_line(sqlerrm);
    END;

END;



/* User-Defined Error Exception */

SELECT *
  FROM employees
 WHERE employee_id = 1;
 
 
/* No Exception but no records updated */

DECLARE

    v_employee_id NUMBER := 1;
    
BEGIN

    UPDATE employees
       SET salary = 20000
     WHERE employee_id = v_employee_id;

    dbms_output.put_line(SQL%rowcount);
    
END;

--------------------------------------

DECLARE

    v_employee_id NUMBER := 1;
    e_invalid_no EXCEPTION;
    
BEGIN

    UPDATE employees
       SET salary = 20000
     WHERE employee_id = v_employee_id;

        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
        
    IF SQL%NOTFOUND THEN
        RAISE e_invalid_no;
    END IF;
    
    COMMIT;
    
EXCEPTION

    WHEN e_invalid_no THEN
        dbms_output.put_line('Invalid emp ID');
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);

END;

------------------------

DECLARE

    v_employee_id NUMBER := 1;
---e_invalid_no exception;

BEGIN

    UPDATE employees
       SET salary = 20000
     WHERE employee_id = v_employee_id;

    IF SQL%NOTFOUND THEN
 ---raise e_invalid_no;
        /*
        The following lets you issue user-defined ORA - error
        messages from stored subprograms.
        That way, you can report errors to your application and 
        avoid returning unhandled exceptions.
        */
        raise_application_error(-20000, 'Invalid employee ID');
    END IF;
    
    COMMIT;
    
END;

/* Group Functions and Exceptions */

SELECT *
  FROM employees
 WHERE employee_id = 15154;

SELECT SUM(salary)
  FROM employees
 WHERE department_id = 888;


/* A group function will not return 
   an error of NO_DATA_FOUND 
*/

DECLARE

    v_sum_sal NUMBER;
    
BEGIN

    SELECT SUM(salary)
      INTO v_sum_sal
      FROM employees
     WHERE department_id = &dno;

        dbms_output.put_line('the sum is ' || v_sum_sal);
        dbms_output.put_line(SQL%rowcount);
    
EXCEPTION

    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('No data found');
        
END;


/* The code below will handle 
   the error No data found 
*/

DECLARE

    v_sum_sal NUMBER;
    v_error EXCEPTION;
    
BEGIN

    SELECT SUM(salary)
      INTO v_sum_sal
      FROM employees
     WHERE department_id = &dno;

    IF v_sum_sal IS NOT NULL THEN
        dbms_output.put_line('the sum is ' || v_sum_sal);
        dbms_output.put_line(SQL%rowcount);
    ELSE
        RAISE v_error;
    END IF;

EXCEPTION

    WHEN v_error THEN
        dbms_output.put_line('No data found');
        
END;

/* Many blocks and many exceptions */

DECLARE

    v_sum_sal NUMBER(2);
    v_error EXCEPTION;
    
BEGIN

    BEGIN
        SELECT SUM(salary)
          INTO v_sum_sal
          FROM employees
         WHERE department_id = &dno;

        IF v_sum_sal IS NOT NULL THEN
            dbms_output.put_line('the sum is ' || v_sum_sal);
            dbms_output.put_line(SQL%rowcount);
        ELSE
            RAISE v_error;
        END IF;

    EXCEPTION
        WHEN v_error THEN
            dbms_output.put_line('No data found');
    END;
    
EXCEPTION

    WHEN OTHERS THEN
        dbms_output.put_line(sqlcode);
        dbms_output.put_line(sqlerrm);
        
END;
