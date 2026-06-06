function previewProductImages(event) {
    const container = document.getElementById('product-image-preview-container');
    container.innerHTML = ''; 
    
    const files = event.target.files;
    if (files) {
        Array.from(files).forEach((file, index) => {
            const reader = new FileReader();
            reader.onload = function(e) {
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
                if (index === 0) radio.checked = true;
                
                const label = document.createElement('label');
                label.innerText = ' Ảnh chính';
                label.style.fontSize = '13px';
                label.style.cursor = 'pointer';
                label.style.marginLeft = '4px';
                
                radio.id = 'radio_main_' + index;
                label.setAttribute('for', radio.id);
                
                radioDiv.appendChild(radio);
                radioDiv.appendChild(label);
                
                div.appendChild(img);
                div.appendChild(radioDiv);
                container.appendChild(div);
            }
            reader.readAsDataURL(file);
        });
    }
}

