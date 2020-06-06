/* 1 */

BEGIN

    dbms_output.put_line('Welcome');

END;

BEGIN

    dbms_output.put_line('');
    dbms_output.put_line('Father''s day');
    
END;

--  When a string contains an apstrophe
--  it is recommended we use the q' notation


SELECT 'Today is Father''s day'
  FROM DUAL;
  
-- Using ? as delimiter q'?Your text?'

SELECT q'?Today is Father's day?'
  FROM DUAL;
  
SELECT q'[Today is Father's day, not Mother's day]'
  FROM DUAL;
  
SELECT q'(Today is Father's day)'
  FROM DUAL;
  
SELECT q'{Today is Father's day}'
  FROM DUAL;
  
SELECT q'*Today is Father's day*'
  FROM DUAL;
  
BEGIN

    dbms_output.put_line('Today is Father''s day, not Mother''s day.');
    dbms_output.put_line(q'[Today is Father's day, not Mother's day.]');

END;

