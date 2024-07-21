create database quanlysinhvien;
use quanlysinhvien;

create table Classes (
	class_id int auto_increment primary key,
    class_name varchar(255) unique not null,
    start_date date not null,
    status bit(1) default 1
);

create table Student (
	student_id int auto_increment primary key,
    student_name varchar(100) unique not null,
    address varchar(255) not null,
    phone varchar(11) unique not null,
    status bit ,
    class_id int not null,
    foreign key (class_id) references Classes (class_id)
);

create table Subjects (
	sub_id int auto_increment primary key,
    sub_name varchar(255) unique not null,
    credit int default 1 check (credit >= 1),
    status bit(1) default 1
);

create table Mark (
	mark_id int auto_increment primary key,
    subject_id int not null,
    foreign key (subject_id) references Subjects (sub_id),
    student_id int not null,
    foreign key (student_id) references Student (student_id),
    mark double default 0 check(mark between 0 and 100),
    examtime int default 1
);

insert into Classes(class_name,start_date, status) values
('HN-JV231103', str_to_date('03/11/2023' , '%d/%m/%Y'),1),
('HN-JV231229',  str_to_date('29/12/2023' , '%d/%m/%Y'), 1),
('HN-JV230615',  str_to_date('15/06/2023' , '%d/%m/%Y'), 1);

select * from Classes;

insert into Student(student_name, address, phone, status, class_id) values 
('Hồ Gia Hùng', 'Hà Nội', '0987654321', 1, 1),
('Phan Văn Giang', 'Đã Nẵng', '0967811255', 1, 1),
-- ('Dương Mỹ Duyên', 'Hà Nội' '0385546611', 1, 2),
('Hoàng Minh Hiếu', 'Nghệ An', '0964425633', 1, 2),
('Nguyễn Vịnh', 'Hà nội', '0975123552', 1, 3),
('Nam Cao', 'Hà Tĩnh', '0919191919', 1, 1),
('Nguyễn Du', 'Nghệ An', '0353535353', 1, 3),
('Dương Mỹ Duyên', 'Hà Nội' ,'0385546611', 1, 2);



insert into Subjects (sub_name, credit, status) values
('Toán', 3, 1),
('Văn', 3, 1),
('Anh', 2, 1);

insert into Mark (subject_id, student_id, mark, examtime) values
(1, 1, 7, str_to_date('12/05/2024' , '%d/%m/%Y')),
(1, 1, 7, str_to_date('15/03/2024' , '%d/%m/%Y')),
(2, 2, 8, str_to_date('15/05/2024' , '%d/%m/%Y')),
(2, 3, 9, str_to_date('08/03/2024' , '%d/%m/%Y')),
(3, 3, 10, str_to_date('11/02/2024' , '%d/%m/%Y'));

-- Hiển thị tất cả lớp học được sắp xếp theo tên giảm dần
select * from Classes order by class_name  desc;
-- Hiển thị tất cả học sinh có address ở “Hà Nội”
select * from Student where address = 'Hà Nội';
-- Hiển thị tất cả học sinh thuộc lớp HN-JV231103
select student_name from Classes c inner join Student s on s.class_id = c.class_id where c.class_name = 'HN-JV231103';
-- Hiển thị tát cả các môn học có credit trên 2
select * from Subjects where credit > 2;
-- Hiển thị tất cả học sinh có phone bắt đầu bằng số 09
select * from Student where phone like '09%';


-- Tạo store procedure lấy ra tất cả lớp học có số lượng học sinh lớn hơn 5
delimiter //
create procedure get_all_class_5()
begin
	select c.class_name ,sum(s.class_id) as Số_lượng  from Classes c
    join Student s on c.class_id = s.class_id
    group by c.class_id
    having Số_lượng > 5;
end; //
delimiter ;

call  get_all_class_5();

-- Tạo store procedure hiển thị ra danh sách môn học có điểm thi là 10
delimiter //
create procedure get_list_diem_thi()
begin
	select s.sub_name, m.mark
    from Subjects s 
    join Mark m on s.sub_id = m.subject_id
     where m.mark = 10
     group by s.sub_name;
end; //
delimiter ;

call get_list_diem_thi();

-- Tạo store procedure hiển thị thông tin các lớp học có học sinh đạt điểm 10
delimiter //
create procedure get_class_with_10()
begin
    select c.class_name, s.student_name, m.mark
    from Classes c
    join Student s on c.class_id = s.class_id
    join Mark m on s.student_id = m.student_id
    where m.mark = 10
    order by c.class_name;
end; //
delimiter ;

call get_class_with_10();

-- Tạo store procedure thêm mới student và trả ra id vừa mới thêm
delimiter //
create procedure add_new_student(
	student_name_in varchar(100),
    address_in varchar(255),
    phone_in varchar(11),
    status_in bit,
    class_id_in int
)
begin
    insert into Student (student_name, address, phone, status, class_id)
    values (student_name_in, address_in, phone_in, status_in, class_id_in);
    select last_insert_id() as student_id_in;
end; //
delimiter ;

call add_new_student('Nguyễn Thị Khánh Vy', 'Nghệ An', '0987654565', 1, 1);


-- Tạo store procedure hiển thị subject chưa được ai thi

delimiter //
create procedure get_subjects_without_exam()
begin
    select s.sub_name
    from Subjects s
    left join Mark m on s.sub_id = m.subject_id
    where m.mark is null
    group by s.sub_name;
end; //
delimiter ;

call get_subjects_without_exam();