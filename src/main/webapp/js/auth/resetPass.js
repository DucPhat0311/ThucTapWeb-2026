const passwordInput = document.getElementById("password");
const confirmInput = document.getElementById("confirmPassword");
const submitBtn = document.getElementById("submitBtn");
const matchError = document.getElementById("match-error");

const rules = {
    lower: document.getElementById("rule-lower"),
    upper: document.getElementById("rule-upper"),
    length: document.getElementById("rule-length"),
    digit: document.getElementById("rule-digit"),
    special: document.getElementById("rule-special"),
};

function validateAll() {
    const value = passwordInput.value;
    const confirmValue = confirmInput.value;

    const checks = {
        lower: /[a-z]/.test(value),
        upper: /[A-Z]/.test(value),
        digit: /\d/.test(value),
        special: /[^A-Za-z0-9]/.test(value),
        length: value.length >= 8 && value.length <= 16,
    };

    let allValid = true;
    for (let key in checks) {
        if (checks[key]) {
            rules[key].classList.add("valid");
            rules[key].classList.remove("invalid");
        } else {
            rules[key].classList.add("invalid");
            rules[key].classList.remove("valid");
            allValid = false;
        }
    }

    let match = value && confirmValue && value === confirmValue;
    if (!match && confirmValue.length > 0) {
        matchError.style.display = "block";
    } else {
        matchError.style.display = "none";
    }

    submitBtn.disabled = !(allValid && match);
}

passwordInput.addEventListener("input", validateAll);
confirmInput.addEventListener("input", validateAll);

document.querySelectorAll('.toggle-password').forEach(function(btn) {
    btn.addEventListener('click', function() {
        const targetId = btn.getAttribute('data-target');
        const input = document.getElementById(targetId);
        if (input.type === "password") {
            input.type = "text";
            btn.innerHTML = '<i class="fa-solid fa-eye-slash" style="color:#7c5a3a;font-size:20px;"></i>';
        } else {
            input.type = "password";
            btn.innerHTML = '<i class="fa-solid fa-eye" style="color:#7c5a3a;font-size:20px;"></i>';
        }
    });
});
