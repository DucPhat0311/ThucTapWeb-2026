<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="modal-overlay" id="addressModal">
    <div class="modal-content">
        <div class="modal-header">
            <h3>Thêm địa chỉ mới</h3>
            <span class="modal-close" id="btnCloseModal">&times;</span>
        </div>

        <form class="address-form" method="post" action="${pageContext.request.contextPath}/${param.formAction}">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="provinceCode" id="provinceCodeInput">
            <input type="hidden" name="districtCode" id="districtCodeInput">
            <input type="hidden" name="wardCode" id="wardCodeInput">
            <c:if test="${not empty param.redirectTo}">
                <input type="hidden" name="redirectTo" value="${param.redirectTo}">
            </c:if>
            <c:if test="${param.forceDefault eq 'true'}">
                <input type="hidden" name="forceDefault" value="true">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label>Họ và tên người nhận <span class="required">*</span></label>
                    <input type="text" name="name" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại <span class="required">*</span></label>
                    <input type="tel" name="phone" id="phoneInput" required>
                    <small id="phoneError" class="error-message"></small>
                </div>
            </div>

            <div class="form-row three-cols">
                <div class="form-group">
                    <label>Tỉnh / Thành phố <span class="required">*</span></label>
                    <select name="city" id="citySelect" required>
                        <option value="">-- Chọn --</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Quận / Huyện <span class="required">*</span></label>
                    <select name="district" id="districtSelect" required disabled>
                        <option value="">-- Chọn --</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Phường / Xã <span class="required">*</span></label>
                    <select name="ward" id="wardSelect" required disabled>
                        <option value="">-- Chọn --</option>
                    </select>
                </div>
            </div>
            <small id="locationError" class="error-message location-error"></small>

            <div class="form-group">
                <label>Địa chỉ chi tiết <span class="required">*</span></label>
                <textarea name="detailAddress" rows="2" placeholder="Số nhà, tên đường..." required></textarea>
            </div>

            <c:if test="${param.hideDefaultOption ne 'true'}">
                <div class="form-group">
                    <label class="checkbox-label">
                        <input type="checkbox" name="isDefault">
                        Đặt làm địa chỉ mặc định
                    </label>
                </div>
            </c:if>

            <div class="form-actions">
                <button type="button" class="btn-cancel" id="btnCancelModal">
                    Hủy
                </button>
                <button type="submit" class="btn-save">
                    Lưu địa chỉ
                </button>
            </div>
        </form>
    </div>
</div>
