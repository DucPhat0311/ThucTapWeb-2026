<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán - AURA Studio</title>
    <link rel="stylesheet" href="css/views/checkout.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ========== HEADER ========== -->
<%@ include file="../include/header.jsp" %>

<!-- ========== CHECKOUT ========== -->
<section class="checkout">
    <div class="checkout-container">
        <form>
            <!-- ===== LEFT ===== -->
            <div class="checkout-left">
                <h2>Thông tin giao hàng</h2>

                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="name" placeholder="Tên người nhận" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" placeholder="Nhập số điện thoại" required>
                </div>

                <div class="form-group">
                    <label>Địa chỉ nhận hàng</label>
                    <input type="text" name="address" placeholder="Số nhà, đường, phường/xã, quận/huyện" required>
                </div>

                <div class="form-group">
                    <label>Ghi chú</label>
                    <textarea name="note" placeholder="Giao giờ hành chính..."></textarea>
                </div>

                <h2>Phương thức thanh toán</h2>

                <div class="payment-method">
                    <label>
                        <input type="radio" name="paymentMethod" value="COD" checked>
                        Thanh toán khi nhận hàng (COD)
                    </label>

                    <label>
                        <input type="radio" name="paymentMethod" value="MOMO">
                        Ví điện tử MOMO
                    </label>

                    <label>
                        <input type="radio" name="paymentMethod" value="ONEPAY">
                        Thẻ ATM / Visa (OnePay)
                    </label>
                </div>
            </div>

            <!-- ===== RIGHT ===== -->
            <div class="checkout-right">
                <h3>Đơn hàng của bạn</h3>

                <div class="order-items">
                    <div class="order-item">
                        <img src="img/aox.webp" alt="Áo sơ mi nam">
                        <div class="info">
                            <p class="name">Áo sơ mi nam</p>
                            <p class="variant">Size L · Trắng</p>
                            <p class="qty">SL: 1</p>
                        </div>
                        <div class="price">350.000₫</div>
                    </div>

                    <div class="order-item">
                        <img src="img/aox.webp" alt="Quần jean nam">
                        <div class="info">
                            <p class="name">Quần jean nam</p>
                            <p class="variant">Size 32 · Xanh</p>
                            <p class="qty">SL: 1</p>
                        </div>
                        <div class="price">420.000₫</div>
                    </div>
                </div>

                <div class="order-summary">
                    <div>
                        <span>Tạm tính</span>
                        <span>770.000₫</span>
                    </div>

                    <div>
                        <span>Phí vận chuyển</span>
                        <span>Miễn phí</span>
                    </div>

                    <div class="total">
                        <span>Tổng cộng</span>
                        <span>770.000₫</span>
                    </div>
                </div>

                <button type="button" class="btn-checkout">
                    XÁC NHẬN THANH TOÁN
                </button>
            </div>
        </form>
    </div>
</section>

<!-- ========== FOOTER ========== -->
<%@ include file="../include/footer.jsp" %>

</body>
</html>
