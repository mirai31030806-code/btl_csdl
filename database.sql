CREATE DATABASE IF NOT EXISTS bus_manager CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE bus_manager;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS revenues;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS manager_accounts;
SET FOREIGN_KEY_CHECKS = 1;

-- XE_KHACH
CREATE TABLE vehicles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license_plate VARCHAR(20) NOT NULL UNIQUE,
    color VARCHAR(40),
    manufacturer VARCHAR(100),
    manufacture_year SMALLINT,
    model VARCHAR(100),
    brand VARCHAR(100) NOT NULL,
    seat_count INT NOT NULL,
    years_used INT DEFAULT 0,
    last_maintenance DATE,
    inspection_expiry DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Sẵn sàng',
    CONSTRAINT chk_vehicle_seats CHECK (seat_count > 2)
);

-- NHAN_VIEN
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    national_id VARCHAR(20),
    license_code VARCHAR(30),
    role VARCHAR(30) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_type VARCHAR(20) DEFAULT 'Không',
    address VARCHAR(255),
    birth_date DATE,
    seniority INT DEFAULT 0
);

-- TUYEN_XE
CREATE TABLE routes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    route_code VARCHAR(20) NOT NULL UNIQUE,
    start_point VARCHAR(120) NOT NULL,
    end_point VARCHAR(120) NOT NULL,
    distance_km DECIMAL(8,2) NOT NULL,
    complexity_level TINYINT NOT NULL,
    ticket_price BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT chk_route_distance CHECK (distance_km > 0),
    CONSTRAINT chk_route_complexity CHECK (complexity_level BETWEEN 1 AND 3)
);

-- CHUYEN_XE
CREATE TABLE trips (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_code VARCHAR(20) NOT NULL UNIQUE,
    route_id INT NOT NULL,
    route_name VARCHAR(120) NOT NULL,
    vehicle_id INT NOT NULL,
    driver_id INT NOT NULL,
    assistant_id INT NULL,
    departure_time DATETIME NOT NULL,
    passenger_count INT DEFAULT 0,
    ticket_price BIGINT NOT NULL DEFAULT 0,
    status VARCHAR(30) DEFAULT 'Sắp khởi hành',
    CONSTRAINT fk_trip_route FOREIGN KEY (route_id) REFERENCES routes(id),
    CONSTRAINT fk_trip_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id),
    CONSTRAINT fk_trip_driver FOREIGN KEY (driver_id) REFERENCES employees(id),
    CONSTRAINT fk_trip_assistant FOREIGN KEY (assistant_id) REFERENCES employees(id),
    CONSTRAINT chk_trip_passengers CHECK (passenger_count >= 0)
);

-- PHAN_CONG
CREATE TABLE assignments (
    trip_id INT NOT NULL,
    role VARCHAR(20) NOT NULL,
    employee_id INT NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (trip_id, role),
    CONSTRAINT fk_assignment_trip FOREIGN KEY (trip_id) REFERENCES trips(id) ON DELETE CASCADE,
    CONSTRAINT fk_assignment_employee FOREIGN KEY (employee_id) REFERENCES employees(id),
    CONSTRAINT chk_assignment_role CHECK (role IN ('Tài xế', 'Phụ xe'))
);

CREATE TABLE revenues (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trip_id INT NOT NULL,
    ticket_revenue BIGINT NOT NULL DEFAULT 0,
    cargo_revenue BIGINT NOT NULL DEFAULT 0,
    recorded_date DATE NOT NULL,
    FOREIGN KEY (trip_id) REFERENCES trips(id)
);

CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    expense_type VARCHAR(80) NOT NULL,
    amount BIGINT NOT NULL DEFAULT 0,
    expense_date DATE NOT NULL,
    note VARCHAR(255),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(id)
);

CREATE TABLE manager_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL
);

-- DU LIEU XE KHACH (25 xe)
INSERT INTO vehicles (id, license_plate, color, manufacturer, manufacture_year, model, brand, seat_count, years_used, last_maintenance, inspection_expiry, status) VALUES
(1,'98B-214.13','Vàng cát','Thaco',2020,'Limousine','Limousine 24 Phòng Đôi',24,6,'2026-07-05','2027-01-31','Sẵn sàng'),
(2,'98B-858.79','Trắng','Samco',2022,'Primas','Samco Primas 34 Giường',34,4,'2026-04-01','2027-01-26','Đang chạy'),
(3,'30G-338.74','Bạc','Thaco',2023,'Mobihome','Thaco Mobihome 34 Giường',34,3,'2026-07-23','2027-11-07','Bảo dưỡng'),
(4,'99B-658.63','Đen','Thaco',2023,'Bluesky','Thaco Bluesky 45 Ghế',45,3,'2026-08-26','2026-12-13','Sẵn sàng'),
(5,'51B-925.30','Vàng cát','Thaco',2021,'Bluesky','Thaco Bluesky 45 Ghế',45,5,'2026-08-05','2027-03-30','Sẵn sàng'),
(6,'51B-444.23','Trắng','Thaco',2019,'Bluesky','Thaco Bluesky 45 Ghế',45,7,'2026-09-28','2027-06-04','Đang chạy'),
(7,'38B-370.15','Vàng cát','Thaco',2023,'Bluesky','Thaco Bluesky 45 Ghế',45,3,'2026-05-13','2027-01-19','Bảo dưỡng'),
(8,'36B-400.90','Bạc','Daewoo',2021,'BX212','Daewoo BX212 42 Giường',42,5,'2026-07-23','2027-01-14','Sẵn sàng'),
(9,'29B-777.39','Xám','Thaco',2019,'Limousine','Limousine 24 Phòng Đôi',24,7,'2026-07-28','2027-01-30','Sẵn sàng'),
(10,'14B-384.68','Vàng cát','Daewoo',2021,'BX212','Daewoo BX212 42 Giường',42,5,'2026-06-12','2027-06-09','Đang chạy'),
(11,'30G-786.44','Vàng cát','Hyundai',2024,'Solati','Hyundai Solati Limousine 16 Chỗ',16,2,'2026-05-20','2027-10-31','Bảo dưỡng'),
(12,'30E-646.41','Đen','Thaco',2022,'Bluesky','Thaco Bluesky 45 Ghế',45,4,'2026-08-21','2027-09-21','Sẵn sàng'),
(13,'30G-801.51','Xám','Daewoo',2025,'BX212','Daewoo BX212 42 Giường',42,1,'2026-04-08','2026-12-26','Sẵn sàng'),
(14,'51B-423.61','Đỏ','Thaco',2020,'Mobihome','Thaco Mobihome 34 Giường',34,6,'2026-09-07','2027-11-10','Đang chạy'),
(15,'24B-505.92','Xanh dương','Hyundai',2021,'Universe','Hyundai Universe 40 Giường',40,5,'2026-06-08','2027-09-23','Bảo dưỡng'),
(16,'36B-369.84','Xanh dương','Samco',2022,'Primas','Samco Primas 34 Giường',34,4,'2026-09-08','2027-02-18','Sẵn sàng'),
(17,'36B-605.21','Xám','Thaco',2025,'Mobihome','Thaco Mobihome 34 Giường',34,1,'2026-05-05','2027-10-27','Sẵn sàng'),
(18,'30E-911.97','Xanh dương','Samco',2019,'Primas','Samco Primas 34 Giường',34,7,'2026-10-13','2027-10-11','Đang chạy'),
(19,'24B-641.42','Bạc','Daewoo',2019,'BX212','Daewoo BX212 42 Giường',42,7,'2026-05-22','2027-09-10','Bảo dưỡng'),
(20,'51B-373.92','Đỏ','Thaco',2021,'Mobihome','Thaco Mobihome 34 Giường',34,5,'2026-10-06','2027-07-30','Sẵn sàng'),
(21,'29B-839.43','Bạc','Daewoo',2020,'BX212','Daewoo BX212 42 Giường',42,6,'2026-05-28','2027-10-26','Sẵn sàng'),
(22,'37B-961.91','Bạc','Samco',2020,'Primas','Samco Primas 34 Giường',34,6,'2026-06-12','2027-03-02','Đang chạy'),
(23,'36B-897.77','Trắng','Samco',2021,'Primas','Samco Primas 34 Giường',34,5,'2026-11-01','2027-02-05','Bảo dưỡng'),
(24,'15B-999.49','Đen','Thaco',2020,'Mobihome','Thaco Mobihome 34 Giường',34,6,'2026-05-03','2027-08-15','Sẵn sàng'),
(25,'49B-170.78','Xám','Hyundai',2020,'Universe','Hyundai Universe 40 Giường',40,6,'2026-11-18','2027-03-04','Sẵn sàng');

-- DU LIEU NHAN VIEN (28 nhan vien)
INSERT INTO employees (id, full_name, national_id, license_code, role, phone, license_type, address, birth_date, seniority) VALUES
(1,'Hoàng Công Thắng','001086000001','GPLX001','Tài xế','0982383095','Hạng E','Thanh Hóa','1991-05-13',13),
(2,'Đỗ Tiến Kiên','001094000002','GPLX002','Tài xế','0979467853','Hạng E','Bắc Ninh','1981-04-08',20),
(3,'Trần Thanh Hùng','001098000003','GPLX003','Tài xế','0984346088','Hạng E','Thanh Hóa','1989-04-01',15),
(4,'Trần Ngọc Tuấn','001087000004','GPLX004','Tài xế','0919046318','Hạng E','Hà Nội','1993-06-03',11),
(5,'Bùi Đức Sơn','001095000005','GPLX005','Tài xế','0938754377','Hạng E','Thái Bình','1982-12-19',20),
(6,'Đặng Hữu Phong','001095000006','GPLX006','Tài xế','0964634663','Hạng E','Thanh Hóa','1981-02-22',20),
(7,'Phan Thanh Thắng','001093000007','GPLX007','Tài xế','0972682989','Hạng E','Hà Nội','1990-11-21',14),
(8,'Trần Văn Bình','001090000008','GPLX008','Tài xế','0924665841','Hạng E','Thanh Hóa','1983-04-18',20),
(9,'Trương Hoàng Thắng','001085000009','GPLX009','Tài xế','0947385696','Hạng E','Bắc Ninh','1983-02-15',20),
(10,'Dương Công Anh','001081000010','GPLX010','Tài xế','0997529405','Hạng E','Thái Bình','1993-01-03',11),
(11,'Dương Đức Hải','001093000011','GPLX011','Tài xế','0975181648','Hạng E','Bắc Ninh','1983-07-02',20),
(12,'Lê Tuấn Hùng','001092000012','GPLX012','Tài xế','0945594951','Hạng E','Bắc Ninh','1984-07-23',20),
(13,'Ngô Công Quân','001084000013','GPLX013','Tài xế','0935487660','Hạng E','Quảng Ninh','1983-01-19',20),
(14,'Ngô Công Tuấn','001090000014','GPLX014','Tài xế','0917672593','Hạng E','Hà Nội','1989-08-17',15),
(15,'Bùi Hoàng Tuấn','001096000015','GPLX015','Tài xế','0920752378','Hạng E','Hải Phòng','1981-10-03',20),
(16,'Đỗ Đức Bình','001083000016','GPLX016','Tài xế','0986460539','Hạng E','Thanh Hóa','1989-10-02',15),
(17,'Đặng Minh Thắng','001098000017',NULL,'Phụ xe','0985863473','Không','Thái Bình','1997-05-07',7),
(18,'Đỗ Ngọc Cường','001087000018',NULL,'Phụ xe','0945650176','Không','Ninh Bình','1994-11-21',10),
(19,'Hoàng Hữu Cường','001082000019',NULL,'Phụ xe','0911250299','Không','Bắc Ninh','2001-10-04',3),
(20,'Trần Công Long','001096000020',NULL,'Phụ xe','0945594597','Không','Hải Phòng','1997-02-08',7),
(21,'Vũ Quốc Hải','001094000021',NULL,'Phụ xe','0982909480','Không','Quảng Ninh','2001-11-17',3),
(22,'Nguyễn Tiến Tùng','001083000022',NULL,'Phụ xe','0928024248','Không','Quảng Ninh','1993-02-24',11),
(23,'Bùi Hoàng Sơn','001089000023',NULL,'Phụ xe','0991178885','Không','Thanh Hóa','1997-04-22',7),
(24,'Đỗ Quốc Vinh','001095000024',NULL,'Phụ xe','0943704923','Không','Hà Nội','1993-11-14',11),
(25,'Hoàng Văn Hùng','001090000025',NULL,'Phụ xe','0927558317','Không','Quảng Ninh','1994-12-15',10),
(26,'Bùi Ngọc Thắng','001097000026',NULL,'Điều hành','0911297845','Không','Nghệ An','1993-12-05',11),
(27,'Bùi Thị Hà','001098000027',NULL,'Điều hành','0984158663','Không','Hải Phòng','1998-03-02',6),
(28,'Hoàng Thanh Tuấn','001091000028',NULL,'Điều hành','0938195995','Không','Thanh Hóa','2002-02-12',2);

-- DU LIEU TUYEN XE (22 tuyen)
INSERT INTO routes (id, route_code, start_point, end_point, distance_km, complexity_level, ticket_price) VALUES
(1,'T-001','Hà Nội','Nghệ An',300,2,250000),
(2,'T-002','Hà Nội','Đà Nẵng',760,3,550000),
(3,'T-003','Hà Nội','Lào Cai',290,2,280000),
(4,'T-004','Sài Gòn','Đà Lạt',300,3,320000),
(5,'T-005','Hà Nội','Hải Phòng',120,1,130000),
(6,'T-006','Hà Nội','Quảng Ninh',165,1,180000),
(7,'T-007','Hà Nội','Thanh Hóa',160,1,150000),
(8,'T-008','Hà Nội','Hà Tĩnh',350,2,290000),
(9,'T-009','Hà Nội','Quảng Bình',490,2,380000),
(10,'T-010','Hà Nội','Huế',660,3,480000),
(11,'T-011','Hà Nội','Sơn La',310,3,300000),
(12,'T-012','Hà Nội','Điện Biên',475,3,420000),
(13,'T-013','Hà Nội','Hà Giang',300,3,310000),
(14,'T-014','Hà Nội','Cao Bằng',280,3,290000),
(15,'T-015','Hà Nội','Lạng Sơn',155,2,170000),
(16,'T-016','Hà Nội','Thái Nguyên',80,1,100000),
(17,'T-017','Hà Nội','Ninh Bình',95,1,110000),
(18,'T-018','Hà Nội','Nam Định',90,1,100000),
(19,'T-019','Sài Gòn','Nha Trang',430,2,360000),
(20,'T-020','Sài Gòn','Cần Thơ',170,1,180000),
(21,'T-021','Sài Gòn','Buôn Ma Thuột',350,3,330000),
(22,'T-022','Đà Nẵng','Quy Nhơn',300,2,260000);

-- DU LIEU CHUYEN XE (30 chuyen)
INSERT INTO trips (id, trip_code, route_id, route_name, vehicle_id, driver_id, assistant_id, departure_time, passenger_count, ticket_price, status) VALUES
(1,'CH-101',1,'Hà Nội - Nghệ An',1,1,17,'2026-11-18 21:30:00',21,250000,'Hoàn thành'),
(2,'CH-102',2,'Hà Nội - Đà Nẵng',2,2,18,'2026-11-05 07:00:00',22,550000,'Hoàn thành'),
(3,'CH-103',3,'Hà Nội - Lào Cai',3,3,19,'2026-11-14 06:00:00',27,280000,'Hoàn thành'),
(4,'CH-104',4,'Sài Gòn - Đà Lạt',4,4,NULL,'2026-11-14 21:00:00',31,320000,'Hoàn thành'),
(5,'CH-105',5,'Hà Nội - Hải Phòng',5,5,21,'2026-11-06 21:00:00',35,130000,'Hoàn thành'),
(6,'CH-106',6,'Hà Nội - Quảng Ninh',6,6,22,'2026-11-02 21:30:00',30,180000,'Hoàn thành'),
(7,'CH-107',7,'Hà Nội - Thanh Hóa',7,7,23,'2026-11-07 21:30:00',34,150000,'Hoàn thành'),
(8,'CH-108',8,'Hà Nội - Hà Tĩnh',8,8,NULL,'2026-11-10 21:00:00',29,290000,'Hoàn thành'),
(9,'CH-109',9,'Hà Nội - Quảng Bình',9,9,25,'2026-11-01 20:00:00',18,380000,'Hoàn thành'),
(10,'CH-110',10,'Hà Nội - Huế',10,10,17,'2026-11-11 08:00:00',30,480000,'Hoàn thành'),
(11,'CH-111',11,'Hà Nội - Sơn La',11,11,18,'2026-11-12 20:30:00',12,300000,'Hoàn thành'),
(12,'CH-112',12,'Hà Nội - Điện Biên',12,12,NULL,'2026-11-01 06:30:00',28,420000,'Hoàn thành'),
(13,'CH-113',13,'Hà Nội - Hà Giang',13,13,20,'2026-11-19 08:00:00',25,310000,'Hoàn thành'),
(14,'CH-114',14,'Hà Nội - Cao Bằng',14,14,21,'2026-11-20 13:30:00',27,290000,'Hoàn thành'),
(15,'CH-115',15,'Hà Nội - Lạng Sơn',15,15,22,'2026-11-14 18:00:00',32,170000,'Hoàn thành'),
(16,'CH-116',16,'Hà Nội - Thái Nguyên',16,16,NULL,'2026-11-19 07:30:00',18,100000,'Hoàn thành'),
(17,'CH-117',17,'Hà Nội - Ninh Bình',17,1,24,'2026-11-14 06:00:00',28,110000,'Hoàn thành'),
(18,'CH-118',18,'Hà Nội - Nam Định',18,2,25,'2026-11-14 06:30:00',27,100000,'Hoàn thành'),
(19,'CH-119',19,'Sài Gòn - Nha Trang',19,3,17,'2026-11-22 21:00:00',31,360000,'Hoàn thành'),
(20,'CH-120',20,'Sài Gòn - Cần Thơ',20,4,NULL,'2026-11-17 08:30:00',27,180000,'Hoàn thành'),
(21,'CH-121',21,'Sài Gòn - Buôn Ma Thuột',21,5,19,'2026-11-13 20:30:00',39,330000,'Hoàn thành'),
(22,'CH-122',22,'Đà Nẵng - Quy Nhơn',22,6,20,'2026-11-05 07:30:00',29,260000,'Hoàn thành'),
(23,'CH-123',1,'Hà Nội - Nghệ An',23,7,21,'2026-11-23 08:00:00',26,250000,'Đang chạy'),
(24,'CH-124',2,'Hà Nội - Đà Nẵng',24,8,NULL,'2026-11-23 14:00:00',17,550000,'Đang chạy'),
(25,'CH-125',3,'Hà Nội - Lào Cai',25,9,23,'2026-11-23 09:00:00',29,280000,'Đang chạy'),
(26,'CH-126',4,'Sài Gòn - Đà Lạt',1,10,24,'2026-11-23 08:00:00',18,320000,'Đang chạy'),
(27,'CH-127',5,'Hà Nội - Hải Phòng',2,11,25,'2026-11-28 21:00:00',27,130000,'Sắp khởi hành'),
(28,'CH-128',6,'Hà Nội - Quảng Ninh',3,12,NULL,'2026-11-27 19:00:00',31,180000,'Sắp khởi hành'),
(29,'CH-129',7,'Hà Nội - Thanh Hóa',4,13,18,'2026-11-25 21:00:00',38,150000,'Sắp khởi hành'),
(30,'CH-130',8,'Hà Nội - Hà Tĩnh',5,14,19,'2026-11-25 21:00:00',25,290000,'Sắp khởi hành');

-- DU LIEU PHAN CONG (53 ban ghi)
INSERT INTO assignments (trip_id, role, employee_id) VALUES
(1,'Tài xế',1),
(1,'Phụ xe',17),
(2,'Tài xế',2),
(2,'Phụ xe',18),
(3,'Tài xế',3),
(3,'Phụ xe',19),
(4,'Tài xế',4),
(5,'Tài xế',5),
(5,'Phụ xe',21),
(6,'Tài xế',6),
(6,'Phụ xe',22),
(7,'Tài xế',7),
(7,'Phụ xe',23),
(8,'Tài xế',8),
(9,'Tài xế',9),
(9,'Phụ xe',25),
(10,'Tài xế',10),
(10,'Phụ xe',17),
(11,'Tài xế',11),
(11,'Phụ xe',18),
(12,'Tài xế',12),
(13,'Tài xế',13),
(13,'Phụ xe',20),
(14,'Tài xế',14),
(14,'Phụ xe',21),
(15,'Tài xế',15),
(15,'Phụ xe',22),
(16,'Tài xế',16),
(17,'Tài xế',1),
(17,'Phụ xe',24),
(18,'Tài xế',2),
(18,'Phụ xe',25),
(19,'Tài xế',3),
(19,'Phụ xe',17),
(20,'Tài xế',4),
(21,'Tài xế',5),
(21,'Phụ xe',19),
(22,'Tài xế',6),
(22,'Phụ xe',20),
(23,'Tài xế',7),
(23,'Phụ xe',21),
(24,'Tài xế',8),
(25,'Tài xế',9),
(25,'Phụ xe',23),
(26,'Tài xế',10),
(26,'Phụ xe',24),
(27,'Tài xế',11),
(27,'Phụ xe',25),
(28,'Tài xế',12),
(29,'Tài xế',13),
(29,'Phụ xe',18),
(30,'Tài xế',14),
(30,'Phụ xe',19);

-- DU LIEU DOANH THU (22 ban ghi)
INSERT INTO revenues (id, trip_id, ticket_revenue, cargo_revenue, recorded_date) VALUES
(1,1,5250000,1400000,'2026-11-19'),
(2,2,12100000,2100000,'2026-11-06'),
(3,3,7560000,2500000,'2026-11-15'),
(4,4,9920000,2400000,'2026-11-15'),
(5,5,4550000,1500000,'2026-11-07'),
(6,6,5400000,700000,'2026-11-03'),
(7,7,5100000,1200000,'2026-11-08'),
(8,8,8410000,1400000,'2026-11-11'),
(9,9,6840000,1200000,'2026-11-02'),
(10,10,14400000,1100000,'2026-11-12'),
(11,11,3600000,900000,'2026-11-13'),
(12,12,11760000,500000,'2026-11-02'),
(13,13,7750000,600000,'2026-11-20'),
(14,14,7830000,1200000,'2026-11-21'),
(15,15,5440000,2000000,'2026-11-15'),
(16,16,1800000,2400000,'2026-11-20'),
(17,17,3080000,700000,'2026-11-15'),
(18,18,2700000,1900000,'2026-11-15'),
(19,19,11160000,1800000,'2026-11-23'),
(20,20,4860000,2500000,'2026-11-18'),
(21,21,12870000,2300000,'2026-11-14'),
(22,22,7540000,1100000,'2026-11-06');

-- DU LIEU CHI PHI (26 ban ghi)
INSERT INTO expenses (id, vehicle_id, expense_type, amount, expense_date, note) VALUES
(1,1,'Phí cầu đường (BOT) & Bến bãi',1000000,'2026-11-16','Phí cao tốc và bến xe hai đầu'),
(2,2,'Bảo dưỡng & Sửa chữa',4300000,'2026-11-08','Thay nhớt, lọc gió và kiểm tra phanh'),
(3,3,'Đăng kiểm & Bảo hiểm',3400000,'2026-11-21','Phí đăng kiểm định kỳ và bảo hiểm TNDS'),
(4,4,'Rửa xe & Vệ sinh nội thất',200000,'2026-11-04','Vệ sinh khoang hành khách sau chuyến'),
(5,5,'Nhiên liệu (Dầu)',4200000,'2026-11-08','Đổ dầu định kỳ theo hành trình'),
(6,6,'Phí cầu đường (BOT) & Bến bãi',600000,'2026-11-23','Phí cao tốc và bến xe hai đầu'),
(7,7,'Bảo dưỡng & Sửa chữa',5100000,'2026-11-15','Thay nhớt, lọc gió và kiểm tra phanh'),
(8,8,'Đăng kiểm & Bảo hiểm',2800000,'2026-11-18','Phí đăng kiểm định kỳ và bảo hiểm TNDS'),
(9,9,'Rửa xe & Vệ sinh nội thất',300000,'2026-11-04','Vệ sinh khoang hành khách sau chuyến'),
(10,10,'Nhiên liệu (Dầu)',4400000,'2026-11-05','Đổ dầu định kỳ theo hành trình'),
(11,11,'Phí cầu đường (BOT) & Bến bãi',1100000,'2026-11-22','Phí cao tốc và bến xe hai đầu'),
(12,12,'Bảo dưỡng & Sửa chữa',5100000,'2026-11-18','Thay nhớt, lọc gió và kiểm tra phanh'),
(13,13,'Đăng kiểm & Bảo hiểm',6300000,'2026-11-11','Phí đăng kiểm định kỳ và bảo hiểm TNDS'),
(14,14,'Rửa xe & Vệ sinh nội thất',500000,'2026-11-20','Vệ sinh khoang hành khách sau chuyến'),
(15,15,'Nhiên liệu (Dầu)',4700000,'2026-11-14','Đổ dầu định kỳ theo hành trình'),
(16,16,'Phí cầu đường (BOT) & Bến bãi',1200000,'2026-11-15','Phí cao tốc và bến xe hai đầu'),
(17,17,'Bảo dưỡng & Sửa chữa',2800000,'2026-11-16','Thay nhớt, lọc gió và kiểm tra phanh'),
(18,18,'Đăng kiểm & Bảo hiểm',5300000,'2026-11-09','Phí đăng kiểm định kỳ và bảo hiểm TNDS'),
(19,19,'Rửa xe & Vệ sinh nội thất',300000,'2026-11-21','Vệ sinh khoang hành khách sau chuyến'),
(20,20,'Nhiên liệu (Dầu)',3200000,'2026-11-17','Đổ dầu định kỳ theo hành trình'),
(21,21,'Phí cầu đường (BOT) & Bến bãi',1100000,'2026-11-21','Phí cao tốc và bến xe hai đầu'),
(22,22,'Bảo dưỡng & Sửa chữa',3300000,'2026-11-09','Thay nhớt, lọc gió và kiểm tra phanh'),
(23,23,'Đăng kiểm & Bảo hiểm',5300000,'2026-11-03','Phí đăng kiểm định kỳ và bảo hiểm TNDS'),
(24,24,'Rửa xe & Vệ sinh nội thất',400000,'2026-11-08','Vệ sinh khoang hành khách sau chuyến'),
(25,25,'Nhiên liệu (Dầu)',3200000,'2026-11-11','Đổ dầu định kỳ theo hành trình'),
(26,1,'Phí cầu đường (BOT) & Bến bãi',900000,'2026-11-18','Phí cao tốc và bến xe hai đầu');

-- TAI KHOAN QUAN LY
INSERT INTO manager_accounts (username, password, full_name) VALUES
('admin', '123456', 'Quản lý hệ thống'),
('dieuhanh01', '123456', 'Nguyễn Văn Điều Hành'),
('ketoan01', '123456', 'Trần Thị Kế Toán');
