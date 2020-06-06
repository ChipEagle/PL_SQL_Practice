DECLARE

    v_first_name employees.first_name%TYPE;
    v_last_name employees.last_name%TYPE;
    v_sal NUMBER;
    "hire date" DATE; -- This is not recommended from Oracle

BEGIN

    SELECT 
        first_name
      , last_name
      , salary
      , hire_date
      INTO 
        v_first_name
      , v_last_name
      , v_sal
      , "hire date"
      FROM employees
     WHERE employee_id = 100;
     
    dbms_output.put_line('The employee first name is: ' || v_first_name);
    dbms_output.put_line('The employee last name is: ' || v_last_name);
    dbms_output.put_line('The employee salary is: ' || v_sal);
    dbms_output.put_line('The employee hire date is: ' || "hire date");
    dbms_output.put_line('The employee first name length is: ' || LENGTH(v_first_name));
    dbms_output.put_line('The first 3 letters of the first name is: ' || substr(v_first_name,1,3) );
  
END;


DECLARE

    v_date DATE := SYSDATE;
    v_sal NUMBER := 5000;

BEGIN

    dbms_output.put_line(v_date);
    dbms_output.put_line(v_date+8);
    dbms_output.put_line(v_date-3);
    dbms_output.put_line(TO_CHAR(v_date, 'MM-DD-YYYY hh:mi:ss AM') );
    dbms_output.put_line(ADD_MONTHS(v_date,2) );
    dbms_output.put_line(TO_CHAR(v_sal, '$999,999') );
    dbms_output.put_line(TO_CHAR(v_sal, '$999,999.00') );

END;

