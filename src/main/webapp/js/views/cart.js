document.addEventListener("DOMContentLoaded", () => {

    const totalQtyEl = document.getElementById("totalQuantity");
    const totalPriceEl = document.getElementById("totalPrice");
    const totalFinalEl = document.getElementById("totalFinal");

    const selectAll = document.getElementById("selectAll");
    const itemCheckbox = document.querySelectorAll(".item-checkbox");

    function updateTotal() {
        let totalQty = 0;
        let totalPrice = 0;

        document.querySelectorAll(".item-checkbox:checked").forEach(checkbox => {
            const row = checkbox.closest("tr");
            const qtyInput = row.querySelector(".qty-display");

            const price = Number(row.dataset.price);
            const qty = Number(qtyInput.value);

            totalQty += qty;
            totalPrice += qty * price;
        });

        totalQtyEl.innerText = totalQty;
        totalPriceEl.innerText = totalPrice.toLocaleString("vi-VN");
        totalFinalEl.innerText = totalPrice.toLocaleString("vi-VN");
    }

    // tăng giảm
    document.querySelectorAll(".qty-form").forEach(form => {
        const minus = form.querySelector(".btn-minus");
        const plus = form.querySelector(".btn-plus");
        const qtyInput = form.querySelector(".qty-display");

        minus.addEventListener("click", () => {
            let qty = Number(qtyInput.value);
            if (qty > 1) {
                qtyInput.value = qty - 1;
                form.submit();
            }
        });

        plus.addEventListener("click", () => {
            qtyInput.value = Number(qtyInput.value) + 1;
            form.submit();
        });
    });

    // chọn tất cả
    if (selectAll) {
        selectAll.addEventListener("change", () => {
            itemCheckbox.forEach(cb => {
                cb.checked = selectAll.checked;
            });
            updateTotal();
        });
    }

    // chọn riêng lẻ
    itemCheckbox.forEach(cb => {
        cb.addEventListener("change", () => {
            // bỏ tích 1 cái ==> bỏ tất cả
            if (!cb.checked) selectAll.checked = false;
            // tất cả đc tích ==> tích tất cả
            const allChecked = Array.from(itemCheckbox).every(i => i.checked);
            if (allChecked) selectAll.checked = true;

            updateTotal();
        });
    });

    updateTotal();
});

const checkoutForm = document.getElementById("checkoutForm");
if (checkoutForm) {
    checkoutForm.addEventListener("submit", (e) => {
        const selectedCheckbox = document.querySelectorAll(".item-checkbox:checked");

        if (selectedCheckbox.length === 0) {
            e.preventDefault();
            alert("Trong giỏ của bạn chưa chọn sản phẩm nào để đặt hàng");
            return;
        }

        // xóa input trc đó mỗi lần nhấn Thanh toán
        const clearInputs = checkoutForm.querySelectorAll('input[name="selectedIds"]');
        clearInputs.forEach(input => input.remove());

        selectedCheckbox.forEach(cb => {
            const input = document.createElement("input");
            input.type = "hidden";
            input.name = "selectedIds";
            input.value = cb.value;
            checkoutForm.appendChild(input);
        });
    });
}

