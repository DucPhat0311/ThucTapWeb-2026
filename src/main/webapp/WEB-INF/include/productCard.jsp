<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="p" value="${requestScope.product_item}" />


<div class="product-card">
    <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>


    <div class="image-box">
        <button class="wishlist-btn" title="Thêm vào yêu thích">
            <i class="fa-regular fa-heart"></i>
        </button>


        <img class="img-default" src="${fn:startsWith(p.thumbnail, 'http') ? p.thumbnail : pageContext.request.contextPath.concat('/img/products').concat(p.thumbnail)}" alt="${p.name}">


        <c:if test="${not empty p.hoverImage}">
            <img class="img-hover" src="${fn:startsWith(p.hoverImage, 'http') ? p.hoverImage : pageContext.request.contextPath.concat('/img/products').concat(p.hoverImage)}" alt="${p.name}">
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

