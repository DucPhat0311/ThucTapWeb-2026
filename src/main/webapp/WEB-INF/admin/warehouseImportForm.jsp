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
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
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
                                <label for="supplier">Nhà cung cấp</label>
                                <input type="text" id="supplier" name="supplier" placeholder="Nhập tên nhà cung cấp..." required>
                            </div>
                            <div class="col">
                                <label for="note">Ghi chú</label>
                                <input type="text" id="note" name="note" placeholder="Nhập ghi chú cho phiếu nhập...">
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h3>Chi tiết sản phẩm nhập</h3>
                        <div id="product-list">
                            <div class="row product-row">
                                <div class="col col-product">
                                    <div class="product-header">
                                        <label>Sản phẩm (Kèm Màu & Size)</label>
                                        <a href="${pageContext.request.contextPath}/productAdmin" target="_blank"
                                            class="link-add-new">
                                            <i class="fas fa-plus"></i> Thêm mới
                                        </a>
                                    </div>
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
                                    <label>Đơn giá nhập</label>
                                    <input type="number" name="price[]" step="0.01" min="0" required
                                        placeholder="Đơn giá">
                                </div>
                                <div class="col col-action">
                                    <button type="button" class="btn-remove-row"
                                        onclick="this.closest('.product-row').remove()">Xóa</button>
                                </div>
                            </div>
                        </div>
                        <div class="btn-action-group">
                            <button type="button" class="btn-add-row" onclick="addRow()">
                                <i class="fas fa-plus"></i> Thêm dòng sản phẩm
                            </button>
                            <label class="btn-excel-import">
                                <input type="file" id="excelUpload" accept=".xlsx, .xls" style="display: none;" onchange="importExcel(event)">
                                <i class="fas fa-file-import"></i> Nhập từ Excel
                            </label>
                            <button type="button" class="btn-excel-template" onclick="downloadExcelTemplate()">
                                <i class="fas fa-download"></i> Tải file mẫu
                            </button>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="button" class="btn-secondary"
                            onclick="window.location.href='${pageContext.request.contextPath}/warehouseAdmin'">Hủy</button>
                        <button type="submit" class="btn-primary">Lưu Phiếu Nhập</button>
                    </div>
                </form>
            </div>

            <select id="variantTemplate" style="display:none;">
                <option value="">-- Chọn sản phẩm --</option>
                <c:forEach var="v" items="${variants}">
                    <option value="${v.id}">${v.productName} - Màu: ${v.colorName} - Size: ${v.sizeName} (Tồn:
                        ${v.stock})</option>
                </c:forEach>
            </select>

            <script>
                function addRow(variantId = "", qty = "", price = "", hint = "") {
                    const variantOptions = document.getElementById('variantTemplate').innerHTML;
                    const row = document.createElement('div');
                    row.className = 'row product-row' + (hint ? ' unmatched' : '');

                    if (hint) {
                        const hintDiv = document.createElement('div');
                        hintDiv.className = 'unmatched-hint';
                        hintDiv.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Chưa tìm thấy trong hệ thống: <strong>' + hint + '</strong> &mdash; Hãy thêm mới sản phẩm trước khi nhập.';
                        row.appendChild(hintDiv);
                    }

                    const colProduct = document.createElement('div');
                    colProduct.className = 'col col-product';
                    colProduct.innerHTML = '<div class="product-header">' +
                        '<label>Sản phẩm (Kèm Màu & Size)</label>' +
                        '<a href="${pageContext.request.contextPath}/productAdmin" target="_blank" class="link-add-new">' +
                        '<i class="fas fa-plus"></i> Thêm mới</a>' +
                        '</div>' +
                        '<select name="productVariantId[]" required>' + variantOptions + '</select>';

                    const colQty = document.createElement('div');
                    colQty.className = 'col col-qty';
                    colQty.innerHTML = '<label>Số lượng</label>' +
                        '<input type="number" name="quantity[]" min="1" required placeholder="Số lượng" value="' + qty + '">';

                    const colPrice = document.createElement('div');
                    colPrice.className = 'col col-price';
                    colPrice.innerHTML = '<label>Đơn giá nhập</label>' +
                        '<input type="number" name="price[]" step="0.01" min="0" required placeholder="Đơn giá" value="' + price + '">';

                    const colBtn = document.createElement('div');
                    colBtn.className = 'col col-action';
                    colBtn.innerHTML = '<button type="button" class="btn-remove-row" onclick="this.closest(\'.product-row\').remove()">Xóa</button>';

                    row.appendChild(colProduct);
                    row.appendChild(colQty);
                    row.appendChild(colPrice);
                    row.appendChild(colBtn);
                    document.getElementById('product-list').appendChild(row);

                    if (variantId) {
                        const selectElement = row.querySelector('select[name="productVariantId[]"]');
                        if (selectElement) {
                            selectElement.value = variantId;
                        }
                    }
                }

                function downloadExcelTemplate() {
                    const ws_data = [
                        ["Tên Sản Phẩm", "Màu sắc", "Size", "Số lượng", "Đơn giá nhập"],
                        ["Áo Thun ABC", "Đen", "L", 10, 150000]
                    ];
                    const ws = XLSX.utils.aoa_to_sheet(ws_data);
                    
                    ws['!cols'] = [ {wch: 30}, {wch: 15}, {wch: 10}, {wch: 15}, {wch: 15} ];
                    
                    const wb = XLSX.utils.book_new();
                    XLSX.utils.book_append_sheet(wb, ws, "Template");
                    XLSX.writeFile(wb, "Mau_Nhap_Kho.xlsx");
                }

                function importExcel(event) {
                    const file = event.target.files[0];
                    if (!file) return;

                    const reader = new FileReader();
                    reader.onload = function(e) {
                        const data = new Uint8Array(e.target.result);
                        const workbook = XLSX.read(data, {type: 'array'});
                        const firstSheetName = workbook.SheetNames[0];
                        const worksheet = workbook.Sheets[firstSheetName];
                        const json = XLSX.utils.sheet_to_json(worksheet, {header: 1});

                        const existingRows = document.querySelectorAll('#product-list .product-row');
                        existingRows.forEach(function(row) {
                            const select = row.querySelector('select[name="productVariantId[]"]');
                            if (!select || !select.value) {
                                row.remove();
                            }
                        });

                        for (let i = 1; i < json.length; i++) {
                            const rowData = json[i];
                            if (!rowData || rowData.length === 0) continue;
                            
                            const pName = rowData[0] ? rowData[0].toString().trim() : '';
                            const pColor = rowData[1] ? rowData[1].toString().trim() : '';
                            const pSize = rowData[2] ? rowData[2].toString().trim() : '';
                            const pQty = rowData[3] ? rowData[3].toString().trim() : '';
                            const pPrice = rowData[4] ? rowData[4].toString().trim() : '';
                            
                            if (!pName) continue;

                            const templateSelect = document.getElementById('variantTemplate');
                            const options = templateSelect.options;
                            let matchedValue = "";

                            for (let j = 0; j < options.length; j++) {
                                const optText = options[j].text.toLowerCase();
                                if (optText.includes(pName.toLowerCase()) && 
                                    optText.includes("màu: " + pColor.toLowerCase()) && 
                                    optText.includes("size: " + pSize.toLowerCase())) {
                                    matchedValue = options[j].value;
                                    break;
                                }
                            }
                            const hint = !matchedValue ? (pName + ' - ' + pColor + ' - ' + pSize) : '';
                            addRow(matchedValue, pQty, pPrice, hint);
                        }
                        event.target.value = ""; 
                    };
                    reader.readAsArrayBuffer(file);
                }
            </script>
        </body>

        </html>