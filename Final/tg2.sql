
-- 2.tg_ProductNoDiscount
-- ต้องกํารล็อคให้ สินค้า ไม่สามารถลดราคา ได้ ดังนั้น
-- เมื่อมีการแก้ไขราคาสินค้าต้องเช็คว่า ถ้าราคาต่ํากว่าราคาเดิมต้องไม่สามารถแก้ไขได้ และยกเลิกการแก้ไข
-- ถ้าแก้ไขได้ ให้แสดงข้อความ แก้ไขสำเร็จ
-- ถ้าแก้ไขไม่ได้ ให้แสดงข้อความยกเลิก และต้องบอกราคาเดิม และราคาใหม่ที่ต้องการแก้ไขด้วย
-- **เพื่อลดความซับซ้อนของ code ให้คิดว่าเป็นการแก้ไขข้อมูลทีละ record เท่านั้น

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
            PRINT 'การแก้ไขถูกยกเลิก: ราคาเดิมคือ ' + CAST(@old_price AS VARCHAR(10)) +
                ' และราคาที่พยายามเปลี่ยนแปลงคือ ' + CAST(@new_price AS VARCHAR(10));
        ROLLBACK;
    END
    ELSE
        BEGIN
            PRINT 'การแก้ไขสำเร็จ';
    END
END;




-- สมมติว่าราคาเดิมของสินค้าที่ pid = 'p01' คือ 1000
UPDATE product SET price = 800 WHERE pid = 'p01';  -- ควรจะถูกยกเลิก

-- สมมติว่าราคาเดิมของสินค้าที่ pid = 'p01' คือ 1000
UPDATE product SET price = 1200 WHERE pid = 'p01';  -- ควรจะสำเร็จ


DROP TRIGGER IF EXISTS tg_ProductNoDiscount


SELECT * FROM product