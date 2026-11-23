# BusManager - Hệ thống quản lý hãng xe khách

## Công nghệ
- Java 17, Maven, JSP, Servlet, JDBC
- MySQL 8.x
- Apache Tomcat 10.1

## Cài đặt cơ sở dữ liệu
1. Mở MySQL Workbench hoặc phpMyAdmin.
2. Chạy toàn bộ tệp `database.sql` để tạo CSDL `bus_manager` và dữ liệu mẫu.
3. Mở `src/main/java/com/busmanager/config/DBConnection.java`, sửa `USER` và `PASSWORD` theo tài khoản MySQL trên máy.

## Chạy trên IntelliJ IDEA
1. Mở thư mục `BusManager` dưới dạng dự án Maven.
2. Chờ Maven tải các thư viện trong `pom.xml`.
3. Tạo cấu hình Tomcat 10.1, chọn artifact `BusManager:war exploded`.
4. Chạy Tomcat và truy cập `/BusManager/dashboard`.

## Các phân hệ
- Tổng quan.
- Quản lý xe khách.
- Quản lý tuyến xe: thêm, xem, xóa tuyến; phân loại độ phức tạp mức 1, 2, 3.
- Quản lý chuyến xe: chọn tuyến, xe, tài xế, phụ xe; dữ liệu tuyến lấy từ MySQL.
- Phân công: khi tạo chuyến, hệ thống tự ghi tài xế và phụ xe vào bảng `assignments` trong cùng giao dịch SQL.
- Quản lý nhân viên.
- Doanh thu và chi phí.

## Cấu trúc CSDL được bổ sung
- `vehicles`: xe khách (bổ sung màu xe, hãng sản xuất, đời xe, model, số năm sử dụng, ngày bảo dưỡng cuối).
- `routes`: tuyến xe (mã tuyến, điểm đầu/cuối, độ dài, mức phức tạp, giá vé).
- `trips`: chuyến xe, liên kết khóa ngoại tới tuyến và xe.
- `assignments`: phân công nhân viên theo vai trò cho từng chuyến; khóa chính gồm mã chuyến và vai trò.
- `employees`: nhân viên (bổ sung số CMT, mã bằng lái, địa chỉ, ngày sinh, thâm niên).
- `revenues`, `expenses`: các bảng tài chính đang có của dự án.

Lưu ý: `database.sql` là kịch bản khởi tạo mới. Nếu đã có CSDL `bus_manager` cũ chứa dữ liệu cần giữ, hãy sao lưu trước; không chạy trực tiếp script khởi tạo này lên dữ liệu cũ.
