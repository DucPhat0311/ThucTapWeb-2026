<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ</title>
    <link rel="stylesheet" href="views/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<%--<!-- ========== BANNER ========== -->--%>
<%--<section class="banner">--%>
<%--    <div class="slider">--%>
<%--        <div class="img-slides">--%>
<%--            <div class="slide">--%>
<%--                <img src="img/Banner1.jpg" alt="AURA Banner 1">--%>
<%--            </div>--%>
<%--            <div class="slide">--%>
<%--                <img src="img/Banner2.jpg" alt="AURA Banner 2">--%>
<%--            </div>--%>
<%--            <div class="slide">--%>
<%--                <img src="img/Banner3.jpg" alt="AURA Banner 3">--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        <button class="prev">&#10094;</button>--%>
<%--        <button class="next">&#10095;</button>--%>
<%--    </div>--%>
<%--</section>--%>

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
                            <span class="new-price">
                            <fmt:formatNumber value="${p.sale_price}" type="number"/>đ
                        </span>
                        <span class="old-price">
                            <fmt:formatNumber value="${p.price}" type="number"/>đ
                        </span>
                    </p>

                    <a href="" class="btn-add">
                        Thêm vào giỏ hàng
                    </a>
                </div>
            </c:forEach>
        </div>
        <div class="dots-container" id="new-dots"></div>
    </div>
</section>

<%--<!-- ========== DANH MỤC ========== -->--%>
<%--<section class="categories">--%>
<%--    <h2>Khám Phá Phong Cách</h2>--%>

<%--    <!-- Nam -->--%>
<%--    <div class="category-block">--%>
<%--        <div class="category-title">Thời trang Nam</div>--%>
<%--        <div class="slider-wrapper">--%>
<%--            <div class="category-products" id="boy-slider">--%>
<%--                <div class="product-mini">--%>
<%--                    <a href="chi-tiet-san-pham.html" class="link-cover"></a>--%>
<%--                    <img src="img/product1.jpg" alt="Áo nam">--%>
<%--                    <h3>Áo nam</h3>--%>
<%--                    <p class="price">--%>
<%--                        <span class="new-price">199000đ</span>--%>
<%--                        <span class="old-price">299000đ</span>--%>
<%--                    </p>--%>
<%--                    <a href="#" class="btn-add">Thêm vào giỏ hàng</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="dots-container" id="boy-dots"></div>--%>
<%--        </div>--%>
<%--        <div class="load-more">--%>
<%--            <a href="san-pham.html">Xem thêm</a>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- Nữ -->--%>
<%--    <div class="category-block" style="background-color: var(--secondary-color);">--%>
<%--        <div class="category-title">Thời trang Nữ</div>--%>
<%--        <div class="slider-wrapper">--%>
<%--            <div class="category-products" id="girl-slider">--%>
<%--                <div class="product-mini">--%>
<%--                    <a href="chi-tiet-san-pham.html" class="link-cover"></a>--%>
<%--                    <img src="img/product2.jpg" alt="Váy nữ">--%>
<%--                    <h3>Váy nữ</h3>--%>
<%--                    <p class="price">--%>
<%--                        <span class="new-price">299000đ</span>--%>
<%--                        <span class="old-price">399000đ</span>--%>
<%--                    </p>--%>
<%--                    <a href="#" class="btn-add">Thêm vào giỏ hàng</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="dots-container" id="girl-dots"></div>--%>
<%--        </div>--%>
<%--        <div class="load-more">--%>
<%--            <a href="san-pham.html">Xem thêm</a>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--    <!-- Phụ kiện -->--%>
<%--    <div class="category-block">--%>
<%--        <div class="category-title">Phụ kiện</div>--%>
<%--        <div class="slider-wrapper">--%>
<%--            <div class="category-products" id="acc-slider">--%>
<%--                <div class="product-mini">--%>
<%--                    <a href="chi-tiet-san-pham.html" class="link-cover"></a>--%>
<%--                    <img src="img/product3.jpg" alt="Túi xách">--%>
<%--                    <h3>Túi xách</h3>--%>
<%--                    <p class="price">--%>
<%--                        <span class="new-price">149000đ</span>--%>
<%--                        <span class="old-price">199000đ</span>--%>
<%--                    </p>--%>
<%--                    <a href="#" class="btn-add">Thêm vào giỏ hàng</a>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="dots-container" id="acc-dots"></div>--%>
<%--        </div>--%>
<%--        <div class="load-more">--%>
<%--            <a href="san-pham.html">Xem thêm</a>--%>
<%--        </div>--%>
<%--    </div>--%>

<%--</section>--%>

<%@include file="../include/header.jsp"%>


</body>
</html>