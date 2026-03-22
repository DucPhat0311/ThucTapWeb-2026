function openConfirmModal(userId, textStatus, textBtn) {
    document.getElementById("confirmUserId").value = userId;
    document.getElementById("modalActionText").innerText = textBtn + " người dùng nầy?";
    
    if (textBtn === 'khóa') {
         document.getElementById("formActionField").value = "block";
         document.getElementById("btnConfirmSubmit").className = "btn-danger";
    } else {
         document.getElementById("formActionField").value = "unblock";
         document.getElementById("btnConfirmSubmit").className = "btn-primary"; 
    }

    document.getElementById("confirmModal").style.display = "flex";
}

function closeModal() {
    document.getElementById("confirmModal").style.display = "none";
}
