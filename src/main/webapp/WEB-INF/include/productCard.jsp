<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>


<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/productCard.css">
<c:set var="p" value="${requestScope.product_item}" />


<div class="product-card">
    <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>
    <div class="image-box">


    <img class="img-default" src="${aura:resolve(pageContext.request.contextPath, '/img/products', p.thumbnail, 'img/logo.png')}" alt="${p.name}">

        <c:if test="${not empty p.hoverImage}">
            <img class="img-hover" src="${aura:resolve(pageContext.request.contextPath, '/img/products', p.hoverImage, '')}" alt="${p.name}">
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
            <c:choose>
                <c:when test="${not empty p.totalReviews && p.totalReviews > 0}">
                    <c:set var="rating" value="${p.avgRating}" />
                    <c:set var="fullStars" value="${p.avgRating - (p.avgRating % 1)}" />
                    <c:set var="hasHalf" value="${(p.avgRating % 1) >= 0.3 ? 1 : 0}" />
                    <c:set var="emptyStars" value="${5 - fullStars - hasHalf}" />

                    <div class="stars" style="color: #ffb703;">
                        <c:forEach begin="1" end="${fullStars}">
                            <i class="fas fa-star"></i>
                        </c:forEach>

                        <c:if test="${hasHalf == 1}">
                            <i class="fas fa-star-half-alt"></i>
                        </c:if>

                        <c:if test="${emptyStars > 0}">
                            <c:forEach begin="1" end="${emptyStars}">
                                <i class="far fa-star"></i>
                            </c:forEach>
                        </c:if>
                    </div>

                    <div class="rating-info">
                        <span class="rating-avg">${p.avgRating}</span>
                        <span class="rating-count">(${p.totalReviews} đánh giá)</span>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="stars" style="color: #ccc;">
                        <i class="far fa-star"></i>
                        <i class="far fa-star"></i>
                        <i class="far fa-star"></i>
                        <i class="far fa-star"></i>
                        <i class="far fa-star"></i>
                    </div>
                    <div class="rating-info">
                        <span class="no-rating" style="color: #777; font-size: 13px; font-style: italic;">
                            Chưa đánh giá
                        </span>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

