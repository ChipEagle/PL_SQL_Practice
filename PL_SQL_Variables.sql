/* 1 */

DECLARE

    v_date date;
    v_no number := 10;
    v_name varchar2(100) NOT NULL := 'titus';
    
BEGIN
    dbms_output.put_line(v_date);
    dbms_output.put_line(v_no);
    dbms_output.put_line(v_name);
    
    v_no := v_no + 10;
    v_name := 'carla';
    dbms_output.put_line(v_name);
    
    v_date := '10-May-2020';
    dbms_output.put_line(v_date);
    
    dbms_output.put_line(v_no);
    
END;


/* 2 */

DECLARE

    v_date date := SYSDATE;
    v_no number := 10*2;
    c_pi CONSTANT NUMBER := 3.14;
    
BEGIN

    dbms_output.put_line(v_date);
    dbms_output.put_line(v_no);
    dbms_output.put_line(c_pi);
    
    v_date := v_date + 10;
    dbms_output.put_line(v_date);
--    c_pi := 10; -- If we do this we will get an error.

END;


