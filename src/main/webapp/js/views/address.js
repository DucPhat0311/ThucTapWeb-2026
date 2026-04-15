const CONTEXT_PATH = (window.APP_CONTEXT_PATH || "").replace(/\/$/, "");
const LOCATION_API = {
    provinces: `${CONTEXT_PATH}/api/locations/provinces`,
    districts: `${CONTEXT_PATH}/api/locations/districts`,
    wards: `${CONTEXT_PATH}/api/locations/wards`
};

const PLACEHOLDER = {
    province: "-- Chọn Tỉnh / Thành phố --",
    district: "-- Chọn Quận / Huyện --",
    ward: "-- Chọn Phường / Xã --",
    loading: "Đang tải...",
    error: "Không tải được dữ liệu"
};

let provinceLoadPromise = null;

document.addEventListener("DOMContentLoaded", initAddressPage);

function initAddressPage() {
    setupModalEvents();
    setupLocationEvents();
    setupFormValidation();
    loadProvinces();
}

function setupModalEvents() {
    const modal = document.getElementById("addressModal");
    const btnOpen = document.getElementById("btnOpenModal");
    const btnClose = document.getElementById("btnCloseModal");
    const btnCancel = document.getElementById("btnCancelModal");

    if (btnOpen) {
        btnOpen.addEventListener("click", async () => {
            resetForm();
            modal.classList.add("active");
            await loadProvinces();
        });
    }

    if (btnClose) {
        btnClose.addEventListener("click", () => modal.classList.remove("active"));
    }

    if (btnCancel) {
        btnCancel.addEventListener("click", () => modal.classList.remove("active"));
    }

    window.addEventListener("click", (event) => {
        if (event.target === modal) {
            modal.classList.remove("active");
        }
    });
}

function setupLocationEvents() {
    const citySelect = getCitySelect();
    const districtSelect = getDistrictSelect();
    const wardSelect = getWardSelect();

    if (citySelect) {
        citySelect.addEventListener("change", async () => {
            syncLocationCode(citySelect, "provinceCodeInput");
            resetSelect(districtSelect, PLACEHOLDER.district, true);
            resetSelect(wardSelect, PLACEHOLDER.ward, true);
            clearHiddenValue("districtCodeInput");
            clearHiddenValue("wardCodeInput");

            const provinceCode = getSelectedCode(citySelect);
            if (provinceCode) {
                await loadDistricts(provinceCode);
            }
        });
    }

    if (districtSelect) {
        districtSelect.addEventListener("change", async () => {
            syncLocationCode(districtSelect, "districtCodeInput");
            resetSelect(wardSelect, PLACEHOLDER.ward, true);
            clearHiddenValue("wardCodeInput");

            const districtCode = getSelectedCode(districtSelect);
            if (districtCode) {
                await loadWards(districtCode);
            }
        });
    }

    if (wardSelect) {
        wardSelect.addEventListener("change", () => {
            syncLocationCode(wardSelect, "wardCodeInput");
        });
    }
}

async function loadProvinces(selectedName = "", selectedCode = "") {
    const citySelect = getCitySelect();
    if (!citySelect) return;

    if (!provinceLoadPromise) {
        setLoading(citySelect);
        provinceLoadPromise = fetchLocations(LOCATION_API.provinces);
    }

    try {
        const provinces = await provinceLoadPromise;
        renderOptions(citySelect, provinces, PLACEHOLDER.province, selectedName, selectedCode);
        citySelect.disabled = false;
        syncLocationCode(citySelect, "provinceCodeInput");
    } catch (error) {
        console.error(error);
        provinceLoadPromise = null;
        showSelectError(citySelect);
    }
}

async function loadDistricts(provinceCode, selectedName = "", selectedCode = "") {
    const districtSelect = getDistrictSelect();
    if (!districtSelect) return;

    setLoading(districtSelect);

    try {
        const districts = await fetchLocations(`${LOCATION_API.districts}?provinceCode=${encodeURIComponent(provinceCode)}`);
        renderOptions(districtSelect, districts, PLACEHOLDER.district, selectedName, selectedCode);
        districtSelect.disabled = false;
        syncLocationCode(districtSelect, "districtCodeInput");
    } catch (error) {
        console.error(error);
        showSelectError(districtSelect);
    }
}

async function loadWards(districtCode, selectedName = "", selectedCode = "") {
    const wardSelect = getWardSelect();
    if (!wardSelect) return;

    setLoading(wardSelect);

    try {
        const wards = await fetchLocations(`${LOCATION_API.wards}?districtCode=${encodeURIComponent(districtCode)}`);
        renderOptions(wardSelect, wards, PLACEHOLDER.ward, selectedName, selectedCode);
        wardSelect.disabled = false;
        syncLocationCode(wardSelect, "wardCodeInput");
    } catch (error) {
        console.error(error);
        showSelectError(wardSelect);
    }
}

async function fetchLocations(url) {
    const response = await fetch(url, {
        headers: {
            "Accept": "application/json"
        }
    });

    if (!response.ok) {
        throw new Error(`Không thể tải dữ liệu địa chỉ. HTTP ${response.status}`);
    }

    return response.json();
}

function renderOptions(select, items, placeholder, selectedName = "", selectedCode = "") {
    resetSelect(select, placeholder, false);

    items.forEach((item) => {
        const option = document.createElement("option");
        option.value = item.name;
        option.textContent = item.name;
        option.dataset.code = item.code;
        select.appendChild(option);
    });

    selectLocationOption(select, selectedName, selectedCode);
}

function selectLocationOption(select, selectedName = "", selectedCode = "") {
    const normalizedName = normalizeText(selectedName);
    const code = String(selectedCode || "");

    for (const option of select.options) {
        const optionCode = String(option.dataset.code || "");
        const optionName = normalizeText(option.value);
        if (code && optionCode === code) {
            option.selected = true;
            return;
        }

        if (normalizedName && (optionName === normalizedName
            || optionName.includes(normalizedName)
            || normalizedName.includes(optionName))) {
            option.selected = true;
            return;
        }
    }

    select.value = "";
}

function resetForm() {
    const form = document.querySelector(".address-form");
    if (!form) return;

    form.reset();
    form.querySelector("input[name='action']").value = "add";
    removeAddressIdInput(form);
    clearPhoneError();
    clearAllLocationCodes();

    const title = document.querySelector(".modal-header h3");
    if (title) {
        title.textContent = "Thêm địa chỉ mới";
    }

    const citySelect = getCitySelect();
    const districtSelect = getDistrictSelect();
    const wardSelect = getWardSelect();

    if (citySelect) {
        citySelect.value = "";
    }
    resetSelect(districtSelect, PLACEHOLDER.district, true);
    resetSelect(wardSelect, PLACEHOLDER.ward, true);
}

async function openEditModal(
    id,
    name,
    phone,
    city,
    provinceCode,
    district,
    districtCode,
    ward,
    wardCode,
    detail,
    isDefault
) {
    const modal = document.getElementById("addressModal");
    const form = document.querySelector(".address-form");
    if (!modal || !form) return;

    resetForm();

    const title = document.querySelector(".modal-header h3");
    if (title) {
        title.textContent = "Cập nhật địa chỉ";
    }

    form.querySelector("input[name='action']").value = "update";
    form.querySelector("input[name='name']").value = name;
    form.querySelector("input[name='phone']").value = phone;
    form.querySelector("textarea[name='detailAddress']").value = detail;
    form.querySelector("input[name='isDefault']").checked = Boolean(isDefault);
    ensureAddressIdInput(form).value = id;

    modal.classList.add("active");

    await loadProvinces(city, provinceCode);
    const selectedProvinceCode = getSelectedCode(getCitySelect()) || provinceCode;
    if (selectedProvinceCode) {
        await loadDistricts(selectedProvinceCode, district, districtCode);
    }

    const selectedDistrictCode = getSelectedCode(getDistrictSelect()) || districtCode;
    if (selectedDistrictCode) {
        await loadWards(selectedDistrictCode, ward, wardCode);
    }
}

function validateForm(event) {
    const phoneInput = document.getElementById("phoneInput");
    const phone = phoneInput.value.trim();

    if (!isValidPhone(phone)) {
        showPhoneError("Vui lòng nhập đúng số điện thoại");
        phoneInput.focus();
        event.preventDefault();
        return false;
    }

    return true;
}

function setupFormValidation() {
    const form = document.querySelector(".address-form");
    const phoneInput = document.getElementById("phoneInput");

    if (form) {
        form.addEventListener("submit", validateForm);
    }

    if (!phoneInput) return;

    phoneInput.addEventListener("input", () => {
        const value = phoneInput.value.trim();
        if (value === "") {
            clearPhoneError();
            return;
        }

        if (!isValidPhone(value)) {
            showPhoneError("Số điện thoại phải đúng định dạng (VD: 090xxxxxxx)");
        } else {
            clearPhoneError();
        }
    });

    phoneInput.addEventListener("blur", () => {
        if (phoneInput.value && !isValidPhone(phoneInput.value)) {
            showPhoneError("Số điện thoại không hợp lệ");
        }
    });
}

function isValidPhone(phone) {
    const normalized = phone.replace(/[\s.-]/g, "");
    return /^(0[35789])[0-9]{8}$/.test(normalized);
}

function showPhoneError(message) {
    const phoneInput = document.getElementById("phoneInput");
    const phoneError = document.getElementById("phoneError");
    if (!phoneInput || !phoneError) return;

    phoneError.textContent = message;
    phoneError.style.display = "block";
    phoneInput.classList.add("input-error");
}

function clearPhoneError() {
    const phoneInput = document.getElementById("phoneInput");
    const phoneError = document.getElementById("phoneError");
    if (!phoneInput || !phoneError) return;

    phoneError.textContent = "";
    phoneError.style.display = "none";
    phoneInput.classList.remove("input-error");
}

function setLoading(select) {
    resetSelect(select, PLACEHOLDER.loading, true);
}

function showSelectError(select) {
    resetSelect(select, PLACEHOLDER.error, true);
}

function resetSelect(select, placeholder, disabled) {
    if (!select) return;

    select.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = placeholder;
    select.appendChild(option);
    select.disabled = disabled;
}

function syncLocationCode(select, inputId) {
    const input = document.getElementById(inputId);
    if (!select || !input) return;

    input.value = getSelectedCode(select) || "";
}

function clearHiddenValue(inputId) {
    const input = document.getElementById(inputId);
    if (input) {
        input.value = "";
    }
}

function clearAllLocationCodes() {
    clearHiddenValue("provinceCodeInput");
    clearHiddenValue("districtCodeInput");
    clearHiddenValue("wardCodeInput");
}

function getSelectedCode(select) {
    return select?.selectedOptions?.[0]?.dataset?.code || "";
}

function ensureAddressIdInput(form) {
    let idInput = form.querySelector("input[name='id']");
    if (!idInput) {
        idInput = document.createElement("input");
        idInput.type = "hidden";
        idInput.name = "id";
        form.appendChild(idInput);
    }
    return idInput;
}

function removeAddressIdInput(form) {
    const idInput = form.querySelector("input[name='id']");
    if (idInput) {
        idInput.remove();
    }
}

function getCitySelect() {
    return document.getElementById("citySelect");
}

function getDistrictSelect() {
    return document.getElementById("districtSelect");
}

function getWardSelect() {
    return document.getElementById("wardSelect");
}

function normalizeText(value) {
    return String(value || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase()
        .trim();
}

window.openEditModal = openEditModal;
