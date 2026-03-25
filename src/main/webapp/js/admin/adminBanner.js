function openDeleteModal(id, title) {
        document.getElementById("deleteBannerId").value = id;
        document.getElementById("deleteMessage").innerHTML = 
            'Bạn có chắc muốn xóa banner "<b>' + title + '</b>" không?';
        document.getElementById("deleteModal").style.display = "flex";
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    function closeModal() {
        document.getElementById("confirmModal").style.display = "none";
    }

