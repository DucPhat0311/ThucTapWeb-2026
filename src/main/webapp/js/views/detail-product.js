document.addEventListener("DOMContentLoaded", () => {
    const colorBtns = document.querySelectorAll(".color-btn");
    const sizeButtons = document.querySelectorAll(".size-btn");
    const btnAddCart = document.querySelector(".btn-add-cart");
    const decreaseBtn = document.querySelector(".btn-decrease");
    const increaseBtn = document.querySelector(".btn-increase");
    const quantityInput = document.getElementById("quantity");
    const stars = document.querySelectorAll(".star-select .star");
    const submitBtn = document.getElementById("submit-review");
    const ratingInput = document.getElementById("rating-value");
    const buyNowBtn = document.querySelector(".btn-buy-now");

    const priceDisplayContainer = document.getElementById("variant-price-display");

    let selectedColorId = null;
    let selectedSizeId = null;
    let selectedRating = 0;
    let currentStock = 0;


    function checkAndRenderVariant() {
        const stockStatusText = document.getElementById("stock-status-text");
        if (!selectedColorId || !selectedSizeId) {
            if (stockStatusText) {
                if (firstTotalStock > 0) {
                    stockStatusText.innerHTML = ` Còn hàng (Tổng còn ${firstTotalStock} sản phẩm)`;
                } else {
                    stockStatusText.innerHTML = `Hết hàng`;
                }
            }
            return;
        }
        const matchedVariant = variants.find(v => v.colorId === selectedColorId && v.sizeId === selectedSizeId);

        if (matchedVariant) {
            if (stockStatusText) {
                if (matchedVariant.stock > 0) {
                    stockStatusText.innerHTML = `Còn hàng (Mẫu này còn ${matchedVariant.stock} sản phẩm)`;
                } else {
                    stockStatusText.innerHTML = `Hết hàng`;
                }
            }
            if (priceDisplayContainer) {
                let htmlPrice = "";
                if (matchedVariant.salePrice > 0 && matchedVariant.salePrice < matchedVariant.price) {
                    htmlPrice = `
                        <span class="current-price" style="font-weight:bold; color: red">
                            ${new Intl.NumberFormat('vi-VN').format(matchedVariant.salePrice)}₫
                        </span>
                        <span class="old-price" style="text-decoration: line-through; color: #999; font-size: 0.9em; margin-left: 8px;">
                            ${new Intl.NumberFormat('vi-VN').format(matchedVariant.price)}₫
                        </span>
                    `;
                } else {
                    htmlPrice = `
                        <span class="current-price" style="font-weight:bold">
                            ${new Intl.NumberFormat('vi-VN').format(matchedVariant.price)}₫
                        </span>
                    `;
                }
                priceDisplayContainer.innerHTML = htmlPrice;
            }
        } else {
            if (priceDisplayContainer) {
                priceDisplayContainer.innerHTML = `<span style="color: #999; font-style: italic;">Tạm hết hàng</span>`;
            }
        }
    }

    function showToast(message, isError = false) {
        const toast = document.getElementById("toast");
        if (!toast) return;
        toast.textContent = message;

        if (isError) {
            toast.style.backgroundColor = "#ff4d4f";
            toast.style.color = "#ffffff";
            toast.style.fontWeight = "bold";
            toast.style.boxShadow = "0 4px 12px rgba(255, 77, 79, 0.4)";
        } else {
            toast.style.backgroundColor = "";
            toast.style.color = "";
            toast.style.fontWeight = "";
            toast.style.boxShadow = "";
        }

        toast.className = "show";
        setTimeout(() => {
            toast.className = toast.className.replace("show", "");
        }, 6000);
    }

    function updateCartBadge(quantity) {
        const badge = document.querySelector(".cart-count");
        if (badge) {
            badge.textContent = quantity;
            badge.style.display = quantity > 0 ? "inline-block" : "none";
        }
    }

    // chọn Màu
    colorBtns.forEach(btn => {
        btn.addEventListener("click", () => {
            const colorId = Number(btn.dataset.colorId);

            if (selectedColorId === colorId) {
                btn.classList.remove("active");
                selectedColorId = null;
            } else {
                colorBtns.forEach(t => t.classList.remove("active"));
                btn.classList.add("active");
                selectedColorId = colorId;
            }

            if (selectedColorId && selectedSizeId) {
                const variant = variants.find(v => v.colorId === selectedColorId && v.sizeId === selectedSizeId);
                currentStock = variant ? variant.stock : 0;
            } else {
                currentStock = 0;
            }

            checkAndRenderVariant();
        });
    });

    // chọn Size
    sizeButtons.forEach(btn => {
        btn.addEventListener("click", () => {
            const sizeId = Number(btn.dataset.sizeId);

            if (selectedSizeId === sizeId) {
                btn.classList.remove("active");
                selectedSizeId = null;
                currentStock = 0;
            } else {
                sizeButtons.forEach(b => b.classList.remove("active"));
                btn.classList.add("active");
                selectedSizeId = sizeId;
            }

            if (selectedColorId && selectedSizeId) {
                const variant = variants.find(v => v.colorId === selectedColorId && v.sizeId === selectedSizeId);
                currentStock = variant ? variant.stock : 0;
            } else {
                currentStock = 0;
            }

            if (quantityInput) quantityInput.value = 1;
            checkAndRenderVariant();
        });
    });

    // + Tang - giam so luong
    if (decreaseBtn && increaseBtn && quantityInput) {
        decreaseBtn.addEventListener("click", () => {
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size trước", true);
            }
            let val = parseInt(quantityInput.value);
            if (val > 1) quantityInput.value = val - 1;
        });

        increaseBtn.addEventListener("click", () => {
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size trước", true);
                return;
            }
            let val = parseInt(quantityInput.value);
            if (val < currentStock) {
                quantityInput.value = val + 1;
            } else {
                showToast(`Chỉ còn ${currentStock} sản phẩm`, true);
            }
        });
    }

    // danh gia sao
    stars.forEach(star => {
        star.addEventListener("click", () => {
            selectedRating = parseInt(star.dataset.value);
            if (ratingInput) ratingInput.value = selectedRating;

            stars.forEach(s => s.classList.remove("active"));
            for (let i = 0; i < selectedRating; i++) {
                stars[i].classList.add("active");
            }
        });
    });

    if (submitBtn) {
        submitBtn.addEventListener("click", (e) => {
            if (selectedRating === 0) {
                e.preventDefault();
                alert("Vui lòng chọn số sao trước khi gửi đánh giá!");
            }
        });
    }

    // handle nút Thêm vào giỏ hàng
    if (btnAddCart) {
        btnAddCart.addEventListener("click", () => {
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size", true);
                return;
            }

            const variant = variants.find(v => v.colorId === selectedColorId && v.sizeId === selectedSizeId);
            const quantity = parseInt(quantityInput.value);

            fetch("add-cart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({
                    variantId: variant.id,
                    quantity: quantity
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.error === "not_logged_in") {
                        window.location.href = "login";
                        return;
                    }
                    if (data.success) {
                        showToast("Đã thêm vào giỏ hàng!", false);
                        const newCartSize = data.cartSize !== undefined ? data.cartSize : data.totalQuantity;
                        updateCartBadge(newCartSize);
                    } else {
                        showToast(data.message || "Thêm thất bại", true);
                    }
                })
                .catch(err => {
                    console.error(err);
                    showToast("Lỗi kết nối tới Server", true);
                });
        });
    }

    if (buyNowBtn) {
        buyNowBtn.addEventListener("click", function(e) {
            e.preventDefault();
            if (!selectedColorId || !selectedSizeId) {
                showToast("Vui lòng chọn màu và size", true);
                return;
            }

            const quantity = quantityInput ? parseInt(quantityInput.value) : 1;
            const foundVariant = variants.find(v => v.colorId === selectedColorId && v.sizeId === selectedSizeId);

            if (!foundVariant) {
                showToast("Mẫu này hiện không tồn tại trên hệ thống!", true);
                return;
            }

            if (foundVariant.stock <= 0) {
                showToast("Sản phẩm đã hết hàng", true);
                return;
            }
            if (quantity > foundVariant.stock) {
                showToast(`Số lượng chọn vượt quá hàng tồn kho (Còn: ${foundVariant.stock})`, true);
                return;
            }

            fetch("add-cart", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: new URLSearchParams({
                    variantId: foundVariant.id,
                    quantity: quantity
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.error === "not_logged_in") {
                        window.location.href = "login";
                        return;
                    }

                    if (!data.success) {
                        showToast(data.message || "Sản phẩm hiện không thể mua hàng!", true);
                        return;
                    }

                    const form = document.createElement("form");
                    form.method = "POST";
                    form.action = requestContextPath + "/buy-now";

                    const fields = {
                        variantId: foundVariant.id,
                        quantity: quantity,
                        productId: currentProductId
                    };

                    for (const key in fields) {
                        const input = document.createElement("input");
                        input.type = "hidden";
                        input.name = key;
                        input.value = fields[key];
                        form.appendChild(input);
                    }

                    document.body.appendChild(form);
                    form.submit();
                })
                .catch(err => {
                    console.error(err);
                    showToast("Lỗi hệ thống khi kiểm tra sản phẩm", true);
                });
        });
    }
});
// handle nút back trogn chrome khi thêm giỏ hàng
window.addEventListener("pageshow", function (event) {
    if (event.persisted) {
        window.location.reload();
    }
});