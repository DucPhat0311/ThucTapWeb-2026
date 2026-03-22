<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đánh giá sản phẩm - AURA Studio</title>
    <link rel="stylesheet" href="css/views/shared-profile.css">
    <link rel="stylesheet" href="css/views/reviews.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== REVIEW PAGE ========== -->
<section class="profile-container">
    <!-- ========== SIDEBAR ========== -->
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="img/avt.jpg" alt="Avatar">
                <button type="button" class="change-avatar-btn">Đổi ảnh</button>
            </div>
            <h3>Nguyễn Văn A</h3>
            <p>Thành viên từ: 01/01/2024</p>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="#"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li class="active"><a href="#"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li><a href="#"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="#"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <!-- ========== CONTENT ========== -->
    <div class="profile-content review-page">
        <div class="review-header">
            <div>
                <h2>Đánh giá sản phẩm</h2>
                <p class="review-subtitle">Đơn hàng: <strong>#AURA1025</strong></p>
            </div>
            <a href="#" class="btn-back-order">Quay lại chi tiết đơn hàng</a>
        </div>

        <!-- ========== PRODUCT 1 ========== -->
        <div class="review-card">
            <div class="review-product">
                <div class="review-product-left">
                    <img src="img/aox.webp" alt="Áo sơ mi nam">
                    <div class="review-product-info">
                        <h3>Áo sơ mi nam</h3>
                        <p>Phân loại: Trắng, L</p>
                        <p>Số lượng: 1</p>
                    </div>
                </div>

                <div class="review-status">
                    <span class="review-badge">Đã giao</span>
                </div>
            </div>

            <form class="review-form">
                <div class="form-group">
                    <label>Mức độ hài lòng</label>
                    <div class="star-rating">
                        <input type="radio" name="rating-1" id="star5-1">
                        <label for="star5-1"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-1" id="star4-1">
                        <label for="star4-1"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-1" id="star3-1" checked>
                        <label for="star3-1"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-1" id="star2-1">
                        <label for="star2-1"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-1" id="star1-1">
                        <label for="star1-1"><i class="fa-solid fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment1">Nội dung đánh giá</label>
                    <textarea id="comment1" rows="5" placeholder="Hãy chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                </div>

                <div class="review-actions">
                    <button type="button" class="btn-submit-review">Gửi đánh giá</button>
                </div>
            </form>
        </div>

        <!-- ========== PRODUCT 2 ========== -->
        <div class="review-card">
            <div class="review-product">
                <div class="review-product-left">
                    <img src="img/aox.webp" alt="Quần jean nam">
                    <div class="review-product-info">
                        <h3>Quần jean nam</h3>
                        <p>Phân loại: Xanh, 32</p>
                        <p>Số lượng: 1</p>
                    </div>
                </div>

                <div class="review-status">
                    <span class="review-badge">Đã giao</span>
                </div>
            </div>

            <form class="review-form">
                <div class="form-group">
                    <label>Mức độ hài lòng</label>
                    <div class="star-rating">
                        <input type="radio" name="rating-2" id="star5-2" checked>
                        <label for="star5-2"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-2" id="star4-2">
                        <label for="star4-2"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-2" id="star3-2">
                        <label for="star3-2"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-2" id="star2-2">
                        <label for="star2-2"><i class="fa-solid fa-star"></i></label>

                        <input type="radio" name="rating-2" id="star1-2">
                        <label for="star1-2"><i class="fa-solid fa-star"></i></label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="comment2">Nội dung đánh giá</label>
                    <textarea id="comment2" rows="5" placeholder="Hãy chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                </div>

                <div class="review-actions">
                    <button type="button" class="btn-submit-review">Gửi đánh giá</button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>