<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hủy đơn hàng - AURA Studio</title>
    <link rel="stylesheet" href="css/views/shared-profile.css">
    <link rel="stylesheet" href="css/views/cancelled-order.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== HỦY ĐƠN HÀNG ========== -->
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
    <div class="profile-content cancel-order-page">
        <div class="cancel-header">
            <h2>Hủy đơn hàng</h2>
            <p class="cancel-subtitle">Bạn đang thao tác với đơn hàng <strong>#AURA1025</strong></p>
        </div>

        <div class="cancel-warning-box">
            <div class="warning-icon">
                <i class="fas fa-triangle-exclamation"></i>
            </div>
            <div class="warning-text">
                <h3>Xác nhận hủy đơn</h3>
                <p>
                    Sau khi hủy, đơn hàng sẽ chuyển sang trạng thái <strong>Đã hủy</strong>.
                    Thao tác này không thể hoàn tác.
                </p>
            </div>
        </div>

        <!-- ========== TÓM TẮT ĐƠN ========== -->
        <div class="cancel-section">
            <h3>Thông tin đơn hàng</h3>

            <div class="order-summary-box">
                <div class="summary-row">
                    <span>Mã đơn hàng</span>
                    <span>#AURA1025</span>
                </div>

                <div class="summary-row">
                    <span>Ngày đặt</span>
                    <span>22/03/2026</span>
                </div>

                <div class="summary-row">
                    <span>Trạng thái hiện tại</span>
                    <span class="current-status">Chờ xác nhận</span>
                </div>

                <div class="summary-row">
                    <span>Tổng tiền</span>
                    <span class="total-price">770.000₫</span>
                </div>
            </div>
        </div>

        <!-- ========== LÝ DO HỦY ========== -->
        <div class="cancel-section">
            <h3>Lý do hủy đơn</h3>

            <form class="cancel-form">
                <div class="reason-list">
                    <label class="reason-item">
                        <input type="radio" name="cancelReason" checked>
                        Tôi muốn thay đổi sản phẩm / phân loại
                    </label>

                    <label class="reason-item">
                        <input type="radio" name="cancelReason">
                        Tôi muốn thay đổi địa chỉ nhận hàng
                    </label>

                    <label class="reason-item">
                        <input type="radio" name="cancelReason">
                        Tôi không còn nhu cầu mua nữa
                    </label>

                    <label class="reason-item">
                        <input type="radio" name="cancelReason">
                        Thời gian giao hàng quá lâu
                    </label>

                    <label class="reason-item">
                        <input type="radio" name="cancelReason">
                        Lý do khác
                    </label>
                </div>

                <div class="form-group">
                    <label for="cancelNote">Ghi chú thêm</label>
                    <textarea id="cancelNote" rows="4" placeholder="Nhập lý do chi tiết nếu cần..."></textarea>
                </div>

                <div class="cancel-actions">
                    <a href="order-detail.jsp" class="btn-back">Quay lại</a>
                    <button type="button" class="btn-confirm-cancel">Xác nhận hủy đơn</button>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>