<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Tìm kiếm - AURA Studio</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/search.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/productCard.css">
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
       <span class="search-count" style="font-size: 1rem; color: #666; font-weight: normal; display: block; text-align: center; margin-bottom: 20px;">
           (Tìm thấy ${totalProducts} sản phẩm)
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


<c:if test="${totalPages > 1}">
  <div class="pagination">

    <c:if test="${currentPage > 1}">
      <a href="${pageContext.request.contextPath}/search?keyword=${param.keyword}&page=${currentPage - 1}">&laquo;</a>
    </c:if>

        <c:if test="${currentPage > 3}">
      <a href="${pageContext.request.contextPath}/search?keyword=${param.keyword}&page=1">1</a>
      <c:if test="${currentPage > 4}">
        <span class="paging-sep">...</span>
      </c:if>
    </c:if>

    <c:set var="begin" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
    <c:set var="end" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

        <c:forEach var="i" begin="${begin}" end="${end}">
      <a href="${pageContext.request.contextPath}/search?keyword=${param.keyword}&page=${i}"
         class="${currentPage == i ? 'active' : ''}">${i}</a>
    </c:forEach>

        <c:if test="${currentPage < totalPages - 2}">
      <c:if test="${currentPage < totalPages - 3}">
        <span class="paging-sep">...</span>
      </c:if>
      <a href="${pageContext.request.contextPath}/search?keyword=${param.keyword}&page=${totalPages}">${totalPages}</a>
    </c:if>


    <c:if test="${currentPage < totalPages}">
      <a href="${pageContext.request.contextPath}/search?keyword=${param.keyword}&page=${currentPage + 1}">&raquo;</a>
    </c:if>


  </div>
</c:if>


<%@include file="../include/footer.jsp"%>


</body>
</html>

