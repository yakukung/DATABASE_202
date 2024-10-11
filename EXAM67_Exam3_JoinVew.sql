
/*********************************************************************
-------		TUTORIAL Quiz.3 Join, View
*********************************************************************/

/***    ง่าย ข้อละ 2 คะแนน **************************************
***************************************************************/

--1.	แสดงรหัสสินค้า ชื่อสินค้า ราคา ชื่อร้านค้าที่ขาย ของสินค้าที่เป็นประเภท drink
select	product.pid, product.name, price, shop.name as shop_name
from	shop, product, product_type, type
where	shop.sid		= product.shopid
and		product.pid		= product_type.pid
and		product_type.tid = type.tid
and		type.name		= 'drink'

สิ่งที่เช็ค
- table ครบ 4 table  ถ้าไม่ครบ ไม่ได้คะแนนเลย
- join  ครบ
- เงื่อนไข type.name = 'drink'


--2.	แสดงรหัสลูกค้า ชื่อลูกค้า เบอร์โทรของลูกค้า และวันที่สั่งซื้อ
--ของลูกค้าที่ในปี 2024 มีการซื้อของจากร้านค้ารหัส s01
select	customer.cid, customer.name, phone, odate
from	customer, orders
where	customer.cid	= orders.cusid
and		shopid			= 's01'
and		year(odate)		= '2024'

สิ่งที่เช็ค
- table 2 table เท่านั้น ถ้าเกินมี table shop เกินมา หัก 1 คะแนน
- join  ครบ
- เงื่อนไข ครบทั้ง 2 เงื่อนไข shopid, year(odate) ถ้าไม่ครบไม่ได้คะแนนเลย


/*
3.	แสดงรหัสสินค้า ชื่อสินค้า ราคา จำนวนสินค้าคงเหลือ และชื่อร้านค้า 
ของสินค้าที่ขายโดยผู้ขายชื่อ prymania 
โดยแสดงเฉพาะสินค้าที่มีจำนวนสินค้าคงเหลือน้อยกว่า 100 ชิ้น
ให้แสดงเรียงลำดับตามชื่อร้านค้า และรหัสสินค้า
*/

select	product.pid, product.name, price, stock, shop.name, seller.name
from	product, shop, seller
where	product.shopid  = shop.sid
and		shop.sellerid	= seller.sid
and		seller.name		= 'prymania'
and		stock			< 100
order by shop.name, product.pid

สิ่งที่เช็ค
- table 3 table 
- join  ครบ
- เงื่อนไข ครบทั้ง 2 เงื่อนไข ถ้าไม่ครบไม่ได้คะแนนเลย
- order by ถ้าไม่ใส่ หรือไม่ถูกต้อง หัก 1 คะแนน

--4.	แสดงรหัสสินค้า และจำนวนชิ้นที่ขายได้ทั้งหมดในปี 2024
--ของสินค้าทุกตัวในร้านรหัส s01

select		pid, sum(amount) as amount
from		order_detail, orders
where		order_detail.oid   = orders.oid
and			year(odate)			= '2024'
and			shopid				= 's01'
group by	pid

--สิ่งที่เช็ค
- table 2 table
- function sum(amount)
- condition year(odate), shopid 
- group by

--5.	แสดงรหัสลูกค้า ชื่อลูกค้า ชื่อร้านค้าที่ขาย ของการซื่อสินค้าชื่อ iPhone ในปี 2024
--(ร้านที่ขาย iphone อาจมีหลายร้าน ลูกค้าอาจซื้อจากร้านใดก็ได้)

select	distinct orders.oid, cusid, customer.name, shop.sid, shop.name
from	customer, orders, order_detail, product, shop
where	customer.cid		= orders.cusid 
and		orders.oid			= order_detail.oid
and		order_detail.pid	= product.pid
and		orders.shopid		= shop.sid
and		product.name		= 'iPhone'
and		year(odate)			= 2024


/**********************************/
--สิ่งที่เช็ค
- table 5 table
- join ครบ
- condition year(odate)
- condition: product.name

-- ต้องมี table order_detail เท่านั้น ถ้าไม่มีจะไม่ได้คะแนน เพราะเป็นส่วนสำคัญในการเช็ค iphone
-- ต้องมีครบ  5 table		จึงจะได้คะแนน
-- ถ้า table ถูก แต่เงื่อนไข  odate = 2024 ผิด				1 คะแนน
-- table correct, join ไม่ครบ							1 คะแนน

/***************************************************************  
***  section2:  ข้อละ 5 คะแนน **************************************
***************************************************************/

/*1. แสดงรหัสลูกค้า ชื่อลูกค้า รหัสของคนแนะนำและชื่อของคนแนะนำ
ของลูกค้าทุกคน แม้ว่าลูกค้าคนนั้นจะไม่มีคนแนะนำ โดยถ้าลูกค้านั้นไม่มีคนแนะนำให้แสดงเป็นข้อความ ไม่มีคนแนะนำ
*/

select	c1.cid			as รหัสลูกค้า,
		c1.name			as ชื่อลูกค้า,
		isnull(c1.suggestedid, 'ไม่มีคนแนะนำ')	as รหัสคนแนะนำ,
		isnull(c2.name, 'ไม่มีคนแนะนำ')			as ชื่อคนแนะนำ
from	customer c1 left outer join customer c2
on	c1.suggestedid	= c2.cid

สิ่งที่เช็ค
- ต้องใช้ left outer join เท่านั้น ถ้าไม่ใช้ ไม่ได้คะแนนเลย
- ถ้า left join ถูก แต่ไม่ได้ใช้ function isnull  หัก 2 คะแนน



/*2.	แสดงรหัสสินค้า ชื่อสินค้า ราคาสินค้า ของสินค้าในร้านชื่อ pDrink ที่ขายไม่ได้เลยในปี 2024 
*/
select	product.pid, product.name, price
from	product, shop
where	product.shopid	= shop.sid
and		shop.name		= 'pDrink'
and		product.pid not in
		(select		pid
		from		orders, order_detail
		where		orders.oid = order_detail.oid                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
		and			year(odate)		= '2024')

สิ่งที่เช็ค
- ต้อง idea ถูกเท่านั้นจึงจะได้คะแนน ถ้าผิดนิดหน่อยไม่ได้คะแนนเลย
- อาจจะใช้ except ได้
- concept คือ ต้องใช้ not in, หรือ except


/*
3.	ต้องการแสดงรายงานการขายประจำปี โดยแสดง
รหัสร้านค้า 
ยอดรวมการขายทั้งหมดก่อนลดราคา 
ยอดรวมแต้มสะสมทั้งหมดที่ใช้ซื้อ 
ยอดรวมการขายทั้งหมดหลังลดราคา
โดยแสดงเฉพาะร้านค้าของผู้ขายชื่อ prymania 
และเฉพาะการขายที่เกิดขึ้นในปีนี้เท่านั้น 	** ปีนี้คือปีที่รันคำสั่ง
	*หมายเหตุ* output การแสดงผลคือ 1 ร้านค้าแสดง 1 บรรทัดเท่านั้น
*/

select	shopid, 
		sum(list_price)			as ยอดรวมการขายทั้งหมดก่อนลดราคา,
		sum(discount_point)		as ยอดรวมแต้มสะสมทั้งหมดที่ใช้ซื้อ ,
		sum(final_price)		as ยอดรวมการขายทั้งหมดหลังลดราคา
from	orders, shop, seller
where	orders.shopid	= shop.sid
and		shop.sellerid	= seller.sid
and		seller.name		= 'prymania'
and		year(odate)		= year(getdate())
group by shopid

-- วิธีที่ 2 
select	shop.sid, 
        sum(use_point+item_price)		as ยอดรวมการขายทั้งหมดก่อนลดราคา,
        sum(use_point)					as ยอดรวมแต้มสะสมทั้งหมดที่ใช้ซื้อ ,
        sum(item_price)					as ยอดรวมการขายทั้งหมดหลังลดราคา
from    seller, shop, orders, order_detail
where   seller.sid                        =        shop.sellerid
and     shop.sid                        =        orders.shopid
and     orders.oid                        =        order_detail.oid
and     seller.name                        =        'prymania'
and     year(odate)		= year(getdate())
group by        shop.sid



/*
สิ่งที่เช็ค
- 3 table
- ถ้า idea ถูกทุกอย่าง แต่มี table เกินมาและ join ถูก	ให้ 5 คะแนน
- ต้องมี function sum() และ group by shopid เท่านั้น จึงจะได้คะแนน
- ถ้าไม่มีเงื่อนไข seller.name				หัก 1 คะแนน
- ถ้าไม่มีเงื่อนไข year(odate)				หัก 1 คะแนน
*/




/*4.	แสดงรหัสสินค้า  และจำนวนชิ้นที่ขายได้  ของสินค้าทุกอย่างที่มาจากร้านค้าคือ pDrink
โดยถ้าสินค้านั้นขายไม่ได้เลย ให้แสดงเป็น 0 ชิ้น 
*/
select product.pid, isnull(sum(amount), 0) as totol_amount
from	product left outer join order_detail on product.pid = order_detail.pid
where	product.shopid in
		(select sid
		from	shop
		where	name = 'pDrink')
group by product.pid

-- or
select product.pid, isnull(sum(amount), 0) as totol_amount
from	product left outer join order_detail on product.pid = order_detail.pid,
				shop
where	product.shopid = shop.sid
and		shop.name = 'pDrink'
group by product.pid

/*
สิ่งที่เช็ค
-- ต้องใช้ left outer join, 						
-- group by, sum(amount)						
-- ถ้า ไม่ใช้ isnull(sum) แต่ left join					2 คะแนน
-  ถ้าใช้ isnull(sum) แต่ไม่ left join					1 คะแนน
- ถ้าไม่มี group by, sum(amount)						0
*/



/*
5.	ร้าน pDrink ต้องแสดงรายงานการขายแต่ละปีของร้านค้า โดยแสดงข้อมูลคือ
รหัสลูกค้า
ปีที่ทำรายการขาย (odate)
ยอดขายรวมหลังลดราคาของปีนั้น ๆ  
ของร้านค้า (shop) ชื่อ  pDrink
ตัวอย่างการแสดงผล

*/

select	cusid, year(odate) as year, sum(final_price) as sum_final_price
from	orders, shop
where	orders.shopid	= shop.sid
and		shop.name		= 'pDrink'
group by cusid, year(odate)

/*
การให้คะแนน
- year(fdate)								5 คะแนน
- ถ้าถูกหมด แต่ผิด group by cusid, odate	ให้ 3 คะแนน
- ไม่ join column, ไม่มี grop by			ไม่ให้คะแนน
- มี table orders เท่านั้น ไม่มีเช็คเงือ่นไข		ไม่ให้คะแนน
- ไม่มี grop by							ไม่ให้คะแนน
- group by cid, odate, final_price		ไม่ให้คะแนน
- ไอเดียถูก มี table เกิน หรือ join ไม่จำเป็น	ให้ 4 คะแนน
- ไอเดียถูก ไม่มีเงื่อนไข shop.name				ให้ 3 คะแนน
- sum(item_price), from order_detail	ให้ 4 คะแนน
- ไอเดียถูก มี check year ผิด				ให้ 3 คะแนน
- ไอเดียถูกแต่ group by odate, มี check year ผิด				ให้ 2 คะแนน
- all correct, group by cusid only		1
*/



/*6.	เพิ่มแต้มสะสมให้ลูกค้า ที่ทำการซื้อในปี 2024 มากกว่า 5 ครั้ง โดยให้แต้มเพิ่มคนละ 10 แต้ม

-- demo data มี c01, c02 ที่จะได้เพิ่มแต้ม
*/

select * from customer


update	customer
set		point = point + 10
where	cid IN
		(select		cusid
		from		orders
		where		year(odate) = 2024
		group by	cusid
		having		count(*) > 5)


/*
การให้คะแนน

- all correct, but nested with orders, order_detail			==>	4
- all correct, but nested with orders, order_detail	no join	==>	2
- ไม่มี having count(*) > 5	 หรือใช้ amount > 5				==> 0
- concept correct, ใช้ join ทำให้คำสั่งผิด						==> 1
- all correst, but nested with count(*) so error			==> 2
- all correct,  fdate in('2024')							==> 3
- nested: where cid > (select amount.... ), all correct		==>	1
- no condition:		year(odate) = 2024						==>	2
- wrong calculation: point = point + point + 10				==> 4
- condition odate like 2024%		==> 5
*/





/*7.	สินค้าที่ในปี 2023 ขายไม่ได้เลย ให้ลดราคาสินค้าลง 10%

demo data มี สินค้า 9 อันที่ขายไม่ได้
select	*
from	product
where	pid NOT IN
		(select		pid
		from		orders, order_detail
		where		orders.oid = order_detail.oid
		and			year(odate) = 2023)
*/

update	product
set		price = price - price * 0.1
where	pid NOT IN
		(select		pid
		from		orders, order_detail
		where		orders.oid = order_detail.oid
		and			year(odate) = 2023)

/*
การให้คะแนน
- ต้องใช้ concept: not in หรือ except เท่านั้น
- concept รวมๆถูก แต่ nested join table เกิน 				5 คะแนน
- concept รวมๆถูก แต่  ambiguous colum name				4 คะแนน
- wrong calculation										4 คะแนน
- ถ้า  not in(select pid from order_detail) ไม่มี year		2 คะแนน
- concept ถูก แต่ไม่  join orders, order_detail				2 คะแนน
- wrong join column, no order_detail					0
*/



/********     VIEW      ****************************/
/****************************************************/
/****************************************************/


/*
-- 1.	แสดงรหัสร้านค้า รหัสสินค้า  ชื่อสินค้า และราคาสินค้า ที่แพงที่สุดจากทุกร้าน

drop view expensive_product
*/
create  view expensive_product(shopid, max_price) as
	select	shopid, max(price)
	from	product
	group by shopid

select	pid, name, price, product.shopid
from	product, expensive_product
where	product.shopid	=	expensive_product.shopid
and		product.price	=	expensive_product.max_price


/*การให้คะแนน
- view ต้องถูกต้อง  2 คะแนน
table  เกิน ให้ 1 คะแนน
ไม่มี group by  ไม่ให้คะแนนเลย
- select 3 คะแนน
	- join product, view ถูกต้อง
	- ถ้า table เกิน ให้ 2 คะแนน
	- ถ้า join ไม่ครบ 2 คอลัมน์ ไม่ให้คะแนนเลย

ถ้า view ผิดเลย แต่ select ถูก ทั้งหมดให้ 2 คะแนน

-- ส่วนมากที่ทำผิด
1. เอา table shop เกินมา ทั้ง view และ select
2. select ทำเป็น nested join ข้อนี้ไม่ได้เลย ต้อง join ธรรมดา
3. join ไม่ครบ 2 คอลัมน์ คือ price, shopid
*/


/*
2.	แสดงรหัสลูกค้า ชื่อลูกค้า รหัสร้านค้า ยอดซื้อรวมของลูกค้าที่ซื้อในร้านค้านั้น 

drop view customer_by_shop
*/
create view customer_by_shop(cusid, shopid, total_buy)
as
	select  cusid, shopid, sum(final_price)
	from	orders
	group by cusid, shopid


select	cid, name, shopid, total_buy
from	customer, customer_by_shop
where	customer.cid = customer_by_shop.cusid



/*การให้คะแนน
- view ต้องถูกต้อง  2 คะแนน
-table customer เกินมา ให้ 1 คะแนน
-ไม่มี group by:  cusid, shopid ไม่ให้คะแนนเลย
- group by cusid  อย่างเดียว ไม่ให้คะแนนเลย
- group by name ไม่ให้คะแนนเลย
- group by cusid, shopid, final_price ไม่ให้คะแนนเลย
- sum(list_price) ไม่ให้คะแนนเลย

- select 3 คะแนน
	- join product, view ถูกต้อง
	- ถ้า table เกิน ให้ 2 คะแนน

ถ้า view ผิดเลย แต่ select ถูก ทั้งหมดให้ 2 คะแนน

*/

/*
-- 3.	เพิ่มแต้มสะสมให้ลูกค้าทุกคนที่มีในปี 2024 โดย ให้แต้มเพิ่ม  แต้ม ทุก ๆ การซื้อ 100 บาท เช่น

drop view customer_sum_by_year
*/
create view customer_sum_by_year(cid, year, total_price)
as
	select	 cusid, year(odate), sum(final_price)
	from	orders
	group by cusid, year(odate)


select * from customer_sum_by_year

update	customer
set		point = isnull(point, 0) + total_price/100
from	customer_sum_by_year
where	customer.cid = customer_sum_by_year.cid
and		year		 = 2024
select * from customer_sum_by_year where year = 2024
select * from customer


/*การให้คะแนน
- view ต้องถูกต้อง  2 คะแนน
-table customer เกินมา ให้ 1 คะแนน
- ต้องมีsum(final_price)
-ไม่มี group by:  cusid, year(odate) ไม่ให้คะแนนเลย
- group by cusid  อย่างเดียว ไม่ให้คะแนนเลย
- group by cusid, odate  ให้ 1 คะแนน 
- sum(list_price) ไม่ให้คะแนนเลย

- update 3 คะแนน
	- join product, view ถูกต้อง
- update ใช้ case ผิดconcept ไม่ให้คะแนนเลย

- ถ้า view ผิด แต่ update ถูกconceptหมด ให้ 2 คะแนน
- ถ้าไม่มีเงื่อนไข year หัก 1 คะแนน


*/
