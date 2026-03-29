    function openDeleteModal(id, title) {
        document.getElementById("deleteBannerId").value = id;
        document.getElementById("deleteMessage").innerHTML =
            'Bạn có chắc muốn xóa banner "<b>' + title + '</b>" không?';
        document.getElementById("deleteModal").style.display = "flex";
    }
    function closeDeleteModal() {
        document.getElementById("deleteModal").style.display = "none";
    }
    function openLockModal(id, title, action) {
        document.getElementById("lockBannerId").value = id;
        document.getElementById("lockAction").value = action;
        if(action === 'lock') {
            document.getElementById("lockModalTitle").innerText = "Xác nhận khóa";
            document.getElementById("lockMessage").innerHTML = 'Bạn có chắc muốn <b>khóa</b> banner "<b>' + title + '</b>" không?';
            document.getElementById("lockSubmitBtn").innerText = "Khóa";
        } else {
            document.getElementById("lockModalTitle").innerText = "Xác nhận mở khóa";
            document.getElementById("lockMessage").innerHTML = 'Bạn có chắc muốn <b>mở khóa</b> banner "<b>' + title + '</b>" không?';
            document.getElementById("lockSubmitBtn").innerText = "Mở khóa";
        }
        document.getElementById("lockModal").style.display = "flex";
    }
    function closeLockModal() {
        document.getElementById("lockModal").style.display = "none";
    }

