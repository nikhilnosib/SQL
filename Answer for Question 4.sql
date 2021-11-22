create procedure dbo.spGetSummaryOfOrders 
as
begin
select distinct CAST(RIGHT(o.order_reference, 3) AS INT) as Order_Reference, UPPER(FORMAT(o.order_date,'MMM-yy')) as OrderPeriod, 
	UPPER(LEFT(s.supplier_name,1))+LOWER(SUBSTRING(s.supplier_name,2,LEN(s.supplier_name))) as Supplier_Name, 
	FORMAT(o.Order_totalamount,'0,0.00') as Order_Total_Amount,o.Order_status, LEFT(i.Invoice_reference,9) as Invoice_Reference,
	FORMAT(T1.TotAmount,'0,0.00') as InvoiceTotalAmount,
	CASE 
			WHEN o.Order_totalamount =T1.TotAmount THEN 'OK'
			WHEN o.Order_totalamount > T1.TotAmount THEN 'To follow up'
			ELSE 'To verify'
	END AS Action 
	from Orders o
	join Supplier s
	on o.supplier_reference=s.supplier_reference
	join Invoice i
	on i.order_reference=o.order_reference 
	join 
	(Select  order_reference,
	sum(Invoice_amount) as TotAmount from Invoice group by order_reference) as T1
	on o.order_reference = T1.order_reference
	order by OrderPeriod desc
	
end
go

-- Procedure Execution
EXEC dbo.spGetSummaryOfOrders;
go
