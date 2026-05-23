var originalValues = {};

window.addEventListener("load", function () {
    saveOriginalValues();
    setupEvents();
});

function setupEvents() {
    var btnEdit = document.getElementById("btn-edit-profile");
    var btnCancel = document.getElementById("btn-cancel-profile");

    if (btnEdit) {
        btnEdit.onclick = enableEditMode;
    }
    if (btnCancel) {
        btnCancel.onclick = cancelEdit;
    }

    setupProfileValidation();
    setupAvatarUpload();
}

function setupProfileValidation() {
    var profileForm = document.querySelector(".profile-form");
    if (!profileForm) {
        return;
    }

    profileForm.addEventListener("submit", function (event) {
        var phoneInput = document.getElementById("phone");
        if (!phoneInput) {
            return;
        }

        var normalizedPhone = phoneInput.value.trim().replace(/[\s.-]/g, "");
        var validPhone = normalizedPhone === "" || /^0[35789][0-9]{8}$/.test(normalizedPhone);
        if (!validPhone) {
            event.preventDefault();
            phoneInput.setCustomValidity("Vui lòng nhập số di động Việt Nam gồm 10 chữ số, bắt đầu bằng 03, 05, 07, 08 hoặc 09.");
            phoneInput.reportValidity();
            return;
        }

        phoneInput.value = normalizedPhone;
        phoneInput.setCustomValidity("");
    });
}

function setupAvatarUpload() {
    var btnChangeAvatar = document.getElementById("btn-change-avatar");
    var avatarFileInput = document.getElementById("avatarFileInput");
    var avatarForm = document.getElementById("avatar-form");

    if (!btnChangeAvatar || !avatarFileInput || !avatarForm) {
        return;
    }

    btnChangeAvatar.onclick = function () {
        avatarFileInput.click();
    };

    avatarFileInput.onchange = function () {
        if (!avatarFileInput.files || avatarFileInput.files.length === 0) {
            return;
        }
        avatarForm.submit();
    };
}

function enableEditMode() {
    toggleInputs(false);

    document.getElementById("btn-edit-profile").style.display = "none";
    document.getElementById("btn-save-profile").style.display = "inline-block";
    document.getElementById("btn-cancel-profile").style.display = "inline-block";
}

function disableEditMode() {
    toggleInputs(true);

    document.getElementById("btn-edit-profile").style.display = "inline-block";
    document.getElementById("btn-save-profile").style.display = "none";
    document.getElementById("btn-cancel-profile").style.display = "none";
}

function toggleInputs(disabled) {
    var ids = ["fullname", "phone", "email", "birthdayDisplay"];
    ids.forEach(function (id) {
        var el = document.getElementById(id);
        if (el) {
            el.disabled = disabled;
        }
    });

    var genders = Array.from(document.getElementsByName("gender"));
    genders.forEach(function (genderInput) {
        genderInput.disabled = disabled;
    });
}

function saveOriginalValues() {
    var selectedGender = document.querySelector("input[name='gender']:checked");

    originalValues = {
        fullname: document.getElementById("fullname") ? document.getElementById("fullname").value : "",
        phone: document.getElementById("phone") ? document.getElementById("phone").value : "",
        email: document.getElementById("email") ? document.getElementById("email").value : "",
        birthday: document.getElementById("birthdayDisplay") ? document.getElementById("birthdayDisplay").value : "",
        gender: selectedGender ? selectedGender.value : ""
    };
}

function cancelEdit() {
    document.getElementById("fullname").value = originalValues.fullname;
    document.getElementById("phone").value = originalValues.phone;
    document.getElementById("email").value = originalValues.email;
    document.getElementById("birthdayDisplay").value = originalValues.birthday;

    var genders = Array.from(document.getElementsByName("gender"));
    genders.forEach(function (genderInput) {
        genderInput.checked = genderInput.value === originalValues.gender;
    });

    disableEditMode();
}

function syncBirthday() {
    var birthdayDisplay = document.getElementById("birthdayDisplay");
    if (!birthdayDisplay || !birthdayDisplay.value) {
        return;
    }

    var parts = birthdayDisplay.value.includes("/") ? birthdayDisplay.value.split("/") : birthdayDisplay.value.split("-");
    if (parts.length !== 3) {
        return;
    }

    var day = parts[0].padStart(2, "0");
    var month = parts[1].padStart(2, "0");
    var year = parts[2];

    var hiddenBirthdayInput = document.getElementById("birthday");
    if (hiddenBirthdayInput) {
        hiddenBirthdayInput.value = year + "-" + month + "-" + day;
    }
}

