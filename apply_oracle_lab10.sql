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
--   sql> @apply_oracle_lab10.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql

SPOOL apply_oracle_lab10.log

    --Write a query that returns the rows necessary to insert records into the RENTAL table.
INSERT INTO rental
SELECT rental_s1.NEXTVAL, contact_id, check_out_date, return_date, created_by, creation_date, last_updated_by, last_update_date FROM (
SELECT   DISTINCT r.rental_id, c.contact_id, tu.check_out_date, tu.return_date, 1 AS created_by, SYSDATE AS creation_date, 1 AS last_updated_by, SYSDATE AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON m.account_number = tu.account_number 
AND c.first_name = tu.first_name AND NVL(c.middle_name, 'a') = NVL(tu.middle_name, 'a') 
AND c.last_name = tu.last_name LEFT JOIN rental r
ON c.contact_id = r.customer_id AND r.check_out_date = tu.check_out_date AND r.return_date = tu.return_date);



    --Write a query that returns the rows necessary to insert records into the RENTAL_ITEM table.
INSERT INTO rental_item
SELECT rental_item_s1.NEXTVAL, rental_id, item_id, created_by, creation_date, last_updated_by, last_update_date, rental_item_type, rental_item_price FROM (
SELECT  r.rental_id, tu.item_id, 1 AS created_by, SYSDATE AS creation_date, 1 AS last_updated_by, SYSDATE AS last_update_date, cl.common_lookup_id AS rental_item_type, TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number AND 
tu.first_name = c.first_name AND NVL(tu.middle_name, 'a') = NVL(c.middle_name, 'a') 
AND tu.last_name = c.last_name LEFT JOIN rental r
ON c.contact_id = r.customer_id AND r.check_out_date = tu.check_out_date AND r.return_date = tu.return_date
INNER JOIN common_lookup cl ON  cl.common_lookup_type = tu.rental_item_type AND cl.common_lookup_column = 'RENTAL_ITEM_TYPE' LEFT JOIN rental_item ri ON ri.item_id = tu.item_id);


    --Write a query that returns the rows necessary to insert records into the TRANSACTION table.
INSERT INTO transaction
SELECT NVL(transaction_id, transaction_s1.NEXTVAL), transaction_account, transaction_type, transaction_date, transaction_amount, rental_id, payment_method_type, payment_account_number, created_by, creation_date, last_updated_by, last_update_date FROM (
SELECT  tr.transaction_id, tu.payment_account_number AS transaction_account, cl1.common_lookup_id AS transaction_type, tu.transaction_date, SUM(tu.transaction_amount) AS transaction_amount, r.rental_id, cl2.common_lookup_id AS payment_method_type, m.credit_card_number AS payment_account_number, 1 AS created_by, SYSDATE AS creation_date, 1 AS last_updated_by, SYSDATE AS last_update_date
FROM member m INNER JOIN contact c
ON m.member_id = c.member_id INNER JOIN transaction_upload tu
ON tu.account_number = m.account_number AND 
tu.first_name = c.first_name AND NVL(tu.middle_name, 'a') = NVL(c.middle_name, 'a') 
AND tu.last_name = c.last_name INNER JOIN rental r
ON c.contact_id = r.customer_id AND r.check_out_date = tu.check_out_date AND r.return_date = tu.return_date
INNER JOIN common_lookup cl1 ON  cl1.common_lookup_table = 'TRANSACTION' AND cl1.common_lookup_column = 'TRANSACTION_TYPE' AND cl1.common_lookup_type = tu.transaction_type INNER JOIN common_lookup cl2 ON cl2.common_lookup_table = 'TRANSACTION' AND cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE' AND cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction tr  ON tr.transaction_account = tu.payment_account_number AND tr.transaction_type = cl1.common_lookup_id AND tr.transaction_date = tu.transaction_date AND tr.transaction_amount = tu.transaction_amount AND tr.payment_method_type = cl2.common_lookup_id AND tr.payment_account_number = m.credit_card_number GROUP BY tr.transaction_id, tu.payment_account_number, cl1.common_lookup_id, tu.transaction_date, r.rental_id, cl2.common_lookup_id, m.credit_card_number);



SPOOL OFF
