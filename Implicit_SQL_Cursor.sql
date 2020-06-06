SELECT *
  FROM employees
 WHERE department_id = 20;
 
 
DECLARE

    v_rows_updated NUMBER := 0;
    
BEGIN

    UPDATE employees
       SET salary = salary + 100
     WHERE department_id = 20;
     
    v_rows_updated := SQL%ROWCOUNT;
    
    dbms_output.put_line('The number of records updated is: ' || v_rows_updated);
    
END;
 
 
---------------------------------------


SELECT *
  FROM employees
 WHERE department_id = 20;


SELECT *
  FROM employees
 WHERE department_id = 9999;

DECLARE

    v_rows_exist BOOLEAN := TRUE;
    
BEGIN

    UPDATE employees
       SET salary = salary + 100
     WHERE department_id = 9999;
     
    v_rows_exist := SQL%FOUND;
    
    IF v_rows_exist = FALSE THEN
        dbms_output.put_line('No records retrieved');
    ELSE
        dbms_output.put_line('The number of records retrieved is: ' || SQL%ROWCOUNT);
    END IF;
    
END;
 
 
ROLLBACK;

