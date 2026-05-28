<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

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

<script>
    var requestContextPath = '${pageContext.request.contextPath}';
    var currentProductId = '${product.id}';
</script>

<main class="product-detail">
    <div class="detail-wrapper">
        <nav class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">
                <i></i> Trang chủ
            </a>

            <c:if test="${not empty breadcrumbs}">
                <c:forEach var="cat" items="${breadcrumbs}">
                    <span>/</span>
                    <a href="${pageContext.request.contextPath}/product?categoryId=${cat.id}">
                            ${cat.name}
                    </a>
                </c:forEach>
            </c:if>
            <span>/</span>
            <span>${product.name}</span>
        </nav>
        <div class="product-container">
            <div class="product-image">
                <div class="main-image-container">
                    <c:set var="hasMain" value="false" />
                    <c:forEach var="img" items="${images}">
                        <c:if test="${img.main && not hasMain}">
                            <img id="main-image" src="${pageContext.request.contextPath}/img/products${img.imageUrl}" alt="${product.name}">
                            <c:set var="hasMain" value="true" />
                        </c:if>
                    </c:forEach>
                </div>

                <div class="swiper thumbSwiper">
                    <div class="swiper-wrapper">
                        <c:set var="hasMain2" value="false" />
                        <c:forEach var="img" items="${images}">
                            <div class="swiper-slide">
                                <img class="thumb-item ${img.main && not hasMain2 ? 'active' : ''}"
                                     src="${pageContext.request.contextPath}/img/products${img.imageUrl}"
                                     alt="${product.name}">
                            </div>
                            <c:set var="hasMain2" value="true" />
                        </c:forEach>
                    </div>
                    <div class="swiper-button-next"></div>
                    <div class="swiper-button-prev"></div>
                </div>
            </div>

            <div class="product-info">
                <h1 class="product-name">${product.name}</h1>

                <div class="product-sku">
                    Mã sản phẩm: <strong id="display-sku">AUR-${product.id}</strong>
                </div>

                <p class="product-price">Giá:
                    <span id="display-price-container">
                        <span id="variant-price-display">
                            <fmt:setLocale value="vi_VN"/>
                            <c:choose>
                                <c:when test="${product.sale_price > 0 && product.sale_price < product.price}">
                                    <span class="current-price" style="font-weight:bold; color: red">
                                        <fmt:formatNumber value="${product.sale_price}" pattern="#,###"/>₫
                                    </span>
                                    <span class="old-price" style="text-decoration: line-through; color: #999; font-size: 0.9em; margin-left: 8px;">
                                        <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="current-price" style="font-weight:bold">
                                        <fmt:formatNumber value="${product.price}" pattern="#,###"/>₫
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </span>
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
                            <button class="color-btn" data-color-id="${color.id}" style="background-color: ${color.code};">
                            </button>
                        </c:forEach>
                    </div>
                </div>

                <div class="product-sizes">
                    <div class="size-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                        <p style="margin: 0;"><strong>Chọn size:</strong></p>
                        <button type="button" id="open-size-modal"
                                data-size-img="${sizeChartImg}"
                                style="background: none; border: none; color: #6F4E37; text-decoration: underline; cursor: pointer; font-size: 0.95rem; display: flex; align-items: center; gap: 5px; font-weight: 600;">
                            <i class="fa-solid fa-ruler-combined"></i> Gợi ý tìm size
                        </button>
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
                    <button type="button" id="btn-wishlist" data-product-id="${product.id}"
                            style="flex: 0.5; height: 48px; background: #fff; border: 0px solid ${isWishlisted ? '#ff4d4f' : '#ddd'}; border-radius: 4px; cursor: pointer; font-size: 1.3rem; display: flex; justify-content: center; align-items: center; transition: all 0.2s ease;">
                        <i class="${isWishlisted ? 'fa-solid' : 'fa-regular'} fa-heart" style="color: ${isWishlisted ? '#ff4d4f' : '#6F4E37'};"></i>
                    </button>

                </div>

                <div class="product-policy-detailed">
                    <div class="policy-row">
                        <div class="policy-col">
                            <i class="fa-solid fa-truck-fast"></i>
                            <span>Miễn phí giao hàng cho đơn từ 500K</span>
                        </div>
                        <div class="policy-col">
                            <i class="fa-solid fa-check"></i>
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
                    <div class="review-filter-dropdown-container" style="margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <label for="star-filter" style="color: var(--aura-text-bronze); font-weight: 600; font-size: 15px;">Lọc theo:</label>
                        <select id="star-filter" style="padding: 8px 15px; border: 1px solid #dbdbdb; border-radius: 4px; background-color: #fff; color: #333; font-size: 14px; cursor: pointer; outline: none; min-width: 180px;">
                            <option value="all">Tất cả đánh giá (${totalReviews != null ? totalReviews : 0})</option>
                            <option value="5">⭐⭐⭐⭐⭐ 5 Sao (${count5Star})</option>
                            <option value="4">⭐⭐⭐⭐ 4 Sao (${count4Star})</option>
                            <option value="3">⭐⭐⭐ 3 Sao (${count3Star})</option>
                            <option value="2">⭐⭐ 2 Sao (${count2Star})</option>
                            <option value="1">⭐ 1 Sao (${count1Star})</option>
                        </select>
                    </div>

                    <div class="review-list">
                        <c:choose>
                            <c:when test="${not empty reviews}">
                                <c:forEach var="rv" items="${reviews}">
                                    <div class="review-item" data-stars="${rv.rating}">
                                        <div class="review-header">
                                            <strong class="review-user-name">Người dùng ẩn danh</strong>
                                            <span class="review-stars">
                                               <c:forEach begin="1" end="${rv.rating}"><i class="fa-solid fa-star" style="color: #FFD43B;"></i></c:forEach>
                                               <c:forEach begin="1" end="${5 - rv.rating}"><i class="fa-regular fa-star" style="color: #FFD43B;"></i></c:forEach>
                                           </span>
                                        </div>

                                        <c:if test="${not empty rv.images}">
                                            <div class="review-images" style="display: flex; gap: 10px; margin-top: 10px; margin-bottom: 10px;">
                                                <c:forEach var="imgUrl" items="${rv.images}">
                                                    <img src="${pageContext.request.contextPath}/${imgUrl}"
                                                         alt="Review Image"
                                                         style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; cursor: pointer;"
                                                         onclick="window.open(this.src)">
                                                </c:forEach>
                                            </div>
                                        </c:if>

                                        <c:if test="${not empty rv.createdAt}">
                                            <small class="review-date" style="color: #999; display: block;">
                                                <fmt:parseDate value="${rv.createdAt}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                                                <fmt:formatDate value="${parsedDate}" pattern="HH:mm dd/MM/yyyy" />
                                            </small>
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
                    <c:set var="product_item" value="${item}" scope="request" />
                    <jsp:include page="../include/productCard.jsp" />
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
    const variants = [
        <c:forEach var="v" items="${variants}" varStatus="st">
        {
            id: ${v.id},
            colorId: ${v.colorId},
            sizeId: ${v.sizeId},
            stock: ${v.stock},
            price: ${v.price},
            salePrice: ${v.salePrice},
        }<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
</script>

<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const tabItems = document.querySelectorAll(".tab-item");
        const tabPanes = document.querySelectorAll(".tab-pane");

        tabItems.forEach(item => {
            item.addEventListener("click", function () {
                tabItems.forEach(t => t.classList.remove("active"));
                tabPanes.forEach(p => p.classList.remove("active"));
                this.classList.add("active");
                const tabId = this.getAttribute("data-tab");
                const targetPane = document.getElementById(tabId);
                if (targetPane) {
                    targetPane.classList.add("active");
                }
            });
        });


        const faqQuestions = document.querySelectorAll(".faq-question");
        faqQuestions.forEach(question => {
            question.addEventListener("click", function () {
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


        const swiper = new Swiper(".thumbSwiper", {
            spaceBetween: 10,
            slidesPerView: 4,
            freeMode: false,
            watchSlidesProgress: true,
            slideToClickedSlide: true,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
            breakpoints: {
                320: {slidesPerView: 3},
                768: {slidesPerView: 4}
            }
        });


        const mainImg = document.getElementById("main-image");
        const thumbs = document.querySelectorAll(".thumb-item");
        const colorButtons = document.querySelectorAll(".color-btn");
        const starFilter = document.getElementById("star-filter");
        const reviewItems = document.querySelectorAll(".review-item");


        const openSizeBtn = document.getElementById("open-size-modal");
        const closeSizeBtn = document.getElementById("close-size-modal");
        const sizeModal = document.getElementById("size-modal");
        const sizeModalContent = document.getElementById("size-modal-content");
        const modalImg = document.getElementById("modal-size-img");

        if (openSizeBtn && sizeModal && modalImg) {
            openSizeBtn.addEventListener("click", function (e) {
                e.preventDefault();


                let imgName = this.getAttribute("data-size-img");


                if (!imgName || imgName.trim() === "" || imgName.toLowerCase().includes("null")) {
                    return;
                }


                if (!imgName.startsWith("/")) {
                    imgName = "/" + imgName;
                }


                modalImg.src = requestContextPath + "/img/size-guide" + imgName;


                sizeModal.style.display = "flex";
                setTimeout(() => {
                    sizeModal.style.opacity = "1";
                    if (sizeModalContent) sizeModalContent.style.transform = "scale(1)";
                }, 10);
            });


            if (closeSizeBtn) {
                closeSizeBtn.addEventListener("click", closeSizeModal);
            }


            sizeModal.addEventListener("click", function (e) {
                if (e.target === sizeModal) closeSizeModal();
            });


            function closeSizeModal() {
                sizeModal.style.opacity = "0";
                if (sizeModalContent) sizeModalContent.style.transform = "scale(0.8)";
                setTimeout(() => {
                    sizeModal.style.display = "none";
                    modalImg.src = "";
                }, 300);
            }
        }


        thumbs.forEach(thumb => {
            thumb.addEventListener("click", function () {
                mainImg.src = this.src;
                thumbs.forEach(t => t.classList.remove("active"));
                this.classList.add("active");
                mainImg.style.opacity = "0.5";
                setTimeout(() => {
                    mainImg.style.opacity = "1";
                }, 150);
            });
        });


        if (starFilter) {
            starFilter.addEventListener("change", function () {
                const selectedValue = this.value;
                reviewItems.forEach(item => {
                    const itemStars = item.getAttribute("data-stars");
                    if (selectedValue === "all") {
                        item.style.display = "block";
                    } else {
                        item.style.display = (itemStars === selectedValue) ? "block" : "none";
                    }
                });

                const listComments = Array.from(reviewItems).filter(item => item.style.display !== "none");
                let emptyMsg = document.querySelector(".review-filter-empty-text");
                if (listComments.length === 0) {
                    if (!emptyMsg) {
                        emptyMsg = document.createElement("p");
                        emptyMsg.className = "review-filter-empty-text";
                        emptyMsg.innerText = "Chưa có đánh giá nào cho mức sao này.";
                        emptyMsg.style.textAlign = "center";
                        emptyMsg.style.color = "#999";
                        emptyMsg.style.padding = "20px 0";
                        document.querySelector(".review-list").appendChild(emptyMsg);
                    }
                } else if (emptyMsg) {
                    emptyMsg.remove();
                }
            });
        }
        const wishlistBtn = document.getElementById("btn-wishlist");
        if (wishlistBtn) {
            wishlistBtn.addEventListener("click", function(e) {
                e.preventDefault();

                const productId = this.getAttribute("data-product-id");
                const heartIcon = this.querySelector("i");

                const params = new URLSearchParams();
                params.append("productId", productId);

                fetch(requestContextPath + "/wishlist", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: params.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.status === 'redirect') {
                            window.location.href = data.url;
                            return;
                        }

                        if (data.success) {
                            if (data.action === "added") {
                                heartIcon.className = "fa-solid fa-heart";
                                heartIcon.style.color = "#ff4d4f";
                                this.style.borderColor = "#ff4d4f";
                            } else if (data.action === "removed") {
                                heartIcon.className = "fa-regular fa-heart";
                                heartIcon.style.color = "#333";
                                this.style.borderColor = "#ddd";
                            }
                            console.log(data.message);
                        } else {
                            alert(data.message);
                        }
                    })
                    .catch(err => {
                        console.error("Lỗi kết nối:", err);
                    });
            });
        }
    });
</script>
<%@include file="../include/footer.jsp"%>

<div id="size-modal" class="size-modal-overlay">
    <div id="size-modal-content" class="size-modal-box">
        <button type="button" id="close-size-modal" class="size-modal-close">&times;</button>
        <h3 class="size-modal-title">BẢNG GỢI Ý KÍCH CỠ</h3>
        <div class="size-modal-body">
            <img id="modal-size-img" src="" alt="Bảng size sản phẩm" class="size-modal-img">
        </div>
    </div>
</div>


<script src="${pageContext.request.contextPath}/js/views/detail-product.js"></script>
</body>
</html>