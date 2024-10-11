CREATE TRIGGER tg_checkProductPointForDiscount
ON order_detail
FOR INSERT
AS
BEGIN
    DECLARE
        @product_id VARCHAR(20),
        @used_points INT,
        @max_points INT;

    SELECT @product_id = pid, @used_points = use_point
    FROM inserted;

    SELECT @max_points = max_point
    FROM product
    WHERE pid = @product_id;

    IF (@used_points > @max_points)
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'ไม่สามารถขายได้: สินค้านี้สามารถใช้ point ลดราคาได้เพียง ' + CAST(@max_points AS VARCHAR(10)) + ' เท่านั้น';
        RETURN;
    END
    ELSE
    BEGIN
        PRINT 'use_point = '+ CAST(@used_points AS VARCHAR(10)) + '
        , max_point =' + CAST(@max_points AS VARCHAR(10));
        PRINT 'ขายสินค้าสำเร็จ';
    END
END;




DROP TRIGGER tg_checkProductPointForDiscount;

insert into order_detail(oid, pid, amount, use_point) values(1, 'p06', 1, 900) --ok
insert into order_detail(oid, pid, amount, use_point) values(1, 'p06', 1, 5000) --rollback

SELECT * FROM product