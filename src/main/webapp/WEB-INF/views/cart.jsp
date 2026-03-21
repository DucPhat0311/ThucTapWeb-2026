<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Giỏ hàng - AURA Studio</title>
    <link rel="stylesheet" href="css/views/cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<div class="cart-title">
    <h2>GIỎ HÀNG CỦA BẠN</h2>
</div>

<section class="card">
    <div class="container">
        <div class="card-content-left">

            <!-- Nếu giỏ hàng trống -->
            <div class="empty-cart-msg">
                <i class="fa-solid fa-cart-shopping"></i>
                <p>Giỏ hàng của bạn đang trống</p>
                <a href="" class="btn-shopping-now">Mua sắm ngay</a>
            </div>

        </div>

        <div class="card-content-right">
            <table>
                <tr>
                    <th colspan="2">TỔNG TIỀN GIỎ HÀNG</th>
                </tr>
                <tr>
                    <td>TỔNG SẢN PHẨM</td>
                    <td><span>0</span></td>
                </tr>
                <tr>
                    <td>TỔNG TIỀN HÀNG</td>
                    <td><span>0</span>₫</td>
                </tr>
                <tr>
                    <td>TẠM TÍNH</td>
                    <td style="font-weight:bold"><span >0</span>₫</td>
                </tr>
            </table>

            <div class="card-content-right-button">
                <a href="">
                    <button >TIẾP TỤC MUA SẮM</button>
                </a>

                <button >THANH TOÁN</button>
            </div>
        </div>
    </div>
</section>

<%@include file="../include/footer.jsp"%>


</body>
</html>