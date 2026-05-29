<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
        <aside class="sidebar">
            <div class="filter-section">
                <h3>Khoảng Giá</h3>
                <div class="price-input">
                    <fmt:setLocale value="vi_VN"/>
                    <input type="text" id="min-price-display" value="<fmt:formatNumber value='${param.minPrice != null ? param.minPrice : 0}' pattern='#,###'/>">
                    <span>-</span>
                    <input type="text" id="max-price-display" value="<fmt:formatNumber value='${param.maxPrice != null ? param.maxPrice : 5000000}' pattern='#,###'/>">


                    <input type="hidden" name="minPrice" id="min-price" value="${param.minPrice != null ? param.minPrice : 0}">
                    <input type="hidden" name="maxPrice" id="max-price" value="${param.maxPrice != null ? param.maxPrice : 5000000}">
                </div>

                <div class="range-slider">
                    <input type="range" id="range-min" min="0" max="5000000" step="50000" value="${param.minPrice != null ? param.minPrice : 0}">
                </div>
            </div>



            <c:set var="selectedSizes" value="${fn:split(param.sizes, ',')}" />
            <c:set var="selectedColors" value="${fn:split(param.colors, ',')}" />

            <div class="filter-group">
                <div class="group-title">Kích thước</div>
                <div class="size-options">
                    <c:forEach var="sizeItem" items="${sizes}">
                        <c:set var="isSizeChecked" value="false" />
                        <c:forEach var="selectedSize" items="${selectedSizes}">
                            <c:if test="${selectedSize eq sizeItem.code}">
                                <c:set var="isSizeChecked" value="true" />
                            </c:if>
                        </c:forEach>

                        <label class="amazon-filter-item">
                            <input type="checkbox" class="size-checkbox" value="${sizeItem.code}" ${isSizeChecked ? 'checked' : ''}>
                            <span class="custom-checkbox"></span>
                            <span class="filter-text">${sizeItem.code}</span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <div class="filter-group">
                <div class="group-title">Màu sắc</div>
                <div class="color-grid">
                    <c:forEach var="colorItem" items="${colors}">
                        <c:set var="isColorChecked" value="false" />
                        <c:forEach var="selectedColor" items="${selectedColors}">
                            <c:if test="${selectedColor eq colorItem.code}">
                                <c:set var="isColorChecked" value="true" />
                            </c:if>
                        </c:forEach>

                        <label class="color-filter-item">
                            <input type="checkbox" class="color-checkbox" value="${colorItem.name}" ${isColorChecked ? 'checked' : ''}>
                            <span class="color-circle" style="background-color: ${colorItem.code};" title="${colorItem.name}"></span>
                        </label>
                    </c:forEach>
                </div>
            </div>

            <button type="button" class="btn-apply" onclick="applyFilters()">Lọc kết quả</button>
        </aside>

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
    const minDisplay = document.getElementById('min-price-display');
    const maxDisplay = document.getElementById('max-price-display');
    const minHidden = document.getElementById("min-price");
    const maxHidden = document.getElementById("max-price");


    function formatMoney(value) {
        if (!value || isNaN(value)) return "0";
        return parseInt(value).toLocaleString('vi-VN');
    }


    function unformatMoney(str) {
        if (!str) return "0";
        return str.toString().replace(/[\.,]/g, '');    }


    window.addEventListener('load', () => {
        if (rangeMin && minHidden) {
            rangeMin.value = minHidden.value;
        }
    });


    if (rangeMin) {
        rangeMin.addEventListener('input', function() {
            let val = this.value;
            minHidden.value = val;
            minDisplay.value = formatMoney(val);
        });
    }


    if (minDisplay) {
        minDisplay.addEventListener('input', function() {
            let cleanValue = unformatMoney(this.value).replace(/\D/g, '');
            let val = parseInt(cleanValue) || 0;


            if (val > 5000000) val = 5000000;
            if (val < 0) val = 0;


            minHidden.value = val;
            if (rangeMin) rangeMin.value = val;


            this.value = formatMoney(val);
        });
    }


    if (maxDisplay) {
        maxDisplay.addEventListener('input', function() {
            let cleanValue = unformatMoney(this.value).replace(/\D/g, '');
            let val = parseInt(cleanValue) || 0;
            if (val < 0) val = 0;


            maxHidden.value = val;
            this.value = formatMoney(val);
        });
    }

    function changeCategory(catId) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('categoryId', catId);
        urlParams.set('page', 1);
        window.location.href = window.location.pathname + "?" + urlParams.toString();
    }

    function applyFilters() {
        const urlParams = new URLSearchParams(window.location.search);
        const sizes = Array.from(document.querySelectorAll('.size-checkbox:checked')).map(cb => cb.value);
        const colors = Array.from(document.querySelectorAll('.color-checkbox:checked')).map(cb => cb.value);
        if (sizes.length > 0) urlParams.set('sizes', sizes.join(','));
        else urlParams.delete('sizes');
        if (colors.length > 0) urlParams.set('colors', colors.join(','));
        else urlParams.delete('colors');
        urlParams.set('minPrice', document.getElementById('min-price').value);
        urlParams.set('maxPrice', document.getElementById('max-price').value);
        urlParams.set('page', 1);
        window.location.href = window.location.pathname + "?" + urlParams.toString();
    }

    function sort(type) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('sortType', type);
        urlParams.set('page', 1);
        window.location.href = window.location.pathname + "?" + urlParams.toString();
    }

</script>

<%@ include file="../include/footer.jsp" %>
