const APP_CONTEXT_PATH = (window.APP_CONTEXT_PATH || "").replace(/\/$/, "");

const LOCATION_API = {
    provinces: APP_CONTEXT_PATH + "/api/locations/provinces",
    districts: APP_CONTEXT_PATH + "/api/locations/districts",
    wards: APP_CONTEXT_PATH + "/api/locations/wards"
};

function initAddressPage() {
    setupModalEvents();
    setupLocationEvents();
    setupFormValidation();
    loadProvinces();
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initAddressPage);
} else {
    initAddressPage();
}

function setupModalEvents() {
    const modal = document.getElementById("addressModal");
    const btnOpen = document.getElementById("btnOpenModal");
    const btnClose = document.getElementById("btnCloseModal");
    const btnCancel = document.getElementById("btnCancelModal");

    if (btnOpen) {
        btnOpen.addEventListener("click", async () => {
            await resetAddressFormForCreate();
            modal.classList.add("active");
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
    const citySelect = document.getElementById("citySelect");
    const districtSelect = document.getElementById("districtSelect");

    if (citySelect) {
        citySelect.addEventListener("change", async () => {
            syncSelectedLocationCode("citySelect", "provinceCodeInput");
            clearLocationCode("districtCodeInput");
            clearLocationCode("wardCodeInput");
            await loadDistrictsForSelectedCity();
        });
    }

    if (districtSelect) {
        districtSelect.addEventListener("change", async () => {
            syncSelectedLocationCode("districtSelect", "districtCodeInput");
            clearLocationCode("wardCodeInput");
            await loadWardsForSelectedDistrict();
        });
    }

    const wardSelect = document.getElementById("wardSelect");
    if (wardSelect) {
        wardSelect.addEventListener("change", () => {
            syncSelectedLocationCode("wardSelect", "wardCodeInput");
        });
    }
}

function setupFormValidation() {
    const form = document.querySelector(".address-form");
    const phoneInput = document.getElementById("phoneInput");
    const phoneError = document.getElementById("phoneError");

    if (form) {
        form.addEventListener("submit", (event) => {
            if (!validatePhoneField(phoneInput, phoneError)) {
                event.preventDefault();
            }
        });
    }

    if (phoneInput && phoneError) {
        phoneInput.addEventListener("input", () => {
            if (phoneInput.value.trim() === "") {
                hidePhoneError(phoneInput, phoneError);
                return;
            }

            if (!isValidPhone(phoneInput.value.trim())) {
                showPhoneError(phoneInput, phoneError, "Số điện thoại phải đúng định dạng (VD: 090xxxxxxx)");
            } else {
                hidePhoneError(phoneInput, phoneError);
            }
        });

        phoneInput.addEventListener("blur", () => {
            if (phoneInput.value.trim() && !isValidPhone(phoneInput.value.trim())) {
                showPhoneError(phoneInput, phoneError, "Số điện thoại không hợp lệ");
            }
        });
    }
}

async function loadProvinces(selectedName) {
    const citySelect = document.getElementById("citySelect");
    if (!citySelect) {
        return;
    }

    setLoadingState(citySelect, "Đang tải Tỉnh / Thành phố...");

    try {
        const provinces = await fetchLocations(LOCATION_API.provinces);
        renderOptions(citySelect, provinces, "-- Chọn --");

        if (selectedName) {
            selectOptionByName(citySelect, selectedName);
            syncSelectedLocationCode("citySelect", "provinceCodeInput");
        }
    } catch (error) {
        setErrorState(citySelect, "Không tải được danh sách tỉnh/thành");
    }
}

async function loadDistrictsForSelectedCity(selectedDistrictName) {
    const citySelect = document.getElementById("citySelect");
    const districtSelect = document.getElementById("districtSelect");
    const wardSelect = document.getElementById("wardSelect");

    resetSelect(districtSelect, "-- Chọn Quận / Huyện --", true);
    resetSelect(wardSelect, "-- Chọn Phường / Xã --", true);

    const selectedCityOption = citySelect.options[citySelect.selectedIndex];
    const provinceCode = selectedCityOption ? selectedCityOption.dataset.code : "";

    if (!provinceCode) {
        return;
    }

    setLoadingState(districtSelect, "Đang tải Quận / Huyện...");

    try {
        const districts = await fetchLocations(LOCATION_API.districts + "?provinceCode=" + encodeURIComponent(provinceCode));
        renderOptions(districtSelect, districts, "-- Chọn Quận / Huyện --");

        if (selectedDistrictName) {
            selectOptionByName(districtSelect, selectedDistrictName);
            syncSelectedLocationCode("districtSelect", "districtCodeInput");
        }
    } catch (error) {
        setErrorState(districtSelect, "Không tải được quận/huyện");
    }
}

async function loadWardsForSelectedDistrict(selectedWardName) {
    const districtSelect = document.getElementById("districtSelect");
    const wardSelect = document.getElementById("wardSelect");

    resetSelect(wardSelect, "-- Chọn Phường / Xã --", true);

    const selectedDistrictOption = districtSelect.options[districtSelect.selectedIndex];
    const districtCode = selectedDistrictOption ? selectedDistrictOption.dataset.code : "";

    if (!districtCode) {
        return;
    }

    setLoadingState(wardSelect, "Đang tải Phường / Xã...");

    try {
        const wards = await fetchLocations(LOCATION_API.wards + "?districtCode=" + encodeURIComponent(districtCode));
        renderOptions(wardSelect, wards, "-- Chọn Phường / Xã --");

        if (selectedWardName) {
            selectOptionByName(wardSelect, selectedWardName);
            syncSelectedLocationCode("wardSelect", "wardCodeInput");
        }
    } catch (error) {
        setErrorState(wardSelect, "Không tải được phường/xã");
    }
}

async function resetAddressFormForCreate() {
    const form = document.querySelector(".address-form");
    if (!form) {
        return;
    }

    form.reset();

    const actionInput = form.querySelector("input[name='action']");
    if (actionInput) {
        actionInput.value = "add";
    }

    clearLocationCode("provinceCodeInput");
    clearLocationCode("districtCodeInput");
    clearLocationCode("wardCodeInput");

    const idInput = form.querySelector("input[name='id']");
    if (idInput) {
        idInput.remove();
    }

    const districtSelect = document.getElementById("districtSelect");
    const wardSelect = document.getElementById("wardSelect");

    resetSelect(districtSelect, "-- Chọn Quận / Huyện --", true);
    resetSelect(wardSelect, "-- Chọn Phường / Xã --", true);

    await loadProvinces();
}

async function openEditModal(
    id, name, phone, city, provinceCode, district, districtCode, ward, wardCode, detail, isDefault
) {
    const modal = document.getElementById("addressModal");
    const form = document.querySelector(".address-form");
    if (!modal || !form) {
        return;
    }

    const actionInput = form.querySelector("input[name='action']");
    if (actionInput) {
        actionInput.value = "update";
    }

    form.querySelector("input[name='name']").value = name;
    form.querySelector("input[name='phone']").value = phone;
    form.querySelector("textarea[name='detailAddress']").value = detail;
    form.querySelector("input[name='isDefault']").checked = Boolean(isDefault);

    let idInput = form.querySelector("input[name='id']");
    if (!idInput) {
        idInput = document.createElement("input");
        idInput.type = "hidden";
        idInput.name = "id";
        form.appendChild(idInput);
    }
    idInput.value = id;

    await loadProvinces(city);
    preferLocationCode("citySelect", "provinceCodeInput", provinceCode);

    await loadDistrictsForSelectedCity(district);
    preferLocationCode("districtSelect", "districtCodeInput", districtCode);

    await loadWardsForSelectedDistrict(ward);
    preferLocationCode("wardSelect", "wardCodeInput", wardCode);

    modal.classList.add("active");
}

window.openEditModal = openEditModal;

async function fetchLocations(url) {
    const response = await fetch(url, {
        method: "GET",
        headers: {
            "Accept": "application/json"
        }
    });

    if (!response.ok) {
        throw new Error("HTTP " + response.status);
    }

    return await response.json();
}

function renderOptions(selectElement, items, placeholder) {
    if (!selectElement) {
        return;
    }

    selectElement.innerHTML = "";

    const firstOption = document.createElement("option");
    firstOption.value = "";
    firstOption.textContent = placeholder;
    selectElement.appendChild(firstOption);

    items.forEach((item) => {
        const option = document.createElement("option");
        option.value = item.name;
        option.textContent = item.name;
        option.dataset.code = String(item.code);
        selectElement.appendChild(option);
    });

    if (!items || items.length === 0) {
        setErrorState(selectElement, "Không có dữ liệu");
        return;
    }

    selectElement.disabled = false;
}

function resetSelect(selectElement, placeholder, disabled) {
    if (!selectElement) {
        return;
    }

    selectElement.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = placeholder;
    selectElement.appendChild(option);
    selectElement.disabled = disabled;
}

function setLoadingState(selectElement, message) {
    if (!selectElement) {
        return;
    }

    selectElement.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = message;
    selectElement.appendChild(option);
    selectElement.disabled = true;
}

function setErrorState(selectElement, message) {
    if (!selectElement) {
        return;
    }

    selectElement.innerHTML = "";
    const option = document.createElement("option");
    option.value = "";
    option.textContent = message;
    selectElement.appendChild(option);
    selectElement.disabled = true;
}

function selectOptionByName(selectElement, targetName) {
    if (!selectElement || !targetName) {
        return;
    }

    const normalizedTarget = normalizeLocationName(targetName);

    for (let i = 0; i < selectElement.options.length; i++) {
        const option = selectElement.options[i];
        if (normalizeLocationName(option.value) === normalizedTarget) {
            selectElement.selectedIndex = i;
            return;
        }
    }

    for (let i = 0; i < selectElement.options.length; i++) {
        const option = selectElement.options[i];
        const normalizedValue = normalizeLocationName(option.value);
        if (normalizedValue.includes(normalizedTarget) || normalizedTarget.includes(normalizedValue)) {
            selectElement.selectedIndex = i;
            return;
        }
    }
}

function syncSelectedLocationCode(selectId, inputId) {
    const selectElement = document.getElementById(selectId);
    const inputElement = document.getElementById(inputId);
    if (!selectElement || !inputElement) {
        return;
    }

    const selectedOption = selectElement.options[selectElement.selectedIndex];
    inputElement.value = selectedOption && selectedOption.dataset.code ? selectedOption.dataset.code : "";
}

function clearLocationCode(inputId) {
    const inputElement = document.getElementById(inputId);
    if (inputElement) {
        inputElement.value = "";
    }
}

function preferLocationCode(selectId, inputId, code) {
    const selectElement = document.getElementById(selectId);
    const inputElement = document.getElementById(inputId);
    if (!selectElement || !inputElement || !code) {
        syncSelectedLocationCode(selectId, inputId);
        return;
    }

    const normalizedCode = String(code);
    for (let i = 0; i < selectElement.options.length; i++) {
        const option = selectElement.options[i];
        if (option.dataset.code === normalizedCode) {
            selectElement.selectedIndex = i;
            inputElement.value = normalizedCode;
            return;
        }
    }

    syncSelectedLocationCode(selectId, inputId);
}

function normalizeLocationName(value) {
    return String(value || "")
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, "")
        .toLowerCase()
        .replace(/^(tinh|thanh pho|tp|quan|huyen|thi xa|thi tran|xa|phuong)\s+/g, "")
        .replace(/\s+/g, " ")
        .trim();
}

function validatePhoneField(phoneInput, phoneError) {
    if (!phoneInput || !phoneError) {
        return true;
    }

    const phone = phoneInput.value.trim();
    if (!isValidPhone(phone)) {
        showPhoneError(phoneInput, phoneError, "Vui lòng nhập đúng số điện thoại");
        phoneInput.focus();
        return false;
    }

    hidePhoneError(phoneInput, phoneError);
    return true;
}

function isValidPhone(phone) {
    const normalized = String(phone || "").replace(/\s|\.|-/g, "");
    const regex = /^(0[3|5|7|8|9])[0-9]{8}$/;
    return regex.test(normalized);
}

function showPhoneError(phoneInput, phoneError, message) {
    phoneError.textContent = message;
    phoneError.style.display = "block";
    phoneInput.classList.add("input-error");
}

function hidePhoneError(phoneInput, phoneError) {
    phoneError.textContent = "";
    phoneError.style.display = "none";
    phoneInput.classList.remove("input-error");
}
