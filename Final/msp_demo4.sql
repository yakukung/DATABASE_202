-- 4.msp_demo4 (@year, @seller_name)
-- เพื่อแสดงรหัสร้านค้า ชื่อร้านค้า ปี และ ยอดรวมการขายในปี@year ร้านที่เป็นของผู้ขายชื่อ @seller_name
-- *หมํายเหตุ* ต้องสร้าง view demo_view4(shopid, year , total_sell) ก่อน
-- การแสดงข้อมูลใน procedure ต้องมีการ join: shop, seller, demo_view4

create view demo_view4(shopid, year, total_sell)
as
    select shopid,
    year(odate) as year,
    sum(final_price)
    from orders
    group by shopid, year(odate)

GO

create procedure msp_demo4
@year varchar(4),
@seller_name varchar(4)
as
begin
    select shop.sid, seller.name, year, total_sell
    from shop, seller, demo_view4
    where shop.sid = demo_view4.shopid
    and year = @year
    and  seller.name = @seller_name
end


exec msp_demo4 '2023', 'uBuy'


DROP PROCEDURE IF EXISTS msp_demo4
DROP VIEW IF EXISTS demo_view4