<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="controller.web.MyOrderController" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    request.setAttribute("pageCss", "views/order-user.css");
    request.setAttribute("pageTitle", "Đơn hàng của tôi");
%>

<%@ include file="../include/header.jsp" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/order-user.css">

<section class="profile-container">
    <div class="profile-sidebar">
        <div class="user-info">
            <div class="avatar">
                <c:set var="avatarPath" value="${empty sessionScope.userlogin.avatarUrl ? 'img/avt.jpg' : sessionScope.userlogin.avatarUrl}" />
                <c:choose>
                    <c:when test="${fn:startsWith(avatarPath, 'http://') or fn:startsWith(avatarPath, 'https://')}">
                        <img src="${avatarPath}" alt="Avatar">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/${avatarPath}" alt="Avatar">
                    </c:otherwise>
                </c:choose>
                <form class="avatar-upload-form" method="post" action="profile" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="updateAvatar">
                    <input type="hidden" name="redirectTo" value="order-user">
                    <input type="file"
                           class="js-avatar-input"
                           name="avatarFile"
                           accept=".jpg,.jpeg,.png,.webp,image/jpeg,image/png,image/webp"
                           hidden>
                    <button type="button" class="change-avatar-btn js-avatar-trigger">Đổi ảnh</button>
                </form>
            </div>
        </div>

        <nav class="profile-menu">
            <ul>
                <li><a href="profile"><i class="fas fa-user"></i> Thông tin cá nhân</a></li>
                <li><a href="address"><i class="fas fa-map-marker-alt"></i> Địa chỉ của tôi</a></li>
                <li class="active"><a href="order-user"><i class="fas fa-clipboard-list"></i> Đơn hàng của tôi</a></li>
                <li><a href="change-password"><i class="fas fa-lock"></i> Đổi mật khẩu</a></li>
                <li><a href="logout"><i class="fa fa-sign-out"></i> Đăng xuất</a></li>
            </ul>
        </nav>
    </div>

    <div class="profile-content">
        <h2>Đơn hàng của tôi</h2>

        <div class="order-tabs">
            <a href="order-user?status=all" class="tab-item ${currentStatus == 'all' || empty currentStatus ? 'active' : ''}">
                Tất cả
            </a>
            <a href="order-user?status=PENDING" class="tab-item ${currentStatus == 'PENDING' ? 'active' : ''}">
                Chờ xác nhận
            </a>
            <a href="order-user?status=PENDING_PAYMENT" class="tab-item ${currentStatus == 'PENDING_PAYMENT' ? 'active' : ''}">
                Chờ thanh toán
            </a>
            <a href="order-user?status=SHIPPING" class="tab-item ${currentStatus == 'SHIPPING' ? 'active' : ''}">
                Đang giao hàng
            </a>
            <a href="order-user?status=COMPLETED" class="tab-item ${currentStatus == 'COMPLETED' ? 'active' : ''}">
                Đã hoàn thành
            </a>
            <a href="order-user?status=CANCELLED" class="tab-item ${currentStatus == 'CANCELLED' ? 'active' : ''}">
                Đã hủy
            </a>
        </div>

        <c:if test="${empty orders}">
            <p style="text-align:center; padding:30px; color:#888">
                Bạn chưa có đơn hàng nào.
            </p>
        </c:if>

        <c:forEach var="o" items="${orders}">
            <div class="order-item">
                <div class="order-center">
                    <div class="order-left ${fn:length(o.items) > 1 ? 'multiple' : ''}">
                        <c:choose>
                            <c:when test="${empty o.items}">
                                <p style="color:red">Không có sản phẩm trong đơn hàng này</p>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="i" items="${o.items}">
                                    <div class="single-product">
                                        <img src="${not empty i.thumbnail ? i.thumbnail : './img/aox.webp'}" alt="${i.productName}">
                                        <div class="order-info">
                                            <a href="detail-product?id=${i.productId}"><h3>${i.productName}</h3></a>
                                            <p>Phân loại: ${i.color}, ${i.size}</p>
                                            <p>x${i.quantity}</p>
                                            <p>Thanh toán: ${MyOrderController.getPaymentMethodLabel(o.paymentMethods)} - ${MyOrderController.getPaymentStatusLabel(o.paymentStatuses)}</p>
                                        </div>

                                        <div class="review-section">
                                            <c:if test="${!i.reviewed && o.orderStatus == 'COMPLETED'}">
                                                <button class="btn-review"
                                                        onclick="openReviewModal(${i.productId}, ${i.id})">
                                                    Đánh giá
                                                </button>
                                            </c:if>

                                            <c:if test="${i.reviewed}">
                                                <button class="btn-review disabled" disabled>
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
                        <span class="status"><%= MyOrderController.getOrderStatusLabel(((model.Order) pageContext.getAttribute("o")).getOrderStatus()) %></span>
                        <p class="price">
                            <fmt:formatNumber value="${o.finalAmount}" type="number"/>₫
                        </p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const stars = document.querySelectorAll(".star-rating .star");
        const ratingInput = document.getElementById("rating-value");

        const renderStars = (rating) => {
            stars.forEach(star => {
                star.classList.toggle("selected", star.dataset.value <= rating);
            });
        };

        stars.forEach(star => {
            star.addEventListener("mouseover", () => renderStars(star.dataset.value));
            star.addEventListener("mouseout", () => renderStars(ratingInput.value || 0));
            star.addEventListener("click", () => {
                ratingInput.value = star.dataset.value;
                renderStars(star.dataset.value);
            });
        });

        const reviewForm = document.getElementById("reviewForm");

        reviewForm.addEventListener("submit", async (e) => {
            e.preventDefault();

            const rating = ratingInput.value;
            if (!rating || rating === "0") {
                alert("Vui lòng chọn số sao để đánh giá!");
                return;
            }

            const submitBtn = reviewForm.querySelector(".btn-submit-review");
            const originalBtnText = submitBtn.innerText;

            submitBtn.disabled = true;
            submitBtn.innerText = "Đang gửi...";

            try {
                const formData = new FormData(reviewForm);
                const urlEncodedData = new URLSearchParams(formData).toString();

                const response = await fetch("review", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/x-www-form-urlencoded"
                    },
                    body: urlEncodedData
                });

                if (!response.ok) {
                    throw new Error("Lỗi: " + response.status);
                }

                alert("Cảm ơn bạn đã đánh giá sản phẩm!");
                closeReviewModal();
                window.location.reload();

            } catch (error) {
                console.error("Lỗi: ", error);
                alert("Lỗi");
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerText = originalBtnText;
            }
        });

        const modal = document.getElementById("reviewModal");
        window.addEventListener("click", (e) => {
            if (e.target === modal) {
                closeReviewModal();
            }
        });
    });

    window.openReviewModal = function(productId, orderItemId) {
        const modal = document.getElementById("reviewModal");
        const form = document.getElementById("reviewForm");

        document.getElementById("popup_product_id").value = productId;
        document.getElementById("popup_order_item_id").value = orderItemId;

        form.reset();
        document.getElementById("rating-value").value = "";
        document.querySelectorAll(".star-rating .star").forEach(star => {
            star.classList.remove("selected");
        });

        modal.style.display = "block";
    };

    window.closeReviewModal = function() {
        document.getElementById("reviewModal").style.display = "none";
    };
</script>

<script src="${pageContext.request.contextPath}/js/views/avatar-upload.js"></script>

<div id="reviewModal" class="review-modal">
    <div class="review-modal-content">
        <span class="close-btn" onclick="closeReviewModal()">&times;</span>

        <h3>Đánh giá sản phẩm</h3>

        <form id="reviewForm" onsubmit="return submitReviewPopup()">
            <input type="hidden" name="product_id" id="popup_product_id">
            <input type="hidden" name="order_item_id" id="popup_order_item_id">
            <input type="hidden" name="rating" id="rating-value">

            <div class="star-rating">
                <span class="star" data-value="1">★</span>
                <span class="star" data-value="2">★</span>
                <span class="star" data-value="3">★</span>
                <span class="star" data-value="4">★</span>
                <span class="star" data-value="5">★</span>
            </div>

            <textarea name="comment" placeholder="Nhập đánh giá..." required></textarea>

            <button type="submit" class="btn-submit-review">Gửi đánh giá</button>
        </form>
    </div>
</div>

<%@ include file="../include/footer.jsp" %>
