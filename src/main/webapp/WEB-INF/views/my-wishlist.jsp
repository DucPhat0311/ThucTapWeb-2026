<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle != null ? pageTitle : "Danh sách yêu thích - AURA Studio"}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/detail-product.css"> <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/wishlist.css">
</head>
<body>

<%@include file="../include/header.jsp"%>

<main class="wishlist-wrapper">
    <h1 class="wishlist-title">
        <i class="fa-solid fa-heart" style="color: #6F4E37; margin-right: 10px;"></i>Sản phẩm bạn đã yêu thích
    </h1>

    <c:choose>
        <c:when test="${not empty wishlistProducts}">
            <div class="wishlist-grid">
                <c:forEach var="item" items="${wishlistProducts}">
                    <c:set var="product_item" value="${item}" scope="request" />
                    <jsp:include page="../include/productCard.jsp" />
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="wishlist-empty">
                <i class="fa-regular fa-heart"></i>
                <p>Danh sách yêu thích của bạn hiện đang trống.</p>
                <a href="${pageContext.request.contextPath}/product" class="btn-shop-now">
                    Tiếp tục khám phá sản phẩm
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@include file="../include/footer.jsp"%>

</body>
</html>