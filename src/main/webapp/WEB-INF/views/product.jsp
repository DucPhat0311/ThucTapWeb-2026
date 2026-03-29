<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%
    request.setAttribute("pageCss", "views/product.css");
    request.setAttribute("pageTitle" , "Trang chủ");
%>

<%@include file="../include/header.jsp"%>


<section class="products">
    <h2>SẢN PHẨM</h2>

    <div class="shop-container">
        <aside class="sidebar">
            <div class="filter-bar">

                <div class="filter-section">
                    <h3>Sắp xếp theo</h3>
                    <div class="filter-buttons">
                        <a href="product?group=${param.group}&category=${param.category}&sort=new">
                            <button class="${param.sort eq 'new' || empty param.sort ? 'active' : ''}">
                                Mới nhất
                            </button>
                        </a>

                        <a href="product?group=${param.group}&category=${param.category}&sort=best">
                            <button class="${param.sort eq 'best' ? 'active' : ''}">
                                Bán chạy
                            </button>
                        </a>

                        <a href="product?group=${param.group}&category=${param.category}&sort=sale">
                            <button class="${param.sort eq 'sale' ? 'active' : ''}">
                                Khuyến mãi
                            </button>
                        </a>

                        <!-- Dropdown: GIÁ -->
                        <div class="dropdown">
                            <button class="dropbtn
                        ${param.sort eq 'price_asc' || param.sort eq 'price_desc' ? 'active' : ''}">
                                Giá <i class="fa-solid fa-caret-down"></i>
                            </button>

                            <div class="dropdown-content">
                                <a class="${param.sort eq 'price_asc' ? 'active' : ''}"
                                   href="product?group=${param.group}&category=${param.category}&sort=price_asc">
                                    Giá thấp đến cao
                                </a>

                                <a class="${param.sort eq 'price_desc' ? 'active' : ''}"
                                   href="product?group=${param.group}&category=${param.category}&sort=price_desc">
                                    Giá cao đến thấp
                                </a>
                            </div>
                        </div>
                    </div>
                </div>


                <div class="filter-section">
                    <h3>Danh mục</h3>
                    <div class="filter-buttons">

                        <a href="product?sort=${param.sort}">
                            <button class="${empty param.category ? 'active' : ''}">
                                Tất cả
                            </button>
                        </a>

                        <c:forEach var="parent" items="${categories}">
                            <div class="dropdown">
                                <button class="dropbtn ${param.category == parent.id ? 'active' : ''}">
                                        ${parent.name} <i class="fa-solid fa-caret-down"></i>
                                </button>
                                <div class="dropdown-content">
                                    <a class="${param.category == parent.id ? 'active' : ''}"
                                       href="product?category=${parent.id}&sort=${param.sort}">
                                        Tất cả
                                    </a>

                                    <c:if test="${not empty parent.subCategories}">
                                        <c:forEach var="sub" items="${parent.subCategories}">
                                            <a class="${param.category == sub.id ? 'active' : ''}"
                                               href="product?category=${sub.id}&sort=${param.sort}">
                                                    ${sub.name}
                                            </a>
                                        </c:forEach>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>

            </div>
        </aside>

        <!-- Danh sách sản phẩm -->
        <div class="main-products">
            <div class="product-list">

                <c:forEach var="p" items="${list}" >
                    <div class="product-card">
                        <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="link-cover"></a>
                        <img src="${p.thumbnail}" alt="${p.name}">
                        <h3>${p.name}</h3>

           <fmt:setLocale value="vi_VN"/>
                <p class="price">
                    <c:choose>
                        <c:when test="${p.sale_price > 0 && p.sale_price < p.price}">
                            <span class="new-price" style="color:red;font-weight:bold">
                                <fmt:formatNumber value="${p.sale_price}" type="number" groupingUsed="true"/>đ
                            </span>
                            <span class="old-price" style="text-decoration: line-through; color: #888; margin-left: 8px;">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="new-price" style="font-weight:bold">
                                <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/>đ
                            </span>
                        </c:otherwise>
                    </c:choose>
                </p>

                        <a href="${pageContext.request.contextPath}/detail-product?id=${p.id}" class="btn-add">
                            Thêm vào giỏ hàng
                        </a>
                    </div>
                </c:forEach>


            </div>
            <div class="load-more-container">
                <button id="load-more">Xem thêm</button>
            </div>
        </div>
    </div>
</section>


<%@ include file="../include/footer.jsp" %>


