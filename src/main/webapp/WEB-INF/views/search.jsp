<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Tìm kiếm - AURA Studio</title>
  <link rel="stylesheet" href="css/include/header.css">
  <link rel="stylesheet" href="css/include/footer.css">
  <link rel="stylesheet" href="css/views/search.css">
  <link rel="stylesheet" href="css/views/productCard.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>

<section class="products search-page">

  <h2 class="search-title">
    Kết quả tìm kiếm cho:
    <span class="keyword">"${param.keyword}"</span>
  </h2>

  <c:if test="${not empty list}">
        <span class="search-count" style="font-size: 1rem; color: #666; font-weight: normal;">
            (Tìm thấy ${fn:length(list)} sản phẩm)
        </span>
  </c:if>

  <c:if test="${empty list}">
    <p class="search-empty">
      Không tìm thấy sản phẩm phù hợp.
    </p>
  </c:if>

  <div class="product-list search-results">
    <c:forEach var="p" items="${list}" >
      <c:set var="product_item" value="${p}" scope="request" />
      <jsp:include page="../include/productCard.jsp" />

    </c:forEach>
  </div>

</section>



<%@include file="../include/footer.jsp"%>


</body>


</html>