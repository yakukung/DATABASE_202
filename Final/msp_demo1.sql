-- 1. msp_demo1 (@year, @shop_name)
-- แสดง รหัสออเดอร์ รหัสลูกค้า ชื่อลูกค้า วันที่ซื้อ ยอดการซื้อของออเดอร์นั้น และ ชื่อร้ํานค้ํา
-- โดยแสดงเฉพําะออเดอร์ในปี @year จากร้านชื่อ @shop_name
CREATE PROCEDURE msp_demo1
    @year VARCHAR(4),
    @shop_name VARCHAR(20)
AS
BEGIN
    SELECT orders.oid, customer.cid, customer.name, odate, final_price
    FROM orders, shop, customer
    WHERE orders.shopid = shop.sid
    AND orders.cusid = customer.cid
    AND YEAR(odate) = @year
    AND shop.name = @shop_name
END

exec msp_demo1 '2024', 'wDrink';

DROP PROCEDURE IF EXISTS msp_demo1