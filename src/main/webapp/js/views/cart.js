document.addEventListener("DOMContentLoaded", () => {
    const totalQtyEl = document.getElementById("totalQuantity");
    const totalPriceEl = document.getElementById("totalPrice");
    const totalFinalEl = document.getElementById("totalFinal");
    const selectAll = document.getElementById("selectAll");
    const itemCheckbox = document.querySelectorAll(".item-checkbox");

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

    // cac checkbox
    if (selectAll) {
        selectAll.addEventListener("change", () => {
            document.querySelectorAll(".item-checkbox").forEach(cb => {
                cb.checked = selectAll.checked;
            });
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
