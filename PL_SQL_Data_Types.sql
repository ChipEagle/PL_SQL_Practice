DECLARE

v_no number := 300;
v_date date;
v_timestamp timestamp;
v_project_period interval year to month;

BEGIN

    v_no := 125.323;
    v_date := SYSDATE;
    v_timestamp := current_timestamp;
    -- Current_timestamp returns the current date and time for the user session
    v_project_period := '03-04';
    
    DBMS_OUTPUT.PUT_LINE(v_no);
    DBMS_OUTPUT.PUT_LINE(v_date);
    DBMS_OUTPUT.PUT_LINE(v_timestamp);
    DBMS_OUTPUT.PUT_LINE(current_timestamp);
    DBMS_OUTPUT.PUT_LINE('The project period is: ' || v_project_period);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE(), 'mm-dd-yyyy hh:mi:ss') );
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(v_date, 'mm-dd-yyyy hh:mi:ss') );
    
    
END;



