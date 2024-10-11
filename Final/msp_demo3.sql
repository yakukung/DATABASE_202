-- 3.msp_demo3(@year)
-- เพื่อแสดงรหัสลูกค้า ชื่อลูกค้า ปี ยอดรวมแต้มสะสมที่ใช้ในปี@year และ ยอดรวมการซื้อในปี@year
-- *หมํายเหตุ* ต้องสร้าง view demo_view3(cusid, year, total_discount, total_buy) ก่อน
-- การแสดงข้อมูลใน procedure ต้องมีการ join: customer, demo_view2


create view demo_view3(cusid, year, total_discount, total_buy)
as
    select orders.cusid,
    year(orders.odate) as year,
    sum(orders.discount_point) as total_discount,
    sum(orders.final_price) as total_buy
    from orders
    group by orders.cusid, year(orders.odate);

GO

create procedure msp_demo3
@year varchar(4)
as
begin
    select cid, name, year, total_discount, total_buy
    from customer, demo_view3
    where customer.cid = demo_view3.cusid
    and year = @year
end
--------------------------------
exec msp_demo3 2024