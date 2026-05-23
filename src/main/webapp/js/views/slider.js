document.addEventListener("DOMContentLoaded", () => {

    const slider = document.querySelector('.img-slides');
    const slides = document.querySelectorAll('.slide');

    const bannerPrevBtn = document.querySelector('.banner .prev');
    const bannerNextBtn = document.querySelector('.banner .next');

    if (slider && slides.length > 0) {
        let currentIndex = 0;
        const totalSlides = slides.length;

        function updateSlider() {
            const offset = -currentIndex * 100;
            slider.style.transform = `translateX(${offset}%)`;
        }

        if (bannerNextBtn) {
            bannerNextBtn.addEventListener('click', () => {
                currentIndex = (currentIndex + 1) % totalSlides;
                updateSlider();
            });
        }

        if (bannerPrevBtn) {
            bannerPrevBtn.addEventListener('click', () => {
                currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
                updateSlider();
            });
        }

        setInterval(() => {
            currentIndex = (currentIndex + 1) % totalSlides;
            updateSlider();
        }, 6000);
    }

    const sliderWrappers = document.querySelectorAll(".slider-wrapper");

    sliderWrappers.forEach(wrapper => {
        const track = wrapper.querySelector(".product-list, .category-products");
        const prevBtn = wrapper.querySelector(".prev");
        const nextBtn = wrapper.querySelector(".next");

        if (track && prevBtn && nextBtn) {
            const scrollStep = 320;

            const handleButtonState = () => {
                const maxScroll = Math.ceil(track.scrollWidth - track.clientWidth);
                const currentScroll = Math.ceil(track.scrollLeft);

                if (currentScroll <= 5) {
                    prevBtn.style.pointerEvents = "none";
                    prevBtn.style.background = "rgba(220, 220, 220, 0.6)";
                    prevBtn.style.color = "#aaa";
                    prevBtn.style.borderColor = "transparent";
                } else {
                    prevBtn.style.pointerEvents = "auto";
                    prevBtn.style.background = "";
                    prevBtn.style.color = "";
                    prevBtn.style.borderColor = "";
                }

                if (maxScroll <= 0 || currentScroll >= maxScroll - 5) {
                    nextBtn.style.pointerEvents = "none";
                    nextBtn.style.background = "rgba(220, 220, 220, 0.6)";
                    nextBtn.style.color = "#aaa";
                    nextBtn.style.borderColor = "transparent";
                } else {
                    nextBtn.style.pointerEvents = "auto";
                    nextBtn.style.background = "";
                    nextBtn.style.color = "";
                    nextBtn.style.borderColor = "";
                }
            };

            nextBtn.addEventListener("click", () => {
                track.scrollBy({ left: scrollStep, behavior: "smooth" });
            });

            prevBtn.addEventListener("click", () => {
                track.scrollBy({ left: -scrollStep, behavior: "smooth" });
            });

            track.addEventListener("scroll", handleButtonState);
            window.addEventListener("resize", handleButtonState);

            setTimeout(handleButtonState, 100);
        }
    });

});