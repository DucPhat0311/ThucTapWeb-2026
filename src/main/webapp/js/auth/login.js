(function () {
    function setFieldError(input, errorEl, message) {
        if (!input || !errorEl) return;

        if (message) {
            errorEl.textContent = message;
            errorEl.classList.remove("is-hidden");
            input.classList.add("input-invalid");
            input.setAttribute("aria-invalid", "true");
            input.setAttribute("aria-describedby", errorEl.id);
            return;
        }

        errorEl.textContent = "";
        errorEl.classList.add("is-hidden");
        input.classList.remove("input-invalid");
        input.removeAttribute("aria-invalid");
        input.removeAttribute("aria-describedby");
    }

    function bindLoginValidation() {
        var form = document.getElementById("loginForm");
        if (!form) return;

        var usernameInput = document.getElementById("username");
        var passwordInput = document.getElementById("password");
        var usernameError = document.getElementById("usernameError");
        var passwordError = document.getElementById("passwordError");

        function validate() {
            var isValid = true;
            var username = usernameInput ? usernameInput.value.trim() : "";
            var password = passwordInput ? passwordInput.value.trim() : "";

            if (!username) {
                setFieldError(usernameInput, usernameError, "Vui lòng nhập email hoặc tên đăng nhập.");
                isValid = false;
            } else {
                setFieldError(usernameInput, usernameError, "");
            }

            if (!password) {
                setFieldError(passwordInput, passwordError, "Vui lòng nhập mật khẩu.");
                isValid = false;
            } else {
                setFieldError(passwordInput, passwordError, "");
            }

            return isValid;
        }

        if (usernameInput) {
            usernameInput.addEventListener("input", function () {
                if (usernameInput.value.trim()) {
                    setFieldError(usernameInput, usernameError, "");
                }
            });
        }

        if (passwordInput) {
            passwordInput.addEventListener("input", function () {
                if (passwordInput.value.trim()) {
                    setFieldError(passwordInput, passwordError, "");
                }
            });
        }

        form.addEventListener("submit", function (event) {
            if (validate()) return;

            event.preventDefault();
        });
    }

    if (document.readyState === "loading") {
        document.addEventListener("DOMContentLoaded", bindLoginValidation);
    } else {
        bindLoginValidation();
    }
})();
