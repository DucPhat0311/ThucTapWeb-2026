function openDeleteModal(id, title) {
        document.getElementById("deleteBlogId").value = id;
        document.getElementById("deleteMessage").innerHTML = 
            'Bạn có chắc muốn xóa tin tức "<b>' + title + '</b>" không?';
        document.getElementById("deleteModal").style.display = "flex";
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    function openConfirmModal(userId) {
        document.getElementById("confirmUserId").value = userId;
        document.getElementById("confirmModal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("confirmModal").style.display = "none";
    }