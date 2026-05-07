    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

    <%
        request.setAttribute("pageCss", "views/checkout.css");
        request.setAttribute("pageTitle", "Thanh toán");
    %>

    <%@include file="../include/header.jsp"%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/address-form.css">

    <section class="checkout">
        <div class="checkout-container">
            <form action="place-order" method="post">
                <div class="checkout-left">
                    <h2>Thông tin giao hàng</h2>
                    <c:if test="${not empty addressError}">
                        <div class="checkout-alert checkout-alert-error">
                                ${addressError}
                        </div>
                    </c:if>


                    <c:choose>
                        <c:when test="${not empty selectedAddress}">
                            <div class="selected-address">
                                <div class="selected-address-header">
                                    <h3>Địa chỉ giao hàng</h3>
                                    <a href="${pageContext.request.contextPath}/address">Quản lý địa chỉ</a>
                                </div>
                                <div class="selected-address-body">
                                    <p class="receiver-line">
                                        <strong>${selectedAddress.name}</strong>
                                        <span>${selectedAddress.phone}</span>
                                    </p>
                                    <p>${selectedAddress.detailAddress}, ${selectedAddress.ward}, ${selectedAddress.district}, ${selectedAddress.city}</p>
                                    <c:if test="${selectedAddress.isDefault}">
                                        <span class="default-badge">Mặc định</span>
                                    </c:if>
                                </div>

                                <input type="hidden" id="ghn-district-id" value="${selectedAddress.districtCode}">
                                <input type="hidden" id="ghn-ward-code" value="${selectedAddress.wardCode}">
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="checkout-address-empty">
                                <div>
                                    <h3>Chưa có địa chỉ giao hàng</h3>
                                    <p>Thêm địa chỉ ngay tại đây để dùng luôn cho đơn hàng. Địa chỉ mới sẽ được lưu vào sổ địa chỉ của bạn.</p>
                                </div>
                                <button type="button" class="btn-address-primary" id="btnOpenModal">
                                    Thêm địa chỉ mới
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>


                    <div class="form-group">
                        <label>Ghi chú</label>
                        <textarea name="note" placeholder="Giao giờ hành chính..."></textarea>
                    </div>


                    <h2>Phương thức thanh toán</h2>
                    <div class="payment-method">
                        <label class="payment-method-option">
                            <input type="radio" name="paymentMethod" value="COD" checked>
                            <span>
                                <strong>Thanh toán khi nhận hàng (COD)</strong>
                                <small>Người nhận thanh toán trực tiếp cho đơn vị giao hàng khi nhận được sản phẩm.</small>
                            </span>
                        </label>

                        <label class="payment-method-option">
                            <input type="radio" name="paymentMethod" value="VNPAY">
                            <span>
                                <strong>Thanh toán qua VNPay</strong>
                                <small>Bạn sẽ được chuyển đến cổng thanh toán VNPay sandbox để hoàn tất giao dịch.</small>
                            </span>
                        </label>
                    </div>
                </div>


                <div class="checkout-right">
                    <h3>Đơn hàng của bạn</h3>
                    <input type="hidden" name="cartId" value="${sessionScope.cartId}">
                    <c:forEach var="item" items="${checkoutItems}">
                        <input type="hidden" name="variantIds" value="${item.variantId}">
                        <input type="hidden" name="quantities" value="${item.quantity}">
                    </c:forEach>


                    <div class="order-items">
                        <c:set var="total" value="0"/>
                        <c:forEach var="item" items="${checkoutItems}">
                            <div class="order-item">
                                <img src="img/products${item.product.thumbnail}">
                                <div class="info">
                                    <p class="name">${item.product.name}</p>
                                    <p class="variant">Size ${item.size} · ${item.color}</p>
                                    <p class="qty">SL: ${item.quantity}</p>
                                </div>
                                <div class="price">
                                    <fmt:formatNumber value="${item.price * item.quantity}" type="number"/>₫
                                </div>
                            </div>


                            <c:set var="total" value="${total + item.price * item.quantity}"/>
                        </c:forEach>
                    </div>


                    <div class="order-summary">
                        <input type="hidden" name="shippingFee" id="shipping-fee-input" value="0">


                        <input type="hidden" id="cart-total" value="${total}">
                        <div>
                            <span>Tạm tính</span>
                            <span><fmt:formatNumber value="${total}" type="number"/>₫</span>
                        </div>


                        <div>
                            <span>Phí vận chuyển</span>
                            <span id="shipping-fee-display">Đang tính...</span> </div>


                        <div>
                            <span>Dự kiến nhận hàng</span>
                            <span id="lead-time-display" style="color: #28a745; font-weight: bold;">Đang tính...</span>
                        </div>


                        <div class="total">
                            <span>Tổng cộng</span>
                            <span id="final-amount-display"><fmt:formatNumber value="${total}" type="number"/>₫</span>
                        </div>
                    </div>


                    <button type="submit" id="submit-btn" class="btn-checkout" disabled>
                        XÁC NHẬN THANH TOÁN
                    </button>
                    <c:if test="${empty selectedAddress}">
                        <p class="checkout-note">Bạn cần thêm địa chỉ giao hàng trước khi xác nhận thanh toán.</p>
                    </c:if>
                </div>
            </form>
        </div>
    </section>

    <jsp:include page="address-modal.jsp">
        <jsp:param name="formAction" value="address" />
        <jsp:param name="redirectTo" value="checkout" />
        <jsp:param name="forceDefault" value="true" />
        <jsp:param name="hideDefaultOption" value="true" />
    </jsp:include>

    <script>
        window.APP_CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
    <script src="${pageContext.request.contextPath}/js/views/address.js"></script>

    <script>
        // infor my shop
        const SHOP_DISTRICT_ID = 1442;
        const SHOP_WARD_ID = "20110";
        const SHOP_ID = 6412985;

        async function calculateShippingFee() {
            const toDistrictInput = document.getElementById('ghn-district-id');
            const toWardInput = document.getElementById('ghn-ward-code');
            const displayElement = document.getElementById('shipping-fee-display');
            const finalAmountElement = document.getElementById('final-amount-display');
            const feeInput = document.getElementById('shipping-fee-input');
            const cartTotalInput = document.getElementById('cart-total');
            const submitBtn = document.getElementById('submit-btn');

            if (submitBtn) submitBtn.disabled = true;

            if (!toDistrictInput || !toDistrictInput.value || toDistrictInput.value.trim() === '') {
                if(displayElement) displayElement.innerText = "Chưa có địa chỉ";
                return;
            }

            const districtVal = toDistrictInput.value;
            if (!districtVal || isNaN(parseInt(districtVal))) {
                if(displayElement) displayElement.innerText = "Vui lòng chọn địa chỉ giao hàng";
                return;
            }

            const toDistrictId = parseInt(toDistrictInput.value);
            const toWardCode = toWardInput.value;
            const cartTotal = parseInt(cartTotalInput ? cartTotalInput.value : 0);

            const payload = {
                "service_type_id": 2,
                "insurance_value": cartTotal,
                "coupon": null,
                "from_district_id": SHOP_DISTRICT_ID,
                "to_district_id": toDistrictId,
                "to_ward_code": toWardCode,
                "weight": 500,
                "length": 10,
                "width": 10,
                "height": 10
            };

            try {
                const response = await fetch(window.APP_CONTEXT_PATH +'/api/shipping-fee', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(payload)
                });

                const result = await response.json();

                if (result.code === 200 && result.data) {
                    const fee = parseInt(result.data.total);
                    const cartTotal = parseInt(document.getElementById('cart-total').value || 0);


                    if(displayElement) displayElement.innerText = new Intl.NumberFormat('vi-VN').format(fee) + "₫";
                    if(feeInput) feeInput.value = fee;


                    const finalTotal = cartTotal + fee;
                    if(finalAmountElement) finalAmountElement.innerText = new Intl.NumberFormat('vi-VN').format(finalTotal) + "₫";


                    if (submitBtn) submitBtn.disabled = false;
                } else {
                    if (displayElement) displayElement.innerText = "Lỗi tính phí";
                }
            } catch (error) {
                if(displayElement) displayElement.innerText = "Lỗi kết nối GHN";
            }
        }

        async function calculateLeadTime() {
            const toDistrictInput = document.getElementById('ghn-district-id');
            const toWardInput = document.getElementById('ghn-ward-code');
            const leadTimeDisplay = document.getElementById('lead-time-display');

            if (!toDistrictInput || !toDistrictInput.value || toDistrictInput.value.trim() === '') {
                return;
            }

            const toDistrictId = parseInt(toDistrictInput.value);
            const toWardCode = toWardInput.value;

            try {
                const serviceResponse = await fetch(window.APP_CONTEXT_PATH +'/api/shipping-service', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        "shop_id": SHOP_ID,
                        "from_district": SHOP_DISTRICT_ID,
                        "to_district": toDistrictId
                    })
                });

                const serviceResult = await serviceResponse.json();
                let validServiceId = null;


                if (serviceResult.code === 200 && serviceResult.data) {
                    const standardService = serviceResult.data.find(s => s.service_type_id === 2);
                    if (standardService) {
                        validServiceId = standardService.service_id;
                    } else if (serviceResult.data.length > 0) {
                        validServiceId = serviceResult.data[0].service_id;
                    }
                }


                if (!validServiceId) {
                    if (leadTimeDisplay) leadTimeDisplay.innerText = "Không hỗ trợ giao";
                    return;
                }

                const payload = {
                    "from_district_id": SHOP_DISTRICT_ID,
                    "from_ward_code": SHOP_WARD_ID,
                    "to_district_id": toDistrictId,
                    "to_ward_code": toWardCode,
                    "service_id": validServiceId
                };

                const response = await fetch(window.APP_CONTEXT_PATH +'/api/shipping-time', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'ShopId': SHOP_ID
                    },
                    body: JSON.stringify(payload)
                });

                const result = await response.json();

                if (result.code === 200 && result.data) {
                    if (result.data.leadtime > 0) {
                        const leadTimeDate = new Date(result.data.leadtime * 1000);
                        const formattedDate = leadTimeDate.toLocaleDateString('vi-VN', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric'
                        });
                        if (leadTimeDisplay) leadTimeDisplay.innerText = formattedDate;
                    } else {
                        // return 0
                        if (leadTimeDisplay) leadTimeDisplay.innerText = "Giao hàng trong ngày";
                    }
                } else {
                    if (leadTimeDisplay) leadTimeDisplay.innerText = "Không xác định";
                }
            } catch (error) {
                if (leadTimeDisplay) leadTimeDisplay.innerText = "Lỗi kết nối";
            }
        }

        document.addEventListener("DOMContentLoaded", () => {
            calculateShippingFee();
            calculateLeadTime()
        });
    </script>


    <%@include file="../include/footer.jsp"%>

