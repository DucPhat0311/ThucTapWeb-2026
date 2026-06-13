function openConfirmModal(userId, textStatus, textBtn, isSelf) {
    document.getElementById("confirmUserId").value = userId;
    document.getElementById("modalActionText").innerText = textBtn + " người dùng";

    const warningEl = document.getElementById("selfLockWarning");
    if (warningEl) {
        if (isSelf && textBtn === 'khóa') {
            warningEl.style.display = 'block';
        } else {
            warningEl.style.display = 'none';
        }
    }

    if (textBtn === 'khóa') {
         document.getElementById("formActionField").value = "block";
         document.getElementById("btnConfirmSubmit").className = "btn-danger";
    } else {
         document.getElementById("formActionField").value = "unblock";
         document.getElementById("btnConfirmSubmit").className = "btn-success";
    }

    document.getElementById("btnConfirmSubmit").innerText = textBtn.charAt(0).toUpperCase() + textBtn.slice(1);
    document.getElementById("confirmModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("confirmModal").style.display = "none";
}

function openChangePassModal(userId, username) {
    document.getElementById("changePassUserId").value = userId;
    document.getElementById("changePassUsername").innerText = username;
    document.getElementById("newPassword").value = "";
    document.getElementById("confirmNewPassword").value = "";
    document.getElementById("newPasswordError").innerText = "";
    document.getElementById("confirmNewPasswordError").innerText = "";
    document.getElementById("changePassModal").style.display = "flex";
}

function closeChangePassModal() {
    document.getElementById("changePassModal").style.display = "none";
}

function validateChangePass() {
    const newPass = document.getElementById("newPassword").value.trim();
    const confirmPass = document.getElementById("confirmNewPassword").value.trim();
    let valid = true;

    document.getElementById("newPasswordError").innerText = "";
    document.getElementById("confirmNewPasswordError").innerText = "";

    if (newPass.length < 1) {
        document.getElementById("newPasswordError").innerText = "Vui lòng nhập mật khẩu mới.";
        valid = false;
    }

    if (newPass !== confirmPass) {
        document.getElementById("confirmNewPasswordError").innerText = "Mật khẩu nhập lại không khớp.";
        valid = false;
    }

    return valid;
}
