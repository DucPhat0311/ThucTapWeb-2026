<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <title>Tạo Phiếu Hoàn Kho</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/warehouseForm.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
        </head>

        <body>
            <div class="container">
                <div class="form-header">
                    <a href="${pageContext.request.contextPath}/warehouseAdmin" class="btn-back">← Quay lại</a>
                    <h2>Tạo Phiếu Hoàn Kho</h2>
                </div>

                <form action="${pageContext.request.contextPath}/admin/warehouseReturnForm" method="post">
                    <div class="card">
                        <h3>Thông tin phiếu</h3>
                        <div class="row">
                            <div class="col col-flex-1">
                                <label for="orderId">Mã đơn trả hàng (nếu có)</label>
                                <input type="number" id="orderId" name="orderId" placeholder="Nhập mã đơn trả hàng để đối soát..." min="1">
                            </div>
                            <div class="col col-flex-2">
                                <label for="note">Ghi chú</label>
                                <input type="text" id="note" name="note" placeholder="Ví dụ: Hoàn kho hàng lỗi từ đơn hàng, hoàn kho sản phẩm dùng thử..." required>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h3>Chi tiết sản phẩm hoàn</h3>
                        <div id="product-list">
                            <div class="row product-row">
                                <div class="col col-product">
                                    <label>Sản phẩm hoàn (Kèm Màu & Size)</label>
                                    <select name="productVariantId[]" required>
                                        <option value="">-- Chọn sản phẩm --</option>
                                        <c:forEach var="v" items="${variants}">
                                            <option value="${v.id}">${v.productName} - Màu: ${v.colorName} - Size:
                                                ${v.sizeName} (Tồn: ${v.stock})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col col-qty">
                                    <label>Số lượng</label>
                                    <input type="number" name="quantity[]" min="1" required placeholder="Số lượng">
                                </div>
                                <div class="col col-price">
                                    <label>Đơn giá hoàn</label>
                                    <input type="number" name="price[]" step="0.01" min="0" required
                                        placeholder="Đơn giá">
                                </div>
                                <div class="col col-action">
                                    <button type="button" class="btn-remove-row"
                                        onclick="this.closest('.product-row').remove()">Xóa</button>
                                </div>
                            </div>
                        </div>
                        <button type="button" class="btn-add-row" onclick="addRow()">+ Thêm dòng sản phẩm</button>
                    </div>

                    <div class="form-footer">
                        <button type="button" class="btn-secondary"
                            onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
                        <button type="submit" class="btn-primary">Lưu Phiếu Hoàn</button>
                    </div>
                </form>
            </div>

            <select id="variantTemplate" class="d-none">
                <option value="">-- Chọn sản phẩm --</option>
                <c:forEach var="v" items="${variants}">
                    <option value="${v.id}">${v.productName} - Màu: ${v.colorName} - Size: ${v.sizeName} (Tồn:
                        ${v.stock})</option>
                </c:forEach>
            </select>

            <script>
                function addRow() {
                    const variantOptions = document.getElementById('variantTemplate').innerHTML;
                    const row = document.createElement('div');
                    row.className = 'row product-row';

                    const colProduct = document.createElement('div');
                    colProduct.className = 'col col-product';
                    colProduct.innerHTML = '<label>Sản phẩm hoàn (Kèm Màu & Size)</label>' +
                        '<select name="productVariantId[]" required>' + variantOptions + '</select>';

                    const colQty = document.createElement('div');
                    colQty.className = 'col col-qty';
                    colQty.innerHTML = '<label>Số lượng</label>' +
                        '<input type="number" name="quantity[]" min="1" required placeholder="Số lượng">';

                    const colPrice = document.createElement('div');
                    colPrice.className = 'col col-price';
                    colPrice.innerHTML = '<label>Đơn giá hoàn</label>' +
                        '<input type="number" name="price[]" step="0.01" min="0" required placeholder="Đơn giá">';

                    const colBtn = document.createElement('div');
                    colBtn.className = 'col col-action';
                    colBtn.innerHTML = '<button type="button" class="btn-remove-row" onclick="this.closest(\'.product-row\').remove()">Xóa</button>';

                    row.appendChild(colProduct);
                    row.appendChild(colQty);
                    row.appendChild(colPrice);
                    row.appendChild(colBtn);
                    document.getElementById('product-list').appendChild(row);
                }
            </script>
        </body>

        </html>
