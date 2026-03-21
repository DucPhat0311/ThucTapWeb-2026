<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - AURA Studio</title>
    <link rel="stylesheet" href="css/include/header.css">
    <link rel="stylesheet" href="css/include/footer.css">
    <link rel="stylesheet" href="css/views/pageatxl.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<main class="product-detail">
    <div class="product-container">

        <!-- HÌNH ẢNH -->
        <div class="product-image">
            <img id="main-image" src="img/.jpg" alt="Áo Thun Nam">
            <div class="image-thumbs">
                <img class="thumb active" src="img/.jpg" alt="Áo Thun Nam">
                <img class="thumb" src="img/.jpg" alt="Áo Thun Nam">
                <img class="thumb" src="img/.jpg" alt="Áo Thun Nam">
            </div>
        </div>

        <!-- THÔNG TIN CHUNG -->
        <div class="product-info">
            <h1 class="product-name">Áo Thun Nam</h1>

            <p class="product-price">Giá: <span>350.000₫</span></p>

            <!-- LƯỢT RATING -->
            <div class="product-rating">
                <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                <i class="fa-regular fa-star" style="color:#FFD43B;"></i>
                <i class="fa-regular fa-star" style="color:#FFD43B;"></i>
                (12 đánh giá)
            </div>

            <!-- CHỌN MÀU -->
            <div class="product-colors">
                <p><strong>Màu sắc:</strong></p>
                <div class="color-options">
                    <div class="color-thumb" style="background-color:#000000;"></div>
                    <div class="color-thumb" style="background-color:#FFFFFF;"></div>
                    <div class="color-thumb" style="background-color:#FF0000;"></div>
                </div>
            </div>

            <!-- CHỌN SIZE -->
            <div class="product-sizes">
                <p><strong>Chọn size:</strong></p>
                <div class="size-options">
                    <button class="size-btn">S</button>
                    <button class="size-btn">M</button>
                    <button class="size-btn">L</button>
                    <button class="size-btn">XL</button>
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
            Áo Thun Nam chất liệu cotton cao cấp, form vừa vặn, thoải mái, phù hợp mặc hàng ngày.
        </div>
    </section>

    <!-- ĐÁNH GIÁ -->
    <section class="product-review">
        <form class="review-form">
            <div class="star-select">
                <i class="fa-solid fa-star star" data-value="1"></i>
                <i class="fa-solid fa-star star" data-value="2"></i>
                <i class="fa-solid fa-star star" data-value="3"></i>
                <i class="fa-solid fa-star star" data-value="4"></i>
                <i class="fa-solid fa-star star" data-value="5"></i>
            </div>
            <textarea id="review-text" placeholder="Nhập nhận xét của bạn..."></textarea>
            <button type="button" id="submit-review">Gửi đánh giá</button>
        </form>

        <section class="review-list">
            <h3>Đánh giá của khách hàng</h3>
            <div class="review-item">
                <strong>User 1</strong>
                <div>
                    <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                    <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                    <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                </div>
                <p>Áo đẹp, mặc vừa vặn!</p>
                <small>20/03/2026</small>
            </div>
            <div class="review-item">
                <strong>User 2</strong>
                <div>
                    <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                    <i class="fa-solid fa-star" style="color:#FFD43B;"></i>
                    <i class="fa-regular fa-star" style="color:#FFD43B;"></i>
                </div>
                <p>Chất lượng ổn, giao hàng nhanh.</p>
                <small>18/03/2026</small>
            </div>
        </section>
    </section>

    <!-- GỢI Ý SẢN PHẨM -->
    <section class="suggested-products">
        <h2>Sản phẩm phù hợp khác</h2>
        <div class="suggested-list">
            <div class="suggested-item">
                <a href="" class="link-cover">
                    <img src="img/.jpg" alt="Váy Nữ">
                </a>
                <h3 class="name"><a href="">Váy Nữ</a></h3>
                <p class="price">Giá: <span class="new-price">450.000đ</span></p>
                <a href="" class="btn-add">Thêm vào giỏ</a>
            </div>

            <div class="suggested-item">
                <a href="" class="link-cover">
                    <img src="img/.jpg" alt="Quần Nam">
                </a>
                <h3 class="name"><a href="">Quần Nam</a></h3>
                <p class="price">Giá: <span class="new-price">320.000đ</span></p>
                <a href="" class="btn-add">Thêm vào giỏ</a>
            </div>
        </div>
        <a href="" class="btn-view-more">Xem thêm</a>
    </section>
</main>


<%@include file="../include/footer.jsp"%>


</body>
</html>