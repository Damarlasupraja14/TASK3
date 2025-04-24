use employee;
select * from oltp;
-- Retrieve all transactions where the Shipping_state is 'NY' (or any other state of your choice).
SELECT * from oltp where Shipping_State="Delaware";

-- Retrieve all transactions that occurred between 10:00 AM and 2:00 PM on any day in your dataset.
SELECT * from oltp where TIME(Timestamp) between  '10:00:00' and '2:00:00';

-- retrieve all transactions that occurred on a specific day (e.g., '2024-01-01').
SELECT * from oltp where DATE(Timestamp)='2016-12-13';

--  List all transactions sorted by the Timestamp in descending order (most recent first)
select * from oltp order by Timestamp desc;

-- Create a query that concatenates the Name and Surname fields to display the customer’s full name along with the TransactioID and Timestamp
Select TransactionID,Timestamp, CONCAT(Name," ",Surname) from oltp;

--  Retrieve all transactions where the Description contains the word "discount".
Select * from oltp where Description like '%Set%';

-- Write a query that calculates the final price for each transaction after applying the discount.
Select TransactionID,Timestamp,Retail_Price, Loyalty_Discount,Retail_Price*(1-Loyalty_Discount) as final_price from oltp;

-- Retrieve transactions where a loyalty discount was actually applied
Select * from oltp where Loyalty_Discount>0;

-- For each customer (CustomerID), count the number of transactions they made.
Select Name,CustomerID,Count(*) as No_of_Transactions from oltp group by CustomerID,Name;

-- Calculate the total retail price (i.e., sum of retail_price) spent by each customer.
Select CustomerID, SUM(Retail_Price) as Total_spent from oltp group by CustomerID;

-- compute the total amount spent after applying the loyalty discount
Select CustomerID,Retail_Price,Loyalty_Discount,SUM(Retail_Price*(1-Loyalty_Discount)) as Tot_Spent from oltp group by CustomerID,Retail_Price,Loyalty_Discount;

-- Group the transactions by day (ignoring the time part) and count the number of transactions per day.
Select DATE(Timestamp) as Transc_Date ,count(*) as Transaction_count from oltp group by DATE(Timestamp);

-- For a given day (e.g., '2024-01-01'), group the transactions by hour and count how many transactions occurred in each hour.
Select DATE(Timestamp),HOUR(Timestamp) as Transaction_hour,count(*) as Count_ofTrans_perhour from oltp where DATE(Timestamp)='2016-12-12' group by Hour(Timestamp),DATE(Timestamp);

-- Retrieve all transactions that occurred between 10:00 AM and 2:00 PM, regardless of the day.
Select * from oltp where TIME(Timestamp) between '10:00:00' and '14:00:00';

-- List the transactions where the final price (after applying the loyalty discount) exceeds $100.
Select TransactionID,Retail_Price,Loyalty_Discount,Retail_Price*(1-Loyalty_Discount) as Final_Price from oltp where Retail_Price*(1-Loyalty_Discount)>100;

-- Find the customers who made more than 5 transactions over the 4-day period.
select CustomerID,Count(*) as Trans_Count from oltp group by CustomerID Having Count(*)>5;

-- Calculate the average retail price of transactions for each Shipping_state.
Select Shipping_State,Avg(Retail_Price) as avg_retail from oltp group by Shipping_State;

-- Determine which Item appears most frequently in the transactions.
Select Description,Item ,count(*) as count_item from oltp group by Item,Description order by count_item desc limit 1;

-- For a given customer (e.g., CustomerID = 12345), retrieve all transactions ordered by the Timestamp to show the sequence of their purchases.
Select * from oltp where Name="Harry" order by Timestamp; 

-- identify duplicates --
select CustomerID,count(*) as dup_count from oltp group by CustomerID having count(*)>1;
with CTE as (
    select CustomerID, row_number() over(partition by CustomerID order by CustomerID) as Row_num
    From oltp
)
Delete from oltp
where CustomerID in(select CustomerID from CTE where Row_num > 1);
