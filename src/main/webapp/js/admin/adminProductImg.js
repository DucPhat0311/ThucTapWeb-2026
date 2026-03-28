let currentImageId = null;
    const getProductId = () => document.getElementById("globalProductId")?.value;

    function deleteImage(imageId) {
        currentImageId = imageId;
        document.getElementById('delete-modal').classList.add('show');
    }

    function closeDeleteModal() {
        document.getElementById('delete-modal').classList.remove('show');
        currentImageId = null;
    }

    function confirmDelete() {
        if (currentImageId) {
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = 'product-image-admin';

            const actionInput = document.createElement('input');
            actionInput.type = 'hidden';
            actionInput.name = 'action';
            actionInput.value = 'delete';
            form.appendChild(actionInput);

            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'id';
            idInput.value = currentImageId;
            form.appendChild(idInput);

            const productIdInput = document.createElement('input');
            productIdInput.type = 'hidden';
            productIdInput.name = 'productId';
            productIdInput.value = getProductId();
            form.appendChild(productIdInput);

            document.body.appendChild(form);
            form.submit();
        }

    function previewImage(event) {
        const file = event.target.files[0];
        const fileName = document.getElementById('fileName');
        const newImagePreview = document.getElementById('newImagePreview');
        const previewImg = document.getElementById('previewImg');

        if (file) {
            fileName.textContent = file.name;

            const reader = new FileReader();
            reader.onload = function(e) {
                previewImg.src = e.target.result;
                newImagePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            const mode = document.getElementById('formMode')?.value;
            fileName.textContent = mode === 'add' ? 'Chưa chọn file' : 'Chọn để thay đổi';
            newImagePreview.style.display = 'none';
        }
    }

}



