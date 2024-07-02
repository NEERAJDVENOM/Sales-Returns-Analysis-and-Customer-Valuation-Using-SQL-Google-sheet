SELECT DB_NAME() AS CurrentDatabase;
use [Academia]


select * from sales;
select * from returns;
select OrderID,sum(returnsales) as total_returnsales from returns  group by orderid;

A) What % of sales result in a return?( In terms of No of sales )
	
with t1 as
(select s.CustomerID,s.TransactionDate,s.Sales,s.OrderID,r.total_returnsales from sales s left join
(select OrderID,sum(returnsales) as total_returnsales from returns  group by orderid) r
on s.OrderID=r.orderid 
) 
select format((select count(*) from t1 where total_returnsales is not null)*1.00/count(*),'0.00%') from t1;


--B) What % of returns are full returns?
with t1 as
(select s.CustomerID,s.TransactionDate,s.Sales,s.OrderID,r.total_returnsales from sales s left join
(select OrderID,sum(returnsales) as total_returnsales from returns  group by orderid) r
on s.OrderID=r.orderid where total_returnsales is not null
) 
select format((select count(*) from t1 where sales=total_returnsales)*1.00/count(*),'0.00%') from t1;


---C) What is the average return % amount (return % of original sale)?
--Note:::Considering only orders wich are returned

with t1 as
(select s.CustomerID,s.TransactionDate,s.Sales,s.OrderID,r.total_returnsales from sales s left join
(select OrderID,sum(returnsales) as total_returnsales from returns  group by orderid) r
on s.OrderID=r.orderid where total_returnsales is not null
) 

select format(AVG(total_returnsales)/AVG(sales),'0.00%') from t1



--D) What % of returns occur within 7 days of the original sale?
with t1 as
(select s.CustomerID,s.TransactionDate,s.Sales,s.OrderID, r.ReturnDate,r.ReturnSales, DATEDIFF(DAY, transactiondate,returndate) AS return_in_days  from sales s left join Returns r on s.OrderID=r.orderid
where DATEDIFF(DAY, transactiondate,returndate) 
is not null and r.ReturnSales>0 )


select format( cast((select count(*) from t1 where return_in_days<=7)*1.0 / count(*) as decimal(10,2)),'00.00%') from t1 ;


-- E) What is the average number of days for a return to occur?
with t1 as
(select s.CustomerID,s.TransactionDate,s.Sales,s.OrderID, r.ReturnDate,r.ReturnSales, DATEDIFF(DAY, transactiondate,returndate) AS return_in_days  from sales s left join Returns r on s.OrderID=r.orderid where DATEDIFF(DAY, transactiondate,returndate) 
is not null )

select AVG(return_in_days) from t1 where return_in_days>=0;

--F) Using this data set, how would you approach and answer the question, who is our most valuable customer?

select top(10) customerid, count(customerid) as purchase_frequency, sum(sales) Total_sales from sales group by 
CustomerID order by Total_sales desc,purchase_frequency desc;