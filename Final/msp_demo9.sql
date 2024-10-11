-- 9. msp_search_customer( @cid, @name, @phone)
-- เพื่อค้นหาข้อมูลลูกค้า ด้วย รหัสลูกค้า หรือ ชื่อ หรือ เบอร์โทร
-- โดยสามารถค้นหาด้วยค่าใดค่าหนึ่ง
-- ถ้าค้นหาด้วย cid หรือ phone ให้ค้นหาแบบ ตรงตัว เช่น c01 หําลูกค้ารหัส c01
-- ถ้าค้นหาด้วย name ให้ค้นหาด้วยชื่อที่มีตัวอักษรนั้นอยู่ เช่น ฟ้ํา หําลูกค้ําที่มีคำว่า ฟ้า อยู่ในชื่อ
-- ลำดับความสำคัญของการค้นหาคือ รหัสลูกค้า ชื่อ เบอร์โทร

CREATE PROCEDURE msp_search_customer(
    @cid VARCHAR(20) = NULL,
    @name VARCHAR(50) = NULL,
    @phone VARCHAR(15) = NULL
)
AS
BEGIN
    SELECT  *
    FROM customer
    WHERE (@cid IS NOT NULL AND customer.cid = @cid)
    OR (@cid IS NULL AND @name IS NOT NULL AND customer.name LIKE '%' + @name + '%')
    OR (@cid IS NULL AND @name IS NULL AND @phone IS NOT NULL AND customer.phone = @phone)
END;



exec msp_search_customer 'c07', 'j', null
exec msp_search_customer null, null, '0645'

DROP PROCEDURE IF EXISTS msp_search_customer
