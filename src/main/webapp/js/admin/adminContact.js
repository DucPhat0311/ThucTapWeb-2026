function openDeleteModal(id, name) {
        document.getElementById("deleteContactId").value = id;
        document.getElementById("deleteMessage").innerHTML = 
            'Bạn có chắc muốn xóa liên hệ từ "<b>' + name + '</b>" không?';
        document.getElementById("deleteModal").style.display = "flex";
    }

    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

