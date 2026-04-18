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
            document.getElementById("lockModalTitle").innerText = "Xác nhận ẩn";
            document.getElementById("lockMessage").innerHTML = 'Bạn có chắc muốn <b>ẩn</b> banner "<b>' + title + '</b>" không?';
            document.getElementById("lockSubmitBtn").innerText = "Ẩn";
        } else {
            document.getElementById("lockModalTitle").innerText = "Xác nhận hiển thị";
            document.getElementById("lockMessage").innerHTML = 'Bạn có chắc muốn <b>hiển thị</b> banner "<b>' + title + '</b>" không?';
            document.getElementById("lockSubmitBtn").innerText = "Hiển thị";
        }
        document.getElementById("lockModal").style.display = "flex";
    }
    function closeLockModal() {
        document.getElementById("lockModal").style.display = "none";
    }

