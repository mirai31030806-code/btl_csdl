<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>BusManager Pro - Tổng quan</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="flex h-screen bg-slate-100">
    <aside class="w-64 bg-slate-900 text-white flex flex-col">
        <div class="p-6 border-b border-slate-800 font-bold text-lg">BusManager Pro</div>
        <nav class="flex-1 p-4 space-y-2 text-sm">
            <a href="${pageContext.request.contextPath}/dashboard" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Tổng quan</a>
            <a href="${pageContext.request.contextPath}/trips" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Chuyến xe & Lịch trình</a>
            <a href="${pageContext.request.contextPath}/routes" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Tuyến xe</a>
            <a href="${pageContext.request.contextPath}/vehicles" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Đội xe</a>
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-6">
        <h1 class="text-2xl font-bold text-slate-800">Tổng quan hoạt động</h1>

        <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
            <div class="bg-white p-6 rounded-xl border border-slate-200">
                <p class="text-sm text-slate-500">Tổng Doanh Thu</p>
                <h2 class="text-xl font-bold text-emerald-600 mt-1"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h2>
            </div>
            <div class="bg-white p-6 rounded-xl border border-slate-200">
                <p class="text-sm text-slate-500">Tổng Chi Phí</p>
                <h2 class="text-xl font-bold text-rose-600 mt-1"><fmt:formatNumber value="${totalExpense}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h2>
            </div>
            <div class="bg-white p-6 rounded-xl border border-slate-200">
                <p class="text-sm text-slate-500">Lợi Nhuận Ròng</p>
                <h2 class="text-xl font-bold text-blue-600 mt-1"><fmt:formatNumber value="${netProfit}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></h2>
            </div>
            <div class="bg-white p-6 rounded-xl border border-slate-200">
                <p class="text-sm text-slate-500">Tổng Số Chuyến</p>
                <h2 class="text-xl font-bold text-slate-800 mt-1">${totalTrips} chuyến</h2>
                <p class="text-xs text-slate-500 mt-1">${readyVehicles}/${totalVehicles} xe sẵn sàng</p>
            </div>
        </div>

        <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
            <div class="px-6 py-4 border-b border-slate-200 font-bold text-slate-800">Chuyến xe gần đây</div>
            <table class="w-full text-left text-sm">
                <thead class="bg-slate-50 text-xs uppercase text-slate-500">
                    <tr>
                        <th class="py-3 px-6">Mã chuyến</th>
                        <th class="py-3 px-6">Tuyến</th>
                        <th class="py-3 px-6">Biển số</th>
                        <th class="py-3 px-6">Tài xế</th>
                        <th class="py-3 px-6">Hành khách</th>
                        <th class="py-3 px-6">Trạng thái</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <c:forEach var="t" items="${recentTrips}">
                        <tr>
                            <td class="py-3 px-6 font-semibold text-blue-600">${t.tripCode}</td>
                            <td class="py-3 px-6">${t.routeName}</td>
                            <td class="py-3 px-6">${t.licensePlate}</td>
                            <td class="py-3 px-6">${t.driverName}</td>
                            <td class="py-3 px-6">${t.passengerCount}/${t.seatCount}</td>
                            <td class="py-3 px-6">${t.status}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </main>
</body>
</html>
