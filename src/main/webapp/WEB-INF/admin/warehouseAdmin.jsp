<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Kho</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/warehouse.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>
<div class="admin">

    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
        <header class="topbar">
            <h1 id="pageTitle">Quản Lý Kho</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <div class="tab-container">
                <div class="tab-link active" onclick="openTab(event, 'import')">Nhập Kho</div>
                <div class="tab-link" onclick="openTab(event, 'export')">Xuất Kho</div>
            </div>

            <div id="import" class="tab-content active">
                <div class="tab-header">
                    <h3>Lịch sử nhập kho</h3>
                    <a href="${pageContext.request.contextPath}/admin/warehouseForm" class="add-btn">Thêm phiếu nhập</a>
                </div>
                <div class="user-table-wrapper">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>Mã Phiếu Nhập</th>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Ngày Nhập</th>
                            <th>Người Nhập</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>PN001</td>
                            <td>Áo Thun Nam</td>
                            <td>100</td>
                            <td>2026-05-04</td>
                            <td>Admin</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="export" class="tab-content">
                <div class="tab-header">
                    <h3>Lịch sử xuất kho</h3>
                    <a href="${pageContext.request.contextPath}/admin/warehouseForm" class="add-btn">Thêm phiếu xuất</a>
                </div>
                <div class="user-table-wrapper">
                    <table class="user-table">
                        <thead>
                        <tr>
                            <th>Mã Phiếu Xuất</th>
                            <th>Sản phẩm</th>
                            <th>Số lượng</th>
                            <th>Ngày Xuất</th>
                            <th>Người Xuất</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>PX001</td>
                            <td>Quần Jean Nữ</td>
                            <td>50</td>
                            <td>2026-05-03</td>
                            <td>Admin</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </section>
</div>
<script>
    function openTab(evt, tabName) {
        var i, tabcontent, tablinks;
        tabcontent = document.getElementsByClassName("tab-content");
        for (i = 0; i < tabcontent.length; i++) {
            tabcontent[i].style.display = "none";
        }
        tablinks = document.getElementsByClassName("tab-link");
        for (i = 0; i < tablinks.length; i++) {
            tablinks[i].className = tablinks[i].className.replace(" active", "");
        }
        document.getElementById(tabName).style.display = "block";
        evt.currentTarget.className += " active";
    }
</script>
</body>
</html>
