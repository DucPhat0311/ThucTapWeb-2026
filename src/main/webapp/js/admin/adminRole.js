document.addEventListener('DOMContentLoaded', function () {
    // Không cần xử lý gì thêm khi load
});

// ====== Modal: Tạo Role ======
function openCreateModal() {
    document.getElementById('roleModalTitle').textContent = 'Thêm vai trò';
    document.getElementById('roleFormAction').value = 'create';
    document.getElementById('roleFormId').value = '';
    document.getElementById('roleFormName').value = '';
    document.getElementById('roleFormDesc').value = '';
    document.getElementById('roleFormSubmitBtn').textContent = 'Tạo';
    document.getElementById('roleModal').classList.add('show');
}

// ====== Modal: Sửa Role ======
function openEditModal(id, name, desc) {
    document.getElementById('roleModalTitle').textContent = 'Sửa vai trò';
    document.getElementById('roleFormAction').value = 'update';
    document.getElementById('roleFormId').value = id;
    document.getElementById('roleFormName').value = name;
    document.getElementById('roleFormDesc').value = desc || '';
    document.getElementById('roleFormSubmitBtn').textContent = 'Cập nhật';
    document.getElementById('roleModal').classList.add('show');
}

function closeRoleModal() {
    document.getElementById('roleModal').classList.remove('show');
}

// ====== Modal: Xoá Role ======
function openDeleteModal(id, name) {
    document.getElementById('deleteRoleId').value = id;
    document.getElementById('deleteRoleName').textContent = name;
    document.getElementById('deleteModal').classList.add('show');
}

function closeDeleteModal() {
    document.getElementById('deleteModal').classList.remove('show');
}

// ====== Toggle tất cả checkbox 1 hàng (module) ======
function toggleRow(module, checked) {
    const checkboxes = document.querySelectorAll(
        'input[type="checkbox"][data-module="' + module + '"]'
    );
    checkboxes.forEach(function (cb) {
        if (!cb.disabled) {
            cb.checked = checked;
        }
    });
}

// ====== Toggle tất cả checkbox 1 cột (action) ======
function toggleColumn(action, checked) {
    const checkboxes = document.querySelectorAll(
        'input[type="checkbox"][data-action="' + action + '"]'
    );
    checkboxes.forEach(function (cb) {
        if (!cb.disabled) {
            cb.checked = checked;
        }
    });
}

// ====== Đóng modal khi click ngoài ======
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('show');
    }
});
