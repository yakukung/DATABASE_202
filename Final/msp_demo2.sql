-- 2.msp_demo2(@year, @shop_name) (คล้ายข้อ 1. แต่มีการเพิ่มเงื่อนไข)
-- แสดง รหัสออเดอร์ รหัสลูกค้า ชื่อลูกค้า วันที่ซื้อ ยอดการซื้อของออเดอร์นั้น และ ชื่อร้ํานค้ํา
-- โดยแสดงเฉพําะออเดอร์ในปี @year จากร้านชื่อ @shop_name
-- ถ้ําปี@year ที่ส่งมําเป็น null ให้แสดงข้อมูลออเดอร์ของทุกปี
create procedure msp_demo2
    @year varchar(4),
    @shop_name varchar(100)
as
begin
    if(@year is null) -- แสดงข้อมูลทุกปี ดงัน้นั ไม่ตอ้งใส่เงื่อนไข @year
        select orders.oid, customer.cid, customer.name, odate, final_price, shop.name
        from orders, shop, customer
        where orders.shopid = shop.sid
        and orders.cusid = customer.cid
        and shop.name = @shop_name
    else -- แสดงข้อมูลทุกปี
        select orders.oid, customer.cid, customer.name, odate, final_price, shop.name
        from orders, shop, customer
        where orders.shopid = shop.sid
        and orders.cusid = customer.cid
        and year(odate) = @year
        and shop.name = @shop_name
end

exec msp_demo2 null, 'wDrink';
