SET DEFINE OFF;

DROP SEQUENCE seq_cus_id;
CREATE SEQUENCE seq_cus_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table customer CASCADE CONSTRAINTS PURGE;
CREATE TABLE customer (
    cus_id number(3,0) not null,
    cus_fname varchar2(15) not null,
    cus_lname varchar2(30) not null,
    cus_street varchar2(30) not null,
    cus_city varchar2(30) not null,
    cus_state char(2) not null,
    cus_zip number(9) not null,
    cus_phone number(10) not null,
    cus_email varchar2(100),
    cus_balance number(7,2),
    cus_notes varchar2(255),
    CONSTRAINT pk_customer PRIMARY KEY(cus_id)
);

DROP SEQUENCE seq_com_id;
CREATE SEQUENCE seq_com_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table commodity CASCADE CONSTRAINTS PURGE;
CREATE TABLE commodity (
    com_id number not null,
    com_name varchar2(20),
    com_price NUMBER(8,2) not null,
    cus_notes varchar2(255),
    CONSTRAINT pk_commodity PRIMARY KEY(com_id),
    CONSTRAINT uq_com_name UNIQUE(com_name)
);

DROP SEQUENCE seq_ord_id;
CREATE SEQUENCE seq_ord_id
start with 1
increment by 1
minvalue 1
maxvalue 10000;

drop table "order" CASCADE CONSTRAINTS PURGE;
CREATE TABLE "order" (
    ord_id number (4,0) not null,
    cus_id number,
    com_id number,
    ord_num_units number(5,0) not null,
    ord_total_cost number (8,2) not null,
    ord_notes varchar2(255),
    CONSTRAINT pk_order PRIMARY KEY(ord_id),
    CONSTRAINT fk_order_customer
    FOREIGN KEY (cus_id)
    REFERENCES customer(cus_id),
    CONSTRAINT fk_order_commodity
    FOREIGN KEY (com_id)
    REFERENCES commodity(com_id),
    CONSTRAINT check_unit CHECK(ord_num_units > 0),
    CONSTRAINT check_total CHECK(ord_total_cost > 0)
);


INSERT INTO customer VALUES (seq_cus_id.nextval, 'Beverly', 'Davis', '123 Main St.', 'Detroit', 'MI', 48252, 3135551212, 'bdavis@aol.com', 11500.99, 'recently moved');
INSERT INTO customer VALUES (seq_cus_id.nextval, 'Stephen', 'Taylor', '456 Elm St.', 'St. Louis', 'MO', 57252, 4185551212, 'staylor@comcast.net', 25.01, NULL);
INSERT INTO customer VALUES (seq_cus_id.nextval, 'Donna', 'Carter', '789 Peach Ave.', 'Los Angeles', 'CA', 48252, 3135551212, 'dcarter@wow.com', 300.99, 'returning customer');
INSERT INTO customer VALUES (seq_cus_id.nextval, 'Robert', 'Silverman', '857 Wilbur Rd.', 'Phoenix', 'AZ', 25278, 4805551212, 'rsilverman@aol.com', NULL, NULL);
INSERT INTO customer VALUES (seq_cus_id.nextval, 'Sally', 'Victors', '534 Holler Way', 'Charleston', 'WV', 78345, 9045551212, 'svictors@wow.com', 500.76, 'new customer');
commit;

INSERT INTO commodity VALUES (seq_com_id.nextval, 'DVD & Player', 109.00, NULL);
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Cereal', 3.00, 'sugar free');
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Scrabble', 29.00, 'original');
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Licorice', 1.89, NULL);
INSERT INTO commodity VALUES (seq_com_id.nextval, 'Tums', 2.45, 'antacid');
commit;


INSERT INTO "order" VALUES (seq_ord_id.nextval, 1, 2, 50, 200, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 2, 3, 30, 100, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 1, 6, 654, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 5, 4, 24, 972, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 5, 7, 300, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 1, 2, 5, 15, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 2, 3, 40, 57, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 1, 4, 300, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 5, 4, 14, 770, NULL);
INSERT INTO "order" VALUES (seq_ord_id.nextval, 3, 5, 15, 883, NULL);
commit;

select * from customer;
select * from commodity;
select * from "order";