document.addEventListener("DOMContentLoaded", () => {

    const colorBtns = document.querySelectorAll(".color-btn");
    const sizeButtons = document.querySelectorAll(".size-btn");
    const btnAddCart = document.querySelector(".btn-add-cart");

    const decreaseBtn = document.querySelector(".btn-decrease");
    const increaseBtn = document.querySelector(".btn-increase");
    const quantityInput = document.getElementById("quantity");

    let selectedColorId = null;
    let selectedSizeId = null;
    let currentStock = 0;


    // ===== Nhấn chọn size =====
    sizeButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            if (btn.disabled) return;

            sizeButtons.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            selectedSizeId = Number(btn.dataset.sizeId);

            const variant = variants.find(v =>
                v.colorId === selectedColorId &&
                v.sizeId === selectedSizeId
            );

            currentStock = variant ? variant.stock : 0;
            quantityInput.value = 1;
        });
    });


    // ===== Nhấn chọn màu =====
    colorBtns.forEach(btn => {
        btn.addEventListener("click", () => {

            colorBtns.forEach(t => t.classList.remove("active"));
            btn.classList.add("active");

            selectedColorId = Number(btn.dataset.colorId);
            selectedSizeId = null;
            currentStock = 0;
            quantityInput.value = 1;

            sizeButtons.forEach(b => b.classList.remove("active"));

            updateSizeAvailability();
        });
    });

    // ===== Chọn size =====
    sizeButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            if (btn.disabled) return;

            sizeButtons.forEach(b => b.classList.remove("active"));
            btn.classList.add("active");

            selectedSizeId = Number(btn.dataset.sizeId);
        });
    });

    // ===== Khóa size theo màu =====
    function updateSizeAvailability() {
        sizeButtons.forEach(btn => {
            const sizeId = Number(btn.dataset.sizeId);

            const variant = variants.find(v =>
                v.colorId === selectedColorId &&
                v.sizeId === sizeId
            );

            if (!variant || variant.stock <= 0) {
                btn.disabled = true;
                btn.classList.add("disabled");
            } else {
                btn.disabled = false;
                btn.classList.remove("disabled");
            }
        });

        currentStock = 0;
        quantityInput.value = 1;
    }


    // ===== tăng giảm số lượng =====
    if (decreaseBtn && increaseBtn && quantityInput) {
        decreaseBtn.addEventListener("click", () => {
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size trước");
                return;
            }
            let val = parseInt(quantityInput.value);
            if (val > 1) quantityInput.value = val - 1;
        });

        increaseBtn.addEventListener("click", () => {
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size trước");
                return;
            }

            let val = parseInt(quantityInput.value);

            if (val < currentStock) {
                quantityInput.value = val + 1;
            } else {
                showToast(`Chỉ còn ${currentStock} sản phẩm`);
            }
        });
    }

    // ===== thông báo =====
    function showToast(message, isError = false) {
        const toast = document.getElementById("toast");
        toast.textContent = message;
        toast.className = "show";

        setTimeout(() => {
            toast.className = toast.className.replace("show", "");
        }, 3000);
    }

    function updateCartBadge(quantity) {
        const badge = document.querySelector(".cart-count");

        if (badge) {
            badge.textContent = quantity;
        }
    }

    // ===== thêm giỏ hàng =====
    btnAddCart.addEventListener("click", () => {

        if (!selectedColorId || !selectedSizeId) {
            showToast("Chọn màu và size!");
            return;
        }

        const variant = variants.find(v =>
            v.colorId === selectedColorId &&
            v.sizeId === selectedSizeId
        );

        const quantity = parseInt(quantityInput.value);

        fetch("add-cart", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: new URLSearchParams({
                variantId: variant.id,
                quantity: quantity
            })
        })
            .then(res => res.json())
            .then(data => {
                console.log(data); // debug

                if (data.error === "not_logged_in") {
                    window.location.href = "login";
                    return;
                }

                if (data.success) {
                    showToast("Đã thêm vào giỏ!");
                    updateCartBadge(data.totalQuantity); // 🔥 QUAN TRỌNG
                } else {
                    showToast(data.message || "Thất bại");

                }
            })
            .catch(err => {
                console.error(err);
                showToast("Lỗi kết nối");
            });
    });})

