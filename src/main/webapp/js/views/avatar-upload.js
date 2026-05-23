(function () {
    function initAvatarUploadForms() {
        var forms = document.querySelectorAll(".avatar-upload-form");
        forms.forEach(function (form) {
            var fileInput = form.querySelector(".js-avatar-input");
            var triggerButton = form.querySelector(".js-avatar-trigger");

            if (!fileInput || !triggerButton) {
                return;
            }

            triggerButton.addEventListener("click", function () {
                fileInput.click();
            });

            fileInput.addEventListener("change", function () {
                if (!fileInput.files || fileInput.files.length === 0) {
                    return;
                }
                form.submit();
            });
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", initAvatarUploadForms);
        return;
    }

    initAvatarUploadForms();
})();
