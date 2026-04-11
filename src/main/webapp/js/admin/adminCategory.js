let currentCategoryId = null;
let currentCategoryStatus = null;

//Xem danh mục
function viewCategory(id) {
    fetch(`category-admin?action=view&id=${id}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('vc-id').textContent = data.id;
            document.getElementById('vc-name').textContent = data.name;
            document.getElementById('vc-status').textContent = data.status == 1 ? 'Đang dùng' : 'Đã khóa';
            
            document.getElementById('view-category-modal').style.display = 'flex';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Lỗi khi tải thông tin danh mục');
        });
}

//Sửa danh mục
function editCategory(id) {
    fetch(`category-admin?action=view&id=${id}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('category-action').value = 'update';
            document.getElementById('category-modal-title').textContent = 'Chỉnh sửa danh mục';
            document.getElementById('category-id').value = data.id;
            document.getElementById('category-name').value = data.name;
            
            document.getElementById('category-modal').style.display = 'flex';
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Lỗi khi tải thông tin danh mục');
        });
}

//Khóa/Mở khóa danh mục
function toggleCategoryStatus(id, name, status) {
    currentCategoryId = id;
    currentCategoryStatus = status;
    
    const action = status == 1 ? 'Khóa' : 'Mở khóa';
    document.getElementById('toggle-status-title').textContent = `${action} danh mục này?`;
    document.getElementById('toggle-status-message').textContent = `Bạn có chắc chắn muốn ${action.toLowerCase()} danh mục "${name}"?`;
    
    document.getElementById('toggle-status-modal').style.display = 'flex';
}

//Xác nhận khóa/mở khóa
function confirmToggleStatus() {
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = 'categoryAdmin';
    
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'toggle-status';
    
    const idInput = document.createElement('input');
    idInput.type = 'hidden';
    idInput.name = 'id';
    idInput.value = currentCategoryId;
    
    form.appendChild(actionInput);
    form.appendChild(idInput);
    document.body.appendChild(form);
    form.submit();
}

//Đóng modal
function closeCategoryModal() {
    document.getElementById('category-modal').style.display = 'none';
}

function closeViewCategory() {
    document.getElementById('view-category-modal').style.display = 'none';
}

function closeToggleStatusModal() {
    document.getElementById('toggle-status-modal').style.display = 'none';
    currentCategoryId = null;
    currentCategoryStatus = null;
}

//Đóng mở danh mục con
    function toggleCategoryStatusFromButton(button) {
        const id = parseInt(button.getAttribute('data-id'), 10);
        const name = button.getAttribute('data-name') || '';
        const status = parseInt(button.getAttribute('data-status'), 10);
        toggleCategoryStatus(id, name, status);
    }

    function toggleCategoryChildrenFromButton(button) {
        const parentId = parseInt(button.getAttribute('data-parent-id'), 10);
        toggleCategoryChildren(parentId, button);
    }

    function toggleCategoryChildren(parentId, button) {
        const childRows = document.querySelectorAll('tr.category-child-row[data-parent-id="' + parentId + '"]');
        if (!childRows.length) {
            return;
        }

        const isCurrentlyHidden = window.getComputedStyle(childRows[0]).display === 'none';
        childRows.forEach((row) => {
            row.style.display = isCurrentlyHidden ? 'table-row' : 'none';
        });

        button.classList.toggle('collapsed', !isCurrentlyHidden);
    }