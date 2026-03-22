<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng - AURA Studio</title>
    <link rel="stylesheet" href="css/views/shared-profile.css">
    <link rel="stylesheet" href="css/views/order-detail.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== CHI TIẾT ĐƠN HÀNG ========== -->
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

    <!-- ========== NỘI DUNG ========== -->
    <div class="profile-content order-detail-page">
        <div class="detail-header">
            <div>
                <h2>Chi tiết đơn hàng</h2>
                <p class="order-code">Mã đơn hàng: <strong>#AURA1025</strong></p>
            </div>

            <div class="detail-status">
                <span class="status-badge shipping">Đang giao hàng</span>
            </div>
        </div>

        <!-- ========== THÔNG TIN CHUNG ========== -->
        <div class="detail-section">
            <h3>Thông tin đơn hàng</h3>

            <div class="summary-grid">
                <div class="summary-item">
                    <span class="label">Ngày đặt hàng</span>
                    <span class="value">22/03/2026</span>
                </div>

                <div class="summary-item">
                    <span class="label">Phương thức thanh toán</span>
                    <span class="value">Thanh toán khi nhận hàng</span>
                </div>

                <div class="summary-item">
                    <span class="label">Hình thức giao hàng</span>
                    <span class="value">Giao hàng tiêu chuẩn</span>
                </div>

                <div class="summary-item">
                    <span class="label">Dự kiến giao</span>
                    <span class="value">25/03/2026</span>
                </div>
            </div>
        </div>

        <!-- ========== DANH SÁCH SẢN PHẨM ========== -->
        <div class="detail-section">
            <h3>Sản phẩm đã đặt</h3>

            <div class="detail-product-list">
                <div class="detail-product-item">
                    <div class="product-left">
                        <img src="img/aox.webp" alt="Áo sơ mi nam">
                        <div class="product-info">
                            <h4>Áo sơ mi nam</h4>
                            <p>Màu sắc: Trắng</p>
                            <p>Size: L</p>
                            <p>Số lượng: 1</p>
                        </div>
                    </div>
                    <div class="product-right">
                        <span class="price">350.000₫</span>
                    </div>
                </div>

                <div class="detail-product-item">
                    <div class="product-left">
                        <img src="img/aox.webp" alt="Quần jean nam">
                        <div class="product-info">
                            <h4>Quần jean nam</h4>
                            <p>Màu sắc: Xanh</p>
                            <p>Size: 32</p>
                            <p>Số lượng: 1</p>
                        </div>
                    </div>
                    <div class="product-right">
                        <span class="price">420.000₫</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ========== THÔNG TIN NHẬN HÀNG ========== -->
        <div class="detail-section">
            <h3>Thông tin nhận hàng</h3>

            <div class="info-box">
                <p><strong>Người nhận:</strong> Nguyễn Văn A</p>
                <p><strong>Số điện thoại:</strong> 0123456789</p>
                <p><strong>Địa chỉ:</strong> 123 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh</p>
                <p><strong>Ghi chú:</strong> Giao giờ hành chính</p>
            </div>
        </div>

        <!-- ========== TỔNG THANH TOÁN ========== -->
        <div class="detail-section">
            <h3>Tổng thanh toán</h3>

            <div class="payment-summary">
                <div class="payment-row">
                    <span>Tạm tính</span>
                    <span>770.000₫</span>
                </div>

                <div class="payment-row">
                    <span>Phí vận chuyển</span>
                    <span>Miễn phí</span>
                </div>

                <div class="payment-row total">
                    <span>Tổng cộng</span>
                    <span>770.000₫</span>
                </div>
            </div>
        </div>

        <!-- ========== NÚT CHỨC NĂNG ========== -->
        <div class="detail-actions">
            <a href="#" class="btn-back">Quay lại đơn hàng</a>
            <a href="cancelled-order.jsp" class="btn-cancel-order">Hủy đơn</a>
            <a href="#" class="btn-main">Đã nhận hàng</a>
        </div>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>