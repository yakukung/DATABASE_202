CREATE TRIGGER tg_checkShopStatus
ON orders
AFTER INSERT
AS
BEGIN
    DECLARE
        @shop_id VARCHAR(10),
        @shop_status INT;

    SELECT @shop_id = shopid
    FROM inserted;

    -- ดึงสถานะของร้านค้า
    SELECT @shop_status = status
    FROM shop
    WHERE sid = @shop_id;

    -- ตรวจสอบสถานะร้านค้า
    IF @shop_status <> 1 -- สถานะเปิดขายปกติ
    BEGIN
        -- ยกเลิกการสั่งซื้อ
        DELETE FROM orders
        WHERE oid IN (SELECT oid FROM inserted);

        PRINT 'การสั่งซื้อถูกยกเลิก: ร้านค้าไม่เปิดขายปกติ';
    END
    ELSE
    BEGIN
        PRINT 'การสั่งซื้อสำเร็จ';
    END
END;



DROP TRIGGER tg_checkShopStatus;


INSERT INTO orders(oid, cusid, shopid, final_price) VALUES (707, 'c01', 's06', 500);

   SELECT * FROM shop
   SELECT * FROM orders