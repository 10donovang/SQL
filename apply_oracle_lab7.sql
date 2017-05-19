-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab7.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab6/apply_oracle_lab6.sql

SPOOL apply_oracle_lab7.log


--Insert two new rows into the COMMON_LOOKUP table to support the ACTIVE_FLAG column in the PRICE table.

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, 'YES'
, 'Yes'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'Y');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, 'NO'
, 'Yes'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'ACTIVE_FLAG'
, 'N');

--Insert three new rows into the COMMON_LOOKUP table to support the PRICE_TYPE column in the PRICE table.

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
, '1-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '1');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '3');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '5');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
, '1-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '1');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '3');

INSERT INTO common_lookup VALUES
(common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '5');

 --Add the following two columns to the RENTAL_ITEM table to support linking the price of rentals to the number of days an item is rented.
ALTER TABLE rental_item
ADD rental_item_type    NUMBER; 

ALTER TABLE rental_item
ADD CONSTRAINT fk_rental_item_7 FOREIGN KEY (rental_item_type) REFERENCES common_lookup(common_lookup_id);

ALTER TABLE rental_item
ADD rental_item_price    NUMBER;

UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

ALTER TABLE rental_item
MODIFY (rental_item_type NUMBER CONSTRAINT nn_rental_item_type NOT NULL); 
 


--You need to insert all price records with a single subquery to an SELECT statement. This is a complex problem. It requires a subquery that produces 135 rows from the 24 rows in the source ITEM table. You'll need to figure out how you can leverage the concept of data fabrication to insert them with a single SELECT statement.

COLUMN active_flag FORMAT A12

SELECT   item_id
,        active_flag
,        cl.common_lookup_id AS price_type
,        cl.common_lookup_type AS price_desc
,        CASE 
                WHEN active_flag = 'N' OR (TRUNC(SYSDATE)- TRUNC(i.release_date)) < 31
                      THEN TO_CHAR(TRUNC(i.release_date),'DD-MON-YY HH24:MI:SS')
                WHEN active_flag = 'Y' OR (TRUNC(SYSDATE)- TRUNC(i.release_date)) >= 30
                      THEN TO_CHAR(TRUNC(i.release_date + 31),'DD-MON-YY HH24:MI:SS')
         END AS start_date
,        CASE active_flag
              WHEN 'N'
                    THEN TO_CHAR(TRUNC(i.release_date + 30),'DD-MON-YY HH24:MI:SS')
         END AS end_date
,        CASE
                WHEN (active_flag = 'N' OR (TRUNC(SYSDATE)- TRUNC(i.release_date)) < 31) AND cl.common_lookup_type = '1-DAY RENTAL' 
                     THEN 3
WHEN (active_flag = 'N' OR (TRUNC(SYSDATE)- TRUNC(i.release_date)) < 31) AND cl.common_lookup_type = '3-DAY RENTAL' 
                     THEN 10
WHEN (active_flag = 'N' OR (TRUNC(SYSDATE)- TRUNC(i.release_date)) < 31) AND cl.common_lookup_type = '5-DAY RENTAL' 
                     THEN 15
                 ELSE TRUNC(cl.common_lookup_code)
          END AS amount
FROM     item i CROSS JOIN
        (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
         SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
        (SELECT '1' AS rental_days FROM dual
         UNION ALL
         SELECT '3' AS rental_days FROM dual
         UNION ALL
         SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR(cl.common_lookup_type,1,1)
WHERE    cl.common_lookup_table = 'PRICE'
AND      cl.common_lookup_column = 'PRICE_TYPE'
AND NOT (af.active_flag = 'N' AND (TRUNC(SYSDATE - 30)) < i.release_date)
ORDER BY 1, 2, 3;

--Verifications
--Step 1

COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

--step 2
COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 3;

--step 3
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

COLUMN table_name      FORMAT A12 HEADING "TABLE NAME"
COLUMN constraint_name FORMAT A18 HEADING "CONSTRAINT NAME"
COLUMN constraint_type FORMAT A12 HEADING "CONSTRAINT|TYPE"
COLUMN column_name     FORMAT A18 HEADING "COLUMN NAME"
SELECT   uc.table_name
,        uc.constraint_name
,        CASE
           WHEN uc.constraint_type = 'R' THEN
            'FOREIGN KEY'
         END AS constraint_type
,        ucc.column_name
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = 'RENTAL_ITEM'
AND      ucc.column_name = 'RENTAL_ITEM_TYPE';

SELECT   ROW_COUNT
,        col_count
FROM    (SELECT   COUNT(*) AS ROW_COUNT
         FROM     rental_item) rc CROSS JOIN
        (SELECT   COUNT(rental_item_type) AS col_count
         FROM     rental_item
         WHERE    rental_item_type IS NOT NULL) cc;



SPOOL OFF
