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
create view v_bi
as
select bi.bid "Ԥ�����",c.cname "�ͻ�����",c.cid_card "�ͻ����֤��",c.cphone_number "�ͻ���ϵ�绰",r.rnum "�����"
from book_info bi
join customer c 
on bi.bcid = c.cid 
join room r 
on bi.brid = r.rid ;

select * from v_bi;

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

-- �������ɶ�����Ϣ����ͼ
create view v_order_1
as
select bi.bid "Ԥ�����",c.cname "�ͻ�����",r.rnum "Ԥ�������",c.cid "�ͻ����"
from book_info bi
join customer c 
on bi.bcid = c.cid 
join room r 
on bi.brid =r.rid ;

create view v_order_2
as
select pi2.pprice "֧���۸�",pi2.pway "֧����ʽ",pi2.pstate "֧��״̬",pi2.ptime "֧��ʱ��",c.cid "�ͻ����"
from customer c 
join pay_info pi2
on c.cid = pi2.pcid ;

create view v_order
as
select vo1.Ԥ����� ,vo1.�ͻ�����, vo1.Ԥ������� ,vo2.֧��״̬ ,vo2.֧����ʽ ,vo2.֧���۸� ,vo2.֧��ʱ�� 
from v_order_1 vo1
join v_order_2 vo2
on vo1.�ͻ���� = vo2.�ͻ���� ;

select  *
from v_order vo ;

-- ������ѯԤ��ʱ�����ͼ
create view book_time
as
select c.cid "�ͻ����",c.cname "�ͻ�����",c.cid_card "�ͻ����֤��",bi.bstart_time "Ԥ����ʼʱ��",date_add(bi.bstart_time,interval bi.blength HOUR) "Ԥ������ʱ��"
from book_info bi 
join customer c 
on bi.bcid =c.cid;

select *
from book_time bt ;
