-- 3.tg_checkProductPrice20Percent
-- เมื่อมีการเพิ่มราคาสินค้ํา ต้องมีการเช็คล็อคไม่ให้เพิ่มราคาสินค้าเกิน 20 %

CREATE TRIGGER tg_ProductNoDiscount
ON product
FOR UPDATE
AS
BEGIN
    DECLARE
        @old_price DECIMAL(10, 2),
        @new_price DECIMAL(10, 2),
        @product_id VARCHAR(20);

    SELECT @product_id = pid, @new_price = price
    FROM inserted;

    SELECT @old_price = price
    FROM deleted
    WHERE pid = @product_id;

    -- ตรวจสอบว่าราคาใหม่ต่ำกว่าราคาเดิมหรือไม่
    IF (@new_price < @old_price)
    BEGIN
        -- ยกเลิกการแก้ไข
        ROLLBACK TRANSACTION;
        PRINT 'การแก้ไขถูกยกเลิก: ราคาเดิมคือ ' + CAST(@old_price AS VARCHAR(10)) +
            ' และราคาที่พยายามเปลี่ยนแปลงคือ ' + CAST(@new_price AS VARCHAR(10));
        RETURN;
    END

    -- ตรวจสอบว่าราคาใหม่เกิน 20% ของราคาเดิมหรือไม่
    IF (@new_price > @old_price * 1.2)
    BEGIN
        -- ยกเลิกการแก้ไข
        ROLLBACK TRANSACTION;
        PRINT 'การแก้ไขถูกยกเลิก: ไม่สามารถเพิ่มราคาสินค้าเกิน 20% จากราคาเดิม';
        RETURN;
    END
    ELSE
    BEGIN
        PRINT 'การแก้ไขสำเร็จ';
    END
END;


UPDATE product SET price = 1200 WHERE pid = 'p01'; --สำเร็จ
UPDATE product SET price = 1100 WHERE pid = 'p01'; -- ปัจจุบันราคาต่ำกว่าลดไม่ได้
UPDATE product SET price = 3000 WHERE pid = 'p01'; -- เพิ่มราคาเกินกว่า 30% ถูกยกเลิก



DROP TRIGGER tg_ProductNoDiscount;
