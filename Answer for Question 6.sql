Create procedure dbo.spGetSupplierWithTotalOrders
as
begin
	select S.supplier_name,
	S.Supplier_contactname,
	Case
		WHEN LEN(Supplier_contactnumber1)>1 THEN concat(substring(Supplier_contactnumber1,1,len(Supplier_contactnumber1)-4),
		'-',substring(Supplier_contactnumber1,len(Supplier_contactnumber1)-3,4))
		ELSE 'NULL'
	END AS Supplier_Contact_No_1,
	Case
		WHEN LEN(Supplier_contactnumber2)>1 THEN concat(substring(Supplier_contactnumber2,1,len(Supplier_contactnumber2)-4),
		'-',substring(Supplier_contactnumber2,len(Supplier_contactnumber2)-3,4))
		ELSE 'NULL'
	END AS Supplier_Contact_No_1,
	count( O.order_reference) as Total_Orders,
    FORMAT(sum( O.Order_totalamount),'0,0.00') as Order_Total_Amount
	from Supplier S
	join Orders O
	on O.supplier_reference=S.supplier_reference
	where o.order_date between '2017-01-01' and '2017-08-31'
	group by S.supplier_name,S.Supplier_contactname,S.Supplier_contactnumber1,S.Supplier_contactnumber2
end
go

-- Procedure Execution
EXEC dbo.spGetSupplierWithTotalOrders;
go