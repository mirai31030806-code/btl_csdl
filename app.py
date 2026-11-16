import streamlit as st
import pandas as pd
import sqlite3

st.set_page_config(
    page_title="Hệ thống Quản lý Vận tải Xe Khách",
    page_icon="🚌",
    layout="wide"
)

@st.cache_resource
def init_db():
    conn = sqlite3.connect("quan_ly_xe_khach.db", check_same_thread=False)
    cursor = conn.cursor()
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS XE_KHACH (
        MaXe TEXT PRIMARY KEY,
        BienSoXe TEXT,
        MauXe TEXT,
        HangSanXuat TEXT,
        DoiXe TEXT,
        Model TEXT,
        SoGhe INTEGER,
        SoNamSuDung INTEGER,
        NgayBaoDuongCuoi TEXT
    )
    ''')
    
    cursor.execute('''
    CREATE TABLE IF NOT EXISTS TUYEN_XE (
        MaTuyen TEXT PRIMARY KEY,
        DiemDau TEXT,
        DiemCuoi TEXT,
        DoDai REAL,
        DoPhucTap TEXT
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS NHAN_VIEN (
        MaNV TEXT PRIMARY KEY,
        TenNV TEXT,
        SoCMT TEXT,
        MaBangLai TEXT,
        LoaiBangLai TEXT,
        DiaChi TEXT,
        NgaySinh TEXT,
        ThamNien INTEGER
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS CHUYEN_XE (
        MaChuyen TEXT PRIMARY KEY,
        MaTuyen TEXT,
        MaXe TEXT,
        SoHanhKhach INTEGER,
        GiaVe INTEGER,
        FOREIGN KEY(MaTuyen) REFERENCES TUYEN_XE(MaTuyen),
        FOREIGN KEY(MaXe) REFERENCES XE_KHACH(MaXe)
    )
    ''')

    cursor.execute('''
    CREATE TABLE IF NOT EXISTS PHAN_CONG (
        MaChuyen TEXT,
        VaiTro TEXT,
        MaNV TEXT,
        PRIMARY KEY(MaChuyen, VaiTro),
        FOREIGN KEY(MaChuyen) REFERENCES CHUYEN_XE(MaChuyen),
        FOREIGN KEY(MaNV) REFERENCES NHAN_VIEN(MaNV)
    )
    ''')

    cursor.execute("SELECT COUNT(*) FROM XE_KHACH")
    if cursor.fetchone()[0] == 0:
        cursor.executemany("INSERT INTO XE_KHACH VALUES (?,?,?,?,?,?,?,?,?)", [
            ('X001', '29A-12345', 'Trắng', 'Toyota', '16C', 'Hiace', 30, 5, '2025-06-01'),
            ('X002', '29B-67890', 'Đen', 'Hyundai', '45C', 'Universe', 40, 7, '2025-05-15'),
            ('X003', '30A-11111', 'Bạc', 'Thaco', '29C', 'Mobihome', 34, 6, '2025-04-20'),
            ('X004', '30B-22222', 'Đỏ', 'Mercedes', '47C', 'Sprinter', 16, 8, '2025-05-10'),
            ('X005', '31A-33333', 'Xanh', 'Ford', '16C', 'Transit', 29, 4, '2025-06-18')
        ])
        cursor.executemany("INSERT INTO TUYEN_XE VALUES (?,?,?,?,?)", [
            ('T001', 'Hà Nội', 'Hải Phòng', 102, 'Thấp'),
            ('T002', 'Hà Nội', 'Đà Nẵng', 791, 'Cao'),
            ('T003', 'Sài Gòn', 'Nha Trang', 441, 'Trung bình'),
            ('T004', 'Hà Nội', 'Vinh', 318, 'Trung bình'),
            ('T005', 'Đà Nẵng', 'Huế', 104, 'Thấp')
        ])
        cursor.executemany("INSERT INTO NHAN_VIEN VALUES (?,?,?,?,?,?,?,?)", [
            ('NV001', 'Nguyễn Văn An', '123456789', 'B2', 'Ô tô', 'Hà Nội', '1990-03-15', 7),
            ('NV002', 'Trần Thị Bình', '987654321', 'D', 'Ô tô', 'Hải Phòng', '1992-07-22', 5),
            ('NV003', 'Lê Văn Cường', '456789123', 'B2', 'Ô tô', 'Đà Nẵng', '1988-10-10', 8),
            ('NV004', 'Phạm Thị Dung', '321654987', 'D', 'Ô tô', 'Huế', '1993-12-05', 4),
            ('NV005', 'Đỗ Văn Hùng', '654987321', 'B2', 'Ô tô', 'Quảng Nam', '1991-01-20', 6)
        ])
        cursor.executemany("INSERT INTO CHUYEN_XE VALUES (?,?,?,?,?)", [
            ('C001', 'T001', 'X001', 25, 120000),
            ('C002', 'T002', 'X002', 35, 150000),
            ('C003', 'T003', 'X003', 30, 130000),
            ('C004', 'T004', 'X004', 14, 160000),
            ('C005', 'T005', 'X005', 25, 140000)
        ])
        cursor.executemany("INSERT INTO PHAN_CONG VALUES (?,?,?)", [
            ('C001', 'Lái xe', 'NV001'),
            ('C001', 'Phụ xe', 'NV002'),
            ('C002', 'Lái xe', 'NV003'),
            ('C002', 'Phụ xe', 'NV004'),
            ('C003', 'Lái xe', 'NV005')
        ])
        conn.commit()
    return conn

conn = init_db()

st.sidebar.title("🚌 Quản lý Vận tải Xe Khách")
menu = st.sidebar.selectbox("Chọn chức năng:", [
    "📊 Trang chủ & Thống kê Doanh thu",
    "🚌 Quản lý Xe Khách",
    "🛣️ Quản lý Tuyến Xe",
    "👥 Quản lý Nhân Viên",
    "🎟️ Quản lý Chuyến Xe & Kiểm tra Ghế",
    "👨‍✈️ Phân công Nhân Viên"
])

if menu == "📊 Trang chủ & Thống kê Doanh thu":
    st.title("📊 Tổng quan & Thống kê Doanh thu")
    
    df_doanh_thu = pd.read_sql('''
        SELECT 
            cx.MaChuyen AS [Mã Chuyến],
            tx.DiemDau AS [Điểm Đầu],
            tx.DiemCuoi AS [Điểm Cuối],
            cx.SoHanhKhach AS [Số Khách],
            cx.GiaVe AS [Giá Vé (VNĐ)],
            (cx.SoHanhKhach * cx.GiaVe) AS [Tổng Doanh Thu (VNĐ)]
        FROM CHUYEN_XE cx
        JOIN TUYEN_XE tx ON cx.MaTuyen = tx.MaTuyen
    ''', conn)
    
    total_rev = df_doanh_thu['Tổng Doanh Thu (VNĐ)'].sum()
    total_passengers = df_doanh_thu['Số Khách'].sum()
    
    col1, col2, col3 = st.columns(3)
    col1.metric("Tổng Doanh Thu Toàn Hãng", f"{total_rev:,.0f} VNĐ")
    col2.metric("Tổng Số Chuyến Xe", len(df_doanh_thu))
    col3.metric("Tổng Lượng Khách Phục Vụ", f"{total_passengers} khách")
    
    st.subheader("Chi tiết Doanh thu theo Chuyến xe")
    st.dataframe(df_doanh_thu, use_container_width=True)
    
    st.subheader("Thống kê Doanh thu theo Tuyến đường")
    df_tuyen = pd.read_sql('''
        SELECT 
            tx.MaTuyen AS [Mã Tuyến],
            tx.DiemDau || ' - ' || tx.DiemCuoi AS [Tuyến Đường],
            SUM(cx.SoHanhKhach * cx.GiaVe) AS [Tổng Doanh Thu]
        FROM CHUYEN_XE cx
        JOIN TUYEN_XE tx ON cx.MaTuyen = tx.MaTuyen
        GROUP BY tx.MaTuyen
    ''', conn)
    st.dataframe(df_tuyen, use_container_width=True)

elif menu == "🚌 Quản lý Xe Khách":
    st.title("🚌 Quản lý Thông tin Xe Khách")
    df = pd.read_sql("SELECT * FROM XE_KHACH", conn)
    st.dataframe(df, use_container_width=True)
    
    with st.form("them_xe"):
        st.subheader("Thêm Xe Khách Mới")
        c1, c2, c3 = st.columns(3)
        maxe = c1.text_input("Mã Xe (VD: X006)")
        bienso = c2.text_input("Biển Số Xe (VD: 29C-99999)")
        mauxe = c3.text_input("Màu Xe")
        
        c4, c5, c6 = st.columns(3)
        hang = c4.text_input("Hãng Sản Xuất")
        doixe = c5.text_input("Đời Xe")
        model = c6.text_input("Model")
        
        c7, c8, c9 = st.columns(3)
        soghe = c7.number_input("Số Ghế", min_value=4, value=40)
        sonam = c8.number_input("Số Năm Sử Dụng", min_value=0, value=3)
        ngaybd = c9.text_input("Ngày Bảo Dưỡng Cuối (YYYY-MM-DD)", value="2025-06-01")
        
        submitted = st.form_submit_button("Thêm Xe")
        if submitted:
            try:
                conn.execute("INSERT INTO XE_KHACH VALUES (?,?,?,?,?,?,?,?,?)", 
                             (maxe, bienso, mauxe, hang, doixe, model, soghe, sonam, ngaybd))
                conn.commit()
                st.success("Thêm xe khách thành công!")
                st.rerun()
            except Exception as e:
                st.error(f"Lỗi: {e}")

elif menu == "🛣️ Quản lý Tuyến Xe":
    st.title("🛣️ Quản lý Tuyến Xe")
    df = pd.read_sql("SELECT * FROM TUYEN_XE", conn)
    st.dataframe(df, use_container_width=True)
    
    with st.form("them_tuyen"):
        st.subheader("Thêm Tuyến Xe Mới")
        c1, c2, c3 = st.columns(3)
        matuyen = c1.text_input("Mã Tuyến (VD: T006)")
        diemdau = c2.text_input("Điểm Đầu")
        diemcuoi = c3.text_input("Điểm Cuối")
        
        c4, c5 = st.columns(2)
        dodai = c4.number_input("Độ Dài (km)", min_value=1.0, value=100.0)
        dophuctap = c5.selectbox("Độ Phức Tạp", ["Thấp", "Trung bình", "Cao"])
        
        if st.form_submit_button("Thêm Tuyến"):
            try:
                conn.execute("INSERT INTO TUYEN_XE VALUES (?,?,?,?,?)", (matuyen, diemdau, diemcuoi, dodai, dophuctap))
                conn.commit()
                st.success("Thêm tuyến thành công!")
                st.rerun()
            except Exception as e:
                st.error(f"Lỗi: {e}")

elif menu == "👥 Quản lý Nhân Viên":
    st.title("👥 Quản lý Nhân Viên (Tài xế & Phụ xe)")
    df = pd.read_sql("SELECT * FROM NHAN_VIEN", conn)
    st.dataframe(df, use_container_width=True)
    
    with st.form("them_nv"):
        st.subheader("Thêm Nhân Viên Mới")
        c1, c2, c3 = st.columns(3)
        manv = c1.text_input("Mã NV (VD: NV006)")
        tennv = c2.text_input("Tên Nhân Viên")
        socmt = c3.text_input("Số CMT/CCCD")
        
        c4, c5, c6 = st.columns(3)
        mabl = c4.text_input("Mã Bằng Lái")
        loaibl = c5.text_input("Loại Bằng Lái")
        diachi = c6.text_input("Địa Chỉ")
        
        c7, c8 = st.columns(2)
        ngaysinh = c7.text_input("Ngày Sinh (YYYY-MM-DD)")
        thamnien = c8.number_input("Thâm Niên (năm)", min_value=0, value=2)
        
        if st.form_submit_button("Thêm Nhân Viên"):
            try:
                conn.execute("INSERT INTO NHAN_VIEN VALUES (?,?,?,?,?,?,?,?)", 
                             (manv, tennv, socmt, mabl, loaibl, diachi, ngaysinh, thamnien))
                conn.commit()
                st.success("Thêm nhân viên thành công!")
                st.rerun()
            except Exception as e:
                st.error(f"Lỗi: {e}")

elif menu == "🎟️ Quản lý Chuyến Xe & Kiểm tra Ghế":
    st.title("🎟️ Quản lý Chuyến Xe & Kiểm tra Quy định Số ghế")
    
    st.info("Quy định: Số lượng hành khách trên mỗi chuyến xe không được vượt quá số ghế quy định của xe (Số ghế trừ đi 2).")
    
    df_check = pd.read_sql('''
        SELECT 
            cx.MaChuyen AS [Mã Chuyến],
            tx.DiemDau || ' - ' || tx.DiemCuoi AS [Tuyến],
            cx.MaXe AS [Xe],
            xk.SoGhe AS [Tổng Số Ghế],
            (xk.SoGhe - 2) AS [Ghế Tối Đa Cho Phép],
            cx.SoHanhKhach AS [Số Khách Thực Tế],
            CASE 
                WHEN cx.SoHanhKhach <= (xk.SoGhe - 2) THEN 'Hợp lệ ✅'
                ELSE 'Vi phạm: Vượt quá quy định ❌'
            END AS [Trạng Thái]
        FROM CHUYEN_XE cx
        JOIN TUYEN_XE tx ON cx.MaTuyen = tx.MaTuyen
        JOIN XE_KHACH xk ON cx.MaXe = xk.MaXe
    ''', conn)
    
    st.dataframe(df_check, use_container_width=True)
    
    with st.form("them_chuyen"):
        st.subheader("Thêm Chuyến Xe Mới")
        c1, c2, c3 = st.columns(3)
        machuyen = c1.text_input("Mã Chuyến (VD: C006)")
        
        tuyen_list = pd.read_sql("SELECT MaTuyen FROM TUYEN_XE", conn)['MaTuyen'].tolist()
        matuyen = c2.selectbox("Mã Tuyến", tuyen_list)
        
        xe_list = pd.read_sql("SELECT MaXe FROM XE_KHACH", conn)['MaXe'].tolist()
        maxe = c3.selectbox("Mã Xe", xe_list)
        
        c4, c5 = st.columns(2)
        sohk = c4.number_input("Số Lượng Hành Khách", min_value=1, value=30)
        giave = c5.number_input("Giá Vé (VNĐ)", min_value=10000, value=150000, step=10000)
        
        if st.form_submit_button("Thêm Chuyến Xe"):
            cursor = conn.cursor()
            cursor.execute("SELECT SoGhe FROM XE_KHACH WHERE MaXe = ?", (maxe,))
            soghe_xe = cursor.fetchone()[0]
            
            if sohk > (soghe_xe - 2):
                st.error(f"Lỗi: Số lượng hành khách ({sohk}) vượt quá số ghế quy định của xe {maxe} (Tối đa: {soghe_xe - 2} khách, vì xe có {soghe_xe} ghế trừ 2).")
            else:
                try:
                    conn.execute("INSERT INTO CHUYEN_XE VALUES (?,?,?,?,?)", (machuyen, matuyen, maxe, sohk, giave))
                    conn.commit()
                    st.success("Thêm chuyến xe thành công và thỏa mãn quy định số ghế!")
                    st.rerun()
                except Exception as e:
                    st.error(f"Lỗi: {e}")

elif menu == "👨‍✈️ Phân công Nhân Viên":
    st.title("👨‍✈️ Quản lý Phân công Nhân sự cho Chuyến Xe")
    df_pc = pd.read_sql('''
        SELECT 
            pc.MaChuyen AS [Mã Chuyến],
            pc.VaiTro AS [Vai Trò],
            nv.MaNV AS [Mã NV],
            nv.TenNV AS [Tên Nhân Viên],
            nv.SoCMT AS [CCCD]
        FROM PHAN_CONG pc
        JOIN NHAN_VIEN nv ON pc.MaNV = nv.MaNV
    ''', conn)
    st.dataframe(df_pc, use_container_width=True)
    
    with st.form("them_pc"):
        st.subheader("Phân công nhân viên mới")
        c1, c2, c3 = st.columns(3)
        
        chuyen_list = pd.read_sql("SELECT MaChuyen FROM CHUYEN_XE", conn)['MaChuyen'].tolist()
        machuyen = c1.selectbox("Mã Chuyến Xe", chuyen_list)
        
        vaitro = c2.selectbox("Vai Trò", ["Lái xe", "Phụ xe"])
        
        nv_list = pd.read_sql("SELECT MaNV, TenNV FROM NHAN_VIEN", conn)
        nv_dict = {f"{row['MaNV']} - {row['TenNV']}": row['MaNV'] for _, row in nv_list.iterrows()}
        selected_nv = c3.selectbox("Nhân Viên", list(nv_dict.keys()))
        
        if st.form_submit_button("Lưu Phân Công"):
            manv = nv_dict[selected_nv]
            try:
                conn.execute("INSERT INTO PHAN_CONG VALUES (?,?,?)", (machuyen, vaitro, manv))
                conn.commit()
                st.success("Phân công nhân viên thành công!")
                st.rerun()
            except Exception as e:
                st.error(f"Lỗi: Phân công này đã tồn tại hoặc nhân viên đã nhận vai trò này!")
