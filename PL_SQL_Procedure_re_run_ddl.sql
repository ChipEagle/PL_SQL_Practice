CREATE OR REPLACE PROCEDURE re_run_ddl (
    p_sql IN VARCHAR2
)
    AUTHID current_user
AS

    l_line         VARCHAR2(500) DEFAULT rpad('-', 20, '-');
    l_cr           VARCHAR2(2) DEFAULT chr(10);
    l_footer       VARCHAR2(500) DEFAULT l_cr
                                   || rpad('*', 20, '*');
    l_ignore_txt   VARCHAR2(200) DEFAULT 'IGNORING --> ';
    ora_00955 EXCEPTION;
    ora_01430 EXCEPTION;
    ora_02260 EXCEPTION;
    ora_01408 EXCEPTION;
    ora_00942 EXCEPTION;
    ora_02275 EXCEPTION;
    ora_01418 EXCEPTION;
    ora_02443 EXCEPTION;
    ora_01442 EXCEPTION;
    ora_01434 EXCEPTION;
    ora_01543 EXCEPTION;
    ora_00904 EXCEPTION;
    ora_02261 EXCEPTION;
    ora_04043 EXCEPTION;
    ora_02289 EXCEPTION;
    PRAGMA exception_init ( ora_00955, -00955 ); --ORA-00955: name is already used by an existing object
    PRAGMA exception_init ( ora_01430, -01430 ); --ORA-01430: column being added already exists in table
    PRAGMA exception_init ( ora_02260, -02260 ); --ORA-02260: table can have only one primary key
    PRAGMA exception_init ( ora_01408, -01408 ); --ORA-01408: such column list already indexed
    PRAGMA exception_init ( ora_00942, -00942 ); --ORA-00942: table or view does not exist
    PRAGMA exception_init ( ora_02275, -02275 ); --ORA-02275: such a referential constraint already exists in the table
    PRAGMA exception_init ( ora_01418, -01418 ); --ORA-01418: specified index does not exist
    PRAGMA exception_init ( ora_02443, -02443 ); --ORA-02443: Cannot drop constraint  - nonexistent constraint
    PRAGMA exception_init ( ora_01442, -01442 ); --ORA-01442: column to be modified to NOT NULL is already NOT NULL
    PRAGMA exception_init ( ora_01434, -01434 ); --ORA-01434: private synonym to be dropped does not exist
    PRAGMA exception_init ( ora_01543, -01543 ); --ORA-01543: tablespace '<TBS_NAME>' already exists
    PRAGMA exception_init ( ora_00904, -00904 ); --ORA-00904: "%s: invalid identifier"
    PRAGMA exception_init ( ora_02261, -02261 ); --ORA-02261: "such unique or primary key already exists in the table"
    PRAGMA exception_init ( ora_04043, -04043 ); --ORA-04043: object %s does not exist
    PRAGMA exception_init ( ora_02289, -02289 ); --ORA-02289: sequence does not exist

    PROCEDURE p (
        p_str         IN   VARCHAR2,
        p_maxlength   IN   INT DEFAULT 120
    ) IS
        i INT := 1;
    BEGIN
        dbms_output.enable(NULL);
        WHILE ( ( length(substr(p_str, i, p_maxlength)) ) = p_maxlength ) LOOP
            dbms_output.put_line(substr(p_str, i, p_maxlength));
            i := i + p_maxlength;
        END LOOP;

        dbms_output.put_line(substr(p_str, i, p_maxlength));
    END p;

BEGIN
    p('EXEC:'
      || l_cr
      || l_line
      || l_cr
      || p_sql
      || l_cr
      || l_line);

    EXECUTE IMMEDIATE p_sql;
    p('done.');
EXCEPTION
    WHEN ora_00955 OR ora_01430 OR ora_02260 OR ora_01408 OR ora_00942 OR ora_02275 OR ora_01418 OR ora_02443 OR ora_01442 OR ora_01434
    OR ora_01543 OR ora_00904 OR ora_02261 OR ora_04043 OR ora_02289 THEN
        p(l_ignore_txt
          || sqlerrm
          || l_footer);
    WHEN OTHERS THEN
        p(sqlerrm);
        p(dbms_utility.format_error_backtrace);
        p(l_footer);
        RAISE;
END;
