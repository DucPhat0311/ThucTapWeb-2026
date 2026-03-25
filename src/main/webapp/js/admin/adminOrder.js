function openConfirmModal(userId) {
        document.getElementById("confirmUserId").value = userId;
        document.getElementById("confirmModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("confirmModal").style.display = "none";
    }

