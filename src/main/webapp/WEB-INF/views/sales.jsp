<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Khuyến mãi</title>

  <link rel="stylesheet" href="css/views/sales.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@ include file="../include/header.jsp" %>

<div class="title">
</div>

<section class="hero-banner">
  <img src="${pageContext.request.contextPath}/img/KhuyenMai.png" alt="Khuyến mãi" class="hero-bg">
  <div class="hero-content">
    <a href="${pageContext.request.contextPath}/product" class="btn-hero">Mua ngay</a>
  </div>
</section>

<section class="products">
  <h2>TẤT CẢ SẢN PHẨM ƯU ĐÃI</h2>

  <div class="product-grid discount-grid">
    <c:forEach items="${discountProducts}" var="p">
      <div class="product-card" data-product-id="${p.id}" data-sale-price="${p.sale_price}">
        <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a><span class="badge flash">SALE -${p.discountPercent}%</span><img src="${p.thumbnail}" alt="${p.name}">
        <div class="product-info-wrapper">
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
        </div>
        <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="btn-add">Thêm vào giỏ hàng</a>
      </div>
    </c:forEach>
  </div>

  <div class="load-more-wrapper">
    <button id="load-more" class="btn-load-more">Xem thêm</button>
  </div>
</section>

<%@ include file="../include/footer.jsp" %>

<div id="toast"></div>


</body>
</html>