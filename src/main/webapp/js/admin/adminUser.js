function openConfirmModal(userId, textStatus, textBtn) {
    document.getElementById("confirmUserId").value = userId;
    document.getElementById("modalActionText").innerText = textBtn + " người dùng";
    
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
