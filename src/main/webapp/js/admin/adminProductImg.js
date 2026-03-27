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
    }


