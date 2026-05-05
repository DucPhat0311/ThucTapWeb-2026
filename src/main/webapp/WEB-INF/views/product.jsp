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
        <h2></h2>

        <div class="sort-dropdown">
            <span>Sắp xếp theo:</span>
            <select onchange="sort(this.value)" class="sort-select">
                <option value="new" ${param.sortType == 'new' || empty param.sortType ? 'selected' : ''}>Mới nhất</option>
                <option value="oldest" ${param.sortType == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                <option value="price_up" ${param.sortType == 'price_up' ? 'selected' : ''}>Giá thấp → cao</option>
                <option value="price_down" ${param.sortType == 'price_down' ? 'selected' : ''}>Giá cao → thấp</option>
                <option value="name_az" ${param.sortType == 'name_az' ? 'selected' : ''}>Tên A-Z</option>
                <option value="name_za" ${param.sortType == 'name_za' ? 'selected' : ''}>Tên Z-A</option>
                <option value="best_seller" ${param.sortType == 'best_seller' ? 'selected' : ''}>Bán chạy nhất</option>
            </select>
        </div>
    </div>


    <div class="shop-container">
        <aside class="sidebar">
            <div class="filter-section">
                <h3>Khoảng Giá</h3>
                <div class="price-input">
                    <input type="number" id="min-price"
                           value="${not empty param.minPrice ? param.minPrice : 0}">
                    <span>-</span>
                    <input type="number" id="max-price"
                           value="${not empty param.maxPrice ? param.maxPrice : 2000000}">
                </div>


                <div class="range-slider">
                    <input type="range" id="range-min" min="0" max="5000000" step="50000"
                           value="${not empty param.minPrice ? param.minPrice : 0}">
                </div>

                <button type="button" class="btn-apply" onclick="filterPrice()">Lọc Kết Quả</button>
                <small class="price-unit">* Đơn vị: VNĐ</small>

                <h3>Danh mục</h3>
                <div class="filter-buttons">
                    <button class="${empty param.categoryId ? 'active' : ''}" style="width: 100%;" onclick="chooseCategory('')">Tất cả sản phẩm</button>


                    <c:forEach var="cat" items="${categoryList}">
                        <div class="dropdown ${param.categoryId == cat.id ? 'open' : ''}">
                            <button class="dropbtn ${param.categoryId == cat.id ? 'active' : ''}" onclick="this.parentElement.classList.toggle('open')" style="width: 100%;">
                                <span>${cat.name}</span> <i class="fa-solid fa-caret-down"></i>
                            </button>
                            <div class="dropdown-content">
                                <a style="cursor: pointer;" onclick="chooseCategory('${cat.id}')"
                                   class="${param.categoryId == cat.id ? 'active' : ''}">
                                    Tất cả ${cat.name}
                                </a>


                                <c:forEach var="sub" items="${cat.subCategories}">
                                    <a style="cursor: pointer;" onclick="chooseCategory('${sub.id}')"
                                       class="${param.categoryId == sub.id ? 'active' : ''}" style="font-weight: 600; background-color: #f9f9f9;">
                                            ${sub.name}
                                    </a>


                                    <c:if test="${not empty sub.subCategories}">
                                        <c:forEach var="sub3" items="${sub.subCategories}">
                                            <a style="cursor: pointer;" onclick="chooseCategory('${sub3.id}')"
                                               class="${param.categoryId == sub3.id ? 'active' : ''}" style="padding-left: 20px; font-size: 0.9em; color: #555;">
                                                - ${sub3.name}
                                            </a>
                                        </c:forEach>
                                    </c:if>
                                </c:forEach>


                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </aside>


        <div class="main-products">
            <div class="product-list">
                <c:choose>
                    <c:when test="${not empty productList}">
                        <c:forEach var="p" items="${productList}">
                            <div class="product-card">
                                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>
                                <img src="${pageContext.request.contextPath}/img/products${p.thumbnail}" alt="${p.name}">


                                <div class="card-content">
                                    <h3>${p.name}</h3>
                                    <fmt:setLocale value="vi_VN"/>
                                    <div class="price">
                                        <c:choose>
                                            <c:when test="${p.sale_price > 0 && p.sale_price < p.price}">
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
                                </div>


                                <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="btn-add">
                                    Chi tiết
                                </a>
                            </div>
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


</script>


<%@ include file="../include/footer.jsp" %>