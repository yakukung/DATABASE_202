-- 5.msp_demo5 (@year)
-- เพื่อเพิ่มแต้มสะสมให้ลูกค้า ที่มียอดการซื้อทั้งหมดในปี @year ตามเงื่อนไขต่อไปนี้
-- - ถ้ายอดซื้อมากกว่า 50000 เพิ่มแต้มสะสมให้ 500 แต้ม
-- - ถ้ายอดซื้อมากกว่า 20000 เพิ่มแต้มสะสมให้ 100 แต้ม
-- - ถ้ายอดซื้อมากกว่า 5000 เพิ่มแต้มสะสมให้ 20 แต้ม
-- *หมายเหตุ* ใช้ view demo_view3 ช่วยในการทำงาน
CREATE PROCEDURE msp_demo5
    @year VARCHAR(4)
AS
BEGIN
    UPDATE c
    SET c.point = c.point + 
        CASE
            WHEN d.total_buy > 50000 THEN 500
            WHEN d.total_buy > 20000 THEN 100
            WHEN d.total_buy > 5000 THEN 20
            ELSE 0
        END
    FROM customer c, demo_view3 d
    WHERE c.cid = d.cusid
    AND d.year = @year;
END;


select * from demo_view3 where year = 2024
select * from customer
exec msp_demo5 '2024'

   
   DROP PROCEDURE IF EXISTS msp_demo5

