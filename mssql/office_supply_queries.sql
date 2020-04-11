-- a5 sql solutions
-- 1) Create a stored procedure (product_days_of_week) listingthe product names, descriptions,and the day of the week in which they were sold, in ascending order of the day of week.
IF OBJECT_ID(N'dbo.product_days_of_week', N'P') IS NOT NULL
DROP PROC dbo.product_days_of_week;
go

CREATE PROC dbo.product_days_of_week as
BEGIN
 select pro_name, pro_descript, datename(dw, tim_day-1) 'day of week'
 from product p
 join sales s on p.pro_id=s.pro_id
 join time t on t.tim_id=s.tim_id
 order by tim_day-1 asc;
END
go

exec dbo.product_days_of_week;

-- 2) Create a stored procedure (product_drill_down) listingthe product name, quantity on hand, store name, city name, state name, and region name where each product was purchased, in descending order of quantity on hand.
IF OBJECT_ID(N'dbo.product_drill_down', N'P') IS NOT NULL
DROP PROC dbo.product_drill_down;
go

CREATE PROC dbo.product_drill_down as
BEGIN
 select pro_name, pro_qoh,
 FORMAT(pro_cost, 'C', 'en-us') as cost,
 FORMAT(pro_price, 'C', 'en-us') as price,
 str_name, cty_name, ste_name, reg_name
 from product p
 join sale s on p.pro_id=s.pro_id
 join store sr on sr.str_id=s.str_id
 join city c on sr.cty_id=c.cty_id
 join state st on c.ste_id=st_ste_id
 join region r on st.reg_id=r.reg_id
 order by pro_qoh desc;
END
go

exec dbo.product_drill_down;

-- 3) Create a stored procedure(add_payment)that adds a payment record. Use variables and pass suitable arguments.
IF OBJECT_ID(N'dbo.add_payment', N'P') IS NOT NULL
DROP PROC dbo.add_payment;
go

CREATE PROC dbo.add_payment
 @inv_id_p int,
 @pay_date_p datetime,
 @pay_amt_p decimal(7,2),
 @pay_notes_p varchar(255)
as
BEGIN
 insert into payment(inv_id, pay_date, pay_amt, pay_notes)
 values
 (@inv_id_p, @pay_date_p, @pay_amt_p, @pay_notes_p);
END
go

DECLARE
 @inv_id_v int = 6,
 @pay_date_v datetime = '2014-01-05 11:56:38',
 @pay_amt_v decimal(7,2) = 159.99,
 @pay_notes_v varchar(255) = 'testing add_payment';

exec dbo.add_payment @inv_id_v, @pay_date_v, @pay_amt_v, @pay_notes_v;

-- 4) Create a stored procedure (customer_balance) listing the customer’s id, name, invoice id, total paid on invoice, balance (derived attribute from the difference of a customer’s invoice total and theirrespective payments), pass customer’s last name as argument—which may return more than one value.
IF OBJECT_ID(N'dbo.customer_balance', N'P') IS NOT NULL
DROP PROC dbo.customer_balance;
go

CREATE PROC dbo.customer_balance
 @per_lname_p varchar(30)
as
BEGIN
 select p.per_id, per_fname, per_lname, i.inv_id, inv_total,
 FORMAT(sum(pay_amt), 'C', 'en-us') as total_paid,
 FORMAT((inv_total - sum(pay_amt)), 'C', 'en-us') as invoice_diff
 from person p
  join dbo.customer c on p.per_id=c.per_id
  join dbo.contact ct on c.per_id=ct.per_id
  join dbo.[order] o on ct.cnt_id=o.cnt_id
  join dbo.invoice i on o.ord_id=i.ord_id
  join dbo.payment pt on i.inv_id=pt.inv_id
 where per_lname = @per_lname_p
 group by p.per_id, i.inv_id, per_lname, per_fname, inv_total;
END
go

DECLARE @per_lname_v varchar(30) = 'smith';

exec dbo.customer_balance @per_lname_v;

-- 5) Create and display the results of a stored procedure (store_sales_between_dates) that lists each store's id, sum of total sales (formatted), and years for a given time period, by passing the start/end dates, group by years, and sort by totalsales then years, both in descending order.
IF OBJECT_ID(N'dbo.store_sales_between_dates', N'P') IS NOT NULL
DROP PROC dbo.store_sales_between_dates;
go

CREATE PROC dbo.store_sales_between_dates
 @start_date_p smallint,
 @end_date_p smallint
as
BEGIN
 select st.str_id, FORMAT(sum(sal_total), 'C', 'en-us') as 'total sales', tim_yr as year
 from store st
  join sale s on st.str_id=s.str_id
  join time t on s.tim_id=t.tim_id
  where tim_yr between @start_date_p and @end_date_p
  group by tim_yr, st.str_id
  order by sum(sal_total) desc, tim_yr desc;
END
go

DECLARE
@start_date_v smallint = 2010,
@end_date_v smallint = 2013;

exec dbo.store_sales_between_dates @start_date_v, @end_date_v;

-- 6) Create a trigger (trg_check_inv_paid) that updates an invoice record, after a payment has been made, indicating whether or not the invoice has been paid.
IF OBJECT_ID(N'dbo.trg_check_inv_paid', N'TR') IS NOT NULL
DROP TRIGGER dbo.trg_check_inv_paid
go

CREATE TRIGGER dbo.trg_check_inv_paid
ON dbo.payment
AFTER INSERT as
BEGIN
 update invoice
 set inv_paid=0;

 update invoice
 set inv_paid=1
 from invoice as i
  join (
      select inv_id, sum(pay_amt) as total_paid
      from payment
      group by inv_id
  ) as v on i.inv_id=v.inv_id
  where total_paid >= inv_total;
END
go

-- 7) Create a viewthat displays the sumof all paidinvoice totalsfor each customer, sort by the largest invoice total sum appearing first.
create view dbo.v_paid_invoice_total as
  select p.per_id, per_fname, per_lname, sum(inv_total) as sum_total, FORMAT(sum(inv_total), 'C', 'en-us') as paid_invoice_total 
  from dbo.person p
    join dbo.customer c on p.per_id=c.per_id 
    join dbo.contact ct on c.per_id=ct.per_cid
    join dbo.[order] o on ct.cnt_id=o.cnt_id
    join dbo.invoice i on o.ord_id=i.ord_id
  where inv_paid !=0
 -- must be contained in group by, if not used in aggregate function
  group by p.per_id, per_fname, per_lname
go

-- 8) Create a stored procedurethat displays all customers’outstanding balances(unstored derived attribute based uponthe difference of a customer's invoice total and their respective payments). List their invoice totals, what was paid, and the difference.
CREATE PROC dbo.sp_all_customers_outstanding_balances AS 
BEGIN
  select p.per_id, per_fname, per_lname, 
  sum(pay_amt) as total_paid, (inv_total - sum(pay_amt)) invoice_diff
    from person p
      join dbo.customer c on p.per_id=c.per_id 
      join dbo.contact ct on c.per_id=ct.per_cid
      join dbo.[order] o on ct.cnt_id=o.cnt_id
      join dbo.invoice i on o.ord_id=i.ord_id
      join dbo.payment pt on i.inv_id=pt.inv_id
     -- must be contained in group by, if not used in aggregate function
  group by p.per_id, per_fname, per_lname, inv_total
  order by invoice_diff desc;
END
GO
-- call stored procedure
exec dbo.sp_all_customers_outstanding_balances;

-- 9) Create a stored procedurethat populatesthe sales rep history table w/salesreps’data when called.
CREATE PROC dbo.sp_populate_srp_hist_table AS 
  INSERT INTO dbo.srp_hist 
  (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes) 
  -- mix dynamically generated data, with original sales reps' data
  SELECT per_id, 'i', getDate(), SYSTEM_USER, getDate(), srp_yr_sales_goal, srp_ytd_sales, srp_ytd_comm, srp_notes
  FROM dbo.slsrep;
GO
-- call stored procedure
exec dbo.sp_populate_srp_hist_table;

-- 10) Create a triggerthat automatically adds a record to the sales reps’ history table for every record addedto the sales rep table.
CREATE TRIGGER dbo.trg_sales_history_insert 
ON dbo.slsrep 
AFTER INSERT AS
BEGIN
  -- declare 
  DECLARE 
  @per_id_v smallint, 
  @sht_type_v char(1), 
  @sht_modified_v date, 
  @sht_modifier_v varchar(45), 
  @sht_date_v date, 
  @sht_yr_sales_goal_v decimal(8,2), 
  @sht_yr_total_sales_v decimal(8,2), 
  @sht_yr_total_comm_v decimal(7,2), 
  @sht_notes_v varchar(255);
  SELECT 
  @per_id_v = per_id, 
  @sht_type_v = 'i',
  @sht_modified_v = getDate(),
  @sht_modifier_v = SYSTEM_USER,
  @sht_date_v = getDate(),
  @sht_yr_sales_goal_v = srp_yr_sales_goal, 
  @sht_yr_total_sales_v = srp_ytd_sales, 
  @sht_yr_total_comm_v = srp_ytd_comm, 
  @sht_notes_v = srp_notes
  FROM INSERTED;
  INSERT INTO dbo.srp_hist 
  (per_id, sht_type, sht_modified, sht_modifier, sht_date, sht_yr_sales_goal, sht_yr_total_sales, sht_yr_total_comm, sht_notes) 
  VALUES
  (@per_id_v, @sht_type_v, @sht_modified_v, @sht_modifier_v, @sht_date_v, @sht_yr_sales_goal_v, @sht_yr_total_sales_v, @sht_yr_total_comm_v,@sht_notes_v);
END
GO

-- 11) Create a triggerthat automatically adds a record to the product history table for every record addedto the product table.
CREATE TRIGGER dbo.trg_product_history_insert 
ON dbo.product 
AFTER INSERT AS
BEGIN
    DECLARE 
      @pro_id_v smallint, 
      @pht_modified_v date, -- when recorded
      @pht_cost_v decimal(7,2), 
      @pht_price_v decimal(7,2), 
      @pht_discount_v decimal(3,0), 
      @pht_notes_v varchar(255);
      SELECT 
      @pro_id_v = pro_id, 
      @pht_modified_v = getDate(),
      @pht_cost_v = pro_cost, 
      @pht_price_v = pro_price, 
      @pht_discount_v = pro_discount, 
      @pht_notes_v = pro_notes
      FROM INSERTED;
      INSERT INTO dbo.product_hist 
      (pro_id, pht_date, pht_cost, pht_price, pht_discount, pht_notes) 
      VALUES
      (@pro_id_v, @pht_modified_v, @pht_cost_v, @pht_price_v, @pht_discount_v,@pht_notes_v);
END
GO

-- Extra Credit: Create a stored procedurethat updates sales reps’ yearly_sales_goal in the slsreptable, based upon 8% more than their previous year’s total sales(sht_yr_total_sales), name it sp_annual_salesrep_sales_goal.
CREATE PROC dbo.sp_annual_salesrep_sales_goal AS 
BEGIN
  -- update is based solely upon 8% of each sales rep's previous year's individual total sales
  UPDATE slsrep
  SET srp_yr_sales_goal = sht_yr_total_sales * 1.08
  from slsrep as sr
    JOIN srp_hist as sh
    ON sr.per_id = sh.per_id
  where sh.sht_date='2014-01-01';
END
GO
-- call stored procedure
exec dbo.sp_annual_salesrep_sales_goal;

-- Extra Credit: Create anddisplay the results of a stored procedure (order_line_total) that calculates the total price for each order line, based upon the product price times quantity, which yields a subtotal (oln_price), totalcolumnincludes6% sales tax. Query result set shoulddisplay order line id, product id, name, description, price, order line quantity,subtotal(oln_price), and totalwith 6% sales tax.Sort by product ID.
IF OBJECT_ID(N'dbo.order_line_total', N'P') IS NOT NULL
DROP PROC dbo.order_line_total;
go

CREATE PROC dbo.order_line_total as
BEGIN
 select oln_id, p.pro_id, pro_name, pro_descript,
 FORMAT(pro_price, 'C', 'en-us') as pro_price,
 oln_qty,
 FORMAT((oln_qty * pro_price), 'C', 'en-us') as oln_price,
 FORMAT((oln_qty * pro_price) * 1.06, 'C', 'en-us') as total_with_6pct_tax
 from product p
 join order_line ol on p.pro_id=ol.pro_id
 order by p.pro_id;
END
go

exec dbo.order_line_total;