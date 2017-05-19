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
--   sql> @apply_oracle_lab6.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

SPOOL apply_oracle_lab6.log
SET ECHO ON
--Step 1
    --Change the RENTAL_ITEM table by adding the RENTAL_ITEM_TYPE and RENTAL_ITEM_PRICE columns. Both columns should use a NUMBER data type.
ALTER TABLE rental_item
        ADD (rental_item_type NUMBER)
        ADD (rental_item_price NUMBER)

--Create the following PRICE table as per the specification, like the description below.

BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'PRICE') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE price CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'PRICE_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE price_s1';
  END LOOP;
END;
/

CREATE TABLE price
(price_id               NUMBER  
, item_id               NUMBER   CONSTRAINT price_nn1 NOT NULL    
, price_type            NUMBER
, active_flag           VARCHAR2(1) CONSTRAINT price_nn2 NOT NULL 
, start_date            DATE   CONSTRAINT price_nn3 NOT NULL 
, end_date              DATE
, amount                NUMBER  CONSTRAINT price_nn4 NOT NULL 
, created_by            NUMBER  CONSTRAINT price_nn5 NOT NULL 
, creation_date         DATE  CONSTRAINT price_nn6 NOT NULL 
, last_updated_by       NUMBER CONSTRAINT price_nn7 NOT NULL 
, last_updated_date     DATE  CONSTRAINT price_nn8 NOT NULL 
, CONSTRAINT price_pk PRIMARY KEY(price_id)
, CONSTRAINT price_fk1 FOREIGN KEY(item_id) REFERENCES item(item_id)
, CONSTRAINT price_fk2 FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT price_check CHECK (active_flag = 'Y' OR active_flag =  'N')
, CONSTRAINT price_fk3 FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT price_fk4 FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)
);

CREATE SEQUENCE price_s1 START WITH 1001;
  
--Insert new data into the model (Check Step #03 on the referenced web page for details).

ALTER TABLE item
        RENAME COLUMN item_release_date TO release_date;

INSERT INTO item
VALUES
(item_s1.nextval
, '955-9555-90'
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
    AND common_lookup_context = 'ITEM')
,'Tron'
, NULL
, 'PG-13'
, SYSDATE
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO item
VALUES
(item_s1.nextval
, '955-9555-80'
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
    AND common_lookup_context = 'ITEM')
,'The Avengers'
, NULL
, 'PG-13'
, SYSDATE
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO item
VALUES
(item_s1.nextval
, '955-9555-94'
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
    AND common_lookup_context = 'ITEM')
,'Thor: The Dark World'
, NULL
, 'PG-13'
, SYSDATE
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO member
VALUES
(member_s1.nextval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'GROUP'
    AND common_lookup_context = 'MEMBER')  
, 'B293-71455'
, '9999-0000-1111-2222'
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'DISCOVER_CARD'
    AND common_lookup_context = 'MEMBER')
, 1
, SYSDATE
, 1
, SYSDATE
);


INSERT INTO contact
VALUES
(contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'CUSTOMER'
    AND common_lookup_context = 'CONTACT')
, 'Harry'
, NULL
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO address
VALUES
(address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'Provo'
, 'Utah'
, 84606
,1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address
VALUES
(street_address_s1.nextval
, address_s1.currval
, '236 N 5th W'
, 2
, SYSDATE
, 2
, SYSDATE
);

INSERT INTO telephone
VALUES
(telephone_s1.nextval
,contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'USA'
, '503'
, '738-1450'
, 2
,SYSDATE
, 2
, SYSDATE);

INSERT INTO rental
VALUES
(rental_s1.nextval
, contact_s1.currval
, SYSDATE
, SYSDATE + 1
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO rental_item
VALUES
(rental_item_s1.nextval
,rental_s1.currval
, (SELECT item_id FROM item
   WHERE item_title = 'Thor: The Dark World'
   AND item_type = (SELECT common_lookup_id FROM common_lookup
                    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
                    AND common_lookup_context = 'ITEM'))
, 2
, SYSDATE
, 2
, SYSDATE);

INSERT INTO rental_item
VALUES
(rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id FROM item
   WHERE item_title = 'Hook'
   AND item_type = (SELECT common_lookup_id FROM common_lookup
                    WHERE common_lookup_type = 'BLU-RAY'
                    AND common_lookup_context = 'ITEM'))
, 2
, SYSDATE
, 2
, SYSDATE);

INSERT INTO contact
VALUES
(contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'CUSTOMER'
    AND common_lookup_context = 'CONTACT')
, 'Ginny'
, NULL
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO address
VALUES
(address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'Provo'
, 'Utah'
, 84606
,1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address
VALUES
(street_address_s1.nextval
, address_s1.currval
, '236 N 5th W'
, 2
, SYSDATE
, 2
, SYSDATE
);

INSERT INTO telephone
VALUES
(telephone_s1.nextval
,contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'USA'
, '503'
, '738-1450'
, 2
,SYSDATE
, 2
, SYSDATE);

INSERT INTO rental
VALUES
(rental_s1.nextval
, contact_s1.currval
, SYSDATE
, SYSDATE + 3
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO rental_item
VALUES
(rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id FROM item
   WHERE item_title = 'The Avengers'
   AND item_type = (SELECT common_lookup_id FROM common_lookup
                    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
                    AND common_lookup_context = 'ITEM'))
, 2
, SYSDATE
, 2
, SYSDATE);

INSERT INTO contact
VALUES
(contact_s1.nextval
, member_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'CUSTOMER'
    AND common_lookup_context = 'CONTACT')
, 'Lily'
, 'Luna'
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO address
VALUES
(address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'Provo'
, 'Utah'
, 84606
,1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address
VALUES
(street_address_s1.nextval
, address_s1.currval
, '236 N 5th W'
, 2
, SYSDATE
, 2
, SYSDATE
);

INSERT INTO telephone
VALUES
(telephone_s1.nextval
,contact_s1.currval
, address_s1.currval
, (SELECT common_lookup_id FROM common_lookup
    WHERE common_lookup_type = 'HOME'
    AND common_lookup_context = 'MULTIPLE')
, 'USA'
, '503'
, '738-1450'
, 2
,SYSDATE
, 2
, SYSDATE);

INSERT INTO rental
VALUES
(rental_s1.nextval
, contact_s1.currval
, SYSDATE
, SYSDATE + 5
, 3
, SYSDATE
, 3
, SYSDATE
);

INSERT INTO rental_item
VALUES
(rental_item_s1.nextval
, rental_s1.currval
, (SELECT item_id FROM item
   WHERE item_title = 'Tron'
   AND item_type = (SELECT common_lookup_id FROM common_lookup
                    WHERE common_lookup_type = 'DVD_WIDE_SCREEN'
                    AND common_lookup_context = 'ITEM'))
, 2
, SYSDATE
, 2
, SYSDATE);

--Modify the design of the COMMON_LOOKUP table following the definitions below, insert new data into the model, and update old non-compliant design data in the model (Check Step #4 on the referenced web page for details).

        DROP INDEX common_lookup_n1;

        DROP INDEX common_lookup_u2;

ALTER TABLE common_lookup
        ADD(common_lookup_table VARCHAR2(20))
        ADD(common_lookup_column VARCHAR2(20))
        ADD(common_lookup_code VARCHAR(20));

UPDATE common_lookup
SET common_lookup_table = common_lookup_context 
WHERE common_lookup_context != 'MULTIPLE';

SET common_lookup_table = 'ADDRESS' WHERE common_lookup_context = 'MULTIPLE';

SET common_lookup_column = common_lookup_context AND '_TYPE' WHERE common_lookup_table = 'MEMBER' 
AND common_lookup_type = 'INDIVIDUAL' OR common_lookup_type = 'GROUP';

SET common_lookup_column = 'CREDIT_CARD_TYPE' WHERE common_lookup_type = 'VISA_CARD' OR common_lookup_type = 'MASTER_CARD'
OR common_lookup_type = 'DISCOVER_CARD';

SET common_lookup_column = 'ADDRESS_TYPE' WHERE common_lookup_context = 'MULTIPLE';

SET common_lookup_column = common_lookup_context AND '_TYPE' WHERE common_lookup_context != 'MULTIPLE' 
AND common_lookup_context != 'MEMBER';





--verification
-- step1

SET NULL ''
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

-- step  2

SET NULL ''
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
WHERE    table_name = 'PRICE'
ORDER BY 2;

COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';


-- step 3

SET NULL ''
COLUMN TABLE_NAME   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   TABLE_NAME
,        column_id
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS NULLABLE
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    TABLE_NAME = 'ITEM'
ORDER BY 2;

SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

COLUMN full_name FORMAT A20
COLUMN city      FORMAT A10
COLUMN state     FORMAT A10
SELECT   c.last_name || ', ' || c.first_name AS full_name
,        a.city
,        a.state_province AS state
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- step 4
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP';

SET NULL ''
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
WHERE    table_name = 'COMMON_LOOKUP'
ORDER BY 2;

SPOOL OFF
