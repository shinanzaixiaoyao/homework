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

-- ����ɾ��Ԥ����Ϣ���޸ķ������Ժ;Ƶ�ʣ�෿������ɾ����صĿͻ���ú�֧�����е������Ϣ�Ĵ�����
create trigger book_hotel_room_number_delete
after delete on book_info
for each row 
begin 
	declare room_id varchar(15);
	declare hotel_id varchar(15);
	declare customer_id varchar(25);
	
	set room_id=old.brid;
	set customer_id = old.bcid;

	select r.rhid into hotel_id
	from room r 
	where r.rid = room_id;

	update room r 
	set r.rf = '0'
	where r.rid =room_id;

	update hotel h
	set h.hroom_number = h.hroom_number + 1
	where h.hid = hotel_id;

	delete from pay_info p
	where p.pcid = customer_id;

	delete from customer c
	where c.cid = customer_id;
end;

/*
-- ���������������������ͻ����֧�����е���Ϣ�Ĵ�����
create trigger order_delete
before delete on order_info
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

-- ����ɾ���Ƶ�������ɾ�������;Ƶ����Ա���е���Ϣ�Ĵ�����
create trigger room_hotel_admin_delete
before delete on hotel
for each row 
begin 
	declare hotel_id varchar(15);

	set hotel_id = old.hid;

	delete from room r
	where r.rhid = hotel_id;

	delete from admin a
	where a.ahid = hotel_id;
end;

-- ����ɾ��������Ϣ������ɾ�������������е���Ϣ�Ĵ�����
create trigger room_delete
before delete on room
for each row 
begin 
	declare room_id varchar(15);

	set room_id=old.rid;

	delete from order_info 
	where orid=room_id;

	delete from book_info 
	where brid = room_id;
end;
*/