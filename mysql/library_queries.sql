-- Library Database

-- i. List the members' first and last names, book ISBNs and titles, loan and due dates, and authors' first and last names sorted in descending order of due dates.
-- old style
select mem_fname, mem_lname, b.bok_isbn, bok_title, lon_loan_date, lon_due_date, aut_fname, aut_lname
from member m, loaner l, book b, attribution at, author a
where m.mem_id=l.mem_id
 and l.bok_isbn=b.bok_isbn
 and b.bok_isbn=at.bok_isbn
 and at.aut_id=a.aut_id
order by lon_due_date desc;
-- join on
select mem_fname, mem_lname, b.bok_isbn, bok_title, lon_loan_date, lon_due_date, aut_fname, aut_lname
from member m
 join loaner l on m.mem_id=l.mem_id
 join book b on l.bok_isbn=b.bok_isbn
 join attribution at on b.bok_isbn=at.bok_isbn
 join author a on at.aut_id=a.aut_id
order by lon_due_date desc;
-- join using
select mem_fname, mem_lname, b.bok_isbn, bok_title, lon_loan_date, lon_due_date, aut_fname, aut_lname
from member
 join loaner using (mem_id)
 join book using (bok_isbn)
 join attribution using (bok_isbn)
 join author using (aut_id)
order by lon_due_date desc;
-- natural join
select mem_fname, mem_lname, b.bok_isbn, bok_title, lon_loan_date, lon_due_date, aut_fname, aut_lname
from member
 natural join loaner
 natural join book
 natural join attribution
 natural join author
order by lon_due_date desc;

-- ii. List an unstored derived attribute called "book sale price," that displays the current price, which is marked down 15% from the original book price (format the number to two decimal places, and include a dollar sign).
-- Step #1: calculate 15% discount and format to two decimal places
select bok_price, bok_price * .85, format(bok_price * .85,2)
from book;
-- Step #2: add dollar sign, and alias
select concat('$',format(bok_price * .85,2)) as book_sale_price
from book;
-- or
select concat('$',format(bok_price * .85,2)) as 'book sale price'
from book;
-- or 
select concat('$',format(bok_price * .85,2)) as "book sale price"
from book;

-- iii. Create a stored derived attribute based upon the calculation above for the second book in the book table, and place the results in member #3's notes attribute.
select * from member;
-- Step #1: test book 2
select bok_price, bok_price * .85
from book
where bok_isbn='1234567891235';
-- Step #2: test concat
select concat('Purchased book at discounted price: ','$',format(bok_price * .85,2))
from book
where bok_isbn='1234567891235';
-- Step #3: check data
select * from member;
-- actual answer
update member
set mem_notes =
 (
     select concat('Purchased book at discounted price: ','$',format(bok_price *.85,2))
     from book
     where bok_isbn='1234567891235';
 )
where mem_id = 3;

select * from member;

-- iv. Using only SQL, add  a test table inside of your database with the following attribute definitions (use prefix tst_for each attribute), all should be not null except email, and notes:id pk int unsigned AUTO INCREMENT,fname varchar(15),lname varchar(30),street varchar(30),city varchar(20),state char(2),zip int unsigned,phone bigintunsigned COMMENT 'otherwise, cannot make contact',email varchar(45) DEFAULT NULL,notes varchar(255) DEFAULT NULL,ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci
show tables;

drop table if exists test;
CREATE TABLE if not exists test
(
    tst_id int unsigned NOT NULL AUTO_INCREMENT,
    tst_fname varchar(15) NOT NULL,
    tst_lname varchar(30) NOT NULL,
    tst_street varchar(30) NOT NULL,
    tst_city varchar(30) NOT NULL,
    tst_state char(2) NOT NULL DEFAULT 'FL',
    tst_zip int unsigned NOT NULL,
    tst_phone bigint unsigned NOT NULL COMMENT 'otherwise, cannot make contact',
    tst_email varchar(100) DEFAULT NULL,
    tst_notes varchar(255) DEFAULT NULL,
    PRIMARY KEY (tst_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_general_ci; -- not always necessary

show tables;

-- v. Insert data into test table from member table.
select * from test;

INSERT INTO test
(tst_id, tst_fname, tst_lname, tst_street, tst_city, tst_state, tst_zip, tst_phone, tst_email, tst_notes)
  SELECT mem_id, mem_fname, mem_lname, mem_street, mem_city, mem_state, mem_zip, mem_phone, mem_email, mem_notes
  FROM member;

select * from test;

-- vi. Alter the last name attribute in test table to the following options: tst_last varchar(35) not null, default 'Doe' and comment "testing".
describe test;

ALTER TABLE test change tst_lname tst_last varchar(35) not null DEFAULT 'Doe' COMMENT 'testing';

describe test;

-- to see comment 
show create table test;
-- or
show full columns from test;