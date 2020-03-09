-- Display Oracle version:
SELECT * FROM PRODUCT_COMPONENT_VERSION; 
SELECT * FROM V$VERSION; 

-- Display current user:
select user from dual; 

-- Display current day/time (formatted, and displaying AM/PM):
SELECT TO_CHAR
(SYSDATE, 'MM-DD-YYYY HH12:MI:SS AM') "NOW"
FROM DUAL;

-- Display your privileges:
SELECT * FROM USER_SYS_PRIVS; 

-- Display all user tables.
SELECT OBJECT_NAME
FROM USER_OBJECTS
WHERE OBJECT_TYPE = 'TABLE';

-- Display structure for each table:
describe customer;
describe commodity;
describe "order";

-- List the customer number, last name, first name, and e-mail of every customer.
select cus_id, cus_lname, cus_fname, cus_email
from customer;

-- Same query as above, include street, city, state, and sort by state in descending order, and last name in ascending order.
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_email
from customer
order by cus_state desc, cus_lname;

-- What is the full name of customer number 3? Display last name first.
select cus_lname, cus_fname
from customer
where cus_id = 3;

-- Find the customer number, last name, first name, and current balance for every customer whose balance exceeds $1,000, sorted by largest to smallest balances.
select cus_id, cus_lname, cus_fname, cus_balance
from customer
where cus_balance > 1000
order by cus_balance desc;

-- List the name of every commodity, and its price (formatted to two decimal places, displaying $ sign), sorted by smallest to largest price.
select com_name, to_char(com_price, 'L99,999.99') as price_formatted
from commodity
order by com_price;

-- Display all customers’ first and last names, streets, cities, states, and zip codes as follows (ordered by zip code descending).
select (cus_lname || ', ' || cus_fname) as name,
(cus_street || ', ' || cus_city || ', ' || cus_state || ' ' || cus_zip) as address
from customer
order by cus_zip desc;

-- List all orders not including cereal--use subquery to find commodity id for cereal.
select * from "order"
where com_id not in (select com_id from commodity where lower(com_name)='cereal');

-- List the customer number, last name, first name, and balance for every customer whose balance is between $500 and $1,000, (format currency to two decimal places, displaying $ sign).
select cus_id, cus_lname, cus_fname, to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance between 500 and 1000;

-- List the customer number, last name, first name, and balance for every customer whose balance is greater than the average balance, (format currency to two decimal places, displaying $ sign).
select cus_id, cus_lname, cus_fname, to_char(cus_balance, 'L99,999.99') as balance_formatted
from customer
where cus_balance >
(select avg(cus_balance) from customer);

-- List the customer number, name, and *total* order amount for each customer sorted in descending *total* order amount, (format currency to two decimal places, displaying $ sign), and include an alias “total orders” for the derived attribute:
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
group by cus_id, cus_lname, cus_fname
order by sum(ord_total_cost) desc;

-- List the customer number, last name, first name, and complete address of every customer who lives on a street with "Peach" anywhere in the street name.
select cus_id, cus_lname, cus_fname, cus_street, cus_city, cus_state, cus_zip
from customer
where cus_street like '%Peach%';

-- List the customer number, name, and *total* order amount for each customer whose *total* order amount is greater than $1500, for each customer sorted in descending *total* order amount, (format currency to two decimal places, displaying $ sign), and include an alias “total orders” for the derived attribute.
select cus_id, cus_lname, cus_fname, to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
group by cus_id, cus_lname, cus_fname
having sum(ord_total_cost) > 1500
order by sum(ord_total_cost) desc;

-- List the customer number, name, and number of units ordered for orders with 30, 40, or 50 units ordered.
select cus_id, cus_lname, cus_fname, ord_num_units
from customer
natural join "order"
where ord_num_units IN (30, 40, 50);

-- Using EXISTS operator: List customer number, name, number of orders, minimum, maximum, and sum of their order total cost, only if there are 5 or more customers in the customer table, (format currency to two decimal places, displaying $ sign).
select cus_id, cus_lname, cus_fname, count(*) as "number of orders", to_char(min(ord_total_cost), 'L99,999.99') as "minimum order cost", to_char(max(ord_total_cost), 'L99,999.99') as "maximum order cost", to_char(sum(ord_total_cost), 'L99,999.99') as "total orders"
from customer
natural join "order"
where exists
(select count(*) from customer having COUNT(*) >= 5)
group by cus_id, cus_lname, cus_fname;

-- Find aggregate values for customers: (Note, difference between count(*) and count(cus_balance), one customer does not have a balance.)
select count(*), count(cus_balance), sum(cus_balance), avg(cus_balance), max(cus_balance), min(cus_balance) from customer;

-- Find the number of unique customers who have orders.
select distinct count(distinct cus_id) from "order";

-- List the customer number, name, commodity name, order number, and order amount for each customer order, sorted in descending order amount, (format currency to two decimal places, displaying $ sign), and include an alias “order amount” for the derived attribute.
select cu.cus_id, cus_lname, cus_fname, com_name, ord_id, to_char(ord_total_cost, 'L99,999.99') as "order amount"
from customer cu
join "order" o on o.cus_id=cu.cus_id
join commodity co on co.com_id=o.com_id
order by ord_total_cost desc;

-- Modify prices for DVD players to $99.
SET DEFINE OFF
UPDATE commodity SET com_price = 99 WHERE com_name = 'DVD & Player';