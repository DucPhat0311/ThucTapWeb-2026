function openAddProductModal() {
    document.getElementById("product-form").reset();
    document.getElementById("product-action").value = "add";
    document.getElementById("product-modal-title").innerText = "Thêm sản phẩm";
    document.getElementById("product-modal").classList.add("show");
}

function viewProduct(id) {
    fetch("product-admin?action=view&id=" + id)
        .then(res => res.json())
        .then(p => {
            document.getElementById("view-product-id").innerText = p.id;
            document.getElementById("view-product-name").innerText = p.name;
            document.getElementById("view-product-price").innerText = 
                Number(p.price).toLocaleString() + " ₫";
            document.getElementById("view-product-category").innerText = p.categoryName || p.category;
            document.getElementById("view-product-status").innerText = p.status;
            document.getElementById("view-product-image").src = p.thumbnail;

            document.getElementById("view-product-modal").classList.add("show");
        })
        .catch(err => {
            console.error("Error loading product:", err);
            alert("Không thể tải thông tin sản phẩm");
        });
}

function closeViewProductModal() {
    document.getElementById("view-product-modal").classList.remove("show");
}

function editProduct(id) {
    fetch("product-admin?action=view&id=" + id)
        .then(res => res.json())
        .then(p => {
            document.getElementById("product-action").value = "update";
            document.getElementById("product-id").value = p.id;
            document.getElementById("product-name").value = p.name;
            document.getElementById("product-price").value = p.price;
            document.getElementById("product-category").value = p.category_id;
            document.getElementById("product-thumbnail").value = p.thumbnail;
            document.getElementById("product-status").value = p.status;
            document.getElementById("product-modal-title").innerText = "Chỉnh sửa sản phẩm";
            
            document.getElementById("product-modal").classList.add("show");
        })
        .catch(err => {
            console.error("Error loading product:", err);
            alert("Không thể tải thông tin sản phẩm");
        });
}

function closeProductModal() {
    document.getElementById("product-modal").classList.remove("show");
}

let toggleProductData = { id: null, name: '', status: '' };

function openToggleProductModal(id, name, status) {
    let message = "";
    if (status === "Đã xoá") {
        message = `Bạn có chắc muốn <strong>xóa</strong> sản phẩm "<strong>${name}</strong>" không?`;
    } else if (status === "Đang bán") {
        message = `Bạn có chắc muốn đặt sản phẩm "<strong>${name}</strong>" thành <strong>Hết hàng</strong> không?`;
    } else {
        message = `Bạn có chắc muốn mở bán lại sản phẩm "<strong>${name}</strong>" không?`;
    }
    document.getElementById("toggle-product-message").innerHTML = message;
    document.getElementById("toggle-product-id").value = id;
    document.getElementById("toggle-product-modal").classList.add("show");
}

function closeToggleProductModal() {
    document.getElementById("toggle-product-modal").classList.remove("show");
}
