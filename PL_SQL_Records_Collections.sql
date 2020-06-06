/*

    Composite Data Types
    
    - Can hold multiple values (unlike scalar types)
    
    - Are of two types:
        - PL/SQL records
        - PL/SQL collections
            - INDEX BY tables or associative arrays
            - Nested table
            - VARRAY

What is a PL/SQL Record?

A PL/SQL record is a composite data structure that is a 
group of related data stored in fields.


*/



DECLARE
TYPE t_emp IS RECORD
( v_emp_id employees.employee_id%TYPE,
  v_first_name employees.first_name%TYPE,
  v_last_name employees.last_name%TYPE
);

v_emp t_emp;

BEGIN
  SELECT employee_id  
        ,first_name        
        ,last_name
    INTO v_emp.v_emp_id
        ,v_emp.v_first_name
        ,v_emp.v_last_name
    FROM employees 
   WHERE employee_id=100;
    dbms_output.put_line(v_emp.V_EMP_id||' '||v_emp.v_first_name||' '||v_emp.v_last_name);
END;

----

DECLARE
TYPE t_emp IS RECORD
( v_emp_id employees.employee_id%TYPE,
  v_first_name employees.first_name%TYPE,
  v_last_name employees.last_name%TYPE
);

v_emp t_emp;

BEGIN
  SELECT employee_id  
        ,first_name        
        ,last_name
    INTO v_emp
    FROM employees 
   WHERE employee_id = 100;
  dbms_output.put_line(v_emp.v_emp_id||' '||v_emp.v_first_name||' '||v_emp.v_last_name);
END;



DECLARE
TYPE t_emp IS RECORD
( v_emp_id employees.employee_id%TYPE,
  v_first_name employees.first_name%TYPE,
  v_last_name employees.last_name%TYPE
);

v_emp t_emp;

BEGIN
  FOR i IN 100..103
      LOOP
      SELECT employee_id  
            ,first_name        
            ,last_name
        INTO v_emp
        FROM employees 
       WHERE employee_id = i;
       
             dbms_output.put_line(v_emp.v_emp_id||' '||v_emp.v_first_name||' '||v_emp.v_last_name);
             
      END LOOP;
END;



SELECT * 
  FROM departments
 WHERE department_id = 10;

DROP TABLE copy_departments;

CREATE TABLE copy_departments AS
SELECT * 
  FROM departments 
 WHERE 1=2;

SELECT * FROM copy_departments;

------------------------------

DECLARE
TYPE t_dept IS RECORD
( v_dept_id departments.department_id%TYPE,
  v_dept_name  departments.department_name%TYPE,
  v_dept_manager  departments.manager_id%TYPE,
  v_dept_loc  departments.location_id%TYPE
);

v_dept t_dept;

BEGIN

  SELECT department_id,department_name,manager_id,location_id
    INTO v_dept 
    FROM departments  
   WHERE department_id = 10;
  
  INSERT 
    INTO copy_departments 
    VALUES v_dept;
  /*
  insert into copy_departments values (v_dept.v_dept_id,v_dept.v_dept_name,.....
  */
  
END;

SELECT * 
  FROM copy_departments;

---------------------


-- - Using the %ROWTYPE
DECLARE

v_dept departments%rowtype;

BEGIN

SELECT department_id,department_name,manager_id,location_id
  INTO v_dept 
  FROM departments  
 WHERE department_id = 10;

INSERT INTO Copy_Departments 
VALUES v_dept;
/*
insert into copy_departments values (v_dept.department_id,v_dept.department_name,.....
*/

END;

SELECT * 
  FROM copy_departments;
----------------------------------------------------



--- Using the %ROWTYPE in update 
DECLARE

v_dept departments%ROWTYPE;

BEGIN

    v_dept.department_id:=10;
    v_dept.department_name:='test';

UPDATE copy_departments
SET ROW=v_dept;

END;

SELECT * FROM copy_departments;
------------------------------------------------------------------

/*

Nested PL/SQL Records

*/

DROP TABLE emp_tel;

CREATE TABLE emp_tel
(emp_id NUMBER PRIMARY KEY,
 full_name VARCHAR2(100),
 mob1 VARCHAR2(20),
 mob2 VARCHAR2(20),
 landline VARCHAR2(20)
 );
 
 INSERT INTO emp_tel 
 VALUES 
 (1,'John T','+3035551212','+3035551213','+3035551214');
 
SELECT * FROM emp_tel;
 
DECLARE
 TYPE t_tel IS RECORD
   ( v_mob1 emp_tel.mob1%TYPE,
     v_mob2 emp_tel.mob2%TYPE,
     v_landline emp_tel.landline%TYPE
   );
   
  TYPE t_emp_tel IS RECORD
  (v_emp_id emp_tel.emp_id%TYPE, 
   v_full_name emp_tel.full_name%TYPE,
   v_tel t_tel
   );
   
   v_rec t_emp_tel;
   
BEGIN
   SELECT emp_id
        , full_name
        , mob1
        , mob2
        , landline
   INTO   v_rec.v_emp_id
         ,v_rec.v_full_name
         ,v_rec.v_tel.v_mob1
         ,v_rec.v_tel.v_mob2
         ,v_rec.v_tel.v_landline
     FROM emp_tel
    WHERE emp_id=1;
           dbms_output.put_line( 'emp_id:'||v_rec.v_emp_id);
           dbms_output.put_line('landline:'||v_rec.v_tel.v_landline);
END;
   
 
/*

INDEX BY TABLE (Associative Arrays) - Collections

*/
 
DECLARE

TYPE tab_no IS TABLE OF VARCHAR2(100)
INDEX BY PLS_INTEGER;

    v_tab_no tab_no;

BEGIN

    v_tab_no(1):='John';
    v_tab_no(6):='Alex';
    v_tab_no(4):='Joe';

    dbms_output.put_line(v_tab_no(1));
    dbms_output.put_line(v_tab_no(6));
    dbms_output.put_line(v_tab_no(4));
    
END;

----- INDEX BY VARCHAR2 Not Recommended but possible --------------------

DECLARE

TYPE tab_no IS TABLE OF NUMBER
INDEX BY VARCHAR2(100);

v_tab_no tab_no;

BEGIN

    v_tab_no('John'):=1;
    v_tab_no('Alex'):=6;
    v_tab_no('Joe'):=4;
    
    dbms_output.put_line(v_tab_no('John'));
    dbms_output.put_line(v_tab_no('Alex'));
    dbms_output.put_line(v_tab_no('Joe'));
    
END;
--------------------------

DECLARE
TYPE tab_emp IS TABLE OF VARCHAR2(100)
INDEX BY PLS_INTEGER;

    v_tab_emp tab_emp;
    v_name VARCHAR2(100);

BEGIN

FOR i IN 100..110
LOOP
 SELECT first_name||' '||last_name 
   INTO v_name
   FROM employees
  WHERE employee_id = i;
        v_tab_emp(i) := v_name;
END LOOP;
  
  FOR i IN 100..110
      LOOP
      dbms_output.put_line( v_tab_emp(i) );
      END LOOP;

END;


--- Index by Tables ---


DECLARE
TYPE tab_no IS TABLE OF VARCHAR2(100)
INDEX BY PLS_INTEGER;

v_tab_no tab_no;
v_total NUMBER;

BEGIN
    v_tab_no(1):='John';
    v_tab_no(2):='Alex';
    v_tab_no(3):='Joe';
    v_tab_no(6):='Ron';
    v_tab_no(5):='Scott';

 FOR i IN 1..10
 LOOP
    IF v_tab_no.EXISTS(i) THEN
        dbms_output.put_line('The element '||i||' exists in the array and is = '||v_tab_no(i));
    ELSE
        dbms_output.put_line('the element '||i||' does not exist in the array');
    END IF;
 END LOOP;
 
 v_total := v_tab_no.count;
    dbms_output.put_line('The total elements in the array = '||v_total);
    dbms_output.put_line('The first element INDEX in the array = '||v_tab_no.first);
    dbms_output.put_line('The NEXT element INDEX AFTER INDEX 3 = '||v_tab_no.NEXT(3));
END;


/*  Index by Table of Records */

DECLARE
TYPE tab_no IS TABLE OF employees%ROWTYPE
INDEX BY PLS_INTEGER;

    v_tab_no tab_no;
    v_total NUMBER;

BEGIN

    v_tab_no(1).employee_id:=1;
    v_tab_no(1).first_name:='John';
    v_tab_no(1).last_name:='Doe';
    
    v_tab_no(2).employee_id:=2;
    v_tab_no(2).first_name:='Scott';
    v_tab_no(2).last_name:='Parker';
    
    dbms_output.put_line(v_tab_no(1).employee_id||' '||v_tab_no(1).first_name||' '||v_tab_no(1).last_name);
    dbms_output.put_line(v_tab_no(2).employee_id||' '||v_tab_no(2).first_name||' '||v_tab_no(2).last_name);

END;


----------------------------

DECLARE
TYPE tab_no IS TABLE OF employees%ROWTYPE
INDEX BY PLS_INTEGER;

v_tab_no tab_no;

BEGIN
 FOR i IN 100..104
 LOOP
 SELECT * 
   INTO v_tab_no(i)
   FROM employees 
  WHERE employee_id=i;
    dbms_output.put_line(v_tab_no(i).employee_id||' '||
                         v_tab_no(i).first_name||' '||v_tab_no(i).last_name  
                         );
 END LOOP;

END;
-------------------------------------

DECLARE
TYPE tab_no IS TABLE OF employees%ROWTYPE
INDEX BY PLS_INTEGER;

v_tab_no tab_no;

Begin
 For i IN 100..104
   LOOP
   SELECT * 
     INTO v_tab_no(i)
     FROM employees 
    WHERE employee_id=i;
  
   END LOOP;
 
 FOR i IN v_tab_no.first..v_tab_no.last
   LOOP
    dbms_output.put_line(v_tab_no(i).employee_id);
    dbms_output.put_line(v_tab_no(i).first_name);
    dbms_output.put_line(v_tab_no(i).last_name);
    dbms_output.put_line(v_tab_no(i).salary);
   END LOOP;
 
END;

/*  Nested Table  */

DECLARE
TYPE t_locations IS TABLE OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('USA','UK','JORDAN');
    
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    dbms_output.put_line(loc(3) );

END;

/*  Nested Table with FOR LOOP */

DECLARE
TYPE t_locations IS TABLE OF VARCHAR2(100);

loc t_locations;

BEGIN

loc:=t_locations('USA','UK','JORDAN');
  FOR i IN loc.first..loc.last
  LOOP
    dbms_output.put_line(loc(i) );
  END LOOP;

END;

/*  Nested Table with Extend */

DECLARE
TYPE t_locations IS TABLE OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('USA','UK','GERMANY');
    loc.extend;
    loc(4):='AUSTRALIA';
    loc.extend;
    loc(5):='ICELAND';
    loc.extend;
    loc(6):='NORWAY';
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    dbms_output.put_line(loc(3) );
    dbms_output.put_line(loc(4) );
    dbms_output.put_line(loc(5) );
    dbms_output.put_line(loc(6) );
      FOR i IN loc.first..loc.last
      LOOP
        dbms_output.put_line(loc(i) );
      END LOOP;

END;


/*  Nested Table with Delete */

DECLARE
TYPE t_locations IS TABLE OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('USA','uae','GERMANY','AUSTRALIA','ICELAND','NORWAY');
    loc.delete(2);
    loc(2):='PANAMA';
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    dbms_output.put_line(loc(3) );

END;

------------------------------------------------------------------------

/*  Nested Table is valid in SQL here is how to use it. 
    This is not usually done because it is complex 
*/

DROP TABLE x_customer;
DROP TYPE t_tel;


CREATE OR REPLACE TYPE t_tel AS TABLE OF NUMBER;

CREATE TABLE x_customer
( cust_id NUMBER
 ,cust_name VARCHAR2(100)
 ,tel t_tel
)
NESTED TABLE tel STORE AS t_tel_tbl;

INSERT INTO x_customer (cust_id,cust_name,tel)
VALUES (1,'John',t_tel(5551212,5551213,5551214));

SELECT * FROM x_customer;

DELETE
  FROM x_customer
 WHERE cust_id = 1;
 


/*  VARRAY  

    Extend is not available in VARRAY

    TRIM is used to remove the instance from the collection.
    Trim(n) removes the n instances from collection.
    
    DELETE removes all of a VARRAY
*/

DECLARE
TYPE t_locations IS VARRAY(6) OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('USA','uae','GERMANY','AUSTRALIA','ICELAND','NORWAY');
    
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    dbms_output.put_line(loc(3) );
    FOR i IN loc.first..loc.last
      LOOP
        dbms_output.put_line(loc(i) );
      END LOOP;

END;

-----------------------------------------------

/* You cannot extend the varray, it will give you an error */

DECLARE
TYPE t_locations IS VARRAY(3) OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('NORWAY','uae','ICELAND');
    loc.extend;
    loc(4):='aa';
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    dbms_output.put_line(loc(3) );

END;

-------------

DECLARE
TYPE t_locations IS VARRAY(3) OF VARCHAR2(100);

loc t_locations;

BEGIN

    loc:=t_locations('NORWAY','uae','ICELAND');
    loc.TRIM(1); -- This will delete one element from last of the VARRAY
    dbms_output.put_line(loc(1) );
    dbms_output.put_line(loc(2) );
    -- dbms_output.put_line(loc(3) );
    FOR i IN loc.first..loc.last
      LOOP
        dbms_output.put_line(loc(i) );
      END LOOP;
      
    loc.TRIM(1); -- This will delete one element from last of the VARRAY
    dbms_output.put_line('After removal of the last element');
    FOR i IN loc.first..loc.last
      LOOP
        dbms_output.put_line(loc(i) );
      END LOOP;

END;

-----------------------------------------------

/* Here is how to use VARRAY in SQL 
   This is not commonly used in SQL
*/

DROP TABLE x_customer;
DROP TYPE t_tel;


CREATE OR REPLACE TYPE t_tel AS VARRAY(10) OF NUMBER;

CREATE TABLE x_customer
( cust_id NUMBER
 ,cust_name VARCHAR2(100),
  tel t_tel
)

/* No need for this NESTED TABLE tel STORE AS t_tel_tbl */

INSERT 
  INTO x_customer (cust_id,cust_name,tel)
VALUES (1,'John',t_tel(5551212,5551213,5551214));

SELECT * FROM x_customer;
