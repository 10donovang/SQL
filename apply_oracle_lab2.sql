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
--   sql> @apply_oracle_lab2.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql

SPOOL create_oracle_store.log

-- Add your lab here:
-- ----------------------------------------------------------------------

  --  [2 points] Create the SYSTEM_USER_LAB 
        -- table
CREATE TABLE system_user_lab
( system_user_lab_id              NUMBER
, system_user_lab_name            VARCHAR2(20) CONSTRAINT nn_system_user_lab_1 NOT NULL
, system_user_lab_group_id        NUMBER       CONSTRAINT nn_system_user_lab_2 NOT NULL
, system_user_lab_type            NUMBER       CONSTRAINT nn_system_user_lab_3 NOT NULL
, first_name                  VARCHAR2(20)
, middle_name                 VARCHAR2(20)
, last_name                   VARCHAR2(20)
, created_by                  NUMBER       CONSTRAINT nn_system_user_lab_4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_system_user_lab_5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_system_user_lab_6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_system_user_lab_7 NOT NULL
, CONSTRAINT pk_system_user_lab_1 PRIMARY KEY(system_user_lab_id));
        -- sequence
CREATE SEQUENCE system_user_lab_s1 START WITH 1001;
        -- constraints 
ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_1 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id);

ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_2 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id);
        
  --  [2 points] Create the COMMON_LOOKUP_LAB 
        -- table
CREATE TABLE common_lookup_lab
( common_lookup_lab_id            NUMBER
, common_lookup_lab_context       VARCHAR2(30) CONSTRAINT nn_clookup_lab_1 NOT NULL
, common_lookup_lab_type          VARCHAR2(30) CONSTRAINT nn_clookup_lab_2 NOT NULL
, common_lookup_lab_meaning       VARCHAR2(30) CONSTRAINT nn_clookup_lab_3 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_clookup_lab_4 NOT NULL
, creation_date               DATE         CONSTRAINT nn_clookup_lab_5 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_clookup_lab_6 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_clookup_lab_7 NOT NULL
, CONSTRAINT pk_c_lookup_lab_1    PRIMARY KEY(common_lookup_lab_id)
, CONSTRAINT fk_c_lookup_lab_1    FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_c_lookup_lab_2    FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE common_lookup_lab_s1 START WITH 1001;
        -- constraints
ALTER TABLE system_user_lab
ADD CONSTRAINT fk_system_user_lab_3 FOREIGN KEY(system_user_lab_type)
    REFERENCES common_lookup_lab(common_lookup_lab_id);
        -- indexes.
CREATE INDEX common_lookup_lab_n1
  ON common_lookup_lab(common_lookup_lab_context);

CREATE UNIQUE INDEX common_lookup_lab_u2
  ON common_lookup_lab(common_lookup_lab_context,common_lookup_lab_type);

  --  [2 points] Create the MEMBER_LAB 
        -- table
CREATE TABLE member_lab
( member_lab_id                   NUMBER
, member_lab_type                 NUMBER
, account_number              VARCHAR2(10) CONSTRAINT nn_member_lab_2 NOT NULL
, credit_card_number          VARCHAR2(19) CONSTRAINT nn_member_lab_3 NOT NULL
, credit_card_type            NUMBER       CONSTRAINT nn_member_lab_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_member_lab_5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_member_lab_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_member_lab_7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_member_lab_8 NOT NULL
, CONSTRAINT pk_member_lab_1      PRIMARY KEY(member_lab_id)
, CONSTRAINT fk_member_lab_1      FOREIGN KEY(member_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_member_lab_2      FOREIGN KEY(credit_card_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT fk_member_lab_3      FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_member_lab_4      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE member_lab_s1 START WITH 1001;
        -- indexes.
CREATE INDEX member_lab_n1 ON member_lab(credit_card_type);

  --  [2 points] Create the CONTACT_LAB 
         -- table
CREATE TABLE contact_lab
( contact_lab_id                  NUMBER
, member_lab_id                   NUMBER       CONSTRAINT nn_contact_lab_1 NOT NULL
, contact_lab_type                NUMBER       CONSTRAINT nn_contact_lab_2 NOT NULL
, first_name                  VARCHAR2(20) CONSTRAINT nn_contact_lab_3 NOT NULL
, middle_name                 VARCHAR2(20)
, last_name                   VARCHAR2(20) CONSTRAINT nn_contact_lab_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_contact_lab_5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_contact_lab_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_contact_lab_7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_contact_lab_8 NOT NULL
, CONSTRAINT pk_contact_lab_1     PRIMARY KEY(contact_lab_id)
, CONSTRAINT fk_contact_lab_1     FOREIGN KEY(member_lab_id) REFERENCES member_lab(member_lab_id)
, CONSTRAINT fk_contact_lab_2     FOREIGN KEY(contact_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_contact_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_contact_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE contact_lab_s1 START WITH 1001;
        -- indexes.
CREATE INDEX contact_lab_n1 ON contact_lab(member_lab_id);
CREATE INDEX contact_lab_n2 ON contact_lab(contact_lab_type);

  --  [2 points] Create the ADDRESS_LAB 
         -- table
CREATE TABLE address_lab
( address_lab_id                  NUMBER
, contact_lab_id                  NUMBER       CONSTRAINT nn_address_lab_1 NOT NULL
, address_lab_type                NUMBER       CONSTRAINT nn_address_lab_2 NOT NULL
, city                        VARCHAR2(30) CONSTRAINT nn_address_lab_3 NOT NULL
, state_province              VARCHAR2(30) CONSTRAINT nn_address_lab_4 NOT NULL
, postal_code                 VARCHAR2(20) CONSTRAINT nn_address_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_address_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_address_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_address_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_address_lab_9 NOT NULL
, CONSTRAINT pk_address_lab_1     PRIMARY KEY(address_lab_id)
, CONSTRAINT fk_address_lab_1     FOREIGN KEY(contact_lab_id) REFERENCES contact_lab(contact_lab_id)
, CONSTRAINT fk_address_lab_2     FOREIGN KEY(address_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_address_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_address_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE address_lab_s1 START WITH 1001;
        -- indexes.
CREATE INDEX address_lab_n1 ON address_lab(contact_lab_id);
CREATE INDEX address_lab_n2 ON address_lab(address_lab_type);

  --  [2 points] Create the STREET_ADDRESS_LAB 
        -- table
CREATE TABLE street_address_lab
( street_address_lab_id           NUMBER
, address_lab_id                  NUMBER       CONSTRAINT nn_saddress_lab_1 NOT NULL
, street_address_lab            VARCHAR2(30) CONSTRAINT nn_saddress_lab_2 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_saddress_lab_3 NOT NULL
, creation_date               DATE         CONSTRAINT nn_saddress_lab_4 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_saddress_lab_5 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_saddress_lab_6 NOT NULL
, CONSTRAINT pk_s_address_lab_1   PRIMARY KEY(street_address_lab_id)
, CONSTRAINT fk_s_address_lab_1   FOREIGN KEY(address_lab_id) REFERENCES address_lab(address_lab_id)
, CONSTRAINT fk_s_address_lab_3   FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_s_address_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE street_address_lab_s1 START WITH 1001;
        
  --  [2 points] Create the TELEPHONE_LAB 
        -- table
CREATE TABLE telephone_lab
( telephone_lab_id                NUMBER
, contact_lab_id                  NUMBER       CONSTRAINT nn_telephone_lab_1 NOT NULL
, address_lab_id                  NUMBER
, telephone_lab_type              NUMBER       CONSTRAINT nn_telephone_lab_2 NOT NULL
, country_code                VARCHAR2(3)  CONSTRAINT nn_telephone_lab_3 NOT NULL
, area_code                   VARCHAR2(6)  CONSTRAINT nn_telephone_lab_4 NOT NULL
, telephone_number            VARCHAR2(10) CONSTRAINT nn_telephone_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_telephone_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_telephone_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_telephone_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_telephone_lab_9 NOT NULL
, CONSTRAINT pk_telephone_lab_1   PRIMARY KEY(telephone_lab_id)
, CONSTRAINT fk_telephone_lab_1   FOREIGN KEY(contact_lab_id) REFERENCES contact_lab(contact_lab_id)
, CONSTRAINT fk_telephone_lab_2   FOREIGN KEY(telephone_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_telephone_lab_3   FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_telephone_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE telephone_lab_s1 START WITH 1001;
        -- indexes.
CREATE INDEX telephone_lab_n1 ON telephone_lab(contact_lab_id,address_lab_id);
CREATE INDEX telephone_lab_n2 ON telephone_lab(address_lab_id);
CREATE INDEX telephone_lab_n3 ON telephone_lab(telephone_lab_type);
  --  [2 points] Create the ITEM_LAB 
        -- table
CREATE TABLE item_lab
( item_lab_id                     NUMBER
, item_lab_barcode                VARCHAR2(14) CONSTRAINT nn_item_lab_1 NOT NULL
, item_lab_type                   NUMBER       CONSTRAINT nn_item_lab_2 NOT NULL
, item_lab_title                  VARCHAR2(60) CONSTRAINT nn_item_lab_3 NOT NULL
, item_lab_subtitle               VARCHAR2(60)
, item_lab_rating                 VARCHAR2(8)  CONSTRAINT nn_item_lab_4 NOT NULL
, item_lab_release_date           DATE         CONSTRAINT nn_item_lab_5 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_item_lab_6 NOT NULL
, creation_date               DATE         CONSTRAINT nn_item_lab_7 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_item_lab_8 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_item_lab_9 NOT NULL
, CONSTRAINT pk_item_lab_1        PRIMARY KEY(item_lab_id)
, CONSTRAINT fk_item_lab_1        FOREIGN KEY(item_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
, CONSTRAINT fk_item_lab_2        FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_item_lab_3        FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE item_lab_s1 START WITH 1001;
 
  --  [2 points] Create the RENTAL_LAB 
         -- table
CREATE TABLE rental_lab
( rental_lab_id                   NUMBER
, customer_id                 NUMBER CONSTRAINT nn_rental_lab_1 NOT NULL
, check_out_date              DATE   CONSTRAINT nn_rental_lab_2 NOT NULL
, return_date                 DATE   CONSTRAINT nn_rental_lab_3 NOT NULL
, created_by                  NUMBER CONSTRAINT nn_rental_lab_4 NOT NULL
, creation_date               DATE   CONSTRAINT nn_rental_lab_5 NOT NULL
, last_updated_by             NUMBER CONSTRAINT nn_rental_lab_6 NOT NULL
, last_update_date            DATE   CONSTRAINT nn_rental_lab_7 NOT NULL
, CONSTRAINT pk_rental_lab_1      PRIMARY KEY(rental_lab_id)
, CONSTRAINT fk_rental_lab_1      FOREIGN KEY(customer_id) REFERENCES contact_lab(contact_lab_id)
, CONSTRAINT fk_rental_lab_2      FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_rental_lab_3      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE rental_lab_s1 START WITH 1001;
  --  [2 points] Create the RENTAL_ITEM_LAB 
        -- table
CREATE TABLE rental_item_lab
( rental_item_lab_id              NUMBER
, rental_lab_id                   NUMBER CONSTRAINT nn_rental_item_lab_1 NOT NULL
, item_lab_id                     NUMBER CONSTRAINT nn_rental_item_lab_2 NOT NULL
, created_by                  NUMBER CONSTRAINT nn_rental_item_lab_3 NOT NULL
, creation_date               DATE   CONSTRAINT nn_rental_item_lab_4 NOT NULL
, last_updated_by             NUMBER CONSTRAINT nn_rental_item_lab_5 NOT NULL
, last_update_date            DATE   CONSTRAINT nn_rental_item_lab_6 NOT NULL
, CONSTRAINT pk_rental_item_lab_1 PRIMARY KEY(rental_item_lab_id)
, CONSTRAINT fk_rental_item_lab_1 FOREIGN KEY(rental_lab_id) REFERENCES rental_lab(rental_lab_id)
, CONSTRAINT fk_rental_item_lab_2 FOREIGN KEY(item_lab_id) REFERENCES item_lab(item_lab_id)
, CONSTRAINT fk_rental_item_lab_3 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
, CONSTRAINT fk_rental_item_lab_4 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));
        -- sequence
CREATE SEQUENCE rental_item_lab_s1 START WITH 1001;
       
SPOOL OFF

