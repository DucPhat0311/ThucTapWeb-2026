<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="css/views/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<!-- ========== BANNER ========== -->
<section class="banner">

    <div class="slider">
        <div class="img-slides">
            <c:choose>
                <c:when test="${not empty banners}">
                    <c:forEach var="b" items="${banners}">
                        <div class="slide">
                            <a href="${b.navigateTo}">
                                <img src="${b.imageUrl}" alt="${b.title}">
                            </a>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="slide">
                        <img src="${pageContext.request.contextPath}/img/Banner.jpg" alt="AURA Banner 1">
                    </div>
                    <div class="slide">
                        <img src="${pageContext.request.contextPath}/img/Banner1.jpg" alt="AURA Banner 2">
                    </div>
                    <div class="slide">
                        <img src="${pageContext.request.contextPath}/img/Banner2.jpg" alt="AURA Banner 3">
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <button class="prev">&#10094;</button>
        <button class="next">&#10095;</button>
    </div>

</section>

<!-- ========== SẢN PHẨM ========== -->
<section class="products">
    <h2>Tuyển Tập Vừa Ra Mắt</h2>

    <div class="slider-wrapper">
        <div class="product-list" id="new-slider">
            <c:forEach var="p" items="${latestProducts}">
                <div class="product-card">
                    <a href="" class="link-cover"></a>
                    <img src="${p.thumbnail}" alt="${p.name}">
                    <h3>${p.name}</h3>

 <p class="price">
                        <c:choose>
                            <c:when test="${p.sale_price != null && p.sale_price lt p.price && p.sale_price gt 0}">
                                <span class="new-price">
                                    <fmt:formatNumber value="${p.sale_price}" type="number"/>đ
                                </span>
                                <span class="old-price">
                                    <fmt:formatNumber value="${p.price}" type="number"/>đ
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="new-price">
                                    <fmt:formatNumber value="${p.price}" type="number"/>đ
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                    <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="btn-add">
                        Thêm vào giỏ hàng
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>
</section>

<!-- ========== DANH MỤC ========== -->
<section class="categories">
    <h2>Khám Phá Phong Cách</h2>

<%--    Các danh mục--%>
    <c:forEach var="cat" items="${allCategories}" varStatus="status">
        <c:if test="${not empty cat.products}">

            <div class="category-block">
                <div class="category-title">${cat.name}</div>
                <div class="slider-wrapper">
                    <div class="category-products">
<%--                        Tên các sản phẩm--%>
                        <c:forEach var="p" items="${cat.products}">
                            <div class="product-mini">
                                <a href="" class="link-cover"></a>
                                <img src="${p.thumbnail}" alt="${p.name}">

                 <h3>${p.name}</h3>
                    <p class="price">
                        <c:choose>
                            <c:when test="${p.sale_price != null && p.sale_price lt p.price && p.sale_price gt 0}">
                                <span class="new-price">
                                    <fmt:formatNumber value="${p.sale_price}" type="number"/>đ
                                </span>
                                <span class="old-price">
                                    <fmt:formatNumber value="${p.price}" type="number"/>đ
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="new-price">
                                    <fmt:formatNumber value="${p.price}" type="number"/>đ
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </p>

                                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}&quantity=1" class="btn-add">
                                    Thêm vào giỏ hàng
                                </a>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <div class="load-more">
                    <a href="">Xem thêm</a>
                </div>
            </div>
        </c:if>
    </c:forEach>

</section>


<%@include file="../include/footer.jsp"%>
<script src="${pageContext.request.contextPath}/js/views/slider.js"></script>


</body>
</html>