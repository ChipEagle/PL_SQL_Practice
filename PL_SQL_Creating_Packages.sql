-- Why do we want to create a package, let's first look at a function.

-- 1) Create a function to calculate the area of a square 

/*
Area of a square = side times side. Since each side of a square is the same, it can simply be the length of one side squared. 
If a square has one side of 4 inches, the area would be 4 inches times 4 inches, or 16 square inches.
*/

CREATE OR REPLACE FUNCTION square_area (
    p_side NUMBER
) 
RETURN NUMBER AS

BEGIN
    RETURN p_side * p_side;
END;

SELECT square_area(4)
FROM dual;

/******************************************************************/
---- 1) Create a function to calculate the area of a rectangle

CREATE OR REPLACE FUNCTION rectangle_area (
    p_length   NUMBER,
    p_width    NUMBER
) RETURN NUMBER AS
BEGIN
    RETURN p_length * p_width;
END;

SELECT  rectangle_area(4, 5)
  FROM  dual;
  
----------------------------------------------------------

-- Now because these 2 functions are logically grouped, it is better to use a package.
-- The code will be more organized.

-- Create the package specification.
-- We don't have a begin in the package specification.

CREATE OR REPLACE PACKAGE area AS
    FUNCTION square_area (
        p_side NUMBER
    ) RETURN NUMBER;

    FUNCTION rectangle_area (
        p_length   NUMBER,
        p_width    NUMBER
    ) RETURN NUMBER;



END;


CREATE OR REPLACE PACKAGE BODY area AS

    FUNCTION square_area (
        p_side NUMBER
    ) RETURN NUMBER AS
    
    BEGIN
        RETURN p_side * p_side;
    END;

    FUNCTION rectangle_area (
        p_length   NUMBER,
        p_width    NUMBER
    ) RETURN NUMBER AS
    
    BEGIN
        RETURN p_length * p_width;
    END;
    
-- The begin is optional, we use it for initialization

BEGIN
    dbms_output.put_line('welcome ');
END;



SELECT  area.square_area(4)
  FROM  dual;

SELECT  area.rectangle_area(4, 10)
  FROM  dual;
  
SET SERVEROUTPUT ON

BEGIN
    dbms_output.put_line(area.square_area(4));
END;



-- So now there is no need for functions square_area, and rectangle_area which we created in steps 1 and 2 above.

DROP FUNCTION square_area;

DROP FUNCTION rectangle_area;

/*

The Specification is the interface to the package.
It declares the types, variables, constants, exceptions, cursors, 
and subprograms that can be referenced from outside of the package.

The body defines the queries for the cursors and the code for the 
subprograms.

Enables the Oracle server to read multiple objects into memory at once.

*/

/*
Advantages of using packages:
  *  Modularity: Encapsulating related constructs
  *  Easier manintenance: Keeping logically related functionality together
  *  Easier application design: Coding and compiling the specification and body separately
  *  Hiding information:
     -  Only the declarations in the package specification are visible and accessible to applications
     -  Private constructs in the package body are hidden and inaccessible
     -  All coding is hidden in the package body
     
*/


/********************************************************************/

DROP TABLE student;

CREATE TABLE student (
    student_id   NUMBER,
    first_name   VARCHAR2(100),
    birthday     DATE,
    CONSTRAINT student_pk PRIMARY KEY ( student_id )
);

DROP SEQUENCE student_seq;

CREATE SEQUENCE student_seq;

-- We need to create a package to be able to insert, delete, and query a student

-- 1) We create the package specification.

CREATE OR REPLACE PACKAGE general_student AS
    PROCEDURE insert_student (
        p_first_name   VARCHAR2,
        p_birthday     DATE
    );

    PROCEDURE delete_student (
        p_student_id NUMBER
    );

    FUNCTION get_name (
        p_student_id NUMBER
    ) RETURN VARCHAR2;

END;
-------
-- 2) We create the package body.

CREATE OR REPLACE PACKAGE BODY general_student AS

    PROCEDURE insert_student (
        p_first_name   VARCHAR2,
        p_birthday     DATE
    ) IS
    BEGIN
        INSERT INTO student VALUES (
            student_seq.NEXTVAL,
            p_first_name,
            p_birthday
        );

        COMMIT;
   
   EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode);
            dbms_output.put_line(sqlerrm);
    END;

    PROCEDURE delete_student (
        p_student_id NUMBER
    ) AS
    BEGIN
        DELETE 
          FROM student
         WHERE student_id = p_student_id;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode);
            dbms_output.put_line(sqlerrm);
    END;

    FUNCTION get_name (
        p_student_id NUMBER
    ) RETURN VARCHAR2 AS
        v_name student.first_name%TYPE;
    BEGIN
        SELECT first_name
          INTO v_name
          FROM student
         WHERE student_id = p_student_id;

        RETURN v_name;
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN NULL;
    END;

END;

-------------------------

EXECUTE general_student.insert_student('John Doe', '10-may-71');

EXECUTE general_student.insert_student('Mary Doe', '10-may-72');

SELECT  *
  FROM  student;

EXECUTE general_student.delete_student(1);

SELECT  *
  FROM  student;

SELECT  general_student.get_name(2)
  FROM  dual;





-- We can create package specification without a body
-- this is used when we want to define a global variable.

CREATE OR REPLACE PACKAGE global_measurement AS
    c_mile_to_km   CONSTANT NUMBER := 1.60934;
    c_kilo_to_mile CONSTANT NUMBER := 0.621371;
END;

SET SERVEROUTPUT ON

EXECUTE dbms_output.put_line('60 mile:= ' || 60 * global_measurement.c_mile_to_km || 'KM');

EXECUTE dbms_output.put_line('100 KM:= '  || 100 * global_measurement.c_kilo_to_mile || ' Mile');

-- Now we will create a function that will read from this package.

CREATE OR REPLACE FUNCTION get_mile_to_km (
    p_value NUMBER
) RETURN NUMBER AS
BEGIN
    RETURN p_value * global_measurement.c_mile_to_km;
END;

SELECT  get_mile_to_km(100)
  FROM  dual;

-----------------------------------------------------

-- You can define a procedure or function inside a pl/sql block
-- but this will only be used in this block.
-- This is a local function or a private function.

DECLARE
    FUNCTION get_sysdate RETURN DATE AS
    BEGIN
        RETURN SYSDATE;
    END;

BEGIN
    dbms_output.put_line(get_sysdate);
END;



CREATE OR REPLACE PACKAGE p_test IS
    c_var1 CONSTANT NUMBER := 10;
    c_var2 VARCHAR2(100) := 'Welcome';
    PROCEDURE print;

END;
------------

CREATE OR REPLACE PACKAGE BODY p_test AS

    c_var3 VARCHAR2(100) := 'Hi there';

    PROCEDURE print AS
        c_var4 VARCHAR2(100) := 'Hi';
    BEGIN
        dbms_output.put_line('This variable came from package spec. ' || c_var1);
        dbms_output.put_line('This variable came from package spec. ' || c_var2);
        dbms_output.put_line('This variable came from package body. ' || c_var3);
        dbms_output.put_line('This variable came from print Proc. ' || c_var4);
    END;

END;

EXECUTE p_test.print;

---------------------------------------------------------------

-- Note that we can update the package body without compiling the specification.

CREATE OR REPLACE PACKAGE BODY p_test AS

    c_var3 VARCHAR2(100) := 'Hi there';

    PROCEDURE print AS
        c_var4 VARCHAR2(100) := 'Hi';
    BEGIN
        dbms_output.put_line('This variable came from package spec. ' || c_var1);
        dbms_output.put_line('This variable came from package spec. ' || c_var2);
        dbms_output.put_line('This variable came from package body. ' || c_var3);
        dbms_output.put_line('This variable came from print Proc. ' || c_var4);
    END;

BEGIN
    dbms_output.put_line('this is optional');
END;

EXECUTE p_test.print;


----------------------------------------------------

-- Now let's try to change the package specification, not a major change.

CREATE OR REPLACE PACKAGE p_test AS
    c_var1 CONSTANT NUMBER := 10;
    c_var2 VARCHAR2(100) := 'Welcome';
    p_n NUMBER;
    PROCEDURE print;

END;

EXECUTE p_test.print;

-- Now let's try to change the package specification again, a major change add a new subprogram.

CREATE OR REPLACE PACKAGE p_test AS
    c_var1 CONSTANT NUMBER := 10;
    c_var2 VARCHAR2(100) := 'Welcome';
    p_n NUMBER;
    PROCEDURE print;

    FUNCTION get_name (
        p NUMBER
    ) RETURN VARCHAR2;

END;

EXECUTE p_test.print;
-----------------------------------------

SELECT  *
  FROM  user_objects
 WHERE  object_name = 'P_TEST'

SELECT  *
  FROM  user_source
 WHERE  name = 'P_TEST'
   AND  type = 'PACKAGE';

SELECT  *
  FROM  user_source
 WHERE  name = 'P_TEST'
   AND  type = 'PACKAGE BODY';

-- To drop the package specification and body   

DROP PACKAGE p_test;

-- To drop only the package body 

DROP PACKAGE BODY p_test;


/*

Examining code

*/

CREATE OR REPLACE PACKAGE tt AS
    FUNCTION xx RETURN NUMBER;
END;

--------------

CREATE OR REPLACE PACKAGE BODY tt AS
    FUNCTION xx RETURN NUMBER AS
    BEGIN
        RETURN 10;
    END;

BEGIN
    dbms_output.put_line('Welcome');
END;

-- What is the output from this block?

BEGIN
    dbms_output.put_line(tt.xx);
END;

DROP PACKAGE tt;

/*
Welcome
10
*/

CREATE OR REPLACE PACKAGE tt IS
    v NUMBER := 50;
    FUNCTION xx RETURN NUMBER;

END;

/* ORA-06553: PLS-221: 'V' is not a procedure or is undefined */
SELECT tt.v FROM DUAL;


BEGIN
    dbms_output.put_line(tt.v);
END;
