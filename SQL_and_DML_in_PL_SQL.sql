-- You cannot name your variables using reserved words

-- The following will give and error because having is a reserved word

DECLARE

    having NUMBER := 50;

BEGIN

    dbms_output.put_line(having);

END;

-- You can name the variable a function like trim, but it is not good practice


DECLARE

    trim NUMBER := 50;

BEGIN

    dbms_output.put_line(trim);
    dbms_output.put_line(standard.trim('   John    ') );

END;

/*
Write a block that retrievs the salary for employee 100 in the variable v_sal
raise the salary by 100 in the variable v_new_sal
update the employee by 100 with the new salary
insert new department called test with ID = 1

*/


DECLARE

    v_sal employees.salary%TYPE;
    v_new_sal employees.salary%TYPE;
    
BEGIN

    SELECT salary
      INTO v_sal
      FROM employees
     WHERE employee_id = 100;
     
    dbms_output.put_line('The old salary is: ' || v_sal);
    v_new_sal := v_sal + 100;
     
     UPDATE employees
        SET salary = v_new_sal
      WHERE employee_id = 100;
      
    dbms_output.put_line('The new salary is: ' || v_new_sal);
    
    INSERT INTO departments 
            (department_id
            ,department_name
            ,manager_id
            ,location_id
            )
    VALUES
            (1
            ,'test'
            ,null
            ,null
            );
            
    COMMIT;
            
 END;
 
 
SELECT *
  FROM employees
 WHERE employee_id = 100;
  
SELECT *
  FROM departments
 WHERE department_id = 1;
 
 /*
 
 PL/SQL does not return and error if an update or delete statement 
 does not affect rows in the underlying table
 
 */
 
 
 BEGIN
 
    DELETE 
      FROM employees
     WHERE employee_id = -989;
 
 END;
 
 