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

<%@include file="../include/header.jsp"%>


<div class="title"></div>

<!-- HERO BANNER -->
<section class="hero-banner">
  <img src="img/.png" alt="Khuyến mãi" class="hero-bg">
  <div class="hero-content">
    <a href="product" class="btn-hero">Mua ngay</a>
  </div>
</section>

<!-- TẤT CẢ SẢN PHẨM ƯU ĐÃI -->
<section class="products">
  <h2>TẤT CẢ SẢN PHẨM ƯU ĐÃI</h2>

  <div class="product-grid discount-grid">
    <div class="product-card">
      <span class="badge flash">SALE -25%</span>
      <img src="img/.jpg" alt="Túi xách">
      <div class="product-info-wrapper">
        <h3>Túi xách</h3>
        <p class="price">
          <span class="new-price">149000₫</span>
          <span class="old-price">199000₫</span>
        </p>
      </div>
      <a href="" class="btn-add">Thêm vào giỏ hàng</a>
    </div>

    <div class="product-card">
      <span class="badge flash">SALE -10%</span>
      <img src="img/.jpg" alt="Mũ lưỡi trai">
      <div class="product-info-wrapper">
        <h3>Mũ lưỡi trai</h3>
        <p class="price">
          <span class="new-price">89000₫</span>
          <span class="old-price">99000₫</span>
        </p>
      </div>
      <a href="" class="btn-add">Thêm vào giỏ hàng</a>
    </div>

  </div>

  <div class="load-more-wrapper">
    <button class="btn-load-more">Xem thêm</button>
  </div>
</section>

<%@include file="../include/footer.jsp"%>


</body>
</html>