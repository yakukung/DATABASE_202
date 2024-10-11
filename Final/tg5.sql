CREATE TRIGGER tg_increaseCustomerPointAfterOrders
ON orders
AFTER INSERT
AS
BEGIN
    DECLARE
        @customer_id VARCHAR(10),
        @total_price DECIMAL(10, 2),
        @points_to_add INT,
        @customer_point INT;

    SELECT @customer_id = cusid, @total_price = final_price
    FROM inserted;

    -- คำนวณแต้มที่จะเพิ่ม
    SET @points_to_add = FLOOR(@total_price / 100);

    -- เพิ่มแต้มให้ลูกค้าในตาราง customer
    UPDATE customer
    SET point = point + @points_to_add
    WHERE cid = @customer_id;

    -- ดึงแต้มปัจจุบันของลูกค้า
    SELECT @customer_point = point
    FROM customer
    WHERE cid = @customer_id;

    PRINT 'ยอดซื้อครั้งนี้: ' + CAST(@total_price AS VARCHAR(10));
    PRINT 'ลูกค้าได้รับแต้มเพิ่ม: ' + CAST(@points_to_add AS VARCHAR(10));
    PRINT 'แต้มสะสมของลูกค้า: ' + CAST(@customer_point AS VARCHAR(10));
END;



DROP TRIGGER tg_increaseCustomerPointAfterOrders;

insert into orders(oid, cusid, shopid, final_price) values (700, 'c02', 's01', 200)
insert into orders(oid, cusid, shopid, final_price) values (701, 'c02', 's01', 250)
insert into orders(oid, cusid, shopid, final_price) values (702, 'c02', 's01', 250)
insert into orders(oid, cusid, shopid, final_price) values (703, 'c02', 's01', 2328)

SELECT * FROM orders
SELECT * FROM customer