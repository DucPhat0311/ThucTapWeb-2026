<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - AURA Studio</title>
    <link rel="stylesheet" href="css/include/header.css">
    <link rel="stylesheet" href="css/include/footer.css">
    <link rel="stylesheet" href="css/views/detail-product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<main class="product-detail">
    <div class="product-container">

        <!-- ========== HÌNH ẢNH ========== -->
        <div class="product-image">
            <c:set var="hasMain" value="false" />
            <c:forEach var="img" items="${images}">
                <c:if test="${img.main}">
                    <img id="main-image" src="${img.imageUrl}" alt="${product.name}">
                    <c:set var="hasMain" value="true" />
                </c:if>
            </c:forEach>

            <c:if test="${not hasMain}">
                <img id="main-image" src="${product.thumbnail}" alt="${product.name}">
            </c:if>

            <div class="image-thumbs">
                <c:forEach var="img" items="${images}">
                    <img class="thumb ${img.main ? 'active' : ''}"
                         src="${img.imageUrl}"
                         alt="${product.name}">
                </c:forEach>
            </div>
        </div>

        <!-- THÔNG TIN CHUNG -->
        <div class="product-info">
            <h1 class="product-name">${product.name}</h1>

            <p class="product-price">Giá:
                <c:choose>
                    <c:when test="${product.sale_price > 0 && product.sale_price < product.price}">
                        <span style="color:red;font-weight:bold"><fmt:formatNumber value="${product.sale_price}" type="number"/>₫</span>
                        <span style="text-decoration: line-through; color: #888; margin-left: 8px;"><fmt:formatNumber value="${product.price}" type="number"/>₫</span>
                    </c:when>
                    <c:otherwise>
                        <span style="font-weight:bold"><fmt:formatNumber value="${product.price}" type="number"/>₫</span>
                    </c:otherwise>
                </c:choose>
            </p>

            <!-- LƯỢT RATING -->
            <div class="product-rating">
                <c:forEach begin="1" end="${displayStar}"><i class="fa-solid fa-star" style="color: #FFD43B;"></i></c:forEach>

                <c:forEach begin="1" end="${5 - displayStar}"><i class="fa-regular fa-star" style="color: #FFD43B;"></i></c:forEach>

                (${totalReviews} đánh giá)
            </div>

            <!-- CHỌN MÀU -->
            <div class="product-colors">
                <p><strong>Màu sắc:</strong></p>
                <div class="color-options">
                    <c:forEach var="color" items="${colors}">
                        <button class="color-btn" data-color-id="${color.id}">
                                ${color.name}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- CHỌN SIZE -->
            <div class="product-sizes">
                <p><strong>Chọn size:</strong></p>
                <div class="size-options">
                    <c:forEach var="s" items="${sizes}">
                        <button class="size-btn"
                                data-size-id="${s.id}">
                                ${s.code}
                        </button>
                    </c:forEach>
                </div>
            </div>

            <!-- SỐ LƯỢNG -->
            <div class="product-quantity">
                <p><strong>Số lượng:</strong></p>
                <div class="quantity-control">
                    <button class="btn-decrease">−</button>
                    <input type="number" id="quantity" min="1" value="1">
                    <button class="btn-increase">+</button>
                </div>
            </div>

            <!-- NÚT MUA -->
            <div class="product-actions">
                <button class="btn-add-cart">Thêm vào giỏ hàng</button>
            </div>
        </div>
    </div>

    <!-- MÔ TẢ + THÔNG TIN -->
    <section class="product-info-tabs">
        <h2>Mô tả chi tiết</h2>
        <div class="product-description-content">
            ${product.description}
        </div>
    </section>

    <!-- ========== ĐÁNH GIÁ ========== -->
    <section class="product-review">
        <form action="review" method="post" class="review-form">
            <input type="hidden" name="product_id" value="${product.id}">
            <input type="hidden" name="rating" id="rating-value">

            <div class="star-select">
                <i class="fa-solid fa-star star" data-value="1"></i>
                <i class="fa-solid fa-star star" data-value="2"></i>
                <i class="fa-solid fa-star star" data-value="3"></i>
                <i class="fa-solid fa-star star" data-value="4"></i>
                <i class="fa-solid fa-star star" data-value="5"></i>
            </div>

            <textarea id="review-text" name="comment" required placeholder="Nhập nhận xét của bạn..."></textarea>

            <button type="submit" id="submit-review">Gửi đánh giá</button>
        </form>

        <section class="review-list">
            <h3>Đánh giá của khách hàng</h3>

            <c:if test="${empty reviews}">
                <p>Chưa có đánh giá nào.</p>
            </c:if>

            <c:forEach var="r" items="${reviews}">
                <div class="review-item">
                    <strong>User ${r.userId}</strong>
                    <div>
                        <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star" style="color: #FFD43B;"></i></c:forEach>
                    </div>
                    <p>${r.comment}</p>
                    <small>${r.createdAt}</small>
                </div>
            </c:forEach>
        </section>
    </section>

    <!-- ========== GỢI Ý SẢN PHẨM ========== -->
    <section class="suggested-products">
        <h2>Sản phẩm phù hợp khác</h2>
        <div class="suggested-list">
            <c:forEach var="item" items="${ralatedProducts}">
                <div class="product-mini">
                    <a href="${pageContext.request.contextPath}/detail-product?id=${item.id}" class="link-cover"></a>
                    <img src="${item.thumbnail}" alt="${item.name}">
                <h3>${item.name}</h3>
                    <p class="price">
                        <c:choose>
                            <c:when test="${item.sale_price > 0 && item.sale_price < item.price}">
                                <span class="new-price" style="color:red;font-weight:bold">
                                    <fmt:formatNumber value="${item.sale_price}" type="number"/>đ
                                </span>
                                <span class="old-price" style="text-decoration: line-through; color: #888; margin-left: 8px;">
                                    <fmt:formatNumber value="${item.price}" type="number"/>đ
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="new-price" style="font-weight:bold">
                                    <fmt:formatNumber value="${item.price}" type="number"/>đ
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/detail-product?id=${item.id}&quantity=1" class="btn-add">Thêm vào giỏ hàng</a>
                </div>
            </c:forEach>

            <c:if test="${empty ralatedProducts}">
                <p>Không tìm thấy sản phẩm phù hợp khác.</p>
            </c:if>
        </div>
        <a href="san-pham" class="btn-view-more">Xem thêm</a>
    </section>
</main>

<div id="toast"></div>

<script>
    const variants = [
        <c:forEach var="v" items="${variants}" varStatus="st">
        {
            id: ${v.id},
            colorId: ${v.colorId},
            sizeId: ${v.sizeId},
            stock: ${v.stock}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
</script>

<%@include file="../include/footer.jsp"%>


</body>


<script src="${pageContext.request.contextPath}/js/views/detail-product.js"></script>


</html>