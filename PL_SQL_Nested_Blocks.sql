DECLARE

    v_global VARCHAR2(100) := 'This is a global variable';
    
BEGIN

    DECLARE

    v_local VARCHAR2(100) := 'This is a local variable';
    
    BEGIN
    
        dbms_output.put_line(v_global);
        dbms_output.put_line(v_local);
        
    END;
    
    dbms_output.put_line(v_global);
    
--    dbms_output.put_line(v_local); -- You cannot access this, this is out of scope

END;


/* Incorrect not recommended */

DECLARE

    v_father_name VARCHAR2(100) := 'John';
    v_birthday DATE := '20-Jul-1981';
    
BEGIN
        DECLARE
        
            v_child_name VARCHAR2(100) := 'Alex';
            v_birthday DATE := '5-Apr-2013';
        
        BEGIN

            dbms_output.put_line(q'[The father's name is: ]' || v_father_name);
            dbms_output.put_line(q'[The father's birthday is: ]' || v_birthday);
            dbms_output.put_line(q'[The child's name is: ]' || v_child_name);
            dbms_output.put_line(q'[The child's birthday is: ]' || v_birthday);
            
        END;
    


END;


/* Correct */

BEGIN <<outer>>

DECLARE

    v_father_name VARCHAR2(100) := 'John';
    v_birthday DATE := '20-Jul-1981';
    
BEGIN
        DECLARE
        
            v_child_name VARCHAR2(100) := 'Alex';
            v_birthday DATE := '5-Apr-2013';
        
        BEGIN

            dbms_output.put_line(q'[The father's name is: ]' || v_father_name);
            dbms_output.put_line(q'[The father's birthday is: ]' || outer.v_birthday);
            dbms_output.put_line(q'[The child's name is: ]' || v_child_name);
            dbms_output.put_line(q'[The child's birthday is: ]' || v_birthday);
            
        END;
    


END;

END outer;


/* Safer way */

DECLARE

    v_father_name VARCHAR2(100) := 'John';
    v_father_birthday DATE := '20-Jul-1981';
    
BEGIN
        DECLARE
        
            v_child_name VARCHAR2(100) := 'Alex';
            v_child_birthday DATE := '5-Apr-2013';
        
        BEGIN

            dbms_output.put_line(q'[The father's name is: ]' || v_father_name);
            dbms_output.put_line(q'[The father's birthday is: ]' || v_father_birthday);
            dbms_output.put_line(q'[The child's name is: ]' || v_child_name);
            dbms_output.put_line(q'[The child's birthday is: ]' || v_child_birthday);
            
        END;
    
END;

