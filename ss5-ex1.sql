use quanlybanhang;

-- Tạo view hiển thị tất cả customer

create view allcustomer as select * from customer;

-- Tạo view hiển thị tất cả order có oTotalPrice trên 150000

select * from orders;



create view orderPrice as select * from orders where ototalprice > 150000;

-- Đánh index cho bảng customer ở cột cName 

Create index indexCustomer on Customer(cName);

select * from customer;

show index from customer;

-- Đánh index cho bảng product ở cột pName

Create index indexProduct on Product(pName);

show index from Product;

-- Tạo store procedure hiển thị ra đơn hàng có tổng tiền bé nhất

delimiter //
create procedure showMinOrder()
begin
select * from orders o order by o.ototalprice asc limit 1;

-- asc sắp xếp từ bé đến lớn
-- desc sắp xếp lớn đến bé
-- limit 1: lấy phần từ đầu tiên

end //

call showMinOrder();

-- Tạo store procedure hiển thị người dùng nào mua sản phẩm “May Giat” ít nhất 

delimiter //
-- cú pháp để phân cách các câu lệnh trong SQL 
create procedure showMinProduct()
begin
	select c.cname, count(od.odqty) as number_maygiat
    from customer c
    join orders o on c.cid = o.cid
    join orderdetail od on o.oid = od.oid
    join product p on od.pid = p.pid
    where p.pname = 'May Giat'
    group by c.cname
    order by number_maygiat asc
    limit 1;


end; //

call showMinProduct();
select * from product;
select * from customer;
select * from orders;
select * from orderdetail;







 








