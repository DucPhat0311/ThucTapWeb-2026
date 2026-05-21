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
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
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
                                        <a href="${pageContext.request.contextPath}/admin/warehouseImportForm"
                                            class="btn-add">Thêm phiếu nhập</a>
                                    </div>
                                    <c:if test="${not empty message}">
                                        <div style="color: green; margin-bottom: 10px;">${message}</div>
                                        <c:remove var="message" scope="session" />
                                    </c:if>
                                    <c:if test="${not empty error}">
                                        <div style="color: red; margin-bottom: 10px;">${error}</div>
                                        <c:remove var="error" scope="session" />
                                    </c:if>

                                    <div class="user-table-wrapper">
                                        <table class="user-table">
                                            <thead>
                                                <tr>
                                                    <th>Mã Phiếu Nhập</th>
                                                    <th>Người Nhập</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Ngày Nhập</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${receipts}">
                                                    <c:if test="${r.type == 'IMPORT'}">
                                                        <tr>
                                                            <td>PN${r.id}</td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}"
                                                                    type="currency" currencySymbol="₫" />
                                                            </td>
                                                            <td>${r.createdAt}</td>
                                                            <td><span style="color: green; font-weight: bold;">
                                                                    <c:choose>
                                                                        <c:when test="${r.status == 'COMPLETED'}">Hoàn
                                                                            thành</c:when>
                                                                        <c:when test="${r.status == 'PENDING'}">Chờ xử
                                                                            lý</c:when>
                                                                        <c:when test="${r.status == 'CANCELLED'}">Đã hủy
                                                                        </c:when>
                                                                        <c:otherwise>${r.status}</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td><a href="?action=view&id=${r.id}"
                                                                    style="color: blue; text-decoration: underline;">Chi
                                                                    tiết</a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="6" style="text-align: center;">Chưa có phiếu nhập
                                                            nào</td>
                                                    </tr>
                                                </c:if>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div id="export" class="tab-content">
                                    <div class="tab-header">
                                        <h3>Lịch sử xuất kho</h3>
                                        <a href="${pageContext.request.contextPath}/admin/warehouseExportForm"
                                            class="btn-add">Thêm phiếu xuất</a>
                                    </div>
                                    <div class="user-table-wrapper">
                                        <table class="user-table">
                                            <thead>
                                                <tr>
                                                    <th>Mã Phiếu Xuất</th>
                                                    <th>Người Xuất</th>
                                                    <th>Tổng Tiền</th>
                                                    <th>Ngày Xuất</th>
                                                    <th>Trạng Thái</th>
                                                    <th>Hành Động</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="r" items="${receipts}">
                                                    <c:if test="${r.type == 'EXPORT'}">
                                                        <tr>
                                                            <td>PX${r.id}</td>
                                                            <td>${r.userName}</td>
                                                            <td>
                                                                <fmt:formatNumber value="${r.totalAmount}"
                                                                    type="currency" currencySymbol="₫" />
                                                            </td>
                                                            <td>${r.createdAt}</td>
                                                            <td><span style="color: orange; font-weight: bold;">
                                                                    <c:choose>
                                                                        <c:when test="${r.status == 'COMPLETED'}">Hoàn
                                                                            thành</c:when>
                                                                        <c:when test="${r.status == 'PENDING'}">Chờ xử
                                                                            lý</c:when>
                                                                        <c:when test="${r.status == 'CANCELLED'}">Đã hủy
                                                                        </c:when>
                                                                        <c:otherwise>${r.status}</c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </td>
                                                            <td><a href="?action=view&id=${r.id}"
                                                                    style="color: blue; text-decoration: underline;">Chi
                                                                    tiết</a></td>
                                                        </tr>
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${empty receipts}">
                                                    <tr>
                                                        <td colspan="6" style="text-align: center;">Chưa có phiếu xuất
                                                            nào</td>
                                                    </tr>
                                                </c:if>
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