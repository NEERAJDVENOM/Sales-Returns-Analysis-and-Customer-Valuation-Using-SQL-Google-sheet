# SQL Solutions

## Sales Data Analysis
Refer to this link for google sheet solution:

This repository contains SQL solutions for various sales data analysis queries.
https://docs.google.com/spreadsheets/d/1LsmG74YnCGnqMzi0MXS5bb-1T505fkpubbdsRDMtIhY/edit?gid=1221437970#gid=1221437970

### Questions and Solutions

**A) What % of sales result in a return? (In terms of No of sales)**

```sql
with t1 as
(select s.CustomerIDs, s.TransactionDates, s.Saless, s.OrderIDr, total_returnsales 
from sales s 
left join
(select OrderID, sum(returnsales) as total_returnsales from returns group by orderid) r
on s.OrderID = r.orderid) 
select format((select count(*) from t1 where total_returnsales is not null) * 1.00 / count(*), '0.00%') from t1; 
Answer: 4.23%


B) What % of returns are full returns?

with t1 as
(select s.CustomerIDs, s.TransactionDates, s.Saless, s.OrderIDr, total_returnsales 
from sales s 
left join
(select OrderID, sum(returnsales) as total_returnsales from returns group by orderid) r
on s.OrderID = r.orderid 
where total_returnsales is not null) 
select format((select count(*) from t1 where sales = total_returnsales) * 1.00 / count(*), '0.00%') from t1;
Answer: 20.10% of the returns are full returns.

C) What is the average return % amount (return % of original sale)?

with t1 as
(select s.CustomerIDs, s.TransactionDates, s.Saless, s.OrderIDr, total_returnsales 
from sales s 
left join
(select OrderID, sum(returnsales) as total_returnsales from returns group by orderid) r
on s.OrderID = r.orderid 
where total_returnsales is not null) 
select format(AVG(total_returnsales) / AVG(sales), '0.00%') from t1;
Answer: 41.34%

D) What % of returns occur within 7 days of the original sale?

with t1 as
(select s.CustomerIDs, s.TransactionDates, s.Saless, s.OrderID, r.ReturnDate, r.ReturnSales, DATEDIFF(DAY, transactiondate, returndate) AS return_in_days  
from sales s 
left join Returns r 
on s.OrderID = r.orderid
where DATEDIFF(DAY, transactiondate, returndate) is not null and r.ReturnSales > 0) 
select format(cast((select count(*) from t1 where return_in_days <= 7) * 1.0 / count(*) as decimal(10, 2)), '00.00%') from t1;
Answer: 40%

E) What is the average number of days for a return to occur?
with t1 as
(select s.CustomerIDs, s.TransactionDates, s.Saless, s.OrderID, r.ReturnDate, r.ReturnSales, DATEDIFF(DAY, transactiondate, returndate) AS return_in_days  
from sales s 
left join Returns r 
on s.OrderID = r.orderid 
where DATEDIFF(DAY, transactiondate, returndate) is not null) 
select AVG(return_in_days) from t1 where return_in_days >= 0;
Answer: Average return days for any order_id if it is returned is 78 days.

F) Using this data set, how would you approach and answer the question of who is our most valuable customer?

Answer: Customer with customer_ID RIVES87271 has the maximum sales amount and customer RACG3 shops more frequently, hence these 2 customers are very important in terms of retention value.


 


 
