<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chuyến xe & Lịch trình</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex h-screen bg-slate-100">
    <aside class="w-64 bg-slate-900 text-white flex flex-col">
        <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
        <nav class="flex-1 p-4 space-y-2 text-sm">
            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Chuyến xe & Lịch trình</a>
            <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Tuyến xe</a>
            <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Đội xe</a>
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-6">
        <div class="flex justify-between items-center">
            <h1 class="text-2xl font-bold text-slate-800">Chuyến xe & Lịch trình</h1>
            <form method="get" action="${pageContext.request.contextPath}/trips">
                <select name="status" onchange="this.form.submit()" class="border border-slate-300 rounded-lg px-3 py-2 text-sm bg-white">
                    <option value="ALL" ${selectedStatus == 'ALL' ? 'selected' : ''}>Tất cả trạng thái</option>
                    <option value="Sắp khởi hành" ${selectedStatus == 'Sắp khởi hành' ? 'selected' : ''}>Sắp khởi hành</option>
                    <option value="Đang chạy" ${selectedStatus == 'Đang chạy' ? 'selected' : ''}>Đang chạy</option>
                    <option value="Hoàn thành" ${selectedStatus == 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                </select>
            </form>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/trips" class="bg-white p-6 rounded-xl border border-slate-200 grid grid-cols-1 md:grid-cols-6 gap-3">
            <select name="routeId" required class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
                <c:forEach var="r" items="${routes}">
                    <option value="${r.id}">${r.routeCode} - ${r.routeName} (${r.distanceKm} km, mức ${r.complexityLevel})</option>
                </c:forEach>
            </select>
            <select name="vehicleId" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
                <c:forEach var="v" items="${vehicles}">
                    <option value="${v.id}">${v.licensePlate} (${v.status})</option>
                </c:forEach>
            </select>
            <select name="driverId" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
                <c:forEach var="e" items="${employees}">
                    <c:if test="${e.role == 'Tài xế'}"><option value="${e.id}">${e.fullName}</option></c:if>
                </c:forEach>
            </select>
            <select name="assistantId" class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
                <option value="">-- Không có phụ xe --</option>
                <c:forEach var="e" items="${employees}">
                    <c:if test="${e.role == 'Phụ xe'}"><option value="${e.id}">${e.fullName}</option></c:if>
                </c:forEach>
            </select>
            <input type="datetime-local" name="departureTime" required class="border border-slate-300 rounded-lg px-3 py-2 text-sm">
            <div class="flex gap-2">
                <input type="number" name="passengerCount" value="0" min="0" class="border border-slate-300 rounded-lg px-2 py-2 text-sm w-20">
                <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-medium flex-1">Tạo chuyến</button>
            </div>
        </form>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-6">Mã</th>
                        <th class="py-3 px-6">Tuyến</th>
                        <th class="py-3 px-6">Khởi hành</th>
                        <th class="py-3 px-6">Xe & Tổ lái</th>
                        <th class="py-3 px-6">Chốt sổ chuyến</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="t" items="${trips}">
                        <tr>
                            <td class="py-3 px-6 font-semibold text-blue-600">${t.tripCode}</td>
                            <td class="py-3 px-6">${t.routeName}</td>
                            <td class="py-3 px-6">${t.departureTime}</td>
                            <td class="py-3 px-6">${t.licensePlate} - TX: ${t.driverName}</td>
                            <td class="py-3 px-6">
                                <form method="post" action="${pageContext.request.contextPath}/trips" class="flex items-center gap-2">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="tripId" value="${t.id}">
                                    <input type="number" name="passengerCount" value="${t.passengerCount}" min="0" class="border rounded px-2 py-1 w-16 text-xs">
                                    <select name="status" class="border rounded px-2 py-1 text-xs">
                                        <option value="Sắp khởi hành" ${t.status == 'Sắp khởi hành' ? 'selected' : ''}>Sắp khởi hành</option>
                                        <option value="Đang chạy" ${t.status == 'Đang chạy' ? 'selected' : ''}>Đang chạy</option>
                                        <option value="Hoàn thành" ${t.status == 'Hoàn thành' ? 'selected' : ''}>Hoàn thành</option>
                                    </select>
                                    <button class="bg-emerald-600 text-white px-2.5 py-1 rounded text-xs">Lưu</button>
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
