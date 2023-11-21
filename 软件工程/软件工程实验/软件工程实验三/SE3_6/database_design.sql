/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2023/11/16 15:03:07                          */
/*==============================================================*/


drop table if exists course;

drop table if exists select_course;

drop table if exists student;

drop table if exists teacher;

/*==============================================================*/
/* Table: course                                                */
/*==============================================================*/
create table course
(
   c_id                 numeric(10,0) not null,
   t_id                 numeric(10,0) not null,
   c_name               varchar(10) not null,
   c_add                char(5) not null,
   c_t_id               numeric(10,0) not null,
   primary key (c_id)
);

/*==============================================================*/
/* Table: select_course                                         */
/*==============================================================*/
create table select_course
(
   c_id                 numeric(10,0) not null,
   s_id                 numeric(15,0) not null,
   score                int,
   primary key (c_id, s_id)
);

alter table select_course comment '一个学生可以选多门课
一门课有很多学生';

/*==============================================================*/
/* Table: student                                               */
/*==============================================================*/
create table student
(
   s_id                 numeric(15,0) not null,
   s_name               varchar(20) not null,
   s_sex                char(1) not null,
   s_profession         varchar(30) not null,
   primary key (s_id)
);

/*==============================================================*/
/* Table: teacher                                               */
/*==============================================================*/
create table teacher
(
   t_id                 numeric(10,0) not null,
   t_name               varchar(20) not null,
   t_sex                char(1) not null,
   primary key (t_id)
);

alter table course add constraint FK_授课 foreign key (t_id)
      references teacher (t_id) on delete restrict on update restrict;

alter table select_course add constraint FK_select_course foreign key (c_id)
      references course (c_id) on delete restrict on update restrict;

alter table select_course add constraint FK_select_course2 foreign key (s_id)
      references student (s_id) on delete restrict on update restrict;

