/*

drop table order_detail
drop table orders
drop table product_type
drop table type
drop table product
drop table customer
drop table shop
drop table seller


-- คำสั่งเพื่อเช็คว่าใน account ตัวเองมี table ใดบ้าง เปลี่ยน prymania เป็น login ของตัวเอง
select * from INFORMATION_SCHEMA.TABLES
where table_schema = 'DB_65011212081_schema'

sp_help customer

*/



create table seller( -- ผู้ขาย
	sid		varchar(10)	,		-- รหัสผู้ขาย
	name	varchar(100),		-- ชื่อผู้ขาย
	status	int,				-- สถานะของผู้ขาย 0 คือยกเลิกผู้ขาย 1 คือเปิดขายปกติ
constraint sell_pk primary key(sid),
constraint sell_name check(name is not null),
constraint sell_status check(status in (0, 1)))


create table shop(	-- ร้านค้า
	sid			varchar(10),
	sellerid	varchar(10),	-- รหัสผู้ขาย
	name		varchar(100),
	address		varchar(200),
	phone		varchar(10),
	status		int,			-- สถานะของร้านค้า 0-ยกเลิกร้านค้า , 1- เปิดขายปกติ, และ 2 – ปิดชั่วคราว 
constraint shop_pk primary key(sid),
constraint shop_fk foreign key(sellerid) references seller(sid) on delete cascade,
constraint shop_status check (status in (0, 1, 2)))

create table customer(
	cid				varchar(10),
	name			varchar(100),
	phone			varchar(10),
	address			varchar(100),
	birthday		date,
	point			int,
	suggestedid		varchar(10),	-- รหัสลูกค้าที่เป็นผู้แนะนำลูกค้าคนนี้
constraint cus_pk		primary key(cid),
constraint cus_fk		foreign key(suggestedid) references customer(cid) on delete no action,
constraint cus_point	check (point >= 0))

create table product(
	pid				varchar(10),
	shopid			varchar(10),		--รหัสร้านค้าที่ขายสินค้าชิ้นนี้
	name			varchar(100),
	price			float,
	max_point		int		default 0,	-- จำนวนแต้มสูงสุดที่สามารถใช้เป็นส่วนลดการซื้อสินค้าชิ้นนี้ได้
	stock			int,				-- จำนวนสินค้าที่เหลือในร้าน
constraint product_pk primary key(pid),
constraint product_fk foreign key(shopid) references shop(sid)  on delete cascade,
constraint product_price check (price > 0),
constraint product_stock check (stock >= 0))

create table type(	-- หมวดหมู่สินค้า
	tid		varchar(10),
	name	varchar(100),
constraint type_pk primary key(tid))

create table product_type(
	pid		varchar(10),
	tid		varchar(10),
constraint gcate_pk primary key(pid, tid))

create table orders( --การสั่งซื้อ
	oid				int ,
	cusid			varchar(10),
	shopid			varchar(10),
	odate			date,	-- วันที่ทำการสั่งซื้อ
	fdate			date,	-- วันที่การสั่งซื้อเสร็จสิ้น (ผู้ซื้อได้รับของแล้ว)
	list_price		float,  -- ยอดรวมของการสั่งซื้อก่อนลดราคา 
	discount_point	int,	-- จำนวนแต้มทั้งหมดที่ใช้ลดราคาในการสั่งซื้อนี้ 
	final_price		float,	-- ยอดรวมของการสั่งซื้อหลังใช้แต้มลดราคา (เป็นยอดจริงที่ลูกค้าต้องจ่ายเงิน)
	status			int default 1,	-- สถานะการสั่งซื้อ 1- เริ่มทำการสั่งซื้อ, 2- อยู่ระหว่างการขนส่ง, 3- ส่งสินค้าเรียบร้อยแล้ว, 0- รีเทิร์นสินค้า 
	review			float,
constraint order_pk		primary key(oid),
constraint order_fk_cid foreign key(cusid)	references customer(cid) on delete cascade,
constraint order_fk_pid foreign key(shopid) references shop(sid) on delete cascade,
constraint order_date	check (odate < fdate),
constraint order_status check (status in (0, 1, 2, 3)),
constraint order_review check (review between 0 and 5))

create table order_detail( --รายละเอียดการสั่งซื้อ
	did				int identity(1,1),	-- รหัสรายละเอียด
	oid				int,				-- รหัสการสั่งซื้อ
	pid				varchar(10),		-- รหัสสินค้า
	amount			int,				-- จำนวนสินค้า
	use_point		int		default 0,	-- จำนวนแต้มสะสมที่ใช้เป็นส่วนลดการซื้อสินค้าชิ้นนี้
	item_price		int,				-- ราคารวมของสินค้านี้ (amount*good_price - use_point)
constraint detail_pk		primary key(did),
constraint detail_fk_oid	foreign key(oid) references orders(oid) on delete no action,
constraint detail_fk_pid	foreign key(pid) references product(pid) on delete no action,
constraint detail_amount	check (amount > 0))



--------------------------------------------------------------
--------------------------------------------------------------
----------------   INSERT DATA     ---------------------------
--------------------------------------------------------------
--------------------------------------------------------------

/* เป็นตัวอย่างการ insert ข้อมูลเท่านั้น นิสิตต้องมีการ insert ข้อมูลเพิ่มเติมเอง ควรมีข้อมูลให้พร้อมในการทดสอบคำสั่ง */
insert into seller values('seller01', 'Prymania',	1)
insert into seller values('seller02', 'WARP',		1)
insert into seller values('seller03', 'iSell',		1)
insert into seller values('seller04', 'uBuy',		1)
insert into seller values('seller05', 'i20',		0)

insert into shop values('s01', 'seller01', 'pDrink',		'Bkk 11/22', '08801', 1)
insert into shop values('s02', 'seller01', 'pLuxury',		'Bkk 22/22', '08802', 1)
insert into shop values('s03', 'seller01', 'pFruit',		'Bkk 33/22', '08802', 2)

insert into shop values('s04', 'seller02', 'wSell',		'Bkk 100', '09801', 1)
insert into shop values('s05', 'seller02', 'wDrink',	'Bkk 200', '09802', 1)
insert into shop values('s06', 'seller02', 'wSnack',	'Bkk 300', '09803', 0)

insert into shop values('s07', 'seller03', 'iSellGood',  'Bkk 400', '09804', 1)
insert into shop values('s08', 'seller03', 'iSellBad',	 'Bkk 500', '09805', 1)

insert into customer values('c01', 'Jim',	'0666', 'bkk 335', '1-1-2000', 10000, null)
insert into customer values('c02', 'Jack',	'0555', 'bkk 335', '1-1-2000', 5000, null)
insert into customer values('c03', 'Joe',	'0633', 'bkk 335', '1-5-2001', 2000, null)
insert into customer values('c04', 'Joy',	'0645', 'bkk 335', '1-9-1995', 3000, null)
insert into customer values('c05', 'Jane',	'023',  'bkk 335', '1-3-2002', 5000, null)

insert into customer values('c06', 'Pete', null, null, '1-1-2016', 500,		'c01')
insert into customer values('c07', 'Pam',  null, null, '1-2-2015', 0,		'c01')
insert into customer values('c08', 'Paul', null, null, '1-3-2014', 0,		'c01')



insert into product values ('p01', 's01', 'Pepsi',		10,			0,	20)
insert into product values ('p02', 's01', 'Coke',		10,			0,	50)
insert into product values ('p03', 's01', 'Juice',		100,		0,	10)
insert into product values ('p04', 's01', 'Beer',		200,		0,	10)
insert into product values ('p05', 's01', 'Wine',		1000,		0,	10)

insert into product values ('p06', 's02', 'iPad',		50000,		1000,	50)
insert into product values ('p07', 's02', 'iPhone',		60000,		2000,	20)
insert into product values ('p08', 's02', 'iMouse',		10000,		50,		10)

insert into product values ('p16', 's05', 'Red Wine',		2000,	0,	80)
insert into product values ('p17', 's05', 'White Wine',		2000,	0,	80)

insert into product values ('p18', 's07', 'Sofa',			10000,	500,	80)
insert into product values ('p19', 's07', 'Sofa bed',		80000,  3000,	80)

insert into type values('t01', 'drink')
insert into type values('t02', 'food')
insert into type values('t03', 'stationary')
insert into type values('t04', 'electric')
insert into type values('t05', 'phone')
insert into type values('t06', 'furniture')
insert into type values('t07', 'luxury')
insert into type values('t08', '18+')

insert into product_type values('p01', 't01')
insert into product_type values('p02', 't01')
insert into product_type values('p03', 't01')
insert into product_type values('p04', 't01')
insert into product_type values('p05', 't01')
insert into product_type values('p04', 't08')
insert into product_type values('p05', 't08')

insert into product_type values('p06', 't03')
insert into product_type values('p07', 't03')
insert into product_type values('p08', 't03')
insert into product_type values('p09', 't03')
insert into product_type values('p10', 't03')
insert into product_type values('p06', 't04')
insert into product_type values('p07', 't04')
insert into product_type values('p08', 't04')
insert into product_type values('p09', 't04')
insert into product_type values('p10', 't04')
insert into product_type values('p06', 't07')
insert into product_type values('p07', 't07')
insert into product_type values('p08', 't07')
insert into product_type values('p09', 't07')
insert into product_type values('p10', 't07')

insert into product_type values('p11', 't02')
insert into product_type values('p12', 't02')
insert into product_type values('p13', 't02')
insert into product_type values('p14', 't02')
insert into product_type values('p15', 't02')

insert into orders values(1, 'c01','s01', '1-1-2020',  '7-1-2020',		260,		0,			260,	3, 4)
insert into orders values(2, 'c06','s02', '4-1-2020',  '10-1-2020',		120000,		2000,		118000, 3, 5)
insert into orders values(3, 'c03','s05', '10-3-2020', '24-3-2020',		12000,		0,			12000,	3, 4)
insert into orders values(4, 'c08','s07', '10-3-2020', null,			50000,		1000,		49000,	2, 0)
insert into orders values(5, 'c08','s03', '11-3-2020', null,			700,		30,			670,	1, 0)

insert into order_detail(oid, pid, amount, use_point, item_price) values(1, 'p01', 1,	0,	10)
insert into order_detail(oid, pid, amount, use_point, item_price) values(1, 'p02', 5,	0,	50)
insert into order_detail(oid, pid, amount, use_point, item_price) values(1, 'p03', 2,	0,	200)

insert into order_detail(oid, pid, amount, use_point, item_price) values(2, 'p06', 1,	1000,	49000)
insert into order_detail(oid, pid, amount, use_point, item_price) values(2, 'p06', 1,	1000,	49000)
insert into order_detail(oid, pid, amount, use_point, item_price) values(2, 'p08', 2,	0,		20000)

insert into order_detail(oid, pid, amount, use_point, item_price) values(3, 'p16', 5,	0,		10000)
insert into order_detail(oid, pid, amount, use_point, item_price) values(3, 'p17', 1,	0,		2000)

insert into order_detail(oid, pid, amount, use_point, item_price) values(4, 'p18', 1,	500,	9500)
insert into order_detail(oid, pid, amount, use_point, item_price) values(4, 'p18', 1,	500,	9500)
insert into order_detail(oid, pid, amount, use_point, item_price) values(4, 'p18', 3,	0,		30000)

insert into order_detail(oid, pid, amount, use_point, item_price) values(5, 'p15', 1,	30,		470)
insert into order_detail(oid, pid, amount, use_point, item_price) values(5, 'p14', 1,	0,		200)




select * FROM CustomerOrderDetails
DROP VIEW IF EXISTS CustomerOrderDetails;

