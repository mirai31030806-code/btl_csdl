<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Nhân sự</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex h-screen bg-slate-100">
    <aside class="w-64 bg-slate-900 text-white flex flex-col">
        <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
        <nav class="flex-1 p-4 space-y-2 text-sm">
            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Chuyến xe & Lịch trình</a>
            <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Tuyến xe</a>
            <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Đội xe</a>
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-6">
        <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-slate-800">Quản lý Nhân sự</h1>
            <form method="get" action="${pageContext.request.contextPath}/employees">
                <select name="role" onchange="this.form.submit()" class="border border-slate-300 rounded-lg px-3 py-2 text-sm bg-white">
                    <option value="ALL" ${selectedRole == 'ALL' ? 'selected' : ''}>Tất cả chức vụ</option>
                    <option value="Tài xế" ${selectedRole == 'Tài xế' ? 'selected' : ''}>Tài xế</option>
                    <option value="Phụ xe" ${selectedRole == 'Phụ xe' ? 'selected' : ''}>Phụ xe</option>
                    <option value="Điều hành" ${selectedRole == 'Điều hành' ? 'selected' : ''}>Điều hành</option>
                </select>
            </form>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/employees" class="bg-white p-6 rounded-xl border border-slate-200 grid grid-cols-1 md:grid-cols-5 gap-4">
            <input type="text" name="fullName" required placeholder="Họ và tên" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <select name="role" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
                <option value="Tài xế">Tài xế</option>
                <option value="Phụ xe">Phụ xe</option>
                <option value="Điều hành">Điều hành</option>
            </select>
            <input type="text" name="phone" required placeholder="Số điện thoại" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <input type="text" name="licenseType" placeholder="Hạng bằng lái (VD: Hạng E)" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium">Thêm nhân sự</button>
        </form>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-6">Họ tên</th>
                        <th class="py-3 px-6">Chức vụ</th>
                        <th class="py-3 px-6">Điện thoại</th>
                        <th class="py-3 px-6">Bằng lái</th>
                        <th class="py-3 px-6">Số chuyến</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="e" items="${employees}">
                        <tr>
                            <td class="py-3 px-6 font-bold">${e.fullName}</td>
                            <td class="py-3 px-6">${e.role}</td>
                            <td class="py-3 px-6">${e.phone}</td>
                            <td class="py-3 px-6">${e.licenseType}</td>
                            <td class="py-3 px-6 font-semibold text-blue-600">${e.tripCount} chuyến</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
