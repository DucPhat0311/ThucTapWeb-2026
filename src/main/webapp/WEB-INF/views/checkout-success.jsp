<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng thành công - AURA Studio</title>
    <link rel="stylesheet" href="css/views/checkout-success.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== ORDER SUCCESS ========== -->
<div class="order-success-wrapper">
    <div class="success-top-banner">
        <div class="success-icon-wrapper">
            <i class="fa-solid fa-check"></i>
        </div>
        <h2>Cảm ơn <b>Nguyễn Văn A</b>, đơn hàng đã được đặt thành công!</h2>
        <p class="order-code">Mã đơn hàng của bạn: <b>#1025</b></p>
    </div>

    <div class="order-success-content">
        <div class="order-left">
            <div class="info-card">
                <h3><i class="fa-solid fa-location-dot"></i> Địa chỉ nhận hàng</h3>
                <div class="address-details">
                    <p class="name">Nguyễn Văn A</p>
                    <p class="phone">0123456789</p>
                    <p class="address-text">123 Nguyễn Trãi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh</p>
                    <p class="note"><b>Ghi chú:</b> Giao giờ hành chính</p>
                </div>
            </div>

            <div class="info-card">
                <h3><i class="fa-solid fa-circle-info"></i> Thông tin đơn hàng</h3>
                <ul class="order-updates">
                    <li><i class="fa-solid fa-money-bill-wave"></i> Phương thức: Thanh toán khi nhận hàng (COD)</li>
                    <li><i class="fa-solid fa-phone-volume"></i> Nhân viên giao hàng sẽ liên hệ trước khi giao</li>
                    <li><i class="fa-solid fa-truck-fast"></i> Thời gian dự kiến: Giao hàng tiêu chuẩn (3–5 ngày)</li>
                </ul>
            </div>

            <div class="action-buttons">
                <a href="#" class="btn-secondary">Đơn hàng của tôi</a>
                <a href="#" class="btn-main">Tiếp tục mua sắm</a>
            </div>
        </div>

        <div class="order-right">
            <h3><i class="fa-solid fa-bag-shopping"></i> Tóm tắt đơn hàng</h3>

            <div class="product-list">
                <div class="product-item">
                    <div class="product-img">
                        <img src="img/aox.webp" alt="Áo sơ mi nam">
                        <span class="qty-badge">1</span>
                    </div>
                    <div class="product-info">
                        <b>Áo sơ mi nam</b>
                        <p>Size: L | Màu: Trắng</p>
                    </div>
                    <div class="product-price">350.000₫</div>
                </div>

                <div class="product-item">
                    <div class="product-img">
                        <img src="img/aox.webp" alt="Quần jean nam">
                        <span class="qty-badge">1</span>
                    </div>
                    <div class="product-info">
                        <b>Quần jean nam</b>
                        <p>Size: 32 | Màu: Xanh</p>
                    </div>
                    <div class="product-price">420.000₫</div>
                </div>
            </div>

            <div class="summary-box">
                <div class="summary-row">
                    <span>Tạm tính</span>
                    <span>770.000₫</span>
                </div>
                <div class="summary-row">
                    <span>Phí vận chuyển</span>
                    <span>MIỄN PHÍ</span>
                </div>
                <hr class="divider">
                <div class="summary-total">
                    <span>Tổng cộng</span>
                    <span class="total-price">770.000₫</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>