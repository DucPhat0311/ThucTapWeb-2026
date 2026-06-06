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
        form.action = 'productImgAdmin';

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

function previewImage(event) {
    const newImagePreview = document.getElementById('newImagePreview');
    newImagePreview.innerHTML = '';

    const files = event.target.files;
    if (files && files.length > 0) {
        Array.from(files).forEach((file, index) => {
            const reader = new FileReader();
            reader.onload = function (e) {
                const div = document.createElement('div');
                div.style.position = 'relative';
                div.style.display = 'inline-block';
                div.style.border = '1px solid #ddd';
                div.style.padding = '5px';
                div.style.borderRadius = '8px';

                const img = document.createElement('img');
                img.src = e.target.result;
                img.style.width = '120px';
                img.style.height = '120px';
                img.style.objectFit = 'cover';
                img.style.borderRadius = '4px';
                img.style.display = 'block';

                const radioDiv = document.createElement('div');
                radioDiv.style.textAlign = 'center';
                radioDiv.style.marginTop = '8px';

                const radio = document.createElement('input');
                radio.type = 'radio';
                radio.name = 'mainImageIndex';
                radio.value = index;
                radio.style.cursor = 'pointer';
                
                radio.onclick = function() {
                    if (this.previousChecked) {
                        this.checked = false;
                        this.previousChecked = false;
                    } else {
                        document.getElementsByName('mainImageIndex').forEach(r => r.previousChecked = false);
                        this.previousChecked = true;
                    }
                };

                const label = document.createElement('label');
                label.innerText = ' Ảnh chính';
                label.style.fontSize = '13px';
                label.style.cursor = 'pointer';
                label.style.marginLeft = '4px';

                radio.id = 'radio_main_img_' + index;
                label.setAttribute('for', radio.id);

                radioDiv.appendChild(radio);
                radioDiv.appendChild(label);

                div.appendChild(img);
                div.appendChild(radioDiv);
                newImagePreview.appendChild(div);
            }
            reader.readAsDataURL(file);
        });
    }
}



