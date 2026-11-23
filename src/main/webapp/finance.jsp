<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Doanh thu & Chi phí</title>
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
            <a href="${pageContext.request.contextPath}/employees" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Quản lý Nhân sự</a>
            <a href="${pageContext.request.contextPath}/finance" class="block px-4 py-3 rounded-lg bg-blue-600 text-white">Doanh thu & Chi phí</a>
            <a href="${pageContext.request.contextPath}/reports" class="block px-4 py-3 rounded-lg text-slate-300 hover:bg-slate-800">Báo cáo &amp; Bảo dưỡng</a>
        </nav>
        <div class="p-4 border-t border-slate-800 text-sm"><a href="${pageContext.request.contextPath}/login?action=logout" class="block px-4 py-2 rounded-lg text-slate-300 hover:bg-slate-800">Đăng xuất</a></div>
    </aside>

    <main class="flex-1 p-8 overflow-y-auto space-y-6">
        <h1 class="text-2xl font-bold text-slate-800">Doanh thu & Chi phí</h1>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <form method="post" action="${pageContext.request.contextPath}/finance" class="bg-white p-6 rounded-xl border border-slate-200 space-y-3">
                <h2 class="font-bold text-emerald-700">Ghi nhận Khoản Thu</h2>
                <input type="hidden" name="formType" value="revenue">
                <select name="tripId" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <c:forEach var="t" items="${trips}">
                        <option value="${t.id}">${t.tripCode} - ${t.routeName}</option>
                    </c:forEach>
                </select>
                <input type="number" name="ticketRevenue" required min="0" placeholder="Tiền vé (VNĐ)" class="w-full border rounded-lg px-3 py-2 text-sm">
                <input type="number" name="cargoRevenue" value="0" min="0" placeholder="Tiền hàng ký gửi (VNĐ)" class="w-full border rounded-lg px-3 py-2 text-sm">
                <input type="date" name="recordedDate" required class="w-full border rounded-lg px-3 py-2 text-sm">
                <button class="bg-emerald-600 text-white px-4 py-2 rounded-lg text-sm font-medium">Lưu khoản thu</button>
            </form>

            <form method="post" action="${pageContext.request.contextPath}/finance" class="bg-white p-6 rounded-xl border border-slate-200 space-y-3">
                <h2 class="font-bold text-rose-700">Ghi nhận Khoản Chi</h2>
                <input type="hidden" name="formType" value="expense">
                <select name="vehicleId" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <c:forEach var="v" items="${vehicles}">
                        <option value="${v.id}">${v.licensePlate} - ${v.brand}</option>
                    </c:forEach>
                </select>
                <select name="expenseType" class="w-full border rounded-lg px-3 py-2 text-sm">
                    <option value="Nhiên liệu (Dầu)">Nhiên liệu (Dầu)</option>
                    <option value="Phí cầu đường (BOT) & Bến bãi">Phí cầu đường (BOT) & Bến bãi</option>
                    <option value="Bảo dưỡng & Sửa chữa">Bảo dưỡng & Sửa chữa</option>
                    <option value="Phụ cấp tổ lái">Phụ cấp tổ lái</option>
                </select>
                <input type="number" name="amount" required min="0" placeholder="Số tiền chi (VNĐ)" class="w-full border rounded-lg px-3 py-2 text-sm">
                <div class="grid grid-cols-2 gap-2">
                    <input type="date" name="expenseDate" required class="border rounded-lg px-3 py-2 text-sm">
                    <input type="text" name="note" placeholder="Ghi chú" class="border rounded-lg px-3 py-2 text-sm">
                </div>
                <button class="bg-rose-600 text-white px-4 py-2 rounded-lg text-sm font-medium">Lưu khoản chi</button>
            </form>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
                <div class="px-6 py-3 bg-emerald-50 font-bold text-emerald-800 flex justify-between">
                    <span>Sổ Thu</span>
                    <span><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                </div>
                <table class="w-full text-left text-sm">
                    <tbody class="divide-y divide-slate-200">
                        <c:forEach var="r" items="${revenues}">
                            <tr>
                                <td class="py-3 px-4">${r.tripCode} (${r.routeName}) - ${r.recordedDate}</td>
                                <td class="py-3 px-4 text-right font-bold text-emerald-600"><fmt:formatNumber value="${r.total}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="bg-white rounded-xl border border-slate-200 overflow-hidden">
                <div class="px-6 py-3 bg-rose-50 font-bold text-rose-800 flex justify-between">
                    <span>Sổ Chi</span>
                    <span><fmt:formatNumber value="${totalExpense}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span>
                </div>
                <table class="w-full text-left text-sm">
                    <tbody class="divide-y divide-slate-200">
                        <c:forEach var="e" items="${expenses}">
                            <tr>
                                <td class="py-3 px-4">${e.licensePlate} - ${e.expenseType} (${e.expenseDate})</td>
                                <td class="py-3 px-4 text-right font-bold text-rose-600"><fmt:formatNumber value="${e.amount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>
</body>
</html>
