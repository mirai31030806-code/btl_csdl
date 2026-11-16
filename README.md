# Hướng dẫn Chạy Ứng dụng Quản lý Xe Khách (Yêu cầu 3)

Ứng dụng được xây dựng bằng **Streamlit** (Python) với giao diện trực quan, dễ sử dụng cho người dùng không biết lập trình.

## Cấu trúc thư mục:
- `app.py`: Mã nguồn ứng dụng giao diện Web.
- `quan_ly_xe_khach.sql`: Script cơ sở dữ liệu MySQL (Yêu cầu 2).
- `requirements.txt`: Các thư viện cần thiết.

## Hướng dẫn cài đặt và chạy app:
1. Cài đặt Python (phiên bản 3.8 trở lên).
2. Cài đặt các thư viện phụ thuộc:
   ```bash
   pip install -r requirements.txt
   ```
3. Khởi chạy ứng dụng Streamlit:
   ```bash
   streamlit run app.py
   ```
4. Mở trình duyệt theo đường dẫn hiển thị trên terminal (thường là `http://localhost:8501`).
