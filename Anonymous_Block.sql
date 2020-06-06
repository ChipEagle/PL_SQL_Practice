BEGIN
dbms_output.put_line('My anonymous block');
END;

BEGIN
dbms_output.put_line('This is the first line');
dbms_output.put_line('This is the second line');
END;

DECLARE
BEGIN
dbms_output.put_line('Hello World');
END;

DECLARE
v number;
BEGIN
v := 5;
dbms_output.put_line('Hello World');
dbms_output.put_line(v);
END;


/*   SQLPLUS  */

set serveroutput on

BEGIN
dbms_output.put_line('My anonymous block');
END;
/


