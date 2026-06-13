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
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css?v=<%= System.currentTimeMillis() %>">
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
                            <div class="card card-margin-bottom">
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
                                 <div class="card">
                                <h3 class="h3-margin-bottom">Chi tiết sản phẩm</h3>
                                <div id="product-list">
                                    <div class="row product-row row-align-end-margin">
                                        <div class="col col-flex-2">
                                            <label>Sản phẩm (Kèm Màu & Size)</label>
                                            <select name="productVariantId[]" required
                                                class="select-full-padding">
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
                                         <div class="col col-flex-0-3">
                                             <button type="button" class="btn-danger btn-danger-custom"
                                                 onclick="this.parentElement.parentElement.remove()">Xóa</button>
                                         </div>
                                     </div>
                                 </div>
                                 <button type="button" onclick="addProductRow()"
                                     class="btn-success-custom">+
                                     Thêm dòng sản phẩm</button>
                             </div>
 
                             <div class="form-footer footer-margin-top">
                                <button type="button" class="btn-secondary"
                                    onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
                                <button type="submit" class="btn-primary">Lưu Phiếu Kho</button>
                            </div>
                        </form>
                    </div>

                    <select id="variantTemplate" class="d-none">
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
                            row.className = 'row product-row row-align-end-margin';

                            const colProduct = document.createElement('div');
                            colProduct.className = 'col col-flex-2';
                            colProduct.innerHTML = '<label>Sản phẩm (Kèm Màu & Size)</label>' +
                                '<select name="productVariantId[]" required class="select-full-padding">' +
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
                            colBtn.className = 'col col-flex-0-3';
                            colBtn.innerHTML = '<button type="button" class="btn-danger btn-danger-custom" onclick="this.parentElement.parentElement.remove()">Xóa</button>';

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