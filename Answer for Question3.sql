-- Question 3 Procedure to trigger the insertion process

create procedure dbo.spdata_migration
as
begin

insert into Supplier(supplier_name,Supplier_contactname,Supplier_address,Supplier_contactnumber1,
Supplier_contactnumber2,Supplier_email) 
Select distinct supplier_name, supp_contact_name, supp_address,
case when CHARINDEX(',', supp_contact_number) <> 0 then
SUBSTRING(supp_contact_number, 1, CHARINDEX(',', supp_contact_number) -1)
else supp_contact_number end ,
case when CHARINDEX(',', supp_contact_number) <> 0 then
SUBSTRING(supp_contact_number, CHARINDEX(',', supp_contact_number) +2, LEN(supp_contact_number))
else NULL end ,supp_email
from XXBCM_ORDER_MGT;


insert into Orders 
select order_ref, cast(supplier_reference as int), order_date, cast(order_total_amount as int), order_description, order_status
from XXBCM_ORDER_MGT OM inner join Supplier  S on OM.SUPPLIER_NAME = s.supplier_name
where order_total_amount is not null;


insert into Order_line
Select SUBSTRING(order_ref, 1, CHARINDEX('-', order_ref) -1),
SUBSTRING(order_ref, CHARINDEX('-', order_ref) +1, LEN(order_ref)), cast(Order_line_amount as int)
from XXBCM_ORDER_MGT where Order_line_amount is not null;



insert into Invoice 
Select invoice_reference, order_reference, order_line_reference, invoice_date, INVOICE_STATUS, INVOICE_HOLD_REASON,
INVOICE_AMOUNT, INVOICE_DESCRIPTION
from XXBCM_ORDER_MGT OM inner join Order_line  OL 
on SUBSTRING(OM.order_ref, 1, CHARINDEX('-', OM.order_ref) -1) = OL.order_reference 
and SUBSTRING(order_ref, CHARINDEX('-', order_ref) +1, LEN(order_ref)) = OL.order_line_reference
where INVOICE_AMOUNT is not null;

end
go

-- Procedure Execution
EXEC dbo.spdata_migration;
go
