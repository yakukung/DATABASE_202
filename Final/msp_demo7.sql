
-- 7.msp_demo7 (@year, @shop_name)
-- เพื่อแสดงรหัสการขาย รหัสร้านค้า จำนวนวันที่ใช้ในการจัดการการขาย ปีที่ทำการขาย และ ชื่อร้าน
-- ของปี @year จํากร้ํานชื่อ @shop_name โดยเรียงลำดับตามจำนวนวันที่ใช้จัดการการขาย จากมากไปน้อย
-- ถ้า @shop_name เป็น null ให้แสดงข้อมูลจํากทุกร้าน โดยเรียงลำดับตามชื่อร้าน และ จำนวนวันจากมากไปน้อย

CREATE PROCEDURE msp_demo7(
    @year VARCHAR(4),
    @shop_name VARCHAR(10)
)
AS
BEGIN
    -- ถ้า @shop_name เป็น NULL ให้แสดงข้อมูลจากทุกร้าน
    IF (@shop_name IS NULL
        SELECT 
            orders.oid, 
            orders.shopid, 
            DATEDIFF(DAY, orders.odate, orders.fdate) AS จำนวนวัน,
            YEAR(orders.odate) as year,
            shop.name
        FROM orders,shop
        WHERE orders.shopid = shop.sid
        AND YEAR(orders.odate) = @year
        ORDER BY shop.name ASC, จำนวนวัน DESC;
    ELSE
        -- ถ้า @shop_name ไม่เป็น NULL ให้แสดงข้อมูลเฉพาะร้านนั้น
        SELECT 
            orders.oid, 
            orders.shopid, 
            DATEDIFF(DAY, orders.odate, orders.fdate) AS จำนวนวัน,
            YEAR(orders.odate) as year,
            shop.name
       FROM orders,shop
        WHERE orders.shopid = shop.sid
        AND YEAR(orders.odate) = @year
        AND shop.name = @shop_name
        ORDER BY  shop.name ASC, จำนวนวัน DESC;
END;

-- แสดงข้อมูลของร้าน wDrink
exec msp_demo7 '2024', 'wDrink'

--แสดงข้อมูลของทุกร้าน
exec msp_demo7 '2024', null


DROP PROCEDURE IF EXISTS msp_demo7