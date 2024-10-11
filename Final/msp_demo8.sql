-- 8. msp_demo8 (@year, @shopid)
-- เพื่อแสดงยอดขายรายเดือน ในแต่ละเดือน ของร้านค้ารหัส @shopid ในปี @year

CREATE PROCEDURE msp_demo8(
    @year VARCHAR(4),
    @shopid VARCHAR(4)
)
AS
BEGIN
    SELECT 
        MONTH(odate) AS month,
        YEAR(odate) AS year,
        SUM(final_price) AS ยอดขายรวม
    FROM orders
    WHERE YEAR(odate) = @year
    AND shopid = @shopid
    GROUP BY MONTH(odate), YEAR(odate)
    ORDER BY month;
END;


exec msp_demo8 '2024', 's03'; 



select * from orders
DROP PROCEDURE IF EXISTS msp_demo8