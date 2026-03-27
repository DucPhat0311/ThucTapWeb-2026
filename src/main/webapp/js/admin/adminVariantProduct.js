function openDeleteModal(id, name) {
        document.getElementById("deleteVariantId").value = id;
        document.getElementById("deleteMessage").innerHTML =
            'Bạn có chắc muốn xóa biến thể <b>' + name + '</b> không?';
        document.getElementById("deleteModal").classList.add("show");
    }
    
    function closeDeleteModal() {
        document.getElementById("deleteModal").classList.remove("show");
    }

