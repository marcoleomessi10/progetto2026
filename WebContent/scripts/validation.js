(function () {
    const rules = {
        required(value) {
            return value.trim().length > 0 ? "" : "Campo obbligatorio";
        },
        email(value) {
            return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value) ? "" : "Email non valida";
        },
        password(value) {
            return value.length >= 6 ? "" : "La password deve avere almeno 6 caratteri";
        },
        confirmPassword(value, field) {
            const form = field.closest("form");
            const password = form.querySelector("[name='password']");
            return password && value === password.value ? "" : "Le password non coincidono";
        },
        phone(value) {
            return value.trim() === "" || /^[0-9 +]{6,20}$/.test(value) ? "" : "Telefono non valido";
        },
        name(value) {
            return /^[A-Za-zÀ-ÿ' ]{2,60}$/.test(value.trim()) ? "" : "Inserisci almeno 2 lettere";
        },
        address(value) {
            return value.trim().length >= 8 ? "" : "Inserisci un indirizzo completo";
        },
        price(value) {
            return Number(value) > 0 ? "" : "Prezzo non valido";
        },
        quantity(value) {
            return Number(value) >= 0 ? "" : "Quantita non valida";
        }
    };

    function errorNode(field) {
        const form = field.closest("form");
        return form ? form.querySelector("[data-error-for='" + field.name + "']") : null;
    }

    function showError(field, message) {
        const node = errorNode(field);

        if (node) {
            node.textContent = message;
        }

        field.classList.toggle("invalid", message !== "");
    }

    async function validateField(field) {
        const ruleName = field.dataset.rule;
        let message = "";

        if (ruleName && rules[ruleName]) {
            message = rules[ruleName](field.value, field);
        }

        if (!message && field.dataset.ajaxEmail === "true" && field.value.trim() !== "") {
            const response = await fetch("AjaxServlet?type=email&email=" + encodeURIComponent(field.value));
            const data = await response.json();

            if (data.exists) {
                message = "Email gia registrata";
            }
        }

        showError(field, message);
        return message === "";
    }

    async function validateForm(form) {
        const fields = Array.from(form.querySelectorAll("[data-rule]"));
        const results = [];

        for (const field of fields) {
            results.push(await validateField(field));
        }

        return results.every(Boolean);
    }

    document.addEventListener("change", function (event) {
        if (event.target.matches("[data-rule]")) {
            validateField(event.target);
        }
    });

    document.addEventListener("submit", async function (event) {
        const form = event.target;

        if (!form.matches("[data-validate]")) {
            return;
        }

        event.preventDefault();

        if (await validateForm(form)) {
            form.submit();
        }
    });

    document.addEventListener("error", function (event) {
        const target = event.target;

        if (target.tagName === "IMG" && !target.dataset.fallbackApplied) {
            target.dataset.fallbackApplied = "true";
            target.src = "images/placeholder.svg";
        }
    }, true);

    const menuToggle = document.querySelector("[data-menu-toggle]");
    const menu = document.querySelector("[data-menu]");

    if (menuToggle && menu) {
        menuToggle.addEventListener("click", function () {
            const open = menu.classList.toggle("open");
            menuToggle.setAttribute("aria-expanded", String(open));
        });
    }

    const hero = document.querySelector("[data-hero]");
    const heroMedia = hero ? hero.querySelector(".hero-media") : null;
    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

    if (hero && heroMedia && !reducedMotion) {
        hero.addEventListener("pointermove", function (event) {
            const rect = hero.getBoundingClientRect();
            const x = (event.clientX - rect.left) / rect.width - 0.5;
            const y = (event.clientY - rect.top) / rect.height - 0.5;

            heroMedia.style.backgroundPosition =
                (50 + x * 2).toFixed(2) + "% " + (58 + y * 2).toFixed(2) + "%";
        });
    }
})();
