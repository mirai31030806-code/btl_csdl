<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Tuyến xe</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex min-h-screen bg-slate-100">
<aside class="w-64 bg-slate-900 text-white flex flex-col">
    <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
    <nav class="flex-1 p-4 space-y-2 text-sm">
        <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Tổng quan</a>
        <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Chuyến xe</a>
        <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Quản lý Tuyến xe</a>
        <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Xe khách</a>
        <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân viên</a>
        <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
    </nav>
</aside>
<main class="flex-1 p-8 space-y-6">
    <h1 class="text-2xl font-bold text-slate-800">Quản lý Tuyến xe</h1>
    <form method="post" action="${pageContext.request.contextPath}/routes" class="bg-white p-6 rounded-xl border grid grid-cols-1 md:grid-cols-6 gap-3">
        <input name="routeCode" required placeholder="Mã tuyến" class="border rounded-lg px-3 py-2 text-sm">
        <input name="startPoint" required placeholder="Điểm đầu" class="border rounded-lg px-3 py-2 text-sm">
        <input name="endPoint" required placeholder="Điểm cuối" class="border rounded-lg px-3 py-2 text-sm">
        <input name="distanceKm" type="number" min="1" step="0.01" required placeholder="Độ dài (km)" class="border rounded-lg px-3 py-2 text-sm">
        <select name="complexityLevel" class="border rounded-lg px-3 py-2 text-sm"><option value="1">Mức 1 - Dễ</option><option value="2">Mức 2 - Trung bình</option><option value="3">Mức 3 - Khó</option></select>
        <div class="flex gap-2"><input name="ticketPrice" type="number" min="0" required placeholder="Giá vé" class="border rounded-lg px-3 py-2 text-sm w-full"><button class="bg-blue-600 text-white rounded-lg px-4 text-sm">Thêm</button></div>
    </form>
    <div class="bg-white rounded-xl border overflow-hidden">
        <table class="w-full text-left text-sm">
            <thead class="bg-slate-50 text-slate-500"><tr><th class="p-4">Mã tuyến</th><th class="p-4">Điểm đầu</th><th class="p-4">Điểm cuối</th><th class="p-4">Độ dài</th><th class="p-4">Độ phức tạp</th><th class="p-4">Giá vé</th><th class="p-4">Thao tác</th></tr></thead>
            <tbody class="divide-y">
            <c:forEach var="r" items="${routes}"><tr>
                <td class="p-4 font-semibold">${r.routeCode}</td><td class="p-4">${r.startPoint}</td><td class="p-4">${r.endPoint}</td>
                <td class="p-4">${r.distanceKm} km</td><td class="p-4">Mức ${r.complexityLevel}</td><td class="p-4">${r.ticketPrice} đ</td>
                <td class="p-4"><form method="post" action="${pageContext.request.contextPath}/routes"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${r.id}"><button class="text-red-600" onclick="return confirm('Bạn chắc chắn muốn xóa tuyến này?')">Xóa</button></form></td>
            </tr></c:forEach>
            </tbody>
        </table>
    </div>
</main>
</body>
</html>
