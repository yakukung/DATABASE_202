-- 3.msp_demo3(@year)
-- เพื่อแสดงรหัสลูกค้า ชื่อลูกค้า ปี ยอดรวมแต้มสะสมที่ใช้ในปี@year และ ยอดรวมการซื้อในปี@year
-- *หมํายเหตุ* ต้องสร้าง view demo_view3(cusid, year, total_discount, total_buy) ก่อน
-- การแสดงข้อมูลใน procedure ต้องมีการ join: customer, demo_view2


create view demo_view3(cusid, year, total_discount, total_buy)
as
    select cusid,
    year(odate) as year,
    sum(discount_point) as total_discount,
    sum(final_price) as total_buy
    from orders
    group by cusid, year(odate);

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



    DROP VIEW IF EXISTS demo_view3
      DROP PROCEDURE IF EXISTS msp_demo3