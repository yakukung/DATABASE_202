-- 8. msp_demo8 (@year, @shopid)
-- เพื่อแสดงยอดขายรายเดือน ในแต่ละเดือน ของร้านค้ารหัส @shopid ในปี @year

CREATE PROCEDURE msp_demo8(
    @year VARCHAR(4),
    @shopid VARCHAR(4)
)
AS
BEGIN
    SELECT 
        MONTH(orders.odate) AS month,
        YEAR(orders.odate) AS year,
        SUM(orders.final_price) AS ยอดขายรวม
    FROM orders
    WHERE YEAR(orders.odate) = @year
    AND orders.shopid = @shopid
    GROUP BY 
        MONTH(orders.odate), 
        YEAR(orders.odate)
    ORDER BY 
        month;
END;


exec msp_demo8 '2024', 's05'; 



select * from orders
DROP PROCEDURE IF EXISTS msp_demo8