-- 创建数据库
create database if not exists hotel_management_system character set 'utf8';


-- 使用数据库
use hotel_management_system;


-- 创建表信息

-- 创建客户信息表
create table if not exists customer(
cid varchar(25) primary key,
cname varchar(20) not null,
csex char(1) not null,
cid_card varchar(20) not null unique,
cphone_number varchar(15) not null unique,
bookmethod varchar(15) not null check(bookmethod = '电话预订' or bookmethod = '网上预订')
);


-- 创建酒店信息表
create table if not exists hotel(
hid varchar(15) primary key,
hname varchar(20) not null,
haddress varchar(50) not null,
hphone_number varchar(15) not null,
hroom_number smallint not null default 600 #表示酒店剩余的房间数量，将酒店初始房间数设置为600间
);


-- 创建房间信息表
create table if not exists room(
rid varchar(15) primary key,
rnum varchar(5) not null,
rtype varchar(15) not null check(rtype in('单人床','双人床','豪华套间','商务套间')),#房间类型
rprice decimal(8,2) not null,
rf varchar(1) not null default '0' check(rf in('0','1')),#房间状态，如果房间被预订或有人住，则设为1，否则设为0
rhid varchar(15) not null,

constraint fk_rm_ht_id foreign key(rhid) references hotel(hid)
);


-- 创建酒店管理员信息表
create table if not exists admin(
aid varchar(15) primary key,
aname varchar(20) not null,
apost varchar(15) not null,
ahid varchar(15) not null,

constraint fk_ad_ht_id foreign key(ahid) references hotel(hid)
);


-- 创建预订信息表
create table if not exists book_info(
bid varchar(15) primary key,
bstart_time datetime not null,#房间预订的起始时间
blength smallint not null,#房间预订的时长，以小时为单位，smallint的范围为：0~65535，最多大概7~8年，tinyint的范围为：0~255，最多是10天左右（太少，不适合）
bcid varchar(25) not null,
brid varchar(15) not null,

constraint fk_bi_ct_id foreign key(bcid) references customer(cid),
constraint fk_bi_rm_id foreign key(brid) references room(rid)
);


-- 创建支付信息表
create table if not exists pay_info(
pid varchar(25) primary key,
pprice decimal(8,2) not null,
pway varchar(10) not null check(pway in('微信','支付宝','银行卡')),
pstate varchar(1) not null default '0' check(pstate in('0','1')),#表示支付状态，0表示待支付，1表示支付成功
ptime datetime not null,
pcid varchar(25) not null,

constraint fk_pi_ct_id foreign key(pcid) references customer(cid)
);

/*
-- 创建订单信息表
create table if not exists order_info(
oid varchar(25) primary key,
orid varchar(15) not null,
opid varchar(25) not null,
ocid varchar(25) not null,

constraint fk_oi_rm_id foreign key(orid) references room(rid),
constraint fk_oi_pi_id foreign key(opid) references pay_info(pid),
constraint fk_oi_ct_id foreign key(ocid) references customer(cid)
);
*/

-- 创建索引

-- 在customer上创建姓名和身份证号联合唯一索引
alter table customer 
add unique index uk_idx_name_id_card(cname,cid_card);

show index from customer;


-- 创建视图

-- 创建用于查询酒店信息的视图
create view v_ht
as 
select h.hid "酒店编号",h.hname "酒店名",h.haddress "酒店地址",h.hphone_number "酒店联系方式",h.hroom_number "酒店剩余房间数"
from hotel h;

select *
from v_ht;

-- 创建用于查询房间信息的视图
create view v_rm
as
select r.rid "房间编号",r.rnum "房间号",r.rtype "房间类型",r.rprice "房间价格",r.rf "房间属性",h.hname "房间所在酒店",h.haddress "房间所在酒店的地址",h.hphone_number "房间所在的酒店的联系电话"
from room r,hotel h 
where r.rhid =h.hid ;

select *
from v_rm vr ;

-- 创建用于查询客户预订情况的视图
create view v_oi
as
select oi.oid "订单编号",c.cname "客户姓名",c.cid_card "客户身份证号",c.cphone_number "客户联系电话",r.rnum "房间号"
from order_info oi
join customer c 
on oi.ocid = c.cid 
join room r 
on oi.orid = r.rid ;

select * from v_oi;

-- 创建用于查询入住情况的视图
#我们假设每一位顾客都是准时到达酒店办理入住
create view v_os
as
select c.cname "客户姓名",c.cphone_number "客户联系电话",r.rnum "入住房间号",bi.bstart_time "起始入住时间",bi.blength "入住时长"
from book_info bi 
join customer c on bi.bcid =c.cid 
join room r on bi.brid=r.rid
where bi.bstart_time - now() <= 0;

select * from  v_os;


-- 创建触发器

-- 创建添加预订信息后修改房间属性和酒店剩余房间数的触发器
create trigger book_hotel_room_number_insert
after insert on book_info
for each row 
begin 
	declare room_id varchar(15);
	declare hotel_id varchar(15);
	
	set room_id=new.brid;

	select r.rhid into hotel_id
	from room r 
	where r.rid = room_id;

	update room r 
	set r.rf = '1'
	where r.rid =room_id;

	update hotel h
	set h.hroom_number = h.hroom_number-1
	where h.hid = hotel_id;
end;

-- 创建删除预订信息后修改房间属性和酒店剩余房间数的触发器
create trigger book_hotel_room_number_delete
after delete on book_info
for each row 
begin 
	declare room_id varchar(15);
	declare hotel_id varchar(15);
	
	set room_id=old.brid;

	select r.rhid into hotel_id
	from room r 
	where r.rid = room_id;

	update room r 
	set r.rf = '0'
	where r.rid =room_id;

	update hotel h
	set h.hroom_number = h.hroom_number + 1
	where h.hid = hotel_id;
end;

-- 创建清理订单表后连带清理客户表和支付表中的信息的触发器
create trigger order_delete
after delete on order_info
for each row 
begin 
	declare customer_id varchar(25);
	declare pay_id varchar(25);
	declare room_id varchar(15);

	set customer_id=old.ocid;
	set pay_id=old.opid;
	set room_id=old.orid;

	delete from customer c
	where c.cid = customer_id;

	delete from pay_info p
	where p.pid = pay_id;

	delete from room r
	where r.rid = room_id;
end;

-- 创建删除酒店表后连带删除房间表中的信息的触发器
create trigger room_hotel_delete
after delete on hotel
for each row 
begin 
	declare hotel_id varchar(15);

	set hotel_id = old.hid;

	delete from room r
	where r.rhid = hotel_id;
end;

-- 创建删除房间信息后连带删除关于其它表中的信息的触发器
create trigger room_delete
after delete on room
for each row 
begin 
	declare room_id varchar(15);

	set room_id=old.rid;

	delete from order_info 
	where orid=room_id;

	delete from book_info 
	where brid = room_id;
end;



-- 插入数据

insert into customer 
values
('zhao001','赵','男','111111111111111111','14700212875','电话预订'),
('qian002','钱','男','222222222222222222','17776056193','网上预订'),
('sun0003','孙','女','333333333333333333','17808291444','网上预订'),
('li00004','李','女','444444444444444444','17092813974','电话预订'),
('zhou005','周','男','555555555555555555','15130122247','网上预订'),
('wu00006','吴','女','666666666666666666','15561196820','网上预订'),
('zheng07','郑','男','777777777777777777','14787357209','电话预订'),
('wang008','王','女','888888888888888888','15193792808','电话预订'),
('feng009','冯','女','999999999999999999','15270499367','网上预订'),
('chen010','陈','男','101010101010101010','17524111842','网上预订');

insert into hotel (hid,hname,haddress,hphone_number)
values
('jiudian001','A酒店','河南省郑州市666号','15812394380'),
('jiudian002','B酒店','陕西省西安市888号','17895204198'),
('jiudian003','C酒店','山东省济南市666号','15551137602'),
('jiudian004','D酒店','新疆乌鲁木齐888号','15068954090');


insert into room (rid,rnum,rtype,rprice,rhid)
values
('fangjian001','101','豪华套间',18888.00,'jiudian001'),
('fangjian002','102','豪华套间',18888.00,'jiudian001'),
('fangjian003','201','商务套间',8888.00,'jiudian001'),
('fangjian004','202','商务套间',8888.00,'jiudian001'),
('fangjian005','301','双人床',1888.00,'jiudian001'),
('fangjian006','302','双人床',1888.00,'jiudian001'),
('fangjian007','303','双人床',1888.00,'jiudian001'),
('fangjian008','401','单人床',888.00,'jiudian001'),
('fangjian009','402','单人床',888.00,'jiudian001'),
('fangjian010','403','单人床',888.00,'jiudian001'),
('fangjian011','101','豪华套间',18888.00,'jiudian002'),
('fangjian012','102','豪华套间',18888.00,'jiudian002'),
('fangjian013','201','商务套间',8888.00,'jiudian002'),
('fangjian014','202','商务套间',8888.00,'jiudian002'),
('fangjian015','301','双人床',1888.00,'jiudian002'),
('fangjian016','302','双人床',1888.00,'jiudian002'),
('fangjian017','303','双人床',1888.00,'jiudian002'),
('fangjian018','401','单人床',888.00,'jiudian002'),
('fangjian019','402','单人床',888.00,'jiudian002'),
('fangjian020','403','单人床',888.00,'jiudian002'),
('fangjian021','101','豪华套间',18888.00,'jiudian003'),
('fangjian022','102','豪华套间',18888.00,'jiudian003'),
('fangjian023','201','商务套间',8888.00,'jiudian003'),
('fangjian024','202','商务套间',8888.00,'jiudian003'),
('fangjian025','301','双人床',1888.00,'jiudian003'),
('fangjian026','302','双人床',1888.00,'jiudian003'),
('fangjian027','303','双人床',1888.00,'jiudian003'),
('fangjian028','401','单人床',888.00,'jiudian003'),
('fangjian029','402','单人床',888.00,'jiudian003'),
('fangjian030','403','单人床',888.00,'jiudian003'),
('fangjian031','101','豪华套间',18888.00,'jiudian004'),
('fangjian032','102','豪华套间',18888.00,'jiudian004'),
('fangjian033','201','商务套间',8888.00,'jiudian004'),
('fangjian034','202','商务套间',8888.00,'jiudian004'),
('fangjian035','301','双人床',1888.00,'jiudian004'),
('fangjian036','302','双人床',1888.00,'jiudian004'),
('fangjian037','303','双人床',1888.00,'jiudian004'),
('fangjian038','401','单人床',888.00,'jiudian004'),
('fangjian039','402','单人床',888.00,'jiudian004'),
('fangjian040','403','单人床',888.00,'jiudian004');


insert into admin 
values
('admin001','褚','前台','jiudian001'),
('admin002','卫','店长','jiudian001'),
('admin003','蒋','前台','jiudian002'),
('admin004','沈','店长','jiudian002'),
('admin005','韩','前台','jiudian003'),
('admin006','杨','店长','jiudian003'),
('admin007','朱','前台','jiudian004'),
('admin008','秦','店长','jiudian004');

insert into pay_info 
values
('zhifu001',18888.00,'微信','1','2022-06-10 12:01:12','zhao001'),
('zhifu002',888.00,'支付宝','1','2022-05-18 13:20:23','qian002'),
('zhifu003',1888.00,'银行卡','1','2022-03-20 07:30:36','sun0003'),
('zhifu004',8888.00,'支付宝','1','2022-02-21 08:08:18','li00004'),
('zhifu005',1888.00,'银行卡','1','2022-07-07 21:05:20','zhou005'),
('zhifu006',1888.00,'微信','1','2022-06-18 22:13:34','wu00006'),
('zhifu007',8888.00,'支付宝','1','2022-09-05 14:25:59','zheng07'),
('zhifu008',18888.00,'微信','1','2022-11-11 16:55:13','wang008'),
('zhifu009',888.00,'支付宝','1','2022-12-03 09:32:45','feng009'),
('zhifu010',888.00,'微信','1','2022-10-01 10:45:02','chen010');

insert into book_info 
values
('book001','2022-10-07 12:00:00',100,'zhao001','fangjian001'),
('book002','2022-11-05 11:00:00',24,'qian002','fangjian020'),
('book003','2022-12-20 10:00:00',3,'sun0003','fangjian006'),
('book004','2022-05-30 22:00:00',5,'li00004','fangjian014'),
('book005','2022-10-25 05:00:00',10,'zhou005','fangjian025'),
('book006','2022-06-16 09:00:00',48,'wu00006','fangjian035'),
('book007','2022-02-23 10:00:00',72,'zheng07','fangjian004'),
('book008','2022-09-16 15:00:00',36,'wang008','fangjian031'),
('book009','2022-04-15 16:00:00',50,'feng009','fangjian010'),
('book010','2022-03-07 18:00:00',30,'chen010','fangjian028');

-- 将订单开始时间默认设为支付时间
insert into order_info 
values
('order001','fangjian001','zhifu001','zhao001'),
('order002','fangjian020','zhifu002','qian002'),
('order003','fangjian006','zhifu003','sun0003'),
('order004','fangjian014','zhifu004','li00004'),
('order005','fangjian025','zhifu005','zhou005'),
('order006','fangjian035','zhifu006','wu00006'),
('order007','fangjian004','zhifu007','zheng07'),
('order008','fangjian031','zhifu008','wang008'),
('order009','fangjian010','zhifu009','feng009'),
('order010','fangjian028','zhifu010','chen010');


select *
from room;





















