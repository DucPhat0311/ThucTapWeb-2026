<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo Phiếu Nhập Kho</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/warehouseForm.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>
<div class="container">
    <div class="form-header">
        <a href="${pageContext.request.contextPath}/warehouseAdmin" class="btn-back">← Quay lại</a>
        <h2>Tạo Phiếu Nhập Kho</h2>
    </div>

    <form action="${pageContext.request.contextPath}/admin/warehouseImportForm" method="post">
        <div class="card">
            <h3>Thông tin phiếu</h3>
            <div class="row">
                <div class="col">
                    <label for="note">Ghi chú</label>
                    <input type="text" id="note" name="note" placeholder="Nhập ghi chú cho phiếu nhập...">
                </div>
            </div>
        </div>

        <div class="card">
            <h3>Chi tiết sản phẩm nhập</h3>
            <p class="form-note">* Nếu tổ hợp Sản phẩm - Màu - Size chưa tồn tại, hệ thống sẽ tự động tạo mới.</p>
            <div id="product-list">
                <div class="row product-row">
                    <div class="col col-product">
                        <label>Sản phẩm</label>
                        <select name="productId[]" required>
                            <option value="">-- Chọn sản phẩm --</option>
                            <c:forEach var="p" items="${products}">
                                <option value="${p.id}">${p.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col col-color">
                        <label>Màu sắc</label>
                        <select name="colorId[]" required>
                            <option value="">-- Màu --</option>
                            <c:forEach var="c" items="${colors}">
                                <option value="${c.id}">${c.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col col-size">
                        <label>Size</label>
                        <select name="sizeId[]" required>
                            <option value="">-- Size --</option>
                            <c:forEach var="s" items="${sizes}">
                                <option value="${s.id}">${s.code}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col col-qty">
                        <label>Số lượng</label>
                        <input type="number" name="quantity[]" min="1" required placeholder="Số lượng">
                    </div>
                    <div class="col col-price">
                        <label>Đơn giá nhập</label>
                        <input type="number" name="price[]" step="0.01" min="0" required placeholder="Đơn giá">
                    </div>
                    <div class="col col-action">
                        <button type="button" class="btn-remove-row" onclick="this.closest('.product-row').remove()">Xóa</button>
                    </div>
                </div>
            </div>
            <button type="button" class="btn-add-row" onclick="addRow()">+ Thêm dòng sản phẩm</button>
        </div>

        <div class="form-footer">
            <button type="button" class="btn-secondary"
                onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
            <button type="submit" class="btn-primary">Lưu Phiếu Nhập</button>
        </div>
    </form>
</div>

<select id="tplProduct" style="display:none;">
    <option value="">-- Chọn sản phẩm --</option>
    <c:forEach var="p" items="${products}">
        <option value="${p.id}">${p.name}</option>
    </c:forEach>
</select>
<select id="tplColor" style="display:none;">
    <option value="">-- Màu --</option>
    <c:forEach var="c" items="${colors}">
        <option value="${c.id}">${c.name}</option>
    </c:forEach>
</select>
<select id="tplSize" style="display:none;">
    <option value="">-- Size --</option>
    <c:forEach var="s" items="${sizes}">
        <option value="${s.id}">${s.code}</option>
    </c:forEach>
</select>

<script>
    function addRow() {
        const pOpts = document.getElementById('tplProduct').innerHTML;
        const cOpts = document.getElementById('tplColor').innerHTML;
        const sOpts = document.getElementById('tplSize').innerHTML;

        const row = document.createElement('div');
        row.className = 'row product-row';

        const colP = document.createElement('div');
        colP.className = 'col col-product';
        colP.innerHTML = '<label>Sản phẩm</label>' +
            '<select name="productId[]" required>' + pOpts + '</select>';

        const colC = document.createElement('div');
        colC.className = 'col col-color';
        colC.innerHTML = '<label>Màu sắc</label>' +
            '<select name="colorId[]" required>' + cOpts + '</select>';

        const colS = document.createElement('div');
        colS.className = 'col col-size';
        colS.innerHTML = '<label>Size</label>' +
            '<select name="sizeId[]" required>' + sOpts + '</select>';

        const colQty = document.createElement('div');
        colQty.className = 'col col-qty';
        colQty.innerHTML = '<label>Số lượng</label>' +
            '<input type="number" name="quantity[]" min="1" required placeholder="Số lượng">';

        const colPrice = document.createElement('div');
        colPrice.className = 'col col-price';
        colPrice.innerHTML = '<label>Đơn giá nhập</label>' +
            '<input type="number" name="price[]" step="0.01" min="0" required placeholder="Đơn giá">';

        const colBtn = document.createElement('div');
        colBtn.className = 'col col-action';
        colBtn.innerHTML = '<button type="button" class="btn-remove-row" onclick="this.closest(\'.product-row\').remove()">Xóa</button>';

        row.appendChild(colP);
        row.appendChild(colC);
        row.appendChild(colS);
        row.appendChild(colQty);
        row.appendChild(colPrice);
        row.appendChild(colBtn);
        document.getElementById('product-list').appendChild(row);
    }
</script>
</body>
</html>
