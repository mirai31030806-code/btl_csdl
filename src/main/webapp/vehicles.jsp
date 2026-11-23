<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Đội xe</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex h-screen bg-slate-100">
    <aside class="w-64 bg-slate-900 text-white flex flex-col">
        <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
        <nav class="flex-1 p-4 space-y-2 text-sm">
            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Chuyến xe & Lịch trình</a>
            <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Tuyến xe</a>
            <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Quản lý Đội xe</a>
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-6">
        <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-slate-800">Quản lý Đội xe</h1>
            <form method="get" action="${pageContext.request.contextPath}/vehicles" class="flex gap-2">
                <input type="text" name="search" value="${search}" placeholder="Tìm biển số, dòng xe..." class="border border-slate-300 rounded-lg px-3 py-2 text-sm bg-white">
                <button class="bg-slate-800 text-white px-4 py-2 rounded-lg text-sm">Tìm</button>
            </form>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/vehicles" class="bg-white p-6 rounded-xl border border-slate-200 grid grid-cols-1 md:grid-cols-5 gap-4">
            <input type="text" name="licensePlate" required placeholder="Biển số (VD: 29B-999.99)" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <input type="text" name="brand" required placeholder="Dòng xe / Hãng" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <input type="number" name="seatCount" required value="34" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <input type="date" name="inspectionExpiry" required class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <div class="flex gap-2">
                <select name="status" class="border border-slate-300 rounded-lg px-2 py-2 text-sm flex-1">
                    <option value="Sẵn sàng">Sẵn sàng</option>
                    <option value="Đang chạy">Đang chạy</option>
                    <option value="Bảo dưỡng">Bảo dưỡng</option>
                </select>
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium">Thêm</button>
            </div>
        </form>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-6">Biển số</th>
                        <th class="py-3 px-6">Dòng xe</th>
                        <th class="py-3 px-6">Số ghế</th>
                        <th class="py-3 px-6">Hạn đăng kiểm</th>
                        <th class="py-3 px-6">Trạng thái</th>
                        <th class="py-3 px-6 text-right">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="v" items="${vehicles}">
                        <tr>
                            <td class="py-3 px-6 font-bold">${v.licensePlate}</td>
                            <td class="py-3 px-6">${v.brand}</td>
                            <td class="py-3 px-6">${v.seatCount}</td>
                            <td class="py-3 px-6">${v.inspectionExpiry}</td>
                            <td class="py-3 px-6">${v.status}</td>
                            <td class="py-3 px-6 text-right">
                                <form method="post" action="${pageContext.request.contextPath}/vehicles" class="inline">
                                    <input type="hidden" name="action" value="toggleStatus">
                                    <input type="hidden" name="id" value="${v.id}">
                                    <button class="bg-slate-100 hover:bg-slate-200 px-3 py-1 rounded text-xs">Đổi trạng thái</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
