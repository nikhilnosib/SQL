create procedure dbo.spGetThirdHighestOrderTotalAmount
as
begin
	select distinct CAST(RIGHT(o.order_reference, 3) AS INT) as Order_Reference,
	FORMAT(o.order_date,'MMMM dd, yyyy') as Order_Date,UPPER(s.supplier_name) as Supplier_Name,FORMAT(o.Order_totalamount,'0,0.00') as Order_Amount ,o.Order_status,
	I1.Invoice_reference from Orders o
	join Supplier s
	on o.supplier_reference=s.supplier_reference
	join Invoice i
	on i.order_reference=o.order_reference
	join
	(select order_reference,Invoice_reference=STRING_AGG(Invoice_reference,',')  from Invoice group by order_reference) as I1
	on o.order_reference=I1.order_reference
	where o.Order_totalamount in (
	select TOP 1 Order_totalamount FROM (select TOP 3 Order_totalamount from Orders order by Order_totalamount desc) as Order_Total_Amount order by Order_totalamount asc)
end
go

-- Procedure Execution
EXEC dbo.spGetThirdHighestOrderTotalAmount;
go
