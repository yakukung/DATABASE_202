-- 7.tg_bonusSuggestedCustomer
-- trigger นี้เฝ้า table customer
-- เมื่อมีการเพิ่มลูกค้าใหม่ ให้เพิ่มแต้มสะสม (point) ให้กับลูกค้าที่เป็นผู้แนะนำจำนวน 10 แต้ม
-- เช่น
-- insert into CUSTOMER values('c20', 'Killua', null, null, '7-7-2000', 0, 'c05')
-- แสดงว่า ลูกค้า C05 เป็นผู้แนะนำ c20 ดังนั้นให้เพิ่ม point ให้c05 จำนวน 10 แต้ม
-- แสดงข้อความบอกด้วย ว่ําลูกค้ารหัส
CREATE TRIGGER tg_bonusSuggestedCustomer
ON customer
AFTER INSERT
AS
BEGIN
    DECLARE
        @new_customer_id VARCHAR(10),
        @suggested_id VARCHAR(10),
        @bonus_points INT = 10,
        @current_points INT;

    SELECT @new_customer_id = cid, @suggested_id = suggestedid
    FROM inserted;

    IF @suggested_id IS NOT NULL
    BEGIN
    
        UPDATE customer
        SET point = point + @bonus_points
        WHERE cid = @suggested_id;

        SELECT @current_points = point 
        FROM customer 
        WHERE cid = @suggested_id;

        -- แสดงข้อความว่าผู้แนะนำได้รับแต้มเพิ่ม
        PRINT 'ลูกค้ารหัส ' + @suggested_id + ' ได้รับแต้มเพิ่ม = ' + CAST(@bonus_points AS VARCHAR(10)) + ' แต้ม';
        PRINT 'ทำให้ตอนนี้มี point = ' + CAST(@current_points AS VARCHAR(10));  -- แสดงแต้มสะสมใหม่
    END
END;




DROP TRIGGER tg_bonusSuggestedCustomer;


insert into CUSTOMER values('c23', 'Killua', null, null, '7-7-2000', 0, 'c05')
