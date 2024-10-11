-- 6.msp_demo6 (@year, @amount, @percent)
-- เพื่อลดราคาสินค้า ที่ในปี @year ขายได้น้อยกว่า @amount ชิ้น โดยลดราคาลง @percent %
CREATE PROCEDURE msp_demo6(
    @year VARCHAR(4),
    @amount INT,
    @percent INT
)
AS
BEGIN
    -- ลดราคาสินค้าในปีที่ขายได้น้อยกว่า @amount ชิ้น โดยลดราคาลง @percent
    UPDATE product
    SET product.price = product.price * (1 - (@percent / 100.00))
    WHERE product.pid IN (
        SELECT product.pid
        FROM product, order_detail, orders
        WHERE product.pid = order_detail.pid
        AND orders.oid = order_detail.oid
        AND year(orders.odate) = @year
        GROUP BY product.pid
        HAVING SUM(order_detail.amount) < @amount
    );
END
-- คำสั่งเพื่อดูจำนวนสินค้าที่ขายได้มากกวา่ 2 ชิ้นในปี2024แสดงวา่ ไม่ตอ้งลดราคาสินคา้เหล่าน้ี
select product.pid, sum(order_detail.amount)as total_amount
from product, orders, order_detail
WHERE product.pid = order_detail.pid
AND order_detail.oid = orders.oid
AND YEAR(orders.odate) = 2024
GROUP BY product.pid
HAVING sum(order_detail.amount) > 2

-- เพื่อดูราคาสินค้า(price) ก่อนรัน procedure
select * from product

-- ลดราคาสินค้าที่ปี 2024 ขายไดน้อ้ยกวา่ 2 ชิ้น โดยลดราคาลง 50%
exec msp_demo6 2024, 2 , 50
