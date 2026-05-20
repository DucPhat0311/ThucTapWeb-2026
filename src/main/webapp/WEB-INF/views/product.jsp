<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageCss", "views/product.css");
    request.setAttribute("pageTitle" , "Sản phẩm");
%>

<%@include file="../include/header.jsp"%>

<section class="products">
    <div class="shop-header">
        <div class="category-breadcrumb">
            <c:if test="${not empty currentParentCategory}">
                <span class="sep">/</span>
                <span class="breadcrumb-item active">${currentParentCategory.name}</span>
            </c:if>
        </div>

        <div class="sort-dropdown">
            <span>Sắp xếp theo:</span>
            <select onchange="sort(this.value)" class="sort-select">
                <option value="new" ${param.sortType == 'new' || empty param.sortType ? 'selected' : ''}>Mới nhất</option>
                <option value="price_up" ${param.sortType == 'price_up' ? 'selected' : ''}>Giá thấp → cao</option>
                <option value="price_down" ${param.sortType == 'price_down' ? 'selected' : ''}>Giá cao → thấp</option>
                <option value="best_seller" ${param.sortType == 'best_seller' ? 'selected' : ''}>Bán chạy nhất</option>
            </select>
        </div>
    </div>

    <div class="shop-container">


        <div class="main-products">
            <div class="category-navigation-wrapper">
                <nav class="routine-breadcrumb">
                    <a href="product">Trang chủ</a>
                    <c:forEach var="bc" items="${breadcrumbList}">
                        <span class="arrow">/</span>
                        <a href="product?categoryId=${bc.id}"
                           class="${bc.id == currentCategory.id ? 'active-link' : ''}">
                                ${bc.name}
                        </a>
                    </c:forEach>
                </nav>
                <div class="routine-tag-list">
                    <c:forEach var="tag" items="${displayTags}">
                        <a href="product?categoryId=${tag.id}"
                           class="tag-node ${param.categoryId == tag.id.toString() ? 'node-selected' : ''}">
                                ${tag.name}
                        </a>
                    </c:forEach>
                </div>
            </div>

            <div class="product-list">
                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="p" items="${productList}">
                            <c:set var="product_item" value="${p}" scope="request" />
                            <jsp:include page="../include/productCard.jsp" />
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="grid-column: 1/-1; text-align: center; padding: 80px 20px;">
                            <img src="https://cdn-icons-png.flaticon.com/512/6134/6134065.png" alt="No product" style="width: 100px; opacity: 0.3; margin-bottom: 20px;">
                            <p style="color: #888; font-size: 16px;">Không tìm thấy sản phẩm nào phù hợp trong danh mục này.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="product?groupId=${param.groupId}&categoryId=${param.categoryId}&sortType=${param.sortType}&page=${currentPage - 1}">&laquo;</a>
                </c:if>

                <c:if test="${currentPage > 3}">
                    <a href="product?groupId=${param.groupId}&categoryId=${param.categoryId}&sortType=${param.sortType}&page=1">1</a>
                    <c:if test="${currentPage > 4}">
                        <span class="paging-sep">...</span>
                    </c:if>
                </c:if>

                <c:set var="begin" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
                <c:set var="end" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

                <c:forEach var="i" begin="${begin}" end="${end}">
                    <a href="product?groupId=${param.groupId}&categoryId=${param.categoryId}&sortType=${param.sortType}&page=${i}"
                       class="${currentPage == i ? 'active' : ''}">${i}</a>
                </c:forEach>

                <c:if test="${currentPage < totalPages - 2}">
                    <c:if test="${currentPage < totalPages - 3}">
                        <span class="paging-sep">...</span>
                    </c:if>
                    <a href="product?groupId=${param.groupId}&categoryId=${param.categoryId}&sortType=${param.sortType}&page=${totalPages}">${totalPages}</a>
                </c:if>

                <c:if test="${currentPage < totalPages}">
                    <a href="product?groupId=${param.groupId}&categoryId=${param.categoryId}&sortType=${param.sortType}&page=${currentPage + 1}">&raquo;</a>
                </c:if>
            </div>

        </div>
    </div>
</section>

<script>
    const rangeMin = document.getElementById('range-min');
    const minInput = document.getElementById('min-price');
    const maxInput = document.getElementById('max-price');

    window.addEventListener('load', () => {
        if (rangeMin && minInput) {
            rangeMin.value = minInput.value;
        }
    });

    rangeMin.addEventListener('input', function() {
        minInput.value = this.value;
    });

    minInput.addEventListener('change', function() {
        let val = parseInt(this.value);
        if (val > 5000000) val = 5000000;
        if (val < 0) val = 0;
        this.value = val;
        rangeMin.value = val;
    });

    function changeCategory(catId) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('categoryId', catId);
        urlParams.set('page', 1);
        window.location.href = window.location.pathname + "?" + urlParams.toString();
    }

</script>

<%@ include file="../include/footer.jsp" %>
