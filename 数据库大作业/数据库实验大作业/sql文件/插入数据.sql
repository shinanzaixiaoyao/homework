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

/*
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
*/