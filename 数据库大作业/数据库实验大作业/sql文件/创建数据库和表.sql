-- �������ݿ�
create database if not exists hotel_management_system character set 'utf8';


-- ʹ�����ݿ�
use hotel_management_system;


-- ��������Ϣ

-- �����ͻ���Ϣ��
create table if not exists customer(
cid varchar(25) primary key,
cname varchar(20) not null,
csex char(1) not null,
cid_card varchar(20) not null unique,
cphone_number varchar(15) not null unique,
bookmethod varchar(15) not null check(bookmethod = '�绰Ԥ��' or bookmethod = '����Ԥ��')
);


-- �����Ƶ���Ϣ��
create table if not exists hotel(
hid varchar(15) primary key,
hname varchar(20) not null,
haddress varchar(50) not null,
hphone_number varchar(15) not null,
hroom_number smallint not null default 600 #��ʾ�Ƶ�ʣ��ķ������������Ƶ��ʼ����������Ϊ600��
);


-- ����������Ϣ��
create table if not exists room(
rid varchar(15) primary key,
rnum varchar(5) not null,
rtype varchar(15) not null check(rtype in('���˴�','˫�˴�','�����׼�','�����׼�')),#��������
rprice decimal(8,2) not null,
rf varchar(1) not null default '0' check(rf in('0','1')),#����״̬��������䱻Ԥ��������ס������Ϊ1��������Ϊ0
rhid varchar(15) not null,

constraint fk_rm_ht_id foreign key(rhid) references hotel(hid)
);


-- �����Ƶ����Ա��Ϣ��
create table if not exists admin(
aid varchar(15) primary key,
aname varchar(20) not null,
apost varchar(15) not null,
ahid varchar(15) not null,

constraint fk_ad_ht_id foreign key(ahid) references hotel(hid)
);


-- ����Ԥ����Ϣ��
create table if not exists book_info(
bid varchar(15) primary key,
bstart_time datetime not null,#����Ԥ������ʼʱ��
blength smallint not null,#����Ԥ����ʱ������СʱΪ��λ��smallint�ķ�ΧΪ��0~65535�������7~8�꣬tinyint�ķ�ΧΪ��0~255�������10�����ң�̫�٣����ʺϣ�
bcid varchar(25) not null,
brid varchar(15) not null,

constraint fk_bi_ct_id foreign key(bcid) references customer(cid),
constraint fk_bi_rm_id foreign key(brid) references room(rid)
);


-- ����֧����Ϣ��
create table if not exists pay_info(
pid varchar(25) primary key,
pprice decimal(8,2) not null,
pway varchar(10) not null check(pway in('΢��','֧����','���п�')),
pstate varchar(1) not null default '0' check(pstate in('0','1')),#��ʾ֧��״̬��0��ʾ��֧����1��ʾ֧���ɹ�
ptime datetime not null,
pcid varchar(25) not null,

constraint fk_pi_ct_id foreign key(pcid) references customer(cid)
);

/*
-- ����������Ϣ��
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

-- ��������

-- ��customer�ϴ������������֤������Ψһ����
alter table customer 
add unique index uk_idx_name_id_card(cname,cid_card);

show index from customer;


-- ������ͼ

-- �������ڲ�ѯ�Ƶ���Ϣ����ͼ
create view v_ht
as 
select h.hid "�Ƶ���",h.hname "�Ƶ���",h.haddress "�Ƶ��ַ",h.hphone_number "�Ƶ���ϵ��ʽ",h.hroom_number "�Ƶ�ʣ�෿����"
from hotel h;

select *
from v_ht;

-- �������ڲ�ѯ������Ϣ����ͼ
create view v_rm
as
select r.rid "������",r.rnum "�����",r.rtype "��������",r.rprice "����۸�",r.rf "��������",h.hname "�������ھƵ�",h.haddress "�������ھƵ�ĵ�ַ",h.hphone_number "�������ڵľƵ����ϵ�绰"
from room r,hotel h 
where r.rhid =h.hid ;

select *
from v_rm vr ;

-- �������ڲ�ѯ�ͻ�Ԥ���������ͼ
create view v_oi
as
select oi.oid "�������",c.cname "�ͻ�����",c.cid_card "�ͻ����֤��",c.cphone_number "�ͻ���ϵ�绰",r.rnum "�����"
from order_info oi
join customer c 
on oi.ocid = c.cid 
join room r 
on oi.orid = r.rid ;

select * from v_oi;

-- �������ڲ�ѯ��ס�������ͼ
#���Ǽ���ÿһλ�˿Ͷ���׼ʱ����Ƶ������ס
create view v_os
as
select c.cname "�ͻ�����",c.cphone_number "�ͻ���ϵ�绰",r.rnum "��ס�����",bi.bstart_time "��ʼ��סʱ��",bi.blength "��סʱ��"
from book_info bi 
join customer c on bi.bcid =c.cid 
join room r on bi.brid=r.rid
where bi.bstart_time - now() <= 0;

select * from  v_os;


-- ����������

-- �������Ԥ����Ϣ���޸ķ������Ժ;Ƶ�ʣ�෿�����Ĵ�����
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

-- ����ɾ��Ԥ����Ϣ���޸ķ������Ժ;Ƶ�ʣ�෿�����Ĵ�����
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

-- ���������������������ͻ����֧�����е���Ϣ�Ĵ�����
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

-- ����ɾ���Ƶ�������ɾ��������е���Ϣ�Ĵ�����
create trigger room_hotel_delete
after delete on hotel
for each row 
begin 
	declare hotel_id varchar(15);

	set hotel_id = old.hid;

	delete from room r
	where r.rhid = hotel_id;
end;

-- ����ɾ��������Ϣ������ɾ�������������е���Ϣ�Ĵ�����
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



-- ��������

insert into customer 
values
('zhao001','��','��','111111111111111111','14700212875','�绰Ԥ��'),
('qian002','Ǯ','��','222222222222222222','17776056193','����Ԥ��'),
('sun0003','��','Ů','333333333333333333','17808291444','����Ԥ��'),
('li00004','��','Ů','444444444444444444','17092813974','�绰Ԥ��'),
('zhou005','��','��','555555555555555555','15130122247','����Ԥ��'),
('wu00006','��','Ů','666666666666666666','15561196820','����Ԥ��'),
('zheng07','֣','��','777777777777777777','14787357209','�绰Ԥ��'),
('wang008','��','Ů','888888888888888888','15193792808','�绰Ԥ��'),
('feng009','��','Ů','999999999999999999','15270499367','����Ԥ��'),
('chen010','��','��','101010101010101010','17524111842','����Ԥ��');

insert into hotel (hid,hname,haddress,hphone_number)
values
('jiudian001','A�Ƶ�','����ʡ֣����666��','15812394380'),
('jiudian002','B�Ƶ�','����ʡ������888��','17895204198'),
('jiudian003','C�Ƶ�','ɽ��ʡ������666��','15551137602'),
('jiudian004','D�Ƶ�','�½���³ľ��888��','15068954090');


insert into room (rid,rnum,rtype,rprice,rhid)
values
('fangjian001','101','�����׼�',18888.00,'jiudian001'),
('fangjian002','102','�����׼�',18888.00,'jiudian001'),
('fangjian003','201','�����׼�',8888.00,'jiudian001'),
('fangjian004','202','�����׼�',8888.00,'jiudian001'),
('fangjian005','301','˫�˴�',1888.00,'jiudian001'),
('fangjian006','302','˫�˴�',1888.00,'jiudian001'),
('fangjian007','303','˫�˴�',1888.00,'jiudian001'),
('fangjian008','401','���˴�',888.00,'jiudian001'),
('fangjian009','402','���˴�',888.00,'jiudian001'),
('fangjian010','403','���˴�',888.00,'jiudian001'),
('fangjian011','101','�����׼�',18888.00,'jiudian002'),
('fangjian012','102','�����׼�',18888.00,'jiudian002'),
('fangjian013','201','�����׼�',8888.00,'jiudian002'),
('fangjian014','202','�����׼�',8888.00,'jiudian002'),
('fangjian015','301','˫�˴�',1888.00,'jiudian002'),
('fangjian016','302','˫�˴�',1888.00,'jiudian002'),
('fangjian017','303','˫�˴�',1888.00,'jiudian002'),
('fangjian018','401','���˴�',888.00,'jiudian002'),
('fangjian019','402','���˴�',888.00,'jiudian002'),
('fangjian020','403','���˴�',888.00,'jiudian002'),
('fangjian021','101','�����׼�',18888.00,'jiudian003'),
('fangjian022','102','�����׼�',18888.00,'jiudian003'),
('fangjian023','201','�����׼�',8888.00,'jiudian003'),
('fangjian024','202','�����׼�',8888.00,'jiudian003'),
('fangjian025','301','˫�˴�',1888.00,'jiudian003'),
('fangjian026','302','˫�˴�',1888.00,'jiudian003'),
('fangjian027','303','˫�˴�',1888.00,'jiudian003'),
('fangjian028','401','���˴�',888.00,'jiudian003'),
('fangjian029','402','���˴�',888.00,'jiudian003'),
('fangjian030','403','���˴�',888.00,'jiudian003'),
('fangjian031','101','�����׼�',18888.00,'jiudian004'),
('fangjian032','102','�����׼�',18888.00,'jiudian004'),
('fangjian033','201','�����׼�',8888.00,'jiudian004'),
('fangjian034','202','�����׼�',8888.00,'jiudian004'),
('fangjian035','301','˫�˴�',1888.00,'jiudian004'),
('fangjian036','302','˫�˴�',1888.00,'jiudian004'),
('fangjian037','303','˫�˴�',1888.00,'jiudian004'),
('fangjian038','401','���˴�',888.00,'jiudian004'),
('fangjian039','402','���˴�',888.00,'jiudian004'),
('fangjian040','403','���˴�',888.00,'jiudian004');


insert into admin 
values
('admin001','��','ǰ̨','jiudian001'),
('admin002','��','�곤','jiudian001'),
('admin003','��','ǰ̨','jiudian002'),
('admin004','��','�곤','jiudian002'),
('admin005','��','ǰ̨','jiudian003'),
('admin006','��','�곤','jiudian003'),
('admin007','��','ǰ̨','jiudian004'),
('admin008','��','�곤','jiudian004');

insert into pay_info 
values
('zhifu001',18888.00,'΢��','1','2022-06-10 12:01:12','zhao001'),
('zhifu002',888.00,'֧����','1','2022-05-18 13:20:23','qian002'),
('zhifu003',1888.00,'���п�','1','2022-03-20 07:30:36','sun0003'),
('zhifu004',8888.00,'֧����','1','2022-02-21 08:08:18','li00004'),
('zhifu005',1888.00,'���п�','1','2022-07-07 21:05:20','zhou005'),
('zhifu006',1888.00,'΢��','1','2022-06-18 22:13:34','wu00006'),
('zhifu007',8888.00,'֧����','1','2022-09-05 14:25:59','zheng07'),
('zhifu008',18888.00,'΢��','1','2022-11-11 16:55:13','wang008'),
('zhifu009',888.00,'֧����','1','2022-12-03 09:32:45','feng009'),
('zhifu010',888.00,'΢��','1','2022-10-01 10:45:02','chen010');

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

-- ��������ʼʱ��Ĭ����Ϊ֧��ʱ��
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





















