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
    DECLARE @results TABLE (
        cusid VARCHAR(10),
        year INT,
        total_buy INT,
        points_added INT
    );
    INSERT INTO @results (cusid, year, total_buy, points_added)
    SELECT cusid, year, total_buy,
        CASE
            WHEN total_buy > 50000 THEN 500
            WHEN total_buy > 20000 THEN 100
            WHEN total_buy > 5000 THEN 20
            ELSE 0
        END AS points_added
    FROM demo_view3
    WHERE year = @year;
    
    UPDATE c
    SET c.point = c.point + r.points_added
    FROM customer c, @results r
    where c.cid = r.cusid;
END


select * from demo_view3 where year = 2024
select * from customer
exec msp_demo5 '2024'