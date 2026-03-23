
const LOCATION_DATA = {
    "Hồ Chí Minh": {
        districts: {
            "Quận 1": ["Bến Nghé", "Bến Thành", "Đa Kao", "Tân Định"],
            "Quận 3": ["Phường 1", "Phường 2", "Phường 3"],
            "Quận 5": ["Phường 1", "Phường 2", "Phường 3", "Phường 5"],
            "Quận 7": ["Tân Phong", "Tân Phú", "Phú Mỹ"],
            "Thành phố Thủ Đức": ["Linh Trung", "Linh Xuân", "Hiệp Bình Chánh"]
        }
    },
    "Hà Nội": {
        districts: {
            "Ba Đình": ["Phúc Xá", "Trúc Bạch", "Ngọc Hà"],
            "Đống Đa": ["Láng Hạ", "Khâm Thiên"],
            "Cầu Giấy": ["Dịch Vọng", "Mai Dịch"]
        }
    },
    "Bình Dương": {
        districts: {
            "Thủ Dầu Một": ["Phú Cường", "Phú Hòa"],
            "Dĩ An": ["Dĩ An", "Tân Đông Hiệp"],
            "Thuận An": ["Lái Thiêu", "An Phú"]
        }
    }
};

document.addEventListener("DOMContentLoaded", () => {

    const modal = document.getElementById("addressModal");
    const btnOpen = document.getElementById("btnOpenModal");
    const btnClose = document.getElementById("btnCloseModal");
    const btnCancel = document.getElementById("btnCancelModal");

    if (btnOpen) {
        btnOpen.addEventListener("click", () => {
            resetForm();
            modal.classList.add("active");
        });
    }

    if (btnClose) {
        btnClose.addEventListener("click", () => modal.classList.remove("active"));
    }

    if (btnCancel) {
        btnCancel.addEventListener("click", () => modal.classList.remove("active"));
    }

    window.addEventListener("click", (e) => {
        if (e.target === modal) modal.classList.remove("active");
    });

    const citySelect = document.getElementById("citySelect");
    const districtSelect = document.getElementById("districtSelect");

    if (citySelect) {
        citySelect.addEventListener("change", loadDistricts);
    }

    if (districtSelect) {
        districtSelect.addEventListener("change", loadWards);
    }

    const form = document.querySelector(".address-form");
    if (form) {
        form.addEventListener("submit", validateForm);
    }
});

function loadDistricts() {
    const city = document.getElementById("citySelect").value;
    const districtSelect = document.getElementById("districtSelect");
    const wardSelect = document.getElementById("wardSelect");

    districtSelect.innerHTML = '<option value="">-- Chọn Quận / Huyện --</option>';
    wardSelect.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';

    districtSelect.disabled = true;
    wardSelect.disabled = true;

    if (!LOCATION_DATA[city]) return;

    const districts = LOCATION_DATA[city].districts;

    Object.keys(districts).forEach(d => {
        const opt = document.createElement("option");
        opt.value = d;
        opt.textContent = d;
        districtSelect.appendChild(opt);
    });

    districtSelect.disabled = false;
}

function loadWards() {
    const city = document.getElementById("citySelect").value;
    const district = document.getElementById("districtSelect").value;
    const wardSelect = document.getElementById("wardSelect");

    wardSelect.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';
    wardSelect.disabled = true;

    if (!LOCATION_DATA[city]) return;
    if (!LOCATION_DATA[city].districts[district]) return;

    LOCATION_DATA[city].districts[district].forEach(w => {
        const opt = document.createElement("option");
        opt.value = w;
        opt.textContent = w;
        wardSelect.appendChild(opt);
    });

    wardSelect.disabled = false;
}

function resetForm() {
    document.querySelector(".address-form").reset();

    const districtSelect = document.getElementById("districtSelect");
    const wardSelect = document.getElementById("wardSelect");

    districtSelect.innerHTML = '<option value="">-- Chọn Quận / Huyện --</option>';
    wardSelect.innerHTML = '<option value="">-- Chọn Phường / Xã --</option>';

    districtSelect.disabled = true;
    wardSelect.disabled = true;
}

function validateForm(e) {
    const phoneInput = document.getElementById("phoneInput");
    const phoneError = document.getElementById("phoneError");
    const phone = phoneInput.value.trim();

    if (!isValidPhone(phone)) {
        phoneError.textContent = "Vui lòng nhập đúng số điện thoại";
        phoneError.style.display = "block";
        phoneInput.focus();
        e.preventDefault();
        return false;
    }
}
function openEditModal(
    id, name, phone, city, district, ward, detail, isDefault
) {
    const modal = document.getElementById("addressModal");
    const form = document.querySelector(".address-form");

    form.action.value = "update";

    form.querySelector("input[name='name']").value = name;
    form.querySelector("input[name='phone']").value = phone;
    form.querySelector("select[name='city']").value = city;

    loadDistricts();

    setTimeout(() => {
        document.getElementById("districtSelect").value = district;
        loadWards();
        setTimeout(() => {
            document.getElementById("wardSelect").value = ward;
        }, 50);
    }, 50);

    form.querySelector("textarea[name='detailAddress']").value = detail;
    form.querySelector("input[name='isDefault']").checked = isDefault;

    let idInput = form.querySelector("input[name='id']");
    if (!idInput) {
        idInput = document.createElement("input");
        idInput.type = "hidden";
        idInput.name = "id";
        form.appendChild(idInput);
    }
    idInput.value = id;

    modal.classList.add("active");
}


function isValidPhone(phone) {
    const normalized = phone.replace(/\s|\.|-/g, "");
    const regex = /^(0[3|5|7|8|9])[0-9]{8}$/;
    return regex.test(normalized);
}

document.addEventListener("DOMContentLoaded", () => {
    const phoneInput = document.getElementById("phoneInput");
    const phoneError = document.getElementById("phoneError");

    if (!phoneInput || !phoneError) return;

    phoneInput.addEventListener("input", () => {
        const value = phoneInput.value.trim();

        if (value === "") {
            hidePhoneError();
            return;
        }

        if (!isValidPhone(value)) {
            showPhoneError("Số điện thoại phải đúng định dạng (VD: 090xxxxxxx)");
        } else {
            hidePhoneError();
        }
    });

    phoneInput.addEventListener("blur", () => {
        if (phoneInput.value && !isValidPhone(phoneInput.value)) {
            showPhoneError("Số điện thoại không hợp lệ");
        }
    });

    function showPhoneError(msg) {
        phoneError.textContent = msg;
        phoneError.style.display = "block";
        phoneInput.classList.add("input-error");
    }

    function hidePhoneError() {
        phoneError.textContent = "";
        phoneError.style.display = "none";
        phoneInput.classList.remove("input-error");
    }
});
