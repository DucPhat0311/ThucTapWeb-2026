<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm - AURA Studio</title>
    <link rel="stylesheet" href="css/include/header.css">
    <link rel="stylesheet" href="css/include/footer.css">
    <link rel="stylesheet" href="css/views/detail-product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<%@include file="../include/header.jsp"%>
<main class="product-detail">
    <div class="detail-wrapper">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">
                <i class="fa-solid fa-house"></i> Trang chủ
            </a>

            <c:if test="${not empty breadcrumbs}">
                <c:forEach var="cat" items="${breadcrumbs}">
                    <span>/</span>
                    <a href="${pageContext.request.contextPath}/product?category=${cat.id}">
                            ${cat.name}
                    </a>
                </c:forEach>
            </c:if>
            <span>/</span>
            <span>
                ${product.name}
            </span>
        </nav>
        <div class="product-container">
            <div class="product-info">
                <h1 class="product-name">${product.name}</h1>

                <div class="product-sku">
                    Mã sản phẩm: <strong>AUR-${product.id}</strong>
                </div>

                <p class="product-price">Giá:
                    <c:choose>
                        <c:when test="${product.sale_price > 0 && product.sale_price < product.price}">
                            <span><fmt:formatNumber value="${product.sale_price}" type="number"/>₫</span>
                            <span><fmt:formatNumber value="${product.price}" type="number"/>₫</span>
                        </c:when>
                        <c:otherwise>
                            <span style="font-weight:bold"><fmt:formatNumber value="${product.price}" type="number"/>₫</span>
                        </c:otherwise>
                    </c:choose>
                </p>

                <div class="product-rating">
                    <c:forEach begin="1" end="${displayStar}"><i class="fa-solid fa-star" style="color: #FFD43B;"></i></c:forEach>
                    <c:forEach begin="1" end="${5 - displayStar}"><i class="fa-regular fa-star" style="color: #FFD43B;"></i></c:forEach>
                    (${totalReviews} đánh giá)
                </div>

                <div class="product-colors">
                    <p><strong>Màu sắc:</strong></p>
                    <div class="color-options">
                        <c:forEach var="color" items="${colors}">
                            <button class="color-btn" data-color-id="${color.id}">
                                    ${color.name}
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <div class="product-sizes">
                    <div class="size-header">
                        <p style="margin: 0;"><strong>Chọn size:</strong></p>
                        <a href="#size-chart"><i class="fa-solid fa-ruler-combined"></i> Gợi ý tìm size</a>
                    </div>
                    <div class="size-options">
                        <c:forEach var="s" items="${sizes}">
                            <button class="size-btn" data-size-id="${s.id}">
                                    ${s.code}
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <div class="product-quantity">
                    <p><strong>Số lượng:</strong></p>
                    <div class="quantity-control">
                        <button class="btn-decrease">−</button>
                        <input type="number" id="quantity" min="1" value="1">
                        <button class="btn-increase">+</button>
                    </div>
                </div>

                <div class="product-actions">
                    <button class="btn-add-cart">Thêm vào giỏ hàng</button>
                    <button class="btn-buy-now">Mua ngay</button>
                </div>

                <div class="product-policy-detailed">
                    <div class="policy-row">
                        <div class="policy-col">
                            <i class="fa-solid fa-truck-fast"></i>
                            <span>Miễn phí giao hàng cho đơn từ 500K</span>
                        </div>
                        <div class="policy-col">
                            <i class="fa-solid fa-shield-check"></i>
                            <span>Hàng phân phối chính hãng 100%</span>
                        </div>
                    </div>

                    <div class="policy-row">
                        <div class="policy-col">
                            <i class="fa-solid fa-headset"></i>
                            <span>Hotline: <strong>0888 888 888</strong></span>
                        </div>
                        <div class="policy-col">
                            <i class="fa-solid fa-rotate"></i>
                            <span>Đổi sản phẩm dễ dàng (7 ngày)</span>
                        </div>
                    </div>

                    <div class="policy-row">
                        <div class="policy-col">
                            <i class="fa-solid fa-hand-holding-dollar"></i>
                            <span>Kiểm tra, thanh toán khi nhận hàng COD</span>
                        </div>
                        <div class="policy-col">
                            <i class="fa-solid fa-shop"></i>
                            <span>Hỗ trợ bảo hành tại hệ thống store</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <section class="product-tabs-container">
            <div class="tabs-header">
                <button class="tab-item active" data-tab="desc">Mô tả sản phẩm</button>
                <button class="tab-item" data-tab="review">Đánh giá (${totalReviews != null ? totalReviews : 0})</button>
                <button class="tab-item" data-tab="guide">Hướng dẫn mua hàng</button>
                <button class="tab-item" data-tab="policy">Chính sách đổi trả</button>
                <button class="tab-item" data-tab="faq">Câu hỏi thường gặp</button>
            </div>

            <div class="tabs-content">
                <div class="tab-pane active" id="desc">
                    <div class="product-description-content">
                        ${product.description}
                    </div>
                </div>

                <div class="tab-pane" id="review">
                    <div class="review-list">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="rv" items="${reviews}">
                                    <div class="review-item">
                                        <div class="review-header">
                                            <strong class="review-user-name">Người dùng ẩn danh</strong>
                                            <span class="review-stars">
                                      <c:forEach begin="1" end="${rv.rating}">
                                          <i class="fa-solid fa-star"></i>
                                      </c:forEach>
                                      <c:forEach begin="1" end="${5 - rv.rating}">
                                          <i class="fa-regular fa-star"></i>
                                      </c:forEach>
                                  </span>
                                        </div>
                                        <div class="review-content">
                                            <p><c:out value="${rv.comment}" /></p>
                                        </div>
                                        <c:if test="${not empty rv.createdAt}">
                                            <small class="review-date">${rv.createdAt}</small>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="review-empty-text">Chưa có đánh giá nào cho sản phẩm này.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="tab-pane" id="guide">
                    <div class="guide-content">
                        <h4>QUY TRÌNH MUA HÀNG TRỰC TUYẾN</h4>
                        <ul class="step-list">
                            <li><strong>Bước 1:</strong> Tìm kiếm và lựa chọn sản phẩm yêu thích. Xem kỹ thông tin màu sắc, bảng size để chọn được sản phẩm phù hợp.</li>
                            <li><strong>Bước 2:</strong> Chọn Màu sắc, Size, Số lượng và nhấn nút <b>"Thêm vào giỏ hàng"</b>.</li>
                            <li><strong>Bước 3:</strong> Truy cập Giỏ hàng, kiểm tra lại thông tin đơn hàng và nhấn <b>"Thanh toán"</b>.</li>
                            <li><strong>Bước 4:</strong> Điền đầy đủ thông tin nhận hàng (Tên, Số điện thoại, Địa chỉ chi tiết).</li>
                            <li><strong>Bước 5:</strong> Chọn phương thức thanh toán (COD - Thanh toán khi nhận hàng hoặc Chuyển khoản) và nhấn <b>"Đặt hàng"</b>.</li>
                            <li><strong>Bước 6:</strong> Hệ thống sẽ gửi email hoặc SMS xác nhận đơn hàng thành công. AURA Studio sẽ đóng gói và gửi hàng cho bạn sớm nhất!</li>
                        </ul>
                    </div>
                </div>

                <div class="tab-pane" id="policy">
                    <div class="policy-content">
                        <h4>1. ĐIỀU KIỆN ÁP DỤNG ĐỔI TRẢ</h4>
                        <ul>
                            <li>Thời gian hỗ trợ: Trong vòng <strong>7 ngày</strong> kể từ ngày khách hàng nhận được bưu phẩm.</li>
                            <li>Sản phẩm phải còn nguyên vẹn tem mác, mã vạch, bao bì nguyên bản của AURA Studio.</li>
                            <li>Sản phẩm chưa qua sử dụng, chưa qua giặt ủi, không bị vấy bẩn, ám mùi lạ (nước hoa, mỹ phẩm, mùi cơ thể...) hoặc hư hỏng do tác nhân bên ngoài.</li>
                            <li>Áp dụng đổi size hoặc đổi sang mẫu khác (có giá trị bằng hoặc cao hơn sản phẩm cũ).</li>
                            <li><em>Lưu ý: Không áp dụng trả hàng - hoàn tiền trừ trường hợp sản phẩm bị lỗi nặng từ nhà sản xuất không thể khắc phục. Không hỗ trợ đổi trả với các sản phẩm sale từ 50% trở lên.</em></li>
                        </ul>

                        <h4>2. CHI PHÍ VẬN CHUYỂN KHI ĐỔI TRẢ</h4>
                        <ul>
                            <li><strong>AURA Studio chịu 100% phí vận chuyển 2 chiều:</strong> Nếu sản phẩm bị lỗi do nhà sản xuất (rách, bẩn, lỗi đường may, phai màu bất thường) hoặc do AURA giao nhầm size, nhầm mẫu.</li>
                            <li><strong>Khách hàng thanh toán phí vận chuyển:</strong> Nếu phát sinh từ nhu cầu chủ quan của khách hàng (muốn đổi size vì chọn nhầm, đổi màu, đổi mẫu khác).</li>
                        </ul>

                        <h4>3. QUY TRÌNH ĐỔI TRẢ</h4>
                        <ul>
                            <li><strong>Bước 1:</strong> Liên hệ với Hotline hoặc Fanpage của AURA Studio, cung cấp mã đơn hàng và hình ảnh/video tình trạng sản phẩm.</li>
                            <li><strong>Bước 2:</strong> Nhân viên CSKH sẽ xác nhận và cung cấp địa chỉ kho nhận hàng đổi trả.</li>
                            <li><strong>Bước 3:</strong> Khách hàng đóng gói cẩn thận và gửi qua bưu cục gần nhất. Sau khi kho nhận và kiểm tra đạt tiêu chuẩn, AURA sẽ gửi lại sản phẩm mới cho bạn.</li>
                        </ul>
                    </div>
                </div>

                <div class="tab-pane" id="faq">
                    <div class="faq-content accordion">
                        <div class="faq-item">
                            <div class="faq-question">
                                <span>1. Tất cả sản phẩm trên website đều có sẵn đúng không?</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="faq-answer">
                                <p>Dạ đúng ạ. Tất cả các mặt hàng bạn có thể thêm vào giỏ hàng đều đang có sẵn tại kho của AURA Studio và sẵn sàng giao ngay.</p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question">
                                <span>2. Bao lâu thì tôi sẽ nhận được hàng?</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="faq-answer">
                                <p>- Nội thành TP.HCM/Hà Nội: Nhận hàng trong vòng 1-2 ngày làm việc.<br>
                                    - Các tỉnh thành khác: Nhận hàng từ 3-5 ngày làm việc tùy khu vực.</p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question">
                                <span>3. Phí vận chuyển tính như thế nào?</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="faq-answer">
                                <p> <strong>Miễn phí vận chuyển (Freeship)</strong> cho tất cả các đơn hàng có giá trị từ 500.000 VNĐ. Với đơn hàng dưới 500.000 VNĐ, đồng giá ship toàn quốc là 30.000 VNĐ.</p>
                            </div>
                        </div>
                        <div class="faq-item">
                            <div class="faq-question">
                                <span>4. Tôi có được kiểm tra hàng trước khi thanh toán không?</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="faq-answer">
                                <p>Dạ CÓ. Để đảm bảo quyền lợi, bạn hoàn toàn có thể yêu cầu shipper cho mở gói hàng để kiểm tra màu sắc, kiểu dáng trước khi thanh toán. Tuy nhiên, xin vui lòng <strong>không làm rách tem mác ạ.</strong></p>
                            </div>
                        </div>

                        <div class="faq-item">
                            <div class="faq-question">
                                <span>5. Nếu tôi nhận hàng mặc không vừa thì phải làm sao?</span>
                                <i class="fa-solid fa-chevron-down"></i>
                            </div>
                            <div class="faq-answer">
                                <p>Bạn hoàn toàn yên tâm nhé! AURA hỗ trợ đổi size tận nhà trong vòng 30 ngày. Bạn chỉ cần inbox Fanpage hoặc gọi Hotline, shipper sẽ mang size mới đến giao tận tay và thu hồi size cũ về, bạn không cần phải ra bưu điện gửi hàng.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="suggested-products">
            <h2>Sản phẩm phù hợp khác</h2>
            <div class="suggested-list">
                <c:forEach var="item" items="${ralatedProducts}">
                    <div class="product-mini">
                        <a href="${pageContext.request.contextPath}/detail-product?id=${item.id}" class="link-cover"></a>
                        <img src="img/products${item.thumbnail}" alt="${item.name}">
                        <h3>${item.name}</h3>
                        <p class="price">
                            <c:choose>
                                <c:when test="${item.sale_price > 0 && item.sale_price < item.price}">
                          <span class="new-price" >
                              <fmt:formatNumber value="${item.sale_price}" type="number"/>đ
                          </span>
                                    <span class="old-price">
                              <fmt:formatNumber value="${item.price}" type="number"/>đ
                          </span>
                                </c:when>
                                <c:otherwise>
                          <span class="new-price">
                              <fmt:formatNumber value="${item.price}" type="number"/>đ
                          </span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <a href="${pageContext.request.contextPath}/detail-product?id=${item.id}&quantity=1" class="btn-add">Thêm vào giỏ hàng</a>
                    </div>
                </c:forEach>

                <c:if test="${empty ralatedProducts}">
                    <p>Không tìm thấy sản phẩm phù hợp khác.</p>
                </c:if>

            </div>
            <a href="product" class="btn-view-more">Xem thêm</a>
        </section>
    </div>
</main>
<div id="toast"></div>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const tabItems = document.querySelectorAll(".tab-item");
        const tabPanes = document.querySelectorAll(".tab-pane");

        tabItems.forEach(item => {
            item.addEventListener("click", function() {
                tabItems.forEach(t => t.classList.remove("active"));
                tabPanes.forEach(p => p.classList.remove("active"));

                this.classList.add("active");

                const tabId = this.getAttribute("data-tab");
                const targetPane = document.getElementById(tabId);
                if(targetPane) {
                    targetPane.classList.add("active");
                }
            });
        });
    });

    const faqQuestions = document.querySelectorAll(".faq-question");


    faqQuestions.forEach(question => {
        question.addEventListener("click", function() {
            const currentItem = this.parentElement;

            const isActive = currentItem.classList.contains("active");

            document.querySelectorAll(".faq-item").forEach(item => {
                item.classList.remove("active");
            });

            if (!isActive) {
                currentItem.classList.add("active");
            }
        });
    });

</script>

<script>
    const variants = [
        <c:forEach var="v" items="${variants}" varStatus="st">
        {
            id: ${v.id},
            colorId: ${v.colorId},
            sizeId: ${v.sizeId},
            stock: ${v.stock}
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
</script>

<%@include file="../include/footer.jsp"%>

</body>

<script src="${pageContext.request.contextPath}/js/views/detail-product.js"></script>
</html>

