/*
   %TYPE Attribute
   
    - Is used to declare a variable accroding to:
        - A database column definition
        - Another declared variable
        
        Example:
        emp_lname   employees.last_name%TYPE; -- Define emp_lname variable with the same attributes as 
                                                 the column last_name in the employees table.
        balance     NUMBER(7,2);
        min_balance balance%TYPE := 1000;     -- min_balance has the same attributes as balance.
        
    Advantages of %TYPE Attribute
        - You can avoid errors caused by data type mismatch or wrong precision.
        - You can avoid hard-coding the data type of a variable.
        - You need not change the variable declaration if the column definition changes.
          If you hav already declared some variables for a particular table without using the %TYPE attribute
          the PL/SQL block may throw errors if the column for which the variable is declared is altered.
          
          When you use the %TYPE attribute, PL/SQL determines the data type and size of the variable 
          when the block is compiled. This ensures that such a variable is always compatible with the column 
          that is used to populate it.
*/


DECLARE
    v_empno number := 10;
    v_ename varchar2(100) := 'John';
    v_salary employees.salary%TYPE;
    v_hire_period interval YEAR TO MONTH;
    v_empno1 v_empno%TYPE;  -- It will NOT be initalized like v_empno
        
BEGIN

    dbms_output.put_line(v_empno);
    dbms_output.put_line(v_ename);
    v_salary := 5000;
    dbms_output.put_line(v_salary);
    v_hire_period := '1-3';
    dbms_output.put_line(v_hire_period);
    dbms_output.put_line(v_empno1 || 'v_empno1 has been declared as type number but no value');

END;
    