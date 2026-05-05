document.addEventListener("DOMContentLoaded", () => {
    const totalQtyEl = document.getElementById("totalQuantity");
    const totalPriceEl = document.getElementById("totalPrice");
    const totalFinalEl = document.getElementById("totalFinal");
    const selectAll = document.getElementById("selectAll");
    const itemCheckbox = document.querySelectorAll(".item-checkbox");



    function updateCartBadge(quantity) {
        const badge = document.querySelector(".cart-count");
        if (badge) {
            badge.textContent = quantity;
            badge.style.display = quantity > 0 ? "inline-block" : "none";
        }
    }


    function updateTotal() {
        let totalQty = 0;
        let totalPrice = 0;
        document.querySelectorAll(".cart-item-row").forEach(row => {
            const checkbox = row.querySelector(".item-checkbox");
            const qtyInput = row.querySelector(".qty-display");
            const subtotalEl = row.querySelector(".item-subtotal");
            if (!qtyInput) return;

            const price = Number(row.dataset.price) || 0;
            const qty = Number(qtyInput.value) || 0;

            if (subtotalEl) {
                subtotalEl.innerText = (price * qty).toLocaleString("vi-VN") + " ₫";
            }
            if (checkbox && checkbox.checked) {
                totalQty += qty;
                totalPrice += qty * price;
            }
        });

        if (totalQtyEl) totalQtyEl.innerText = totalQty;
        if (totalPriceEl) totalPriceEl.innerText = totalPrice.toLocaleString("vi-VN");
        if (totalFinalEl) totalFinalEl.innerText = totalPrice.toLocaleString("vi-VN");
    }

    // update so lg
    document.querySelectorAll(".qty-form").forEach(form => {
        const minusBtn = form.querySelector(".btn-minus");
        const plusBtn = form.querySelector(".btn-plus");
        const qtyInput = form.querySelector(".qty-display");


        const updateQuantityAjax = () => {
            fetch(form.action, {
                method: "POST",
                body: new URLSearchParams(new FormData(form))
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        const newCartSize = data.cartSize !== undefined ? data.cartSize : data.totalQuantity;
                        updateCartBadge(newCartSize);
                        updateTotal();
                    } else {
                        alert(data.message || "Lỗi cập nhật số lượng");
                        window.location.reload();
                    }
                })
                .catch(err => console.error("Lỗi AJAX:", err));
        };


        if (minusBtn && plusBtn && qtyInput) {
            minusBtn.addEventListener("click", (e) => {
                e.preventDefault();
                let qty = Number(qtyInput.value);
                if (qty > 1) {
                    qtyInput.value = qty - 1;
                    updateQuantityAjax();
                }
            });


            plusBtn.addEventListener("click", (e) => {
                e.preventDefault();
                let qty = Number(qtyInput.value);
                qtyInput.value = qty + 1;
                updateQuantityAjax();
            });
        }
    });


    // xoa sp
    document.querySelectorAll(".btn-remove").forEach(btn => {
        btn.addEventListener("click", function(e) {
            e.preventDefault();
            const variantId = this.dataset.variantId;
            const row = this.closest("tr");

            if (confirm("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?")) {
                fetch("del-item", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: new URLSearchParams({ variantId: variantId })
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.error === "not_logged_in") {
                            window.location.href = "login";
                            return;
                        }
                        if (data.success) {
                            const newCartSize = data.cartSize !== undefined ? data.cartSize : data.totalQuantity;
                            if (newCartSize === 0) {
                                window.location.reload();
                            } else {
                                row.remove();
                                updateCartBadge(newCartSize);
                                const remainingCheckboxes = document.querySelectorAll(".item-checkbox");
                                if (remainingCheckboxes.length > 0 && selectAll) {
                                    selectAll.checked = Array.from(remainingCheckboxes).every(i => i.checked);
                                } else if (selectAll) {
                                    selectAll.checked = false;
                                }
                            }
                        }
                    })
                    .catch(err => console.error(err));
            }
        });
    });


    // cac checkbox
    if (selectAll) {
        selectAll.addEventListener("change", () => {
            document.querySelectorAll(".item-checkbox").forEach(cb => {
                cb.checked = selectAll.checked;
            });
            updateTotal();
        });
    }


    document.querySelectorAll(".item-checkbox").forEach(cb => {
        cb.addEventListener("change", () => {
            const allCheckboxes = document.querySelectorAll(".item-checkbox");
            if (selectAll) {
                selectAll.checked = Array.from(allCheckboxes).every(i => i.checked);
            }
        });
    });

    updateTotal();

    // kiem tra form trc khi thanh toan
    const checkoutForm = document.getElementById("checkoutForm");
    if (checkoutForm) {
        checkoutForm.addEventListener("submit", (e) => {
            const selectedCheckbox = document.querySelectorAll(".item-checkbox:checked");
            if (selectedCheckbox.length === 0) {
                e.preventDefault();
                alert("Trong giỏ của bạn chưa chọn sản phẩm nào để đặt hàng");
                return;
            }
            checkoutForm.querySelectorAll('input[name="selectedIds"]').forEach(input => input.remove());
            selectedCheckbox.forEach(cb => {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = "selectedIds";
                input.value = cb.value;
                checkoutForm.appendChild(input);
            });
        });
    }
});

// back về handle đc cartSize 2 trang home và detail và ..
window.addEventListener("pageshow", function (event) {
    if (event.persisted) {
        window.location.reload();
    }
});
