SET SERVEROUTPUT ON

BEGIN
    re_run_ddl('
CREATE TABLE TEST
(
  id    NUMBER
 ,s     VARCHAR2(30) 
)
');
END;
/

EXEC re_run_ddl('DROP TABLE TEST');

EXEC re_run_ddl('DROP TABLE TEST');

EXEC re_run_ddl('DROP TABLE TEST');