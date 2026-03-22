<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đơn hàng của tôi - AURA Studio</title>
    <link rel="stylesheet" href="css/views/order-user.css">
    <link rel="stylesheet" href="css/views/shared-profile.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ===== HEADER ===== -->
<%@ include file="../include/header.jsp" %>

<!-- ===== ORDERS ===== -->
<section class="profile-container">

    <!-- ===== SIDEBAR ===== -->
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <img src="img/avt.jpg" alt="Avatar">
                <button type="button" class="change-avatar-btn">Đổi ảnh</button>
            </div>
        </div>

        <nav class="profile-menu">
            <ul>
                <li>
                    <a href="#"><i class="fas fa-user"></i> Thông tin cá nhân</a>
                </li>
                <li>
                    <a href="#"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a>
                </li>
                <li class="active">
                    <a href="#"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a>
                </li>
                <li>
                    <a href="#"><i class="fas fa-lock"></i> Đổi mật khẩu</a>
                </li>
                <li>
                    <a href="#"><i class="fa fa-sign-out"></i> Đăng xuất</a>
                </li>
            </ul>
        </nav>
    </div>

    <!-- ===== CONTENT ===== -->
    <div class="profile-content">
        <h2>Đơn hàng của tôi</h2>

        <!-- ===== TAB FILTER ===== -->
        <div class="order-tabs">
            <a href="#" class="tab-item active">Tất cả</a>
            <a href="#" class="tab-item">Chờ xác nhận</a>
            <a href="#" class="tab-item">Đang giao hàng</a>
            <a href="#" class="tab-item">Đã giao</a>
            <a href="#" class="tab-item">Đã hủy</a>
        </div>

        <!-- ===== ORDER ITEM 1 - PENDING ===== -->
        <div class="order-item">
            <div class="order-center">
                <div class="order-left">
                    <div class="single-product">
                        <img src="img/aox.webp" alt="Áo sơ mi nam">
                        <div class="order-info">
                            <h3>Áo sơ mi nam</h3>
                            <p>Phân loại: Trắng, L</p>
                            <p>x1</p>
                        </div>
                    </div>
                </div>

                <div class="order-right">
                    <span class="status">Chờ xác nhận</span>
                    <p class="price">350.000₫</p>
                </div>
            </div>

            <div class="order-actions">
                <a href="order-detail.jsp" class="btn-order-action btn-detail">Xem chi tiết</a>
                <a href="cancelled-order.jsp" class="btn-order-action btn-cancel">Hủy đơn</a>
            </div>
        </div>

        <!-- ===== ORDER ITEM 2 - SHIPPING ===== -->
        <div class="order-item">
            <div class="order-center">
                <div class="order-left multiple">
                    <div class="single-product">
                        <img src="img/aox.webp" alt="Áo thun basic">
                        <div class="order-info">
                            <h3>Áo thun basic</h3>
                            <p>Phân loại: Đen, M</p>
                            <p>x1</p>
                        </div>
                    </div>

                    <div class="single-product">
                        <img src="img/aox.webp" alt="Quần jean nam">
                        <div class="order-info">
                            <h3>Quần jean nam</h3>
                            <p>Phân loại: Xanh, 32</p>
                            <p>x1</p>
                        </div>
                    </div>
                </div>

                <div class="order-right">
                    <span class="status">Đang giao hàng</span>
                    <p class="price">720.000₫</p>
                </div>
            </div>

            <div class="order-actions">
                <a href="order-detail.jsp" class="btn-order-action btn-detail">Xem chi tiết</a>
                <a href="#" class="btn-order-action btn-confirm">Đã nhận hàng</a>
            </div>
        </div>

        <!-- ===== ORDER ITEM 3 - DELIVERED ===== -->
        <div class="order-item">
            <div class="order-center">
                <div class="order-left">
                    <div class="single-product">
                        <img src="img/aox.webp" alt="Váy nữ">
                        <div class="order-info">
                            <h3>Váy nữ</h3>
                            <p>Phân loại: Hồng, S</p>
                            <p>x1</p>
                        </div>
                    </div>
                </div>

                <div class="order-right">
                    <span class="status">Đã giao</span>
                    <p class="price">450.000₫</p>
                </div>
            </div>

            <div class="order-actions">
                <a href="order-detail.jsp" class="btn-order-action btn-detail">Xem chi tiết</a>
                <a href="reviews.jsp.jsp" class="btn-order-action btn-review">Đánh giá</a>
                <a href="#" class="btn-order-action btn-reorder">Mua lại</a>
            </div>
        </div>

        <!-- ===== ORDER ITEM 4 - CANCELLED ===== -->
        <div class="order-item">
            <div class="order-center">
                <div class="order-left">
                    <div class="single-product">
                        <img src="img/aox.webp" alt="Áo khoác nữ">
                        <div class="order-info">
                            <h3>Áo khoác nữ</h3>
                            <p>Phân loại: Be, M</p>
                            <p>x1</p>
                        </div>
                    </div>
                </div>

                <div class="order-right">
                    <span class="status">Đã hủy</span>
                    <p class="price">520.000₫</p>
                </div>
            </div>

            <div class="order-actions">
                <a href="order-detail.jsp.jsp" class="btn-order-action btn-detail">Xem chi tiết</a>
                <a href="#" class="btn-order-action btn-reorder">Mua lại</a>
            </div>
        </div>

    </div>
</section>

<!-- ===== FOOTER ===== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>