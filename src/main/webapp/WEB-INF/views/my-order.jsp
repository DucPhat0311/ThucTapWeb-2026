<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%!
    public String getStatusInVietnamese(String status) {
        if (status == null) return "Không xác định";
        switch (status) {
            case "PENDING": return "Chờ xác nhận";
            case "CONFIRMED": return "Đã xác nhận";
            case "SHIPPING": return "Đang giao hàng";
            case "DELIVERED": return "Đã giao";
            case "CANCELLED": return "Đã hủy";
            default: return status;
        }
    }
%>

<%
    request.setAttribute("pageCss", "views/my-order.css");
    request.setAttribute("pageTitle" , "Đơn hàng của tôi");
%>

<%@ include file="../include/header.jsp" %>

<!-- ===== PROFILE ===== -->
<section class="profile-container">

    <!-- SIDEBAR -->
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="${pageContext.request.contextPath}/img/avt.jpg" alt="Avatar">
                <button class="change-avatar-btn">Đổi ảnh</button>
            </div>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="dia-chi"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li class="active"><a href="don-mua"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li><a href="doi-mat-khau"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <!-- CONTENT -->
    <div class="profile-content">
        <h2>Đơn hàng của tôi</h2>

        <!-- TAB FILTER -->
        <div class="order-tabs">
            <a href="don-mua?status=all" class="tab-item ${currentStatus == 'all' || empty currentStatus ? 'active' : ''}">
                Tất cả
            </a>
            <a href="don-mua?status=PENDING" class="tab-item ${currentStatus == 'PENDING' ? 'active' : ''}">
                Chờ xác nhận
            </a>
            <a href="don-mua?status=SHIPPING" class="tab-item ${currentStatus == 'SHIPPING' ? 'active' : ''}">
                Đang giao hàng
            </a>
            <a href="don-mua?status=DELIVERED" class="tab-item ${currentStatus == 'DELIVERED' ? 'active' : ''}">
                Đã giao
            </a>
            <a href="don-mua?status=CANCELLED" class="tab-item ${currentStatus == 'CANCELLED' ? 'active' : ''}">
                Đã hủy
            </a>
        </div>

        <c:if test="${empty orders}">
            <p style="text-align:center; padding:30px; color:#888">
                Bạn chưa có đơn hàng nào.
            </p>
        </c:if>

        <c:forEach var="o" items="${orders}">
            <div class="order-item">

                <div class="order-center">
                    <div class="order-left ${fn:length(o.items) > 1 ? 'multiple' : ''}">
                        <!-- Debug: items count = ${fn:length(o.items)} -->
                        <c:choose>
                            <c:when test="${empty o.items}">
                                <p style="color:red">Không có sản phẩm trong đơn hàng này</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="i" items="${o.items}">
                                    <div class="single-product">
                                        <img src="${not empty i.thumbnail ? i.thumbnail : './img/aox.webp'}" alt="${i.productName}">
                                        <div class="order-info">
                                            <h3>${i.productName}</h3>
                                            <p>Phân loại: ${i.color}, ${i.size}</p>
                                            <p>x${i.quantity}</p>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <div class="order-right">
                        <span class="status">
                            <% 
                                Model.Order order = (Model.Order) pageContext.getAttribute("o");
                                out.print(getStatusInVietnamese(order.getOrderStatus()));
                            %>
                        </span>
                        <p class="price">
                            <fmt:formatNumber value="${o.finalAmount}" type="number"/>₫
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

</section>

<!-- ===== FOOTER ===== -->
<%@ include file="../include/footer.jsp" %>

