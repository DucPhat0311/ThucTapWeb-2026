<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    request.setAttribute("pageCss", "views/return-refund-policy.css");
    request.setAttribute("pageTitle", "Chính sách đổi trả và hoàn hàng");
%>

<%@ include file="../include/header.jsp" %>

<main class="policy-page">
    <header class="policy-header">
        <div class="policy-header-inner">
            <p class="policy-label">Chăm sóc khách hàng</p>
            <h1>Chính sách đổi trả và hoàn hàng</h1>
            <p class="policy-intro">
                AURA Studio tiếp nhận yêu cầu trả hàng trong vòng 07 ngày kể từ khi đơn hàng
                được giao thành công, với quy trình minh bạch để bảo vệ quyền lợi khách hàng.
            </p>
        </div>
    </header>

    <div class="policy-layout">
        <nav class="policy-nav" aria-label="Nội dung chính sách">
            <p>Nội dung</p>
            <a href="#pham-vi">Phạm vi áp dụng</a>
            <a href="#dieu-kien">Điều kiện đổi trả</a>
            <a href="#khong-ap-dung">Trường hợp từ chối</a>
            <a href="#quy-trinh">Quy trình xử lý</a>
            <a href="#giao-that-bai">Giao hàng thất bại</a>
            <a href="#hoan-tien">Hoàn tiền</a>
        </nav>

        <article class="policy-content">
            <section id="pham-vi" class="policy-section">
                <h2>Phạm vi áp dụng</h2>
                <p>
                    Chính sách áp dụng cho các đơn hàng mua tại AURA Studio. Khách hàng có thể
                    gửi yêu cầu trả hàng trong vòng <strong>07 ngày</strong> tính từ thời điểm
                    đơn hàng được xác nhận <strong>Đã giao thành công</strong>.
                </p>
                <div class="policy-highlight">
                    <i class="fa-regular fa-clock" aria-hidden="true"></i>
                    <div>
                        <strong>Thời hạn tiếp nhận</strong>
                        <span>07 ngày kể từ ngày nhận hàng thành công.</span>
                    </div>
                </div>
            </section>

            <section id="dieu-kien" class="policy-section">
                <h2>Điều kiện được đổi trả</h2>
                <p>Yêu cầu được xem xét khi thuộc một trong các trường hợp sau:</p>
                <ul class="policy-check-list">
                    <li>Sản phẩm bị lỗi, hư hỏng hoặc không đúng mô tả khi nhận hàng.</li>
                    <li>Giao sai sản phẩm, sai kích cỡ hoặc sai màu sắc so với đơn đặt hàng.</li>
                    <li>Sản phẩm không phù hợp nhưng vẫn còn nguyên trạng, chưa qua sử dụng.</li>
                    <li>Khách hàng cung cấp lý do và thông tin cần thiết để shop kiểm tra yêu cầu.</li>
                </ul>
                <p class="policy-note">
                    Sản phẩm gửi trả cần giữ nguyên tem nhãn, không có dấu hiệu sử dụng, giặt
                    hoặc chỉnh sửa, trừ trường hợp lỗi sản phẩm được ghi nhận khi mở hàng.
                </p>
            </section>

            <section id="khong-ap-dung" class="policy-section">
                <h2>Trường hợp không áp dụng</h2>
                <ul class="policy-deny-list">
                    <li>Yêu cầu được gửi sau thời hạn 07 ngày.</li>
                    <li>Sản phẩm đã qua sử dụng, đã giặt, có mùi hoặc bị hư hỏng do khách hàng.</li>
                    <li>Sản phẩm thiếu tem nhãn hoặc thiếu phụ kiện đi kèm mà không do lỗi giao hàng.</li>
                    <li>Không cung cấp được lý do hoặc thông tin để đối chiếu đơn hàng.</li>
                </ul>
            </section>

            <section id="quy-trinh" class="policy-section">
                <h2>Quy trình yêu cầu trả hàng</h2>
                <ol class="policy-steps">
                    <li>
                        <span>01</span>
                        <div>
                            <strong>Gửi yêu cầu</strong>
                            <p>Khách hàng chọn đơn đã giao và gửi lý do trả hàng trong thời hạn áp dụng.</p>
                        </div>
                    </li>
                    <li>
                        <span>02</span>
                        <div>
                            <strong>Shop kiểm tra</strong>
                            <p>AURA Studio xem xét thông tin yêu cầu và thông báo chấp nhận hoặc từ chối.</p>
                        </div>
                    </li>
                    <li>
                        <span>03</span>
                        <div>
                            <strong>Hoàn hàng</strong>
                            <p>Khi yêu cầu được duyệt, khách hàng gửi sản phẩm về shop theo hướng dẫn.</p>
                        </div>
                    </li>
                    <li>
                        <span>04</span>
                        <div>
                            <strong>Xác nhận và hoàn tiền</strong>
                            <p>Sau khi nhận lại và kiểm tra sản phẩm, shop ghi nhận hoàn hàng và xử lý hoàn tiền.</p>
                        </div>
                    </li>
                </ol>
            </section>

            <section id="giao-that-bai" class="policy-section">
                <h2>Đơn giao không thành công</h2>
                <p>
                    Khi giao hàng thất bại, đơn hàng chưa được xem là đã trả hàng. Shop có thể
                    sắp xếp giao lại hoặc chuyển đơn sang quá trình hoàn hàng về cửa hàng.
                </p>
                <p>
                    Khi hàng đã được xác nhận quay về AURA Studio, tồn kho được cập nhật lại.
                    Đơn COD chưa thanh toán sẽ không phát sinh hoàn tiền; đơn đã thanh toán trực
                    tuyến được chuyển sang bước xử lý hoàn tiền.
                </p>
            </section>

            <section id="hoan-tien" class="policy-section">
                <h2>Phương thức hoàn tiền</h2>
                <div class="refund-methods">
                    <div>
                        <i class="fa-solid fa-money-bill-wave" aria-hidden="true"></i>
                        <h3>Thanh toán COD</h3>
                        <p>
                            Khoản tiền hoàn được xác nhận sau khi shop đã nhận và kiểm tra sản phẩm trả về.
                        </p>
                    </div>
                    <div>
                        <i class="fa-regular fa-credit-card" aria-hidden="true"></i>
                        <h3>Thanh toán VNPay</h3>
                        <p>
                            Yêu cầu được ghi nhận ở trạng thái chờ hoàn tiền và xử lý sau khi hoàn hàng hợp lệ.
                        </p>
                    </div>
                </div>
            </section>

            <section class="policy-support" aria-label="Hỗ trợ chính sách">
                <h2>Cần hỗ trợ thêm?</h2>
                <p>Liên hệ AURA Studio để được hướng dẫn về tình trạng đơn hàng và yêu cầu đổi trả.</p>
                <div class="policy-actions">
                    <a href="${pageContext.request.contextPath}/contact" class="policy-btn-primary">
                        <i class="fa-regular fa-envelope"></i>
                        Liên hệ hỗ trợ
                    </a>
                    <a href="${pageContext.request.contextPath}/order-user" class="policy-btn-secondary">
                        <i class="fa-solid fa-receipt"></i>
                        Đơn hàng của tôi
                    </a>
                </div>
            </section>
        </article>
    </div>
</main>

<%@ include file="../include/footer.jsp" %>
