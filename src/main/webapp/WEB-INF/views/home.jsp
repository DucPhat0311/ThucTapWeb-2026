<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang chủ | AURA Studio</title>
    <link rel="stylesheet" href="css/views/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>

<section class="banner">
    <div class="slider">
        <div class="img-slides">
            <c:choose>
                <c:when test="${not empty banners}">
                    <c:forEach var="b" items="${banners}">
                        <div class="slide">
                            <a href="${b.navigateTo}">
                                <img src="${pageContext.request.contextPath}/img/${b.imageUrl}" alt="${b.title}">
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

<section class="products">
    <h2>Tuyển Tập Vừa Ra Mắt</h2>


    <div class="slider-wrapper">
        <div class="product-list" id="new-slider">
            <c:forEach var="p" items="${latestProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>

                    <div class="image-box">
                        <button class="wishlist-btn" title="Thêm vào yêu thích">
                            <i class="fa-regular fa-heart"></i>
                        </button>

                        <img class="img-default" src="${pageContext.request.contextPath}/img/products${p.thumbnail}" alt="${p.name}">

                        <c:if test="${not empty p.hoverImage}">
                            <img class="img-hover" src="${pageContext.request.contextPath}/img/products${p.hoverImage}" alt="${p.name}">
                        </c:if>
                    </div>

                    <div class="card-content">
                        <div class="variant-counts">
                            <span>+${p.colorCount} Màu sắc</span>
                            <span class="dot">&bull;</span>
                            <span>+${p.sizeCount} Kích thước</span>
                        </div>

                        <h3>${p.name}</h3>

                        <div class="price">
                            <c:choose>
                                <c:when test="${p.sale_price != null && p.sale_price lt p.price && p.sale_price gt 0}">
                                   <span class="new-price">
                                       <fmt:formatNumber value="${p.sale_price}" type="number" groupingUsed="true"/>đ
                                   </span>
                                    <span class="old-price">
                                       <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                   </span>
                                </c:when>
                                <c:otherwise>
                                   <span class="new-price">
                                       <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                   </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="rating-sold">
                            <div class="stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <div class="rating-info">
                                <span class="rating-avg">${not empty p.avgRating ? p.avgRating : '5.0'}</span>
                                <span class="rating-count">(${not empty p.totalReviews ? p.totalReviews : '0'} đánh giá)</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <button class="prev">&#10094;</button>
        <button class="next">&#10095;</button>
    </div>
</section>

<section class="categories">
    <h2>Khám Phá Phong Cách</h2>


    <c:forEach var="cat" items="${allCategories}" varStatus="status">
        <c:if test="${not empty cat.products}">


            <div class="category-block">
                <div class="category-title">${cat.name}</div>


                <div class="slider-wrapper">
                    <button class="prev">&#10094;</button>
                    <div class="category-products">

                        <c:forEach var="p" items="${cat.products}">

                            <div class="product-card">
                                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>

                                <div class="image-box">
                                    <button class="wishlist-btn">
                                        <i class="fa-regular fa-heart"></i>
                                    </button>

                                    <img class="img-default" src="${pageContext.request.contextPath}/img/products${p.thumbnail}" alt="${p.name}">

                                    <c:if test="${not empty p.hoverImage}">
                                        <img class="img-hover" src="${pageContext.request.contextPath}/img/products${p.hoverImage}" alt="${p.name}">
                                    </c:if>
                                </div>

                                <div class="card-content">
                                    <div class="variant-counts">
                                        <span>+${p.colorCount} Màu sắc</span>
                                        <span class="dot">&bull;</span>
                                        <span>+${p.sizeCount} Kích thước</span>
                                    </div>

                                    <h3>${p.name}</h3>

                                    <div class="price">
                                        <c:choose>
                                            <c:when test="${p.sale_price != null && p.sale_price lt p.price && p.sale_price gt 0}">
                                           <span class="new-price">
                                               <fmt:formatNumber value="${p.sale_price}" type="number" groupingUsed="true"/>đ
                                           </span>
                                                <span class="old-price">
                                               <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                           </span>
                                            </c:when>
                                            <c:otherwise>
                                           <span class="new-price">
                                               <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                                           </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="rating-sold">
                                        <div class="stars">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star-half-alt"></i>
                                        </div>
                                        <div class="rating-info">
                                            <span class="rating-avg">${not empty p.avgRating ? p.avgRating : '5.0'}</span>
                                            <span class="rating-count">(${not empty p.totalReviews ? p.totalReviews : 'none'} đánh giá)</span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </c:forEach>


                    </div>
                    <button class="next">&#10095;</button>
                </div>

                <div class="load-more">
                    <a href="product?categoryId=${cat.id}">Xem thêm</a>
                </div>
            </div>
        </c:if>
    </c:forEach>

</section>

<%@include file="../include/footer.jsp"%>
<script src="${pageContext.request.contextPath}/js/views/slider.js"></script>

</body>
</html>

