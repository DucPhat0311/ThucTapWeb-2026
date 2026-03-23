<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${pageTitle != null ? pageTitle : "AURA Studio"}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>

<body><footer class="footer">
    <div class="footer-container">
        <!-- Thông tin thương hiệu -->
        <div class="footer-info">
            <h3 class="footer-logo">AURA<span>Studio</span></h3>
            <p class="slogan">Định nghĩa sự thời trang và cập nhật xu hướng của bạn. Khám phá bộ sưu tập mang phong cách tối giản, thanh lịch và vượt thời gian cùng AURA.</p>
            <p><i class="fa-solid fa-phone"></i> Hotline: <strong>0888 888 888</strong></p>
            <p><i class="fa-solid fa-envelope"></i> Email: <strong>contact@AURAstudio.vn</strong></p>
        </div>

        <!-- Chăm sóc khách hàng -->
        <div class="footer-danhmuc">
            <h3>Chăm sóc khách hàng</h3>
            <a href="#">Trung tâm trợ giúp</a>
            <a href="#">Hướng dẫn mua sắm</a>
            <a href="#">Chính sách thanh toán</a>
            <a href="#">Chính sách đổi trả</a>
            <a href="#">Câu hỏi thường gặp</a>
        </div>

        <!-- Chi nhánh -->
        <div class="footer-contact">
            <h3>Hệ thống cửa hàng</h3>
            <p><i class="fa-solid fa-location-dot"></i> Trung tâm: FIT NLU, Đại học Nông Lâm</p>
            <p><i class="fa-solid fa-store"></i> CN 1: Quận 1, TPHCM</p>
            <h4 class="time-title">Thời gian hoạt động:</h4>
            <p>Thứ 2 - Thứ 6: 08:00 - 21:30</p>
            <p>Thứ 7 - Chủ nhật: 09:00 - 22:00</p>
        </div>

        <!-- Mạng xã hội-->
        <div class="footer-social">
            <h3>Kết nối với AURA</h3>
            <p>Theo dõi chúng tôi trên các nền tảng để nhận ưu đãi mỗi ngày.</p>
            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
                <a href="#"><i class="fa-brands fa-tiktok"></i></a>
                <a href="#"><i class="fa-brands fa-youtube"></i></a>
                <a href="#"><i class="fa-brands fa-pinterest-p"></i></a>
            </div>
        </div>
    </div>

    <div class="copyright">
        <p> &copy; 2026 AURA Studio. Bản quyền đc bảo vệ</p>
    </div>
</footer></body>





