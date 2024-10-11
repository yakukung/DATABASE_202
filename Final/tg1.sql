-- 1.tg_customerPhoneLog
-- เมื่อลูกค้ํามีกํารเปลี่ยนแปลงเบอร์โทร ต้องการเก็บข้อมูลการเปลี่ยนแปลง ไว้ใน table
-- CustomerPhoneLog(cusid, old_phone, new_phone, change_date)

-- ข้อนี้ต้องสร้าง 2 อย่างคือ
-- 1. table: CustomerPhoneLog
-- 2. trigger : tg_customerPhoneLog


CREATE TABLE CustomerPhoneLog (
    cusid VARCHAR(5),
    old_phone VARCHAR(10),
    new_phone VARCHAR(10),
    change_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

GO

CREATE TRIGGER tg_customerPhoneLog
ON customer
FOR UPDATE
AS
BEGIN
    -- ตรวจสอบการเปลี่ยนแปลงเบอร์โทรศัพท์ในตาราง Customer
    INSERT INTO CustomerPhoneLog (cusid, old_phone, new_phone, change_date)
    SELECT i.cid, d.phone AS old_phone, i.phone AS new_phone, GETDATE() AS change_date
    FROM deleted d, inserted i
    WHERE d.cid = i.cid 
    AND d.phone <> i.phone;
END;


-- ทดสอบ: อัปเดตเบอร์โทรศัพท์ของลูกค้า
UPDATE customer SET phone = '0987654333' WHERE cid = 'c01';

-- ตรวจสอบข้อมูลใน log
SELECT * FROM CustomerPhoneLog;

-- ลบ Trigger หลังจากทดสอบ
DROP TRIGGER IF EXISTS tg_customerPhoneLog;

-- ลบตาราง CustomerPhoneLog หลังจากทดสอบ
DROP TABLE IF EXISTS CustomerPhoneLog;


select * from customer


