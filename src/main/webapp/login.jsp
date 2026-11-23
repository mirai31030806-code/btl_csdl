<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Quản lý - BusManager</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="min-h-screen bg-slate-100 flex items-center justify-center p-4">
    <div class="w-full max-w-md bg-white rounded-xl border border-slate-200 p-8 shadow-sm">
        <h1 class="text-xl font-bold text-slate-800 mb-1">Đăng nhập Quản lý</h1>
        <p class="text-sm text-slate-500 mb-6">BusManager - Hệ thống quản lý hãng xe khách</p>

        <c:if test="${not empty error}">
            <div class="mb-4 px-4 py-3 rounded-lg bg-rose-50 border border-rose-200 text-rose-700 text-sm">
                ${error}
            </div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/login" class="space-y-4">
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Tên đăng nhập</label>
                <input type="text" name="username" required autofocus
                       class="w-full border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div>
                <label class="block text-sm font-medium text-slate-700 mb-1">Mật khẩu</label>
                <input type="password" name="password" required
                       class="w-full border border-slate-300 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <button type="submit"
                    class="w-full bg-blue-600 text-white py-2.5 rounded-lg text-sm font-semibold hover:bg-blue-700 transition">
                Đăng nhập
            </button>
        </form>
    </div>
</body>
</html>
