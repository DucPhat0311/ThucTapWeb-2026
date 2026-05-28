<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="controller.web.MyOrderController" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

                    <% request.setAttribute("pageCss", "views/order-user.css" );
                        request.setAttribute("pageTitle", "Đơn hàng của tôi" ); %>

                        <%@ include file="../include/header.jsp" %>
                            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/order-user.css">

                            <section class="profile-container">
                                <div class="profile-sidebar">
                                    <div class="user-info">
                                        <div class="avatar">
                                            <c:set var="avatarPath"
                                                value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                                            <c:choose>
                                                <c:when
                                                    test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                                                    <img src="${avatarPath}" alt="Avatar">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/${avatarPath}"
                                                        alt="Avatar">
                                                </c:otherwise>
                                            </c:choose>
                                            <form class="avatar-upload-form" method="post" action="profile"
                                                enctype="multipart/form-data">
                                                <input type="hidden" name="action" value="updateAvatar">
                                                <input type="hidden" name="redirectTo" value="order-user">
                                                <input type="file" class="js-avatar-input" name="avatarFile"
                                                    accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                                                    hidden>
                                                <button type="button" class="change-avatar-btn js-avatar-trigger">Đổi
                                                    ảnh</button>
                                            </form>
                                        </div>
                                        <h3>${empty sessionScope.userlogin.fullName ? sessionScope.userlogin.username : sessionScope.userlogin.fullName}</h3>
                                        <p>${sessionScope.userlogin.email}</p>
                                    </div>

                                    <nav class="profile-menu">
                                        <ul>
                                            <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                                            <li><a href="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ của
                                                    tôi</a></li>
                                            <li class="active"><a href="order-user"><i
                                                        class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                                            <li><a href="change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a>
                                            </li>
                                            <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
                                        </ul>
                                    </nav>
                                </div>

                                <div class="profile-content">
                                    <div class="profile-heading">
                                        <h2>Đơn hàng của tôi</h2>
                                    </div>

                                    <c:if test="${param.cancel == 'success'}">
                                        <div class="order-alert order-alert-success">Hủy đơn hàng thành công.</div>
                                    </c:if>
                                    <c:if test="${param.cancel == 'failed'}">
                                        <div class="order-alert order-alert-error">${param.message}</div>
                                    </c:if>
                                    <c:if test="${param.cancel == 'invalid'}">
                                        <div class="order-alert order-alert-error">Yêu cầu hủy đơn hàng không hợp lệ.
                                        </div>
                                    </c:if>

                                    <div class="order-tabs">
                                        <a href="order-user?status=all"
                                            class="tab-item tab-all ${currentStatus == 'all' || empty currentStatus ? 'active' : ''}">
                                            Tất cả
                                        </a>
                                        <a href="order-user?status=PENDING"
                                            class="tab-item tab-pending ${currentStatus == 'PENDING' ? 'active' : ''}">
                                            Chờ xác nhận
                                        </a>
                                        <a href="order-user?status=PENDING_PAYMENT"
                                            class="tab-item tab-pending_payment ${currentStatus == 'PENDING_PAYMENT' ? 'active' : ''}">
                                            Chờ thanh toán
                                        </a>
                                        <a href="order-user?status=SHIPPING"
                                            class="tab-item tab-shipping ${currentStatus == 'SHIPPING' ? 'active' : ''}">
                                            Đang giao hàng
                                        </a>
                                        <a href="order-user?status=COMPLETED"
                                            class="tab-item tab-completed ${currentStatus == 'COMPLETED' ? 'active' : ''}">
                                            Đã hoàn thành
                                        </a>
                                        <a href="order-user?status=CANCELLED"
                                            class="tab-item tab-cancelled ${currentStatus == 'CANCELLED' ? 'active' : ''}">
                                            Đã hủy
                                        </a>
                                    </div>

                                    <c:if test="${empty orders}">
                                        <p class="empty-msg">
                                            Bạn chưa có đơn hàng nào.
                                        </p>
                                    </c:if>

                                    <c:forEach var="o" items="${orders}">
                                        <div class="order-item">
                                            <div class="order-center">
                                                <div class="order-left ${fn:length(o.items) > 1 ? 'multiple' : ''}">
                                                    <c:choose>
                                                        <c:when test="${empty o.items}">
                                                            <p style="color:red">Không có sản phẩm trong đơn hàng này
                                                            </p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="i" items="${o.items}">
                                                                <div class="single-product">
                                                                    <c:set var="itemThumb"
                                                                        value="${empty i.thumbnail ? 'img/aox.webp' : i.thumbnail}" />
                                                                    <c:choose>
                                                                        <c:when
                                                                            test="${fn:startsWith(itemThumb, 'http://') or fn:startsWith(itemThumb, 'https://')}">
                                                                            <img src="${itemThumb}" alt="${i.productName}">
                                                                        </c:when>
                                                                        <c:when
                                                                            test="${fn:startsWith(itemThumb, 'img/') or fn:startsWith(itemThumb, '/img/')}">
                                                                            <img src="${pageContext.request.contextPath}${fn:startsWith(itemThumb, '/') ? itemThumb : '/'.concat(itemThumb)}"
                                                                                alt="${i.productName}">
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <img src="${pageContext.request.contextPath}/img/products${fn:startsWith(itemThumb, '/') ? itemThumb : '/'.concat(itemThumb)}"
                                                                                alt="${i.productName}">
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                    <div class="order-info">
                                                                        <a href="detail-product?id=${i.productId}">
                                                                            <h3>${i.productName}</h3>
                                                                        </a>
                                                                        <p>Phân loại: ${i.color}, ${i.size}</p>
                                                                        <p>x${i.quantity}</p>
                                                                        <p>Thanh toán:
                                                                            ${MyOrderController.getPaymentMethodLabel(o.paymentMethods)}
                                                                            -
                                                                            ${MyOrderController.getPaymentStatusLabel(o.paymentStatuses)}
                                                                        </p>
                                                                    </div>

                                                                    <div class="review-section">
                                                                        <c:if
                                                                            test="${!i.reviewed && o.orderStatus == 'COMPLETED'}">
                                                                            <button class="btn-review"
                                                                                onclick="openReviewModal(${i.productId}, ${i.id})">
                                                                                Đánh giá
                                                                            </button>
                                                                        </c:if>

                                                                        <c:if test="${i.reviewed}">
                                                                            <button class="btn-review disabled"
                                                                                disabled>
                                                                                Đã đánh giá
                                                                            </button>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </c:forEach>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>

                                                <div class="order-right">
                                                    <span class="status status-${fn:toLowerCase(o.orderStatus)}">
                                                        <%= MyOrderController.getOrderStatusLabel(((model.Order)
                                                            pageContext.getAttribute("o")).getOrderStatus()) %>
                                                    </span>
                                                    <p class="price">
                                                        <fmt:formatNumber value="${o.finalAmount}" type="number" />₫
                                                    </p>
                                                    <c:if test="${not empty o.ghnOrderCode}">
                                                        <p class="tracking-inline">
                                                            <c:choose>
                                                                <c:when test="${fn:startsWith(o.ghnOrderCode, 'DEMO-')}">
                                                                    Mô phỏng: ${o.ghnOrderCode}
                                                                </c:when>
                                                                <c:otherwise>GHN: ${o.ghnOrderCode}</c:otherwise>
                                                            </c:choose>
                                                        </p>
                                                    </c:if>
                                                </div>
                                            </div>
                                            <div class="order-actions">
                                                <c:if
                                                    test="${(o.orderStatus == 'PENDING' || o.orderStatus == 'PENDING_PAYMENT') && !(o.paymentMethods == 'VNPAY' && o.paymentStatuses == 'PAID') && empty o.ghnOrderCode}">
                                                    <form method="post" action="cancel-order" class="cancel-order-form">
                                                        <input type="hidden" name="id" value="${o.id}">
                                                        <button type="submit" class="btn-order-action btn-cancel">Hủy
                                                            đơn</button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${not empty o.ghnOrderCode}">
                                                    <span class="tracking-chip status-${fn:toLowerCase(o.orderStatus)}">
                                                        <i class="fa-solid fa-truck-fast"></i>
                                                        <c:choose>
                                                            <c:when test="${not empty o.ghnStatusName}">
                                                                ${o.ghnStatusName}
                                                            </c:when>
                                                            <c:when test="${fn:startsWith(o.ghnOrderCode, 'DEMO-')}">
                                                                Đã tạo hành trình
                                                            </c:when>
                                                            <c:otherwise>Đang chờ GHN</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </c:if>
                                                <a href="order-detail?id=${o.id}"
                                                    class="btn-order-action btn-detail">Xem chi tiết</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </section>

                            <div id="cancelOrderModal" class="cancel-order-modal">
                                <div class="cancel-order-dialog">
                                    <h3>Xác nhận hủy đơn hàng</h3>
                                    <p>Đơn hàng sẽ chuyển sang trạng thái đã hủy. Thao tác này không thể hoàn tác.</p>
                                    <div class="cancel-order-actions">
                                        <button type="button" class="btn-cancel-back"
                                            onclick="closeCancelOrderModal()">Quay lại</button>
                                        <form method="post" action="cancel-order" id="cancelConfirmForm">
                                            <input type="hidden" name="id" id="cancelOrderId">
                                            <button type="submit" class="btn-cancel-confirm">Xác nhận hủy</button>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <div id="reviewModal" class="review-modal">
                                <div class="review-modal-content">
                                    <span class="close-btn" onclick="closeReviewModal()">&times;</span>
                                    <h3>Đánh giá sản phẩm</h3>

                                    <form id="reviewForm" class="modern-review-form" enctype="multipart/form-data">
                                        <input type="hidden" name="product_id" id="popup_product_id">
                                        <input type="hidden" name="order_item_id" id="popup_order_item_id">
                                        <input type="hidden" name="rating" id="rating-value">

                                        <div class="form-group center-group">
                                            <label class="form-label">Chất lượng sản phẩm</label>
                                            <div class="star-rating">
                                                <span class="star" data-value="1">★</span>
                                                <span class="star" data-value="2">★</span>
                                                <span class="star" data-value="3">★</span>
                                                <span class="star" data-value="4">★</span>
                                                <span class="star" data-value="5">★</span>
                                            </div>
                                            <span id="rating-text" class="rating-text">Vui lòng chọn số sao</span>
                                        </div>

                                        <div class="form-group">
                                            <label for="review-comment" class="form-label">Chia sẻ trải nghiệm của
                                                bạn</label>
                                            <textarea id="review-comment" name="comment"
                                                placeholder="Hãy điền đánh giá của bạn về sản phẩm của chúng tôi... Xin cảm ơn...."
                                                required></textarea>
                                        </div>

                                        <div class="form-group">
                                            <label class="form-label">Hình ảnh thực tế</label>
                                            <div class="upload-zone">
                                                <input type="file" id="reviewImages" name="reviewImages"
                                                    accept="image/*" multiple class="file-input">
                                                <label for="reviewImages" class="upload-placeholder">
                                                    <span class="upload-text">Thêm hình ảnh sản phẩm</span>
                                                </label>
                                            </div>
                                            <div id="image-preview-container"
                                                style="display: flex; flex-direction: column; gap: 6px; margin-top: 10px;">
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn-submit-review">Gửi đánh giá ngay</button>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <script>
                                document.addEventListener("DOMContentLoaded", () => {
                                    const stars = document.querySelectorAll(".star-rating .star");
                                    const ratingInput = document.getElementById("rating-value");
                                    const ratingText = document.getElementById("rating-text");

                                    const renderStars = (rating) => {
                                        stars.forEach(star => {
                                            star.classList.toggle("selected", star.dataset.value <= rating);
                                        });
                                        if (rating > 0) {
                                            ratingText.style.color = "#ffbe00";
                                        } else {
                                            ratingText.innerText = "Vui lòng chọn số sao";
                                            ratingText.style.color = "#888888";
                                        }
                                    };

                                    stars.forEach(star => {
                                        star.addEventListener("mouseover", () => renderStars(star.dataset.value));
                                        star.addEventListener("mouseout", () => renderStars(ratingInput.value || 0));
                                        star.addEventListener("click", () => {
                                            ratingInput.value = star.dataset.value;
                                            renderStars(star.dataset.value);
                                        });
                                    });

                                    // preview
                                    const fileInput = document.getElementById("reviewImages");
                                    const previewContainer = document.getElementById("image-preview-container");

                                    fileInput.addEventListener("change", function () {
                                        previewContainer.innerHTML = "";
                                        const files = this.files;
                                        if (files.length === 0) return;

                                        Array.from(files).forEach((file) => {
                                            const fileRow = document.createElement("div");
                                            fileRow.style.cssText = "display: flex; align-items: center; justify-content: space-between; background: #f5f5f5; padding: 6px 12px; border-radius: 4px; font-size: 13px; color: #555; border: 1px solid #eee;";


                                            fileRow.innerHTML = `
   <span style="overflow: hidden; text-overflow: ellipsis; white-space: nowrap; max-width: 85%;"><i class="fa-regular fa-image" style="margin-right: 6px;"></i>${file.name}</span>
   <span class="remove-img-btn" style="color: #c62828; cursor: pointer; font-weight: bold; font-size: 16px; padding: 0 4px;">&times;</span>
`;

                                            previewContainer.appendChild(fileRow);
                                        });
                                    });

                                    // delete pic
                                    previewContainer.addEventListener("click", function (e) {
                                        if (e.target.classList.contains("remove-img-btn")) {
                                            e.target.parentElement.remove();
                                        }
                                    });

                                    const reviewForm = document.getElementById("reviewForm");
                                    reviewForm.addEventListener("submit", async (e) => {
                                        e.preventDefault();

                                        const rating = ratingInput ? ratingInput.value : "0";
                                        if (!rating || rating === "0") {
                                            alert("Vui lòng chọn số sao để đánh giá!");
                                            return;
                                        }

                                        const submitBtn = reviewForm.querySelector(".btn-submit-review");
                                        if (submitBtn.disabled) return;

                                        const originalBtnText = submitBtn.innerText;
                                        submitBtn.disabled = true;
                                        submitBtn.innerText = "Đang gửi...";

                                        try {
                                            const formData = new FormData(reviewForm);
                                            const response = await fetch("review", {
                                                method: "POST",
                                                body: formData
                                            });

                                            if (!response.ok) {
                                                throw new Error("Lỗi Server: " + response.status);
                                            }

                                            alert("Cảm ơn bạn đã đánh giá sản phẩm!");
                                            closeReviewModal();
                                            window.location.reload();

                                        } catch (error) {
                                            console.error("Chi tiết lỗi: ", error);
                                            alert("Không thể gửi đánh giá. Vui lòng kiểm tra lại!");
                                            submitBtn.disabled = false;
                                            submitBtn.innerText = originalBtnText;
                                        }
                                    });

                                    const cancelModal = document.getElementById("cancelOrderModal");
                                    const cancelForms = document.querySelectorAll(".cancel-order-form");
                                    const cancelOrderIdInput = document.getElementById("cancelOrderId");

                                    cancelForms.forEach(form => {
                                        form.addEventListener("submit", (e) => {
                                            e.preventDefault();
                                            cancelOrderIdInput.value = form.querySelector("input[name='id']").value;
                                            cancelModal.style.display = "flex";
                                        });
                                    });

                                    const reviewModalEl = document.getElementById("reviewModal");
                                    window.addEventListener("click", (e) => {
                                        if (e.target === reviewModalEl) {
                                            closeReviewModal();
                                        }
                                        if (e.target === cancelModal) {
                                            closeCancelOrderModal();
                                        }
                                    });
                                });

                                window.openReviewModal = function (productId, orderItemId) {
                                    const modal = document.getElementById("reviewModal");
                                    const form = document.getElementById("reviewForm");
                                    const previewContainer = document.getElementById("image-preview-container");

                                    document.getElementById("popup_product_id").value = productId;
                                    document.getElementById("popup_order_item_id").value = orderItemId;

                                    form.reset();
                                    previewContainer.innerHTML = "";
                                    document.getElementById("rating-value").value = "";
                                    document.getElementById("rating-text").innerText = "Vui lòng chọn số sao";
                                    document.getElementById("rating-text").style.color = "#888888";

                                    document.querySelectorAll(".star-rating .star").forEach(star => {
                                        star.classList.remove("selected");
                                    });

                                    modal.style.display = "flex";
                                };

                                window.closeReviewModal = function () {
                                    document.getElementById("reviewModal").style.display = "none";
                                };

                                window.closeCancelOrderModal = function () {
                                    document.getElementById("cancelOrderModal").style.display = "none";
                                    document.getElementById("cancelOrderId").value = "";
                                };
                            </script>
