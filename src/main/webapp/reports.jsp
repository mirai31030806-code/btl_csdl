<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>BusManager Pro - Báo cáo &amp; Thống kê</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex h-screen bg-slate-100">
    <aside class="w-64 bg-slate-900 text-white flex flex-col">
        <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
        <nav class="flex-1 p-4 space-y-2 text-sm">
            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Chuyến xe &amp; Lịch trình</a>
            <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Tuyến xe</a>
            <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Đội xe</a>
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu &amp; Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-8">
        <h1 class="text-2xl font-bold text-slate-800">Báo cáo Nghiệp vụ &amp; Bảo dưỡng (BTL Nhóm 12)</h1>

        <section>
            <h2 class="text-lg font-semibold text-slate-700 mb-3">1. Thống kê số lượng bản ghi hệ thống</h2>
            <div class="grid grid-cols-2 md:grid-cols-5 gap-4">
                <c:forEach var="entry" items="${recordCounts}">
                    <div class="bg-white p-4 rounded-xl border border-slate-200">
                        <p class="text-xs uppercase text-slate-500">${entry.key}</p>
                        <p class="text-xl font-bold text-slate-800 mt-1">${entry.value}</p>
                    </div>
                </c:forEach>
            </div>
        </section>

        <section class="bg-white rounded-xl border border-slate-200 p-6 space-y-4">
            <div class="flex flex-wrap items-center justify-between gap-4">
                <h2 class="text-lg font-semibold text-slate-800">2. Bảng lương nhân viên theo tháng &amp; độ phức tạp tuyến</h2>
                <form method="get" action="${pageContext.request.contextPath}/reports" class="flex items-center gap-3 text-sm">
                    <label>Tháng: <input type="number" name="month" min="1" max="12" value="${month}" class="border rounded px-2 py-1 w-20"></label>
                    <label>Năm: <input type="number" name="year" min="2000" max="2100" value="${year}" class="border rounded px-2 py-1 w-24"></label>
                    <input type="hidden" name="startDate" value="${startDate}">
                    <input type="hidden" name="endDate" value="${endDate}">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-1.5 rounded-lg hover:bg-blue-700">Tính lương</button>
                </form>
            </div>
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-4">Nhân viên</th>
                        <th class="py-3 px-4">Vai trò</th>
                        <th class="py-3 px-4">Số chuyến</th>
                        <th class="py-3 px-4">Lương dự kiến</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="row" items="${salaries}">
                        <tr>
                            <td class="py-3 px-4 font-medium text-slate-800">${row.fullName}</td>
                            <td class="py-3 px-4">${row.role}</td>
                            <td class="py-3 px-4">${row.tripCount}</td>
                            <td class="py-3 px-4 font-semibold text-emerald-600"><fmt:formatNumber value="${row.totalSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty salaries}">
                        <tr><td colspan="4" class="py-4 px-4 text-slate-500 text-center">Không có dữ liệu chuyến chạy trong tháng đã chọn.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>

        <section class="bg-white rounded-xl border border-slate-200 p-6 space-y-4">
            <div class="flex flex-wrap items-center justify-between gap-4">
                <h2 class="text-lg font-semibold text-slate-800">3. Doanh thu từng xe theo khoảng ngày</h2>
                <form method="get" action="${pageContext.request.contextPath}/reports" class="flex items-center gap-3 text-sm">
                    <label>Từ ngày: <input type="date" name="startDate" value="${startDate}" class="border rounded px-2 py-1"></label>
                    <label>Đến ngày: <input type="date" name="endDate" value="${endDate}" class="border rounded px-2 py-1"></label>
                    <input type="hidden" name="month" value="${month}">
                    <input type="hidden" name="year" value="${year}">
                    <button type="submit" class="bg-blue-600 text-white px-4 py-1.5 rounded-lg hover:bg-blue-700">Lọc doanh thu</button>
                </form>
            </div>
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-4">Biển số xe</th>
                        <th class="py-3 px-4">Hãng / Dòng</th>
                        <th class="py-3 px-4">Số chuyến</th>
                        <th class="py-3 px-4">Tổng hành khách</th>
                        <th class="py-3 px-4">Tổng doanh thu vé</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="row" items="${vehicleRevenues}">
                        <tr>
                            <td class="py-3 px-4 font-semibold text-blue-600">${row.licensePlate}</td>
                            <td class="py-3 px-4">${row.brand}</td>
                            <td class="py-3 px-4">${row.tripCount}</td>
                            <td class="py-3 px-4">${row.totalPassengers}</td>
                            <td class="py-3 px-4 font-semibold text-emerald-600"><fmt:formatNumber value="${row.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty vehicleRevenues}">
                        <tr><td colspan="5" class="py-4 px-4 text-slate-500 text-center">Không có doanh thu chuyến xe trong khoảng ngày đã chọn.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>

        <section class="bg-white rounded-xl border border-slate-200 p-6 space-y-4">
            <h2 class="text-lg font-semibold text-slate-800">4. Lịch bảo dưỡng xe theo km quy đổi</h2>
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-4">Biển số</th>
                        <th class="py-3 px-4">Hãng / Dòng</th>
                        <th class="py-3 px-4">Bảo dưỡng gần nhất</th>
                        <th class="py-3 px-4">Km quy đổi</th>
                        <th class="py-3 px-4">Ngày bảo dưỡng tiếp theo</th>
                        <th class="py-3 px-4">Trạng thái</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="row" items="${maintenanceList}">
                        <tr>
                            <td class="py-3 px-4 font-semibold text-slate-800">${row.licensePlate}</td>
                            <td class="py-3 px-4">${row.brand}</td>
                            <td class="py-3 px-4">${row.lastMaintenance}</td>
                            <td class="py-3 px-4"><fmt:formatNumber value="${row.convertedKm}" maxFractionDigits="1"/> km</td>
                            <td class="py-3 px-4">${row.nextMaintenanceDate}</td>
                            <td class="py-3 px-4">
                                <span class="px-2.5 py-1 rounded-full text-xs font-medium ${row.statusLabel == 'Quá hạn bảo dưỡng' ? 'bg-rose-100 text-rose-700' : 'bg-emerald-100 text-emerald-700'}">
                                    ${row.statusLabel}
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </section>
    </main>
</body>
</html>
