<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Form Nhập/Xuất Kho</title>
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                </head>

                <body>

                    <div class="container">
                        <div class="form-header">
                            <a href="${pageContext.request.contextPath}/warehouseAdmin" class="btn-back">← Quay lại</a>
                            <h2>Tạo Phiếu Nhập/Xuất Kho</h2>
                        </div>

                        <form action="${pageContext.request.contextPath}/admin/warehouseForm" method="post">
                            <div class="card" style="margin-bottom: 20px;">
                                <h3>Thông tin phiếu</h3>
                                <div class="row">
                                    <div class="col">
                                        <label for="type">Loại phiếu</label>
                                        <select id="type" name="type" required>
                                            <option value="IMPORT">Nhập kho (IMPORT)</option>
                                            <option value="EXPORT">Xuất kho (EXPORT)</option>
                                        </select>
                                    </div>
                                    <div class="col">
                                        <label for="note">Ghi chú</label>
                                        <input type="text" id="note" name="note"
                                            placeholder="Nhập ghi chú cho phiếu kho...">
                                    </div>
                                </div>
                            </div>

                            <div class="card">
                                <h3 style="margin-bottom: 15px;">Chi tiết sản phẩm</h3>
                                <div id="product-list">
                                    <div class="row product-row" style="align-items: flex-end; margin-bottom: 10px;">
                                        <div class="col" style="flex: 2;">
                                            <label>Sản phẩm (Kèm Màu & Size)</label>
                                            <select name="productVariantId[]" required
                                                style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">
                                                <option value="">-- Chọn sản phẩm --</option>
                                                <c:forEach var="v" items="${variants}">
                                                    <option value="${v.id}">${v.productName} - Màu: ${v.colorName} -
                                                        Size: ${v.sizeName}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col">
                                            <label>Số lượng</label>
                                            <input type="number" name="quantity[]" min="1" required
                                                placeholder="Nhập số lượng">
                                        </div>
                                        <div class="col">
                                            <label>Đơn giá (Nhập/Xuất)</label>
                                            <input type="number" name="price[]" step="0.01" min="0" required
                                                placeholder="Nhập giá">
                                        </div>
                                        <div class="col" style="flex: 0.3;">
                                            <button type="button" class="btn-danger"
                                                onclick="this.parentElement.parentElement.remove()"
                                                style="padding: 10px; background: #dc3545; color: white; border: none; cursor: pointer; border-radius: 4px; width: 100%;">Xóa</button>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" onclick="addProductRow()"
                                    style="margin-top: 10px; padding: 10px 15px; background: #28a745; color: white; border: none; cursor: pointer; border-radius: 4px; font-weight: bold;">+
                                    Thêm dòng sản phẩm</button>
                            </div>

                            <div class="form-footer" style="margin-top: 20px;">
                                <button type="button" class="btn-secondary"
                                    onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
                                <button type="submit" class="btn-primary">Lưu Phiếu Kho</button>
                            </div>
                        </form>
                    </div>

                    <select id="variantTemplate" style="display: none;">
                        <option value="">-- Chọn sản phẩm --</option>
                        <c:forEach var="v" items="${variants}">
                            <option value="${v.id}">${v.productName} - Màu: ${v.colorName} - Size: ${v.sizeName}
                            </option>
                        </c:forEach>
                    </select>

                    <script>
                        function addProductRow() {
                            const variantOptions = document.getElementById('variantTemplate').innerHTML;
                            const row = document.createElement('div');
                            row.className = 'row product-row';
                            row.style.alignItems = 'flex-end';
                            row.style.marginBottom = '10px';

                            const colProduct = document.createElement('div');
                            colProduct.className = 'col';
                            colProduct.style.flex = '2';
                            colProduct.innerHTML = '<label>Sản phẩm (Kèm Màu & Size)</label>' +
                                '<select name="productVariantId[]" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px;">' +
                                variantOptions + '</select>';

                            const colQty = document.createElement('div');
                            colQty.className = 'col';
                            colQty.innerHTML = '<label>Số lượng</label>' +
                                '<input type="number" name="quantity[]" min="1" required placeholder="Nhập số lượng">';

                            const colPrice = document.createElement('div');
                            colPrice.className = 'col';
                            colPrice.innerHTML = '<label>Đơn giá (Nhập/Xuất)</label>' +
                                '<input type="number" name="price[]" step="0.01" min="0" required placeholder="Nhập giá">';

                            const colBtn = document.createElement('div');
                            colBtn.className = 'col';
                            colBtn.style.flex = '0.3';
                            colBtn.innerHTML = '<button type="button" class="btn-danger" onclick="this.parentElement.parentElement.remove()" style="padding: 10px; background: #dc3545; color: white; border: none; cursor: pointer; border-radius: 4px; width: 100%;">Xóa</button>';

                            row.appendChild(colProduct);
                            row.appendChild(colQty);
                            row.appendChild(colPrice);
                            row.appendChild(colBtn);
                            document.getElementById('product-list').appendChild(row);
                        }
                    </script>
                    </div>
                </body>

                </html>