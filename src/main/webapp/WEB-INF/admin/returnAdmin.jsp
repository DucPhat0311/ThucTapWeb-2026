<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý yêu cầu trả hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/returnAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp"/>

    <section class="content">
        <header class="topbar">
            <div>
                <h1>Yêu cầu trả hàng</h1>
                <p class="page-subtitle">Tiếp nhận và duyệt các yêu cầu trong thời hạn đổi trả.</p>
            </div>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main class="page active">
            <div class="cards return-cards">
                <a class="card ${empty currentStatus ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin">
                    Tổng yêu cầu<span>${total}</span>
                </a>
                <a class="card ${currentStatus == 'REQUESTED' ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin?status=REQUESTED">
                    Chờ duyệt<span>${countRequested}</span>
                </a>
                <a class="card ${currentStatus == 'APPROVED' ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin?status=APPROVED">
                    Đã chấp nhận<span>${countApproved}</span>
                </a>
                <a class="card ${currentStatus == 'RETURNING' ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin?status=RETURNING">
                    Đang hoàn hàng<span>${countReturning}</span>
                </a>
                <a class="card ${currentStatus == 'REJECTED' ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin?status=REJECTED">
                    Đã từ chối<span>${countRejected}</span>
                </a>
                <a class="card ${currentStatus == 'RETURNED' ? 'active' : ''}" href="${pageContext.request.contextPath}/returnAdmin?status=RETURNED">
                    Đã hoàn hàng<span>${countReturned}</span>
                </a>
            </div>

            <div class="user-table-wrapper return-table-wrapper">
                <table class="order-table return-table">
                    <thead>
                    <tr>
                        <th>Yêu cầu</th>
                        <th>Đơn hàng</th>
                        <th>Khách hàng</th>
                        <th>Lý do</th>
                        <th>Ngày gửi</th>
                        <th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:if test="${empty returns}">
                        <tr>
                            <td colspan="7" class="empty-row">Chưa có yêu cầu trả hàng phù hợp.</td>
                        </tr>
                    </c:if>
                    <c:forEach items="${returns}" var="returnRequest">
                        <tr>
                            <td>#${returnRequest.id}</td>
                            <td>#${returnRequest.orderId}</td>
                            <td><c:out value="${returnRequest.customerName}"/></td>
                            <td><c:out value="${returnRequest.reasonLabel}"/></td>
                            <td>${returnRequest.requestedAtFormatted}</td>
                            <td>
                                <span class="return-status ${returnRequest.returnStatus}">
                                    <c:out value="${returnRequest.returnStatusLabel}"/>
                                </span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/returnAdmin?mode=view&amp;id=${returnRequest.id}"
                                   class="icon-btn view" title="Xem và xử lý yêu cầu" aria-label="Xem và xử lý yêu cầu">
                                    <i class="fa fa-eye"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <c:if test="${totalPages > 1}">
                <c:choose>
                    <c:when test="${not empty currentStatus}">
                        <c:set var="statusParam" value="&amp;status=${currentStatus}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="statusParam" value=""/>
                    </c:otherwise>
                </c:choose>
                <div class="pagination">
                    <div class="pagination-info">
                        Hiển thị ${(currentPage - 1) * pageSize + 1}
                        - ${currentPage * pageSize > totalFiltered ? totalFiltered : currentPage * pageSize}
                        của ${totalFiltered} yêu cầu
                    </div>
                    <div class="pagination-controls">
                        <c:if test="${currentPage > 1}">
                            <a class="page-btn" href="${pageContext.request.contextPath}/returnAdmin?page=${currentPage - 1}${statusParam}">Trước</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="number">
                            <c:choose>
                                <c:when test="${number == currentPage}">
                                    <span class="page-btn active">${number}</span>
                                </c:when>
                                <c:otherwise>
                                    <a class="page-btn" href="${pageContext.request.contextPath}/returnAdmin?page=${number}${statusParam}">${number}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a class="page-btn" href="${pageContext.request.contextPath}/returnAdmin?page=${currentPage + 1}${statusParam}">Sau</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </main>
    </section>
</div>
</body>
</html>
