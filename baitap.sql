CREATE DATABASE IF NOT EXISTS db_app_restaurant

CREATE TABLE IF NOT EXISTS `user` (
	user_id int PRIMARY KEY AUTO_INCREMENT,
	full_name VARCHAR(255),
	email VARCHAR(255),
	password VARCHAR(255)
)

INSERT INTO user (full_name, email, password) VALUES
('tran quang a1','a1@gmail.com','123'),
('tran quang a2','a2@gmail.com','123'),
('tran quang a3','a3@gmail.com','123'),
('tran quang a4','a4@gmail.com','123'),
('tran quang a5','a5@gmail.com','123'),
('tran quang a6','a6@gmail.com','123')



CREATE TABLE IF NOT EXISTS food_type (
	type_id int PRIMARY KEY AUTO_INCREMENT,
	type_name VARCHAR(255)
)

INSERT INTO food_type (type_name) VALUES
('lau'),
('com'),
('canh')


CREATE TABLE IF NOT EXISTS food (
	food_id int PRIMARY KEY AUTO_INCREMENT,
	food_name VARCHAR(255),
	image VARCHAR(255),
	price FLOAT,
	`desc` VARCHAR(255),
	type_id int,
	FOREIGN KEY(type_id) REFERENCES food_type(type_id)
)


INSERT INTO food (food_name, image, price,`desc`,type_id) VALUES
('lau thai','hinhlauthai',120000,'cay vl',1),
('lau bo','hinhlaubo',220000,'an vo thanh con bo',1),
('com suon','hinhcs',50000,'an cung duoc',2),
('com chay','hinhcchay',70000,'cong duc vo luong',2),
('canh chua caloc','hinhcanhc',100000,'chua vl',3),
('canh khoai mo','hinhcanhkh',130000,'nong vl',3)

CREATE TABLE IF NOT EXISTS sub_food (
	sub_id int PRIMARY KEY AUTO_INCREMENT,
	sub_name VARCHAR(255),
	sub_price FLOAT,
	food_id int,
	FOREIGN KEY(food_id) REFERENCES food(food_id)
)

INSERT INTO sub_food (sub_name, sub_price, food_id) VALUES
('lau thai chay',200000,1),
('lau thai co tom hum',1200000,1),
('lau bo co dui bo',300000,2),
('lau bo chay',200000,2)

CREATE TABLE IF NOT EXISTS restaurant (
	res_id int PRIMARY KEY AUTO_INCREMENT,
	res_name VARCHAR(255),
	image VARCHAR(255),
	`desc` VARCHAR(255)
)

INSERT INTO restaurant (res_name, image, `desc`) VALUES
('Nha Hang A Teo','anhnh1','Ngon, Bo, Ko Re'),
('Nha Hang A Ti','anhnh1','Ngon, ko Bo, Re'),
('Nha Hang A Tai','anhnh1','ko Ngon, Bo, Re')



CREATE TABLE IF NOT EXISTS `order` (
	user_id int ,
	food_id int,
	amount int,
	code VARCHAR(255),
	arr_sub_id VARCHAR(255),
	FOREIGN KEY(user_id) REFERENCES `user`(user_id),
	FOREIGN KEY(food_id) REFERENCES food(food_id)
)


INSERT INTO `order` (user_id, food_id, amount,code,arr_sub_id) VALUES
(1,1,2,'aaazzz',11),
(2,1,3,'aaaxxx',12),
(1,4,1,'aaaxzz',13),
(3,5,1,'aaaxzx',14),
(6,3,3,'aaaxkk',10)

CREATE TABLE IF NOT EXISTS rate_res (
	user_id int ,
	res_id int,
	amount int,
	date_rate datetime,
	FOREIGN KEY(user_id) REFERENCES `user`(user_id),
	FOREIGN KEY(res_id) REFERENCES restaurant(res_id)
)

INSERT INTO rate_res (user_id, res_id, amount,date_rate) VALUES
(2,1,5,'2024-12-06'),
(3,2,3,'2024-12-06'),
(4,1,2,'2024-12-06'),
(1,2,4,'2024-12-06'),
(3,3,5,'2024-12-06')

CREATE TABLE IF NOT EXISTS like_res (
	user_id int,
	res_id int,
	date_like datetime,
	FOREIGN KEY(user_id) REFERENCES `user`(user_id),
	FOREIGN KEY(res_id) REFERENCES restaurant(res_id)
)

INSERT INTO like_res (user_id, res_id,date_like) VALUES
(1,3,'2024-12-04'),
(1,2,'2024-12-04'),
(2,1,'2024-12-03'),
(6,2,'2024-12-03')


-- Tìm 05 người like nhiều nhất
select like_res.user_id, `user`.full_name, COUNT(like_res.user_id) as like_amount from like_res inner join `user` on like_res.user_id=`user`.user_id group by (like_res.user_id)  order by like_amount desc limit 5

-- Tìm 02 nhà hàng có lượt like nhiều nhất
select like_res.res_id, restaurant.res_name, COUNT(like_res.res_id) as like_amount  from like_res inner join restaurant on like_res.res_id=restaurant.res_id group by (like_res.res_id)  order by like_amount desc limit 2

-- Tìm người đã đặt hàng nhiều nhất
SELECT `user`.*, SUM(`order`.amount) as soluongmua from `order` inner join `user` on `order`.user_id=`user`.user_id group by (`order`.user_id)  order by soluongmua desc limit 5

-- Tìm người dùng không hoạt động
select *  from (`order` RIGHT join `user` on `order`.user_id=`user`.user_id) 
LEFT join like_res on `user`.user_id=like_res.user_id 
LEFT join rate_res on `user`.user_id=rate_res.user_id 
where `order`.user_id is NULL and like_res.user_id is NULL and rate_res.user_id is NULL