document.addEventListener("DOMContentLoaded", function () {

    function initSlider(sliderSelector, wrapperSelector, itemClass) {
        const slider = document.querySelector(sliderSelector);
        if (!slider) return;
        
        const wrapper = wrapperSelector ? document.querySelector(wrapperSelector) : slider.parentElement;

        const items = slider.querySelectorAll(itemClass);
        if (items.length <= 4) return;  

        const dotsContainer = wrapper.querySelector(".dots-container");
        if (dotsContainer) {
            dotsContainer.style.display = "none";
        }


        const prevBtn = document.createElement("button");
        prevBtn.className = "slider-nav-btn prev-btn";
        prevBtn.innerHTML = '<i class="fa-solid fa-angle-left"></i>';

    
        const nextBtn = document.createElement("button");
        nextBtn.className = "slider-nav-btn next-btn";
        nextBtn.innerHTML = '<i class="fa-solid fa-angle-right"></i>';

        wrapper.style.position = "relative";
        wrapper.appendChild(prevBtn);
        wrapper.appendChild(nextBtn);

        const updateButtons = () => {
            if (slider.scrollLeft <= 0) {
                prevBtn.style.opacity = "0";
                prevBtn.style.pointerEvents = "none";
                prevBtn.style.transform = "translateY(-50%) translateX(-10px)";
            } else {
                prevBtn.style.opacity = "1";
                prevBtn.style.pointerEvents = "auto";
                prevBtn.style.transform = "translateY(-50%) translateX(0)";
            }

            if (slider.scrollLeft + slider.clientWidth >= slider.scrollWidth - 10) {
                nextBtn.style.opacity = "0";
                nextBtn.style.pointerEvents = "none";
                nextBtn.style.transform = "translateY(-50%) translateX(10px)";
            } else {
                nextBtn.style.opacity = "1";
                nextBtn.style.pointerEvents = "auto";
                nextBtn.style.transform = "translateY(-50%) translateX(0)";
            }
        };

        const scrollAmount = items[0].offsetWidth * 2 + 40; 

        prevBtn.addEventListener("click", () => {
            slider.scrollBy({ left: -scrollAmount, behavior: "smooth" });       
        });

        nextBtn.addEventListener("click", () => {
            slider.scrollBy({ left: scrollAmount, behavior: "smooth" });        
        });

        slider.addEventListener("scroll", updateButtons);
        window.addEventListener("resize", updateButtons);


        setTimeout(updateButtons, 100);
    }


    initSlider("#new-slider", null, ".product-card");
    

    const categorySliders = document.querySelectorAll(".category-products");
    categorySliders.forEach(slider => {
        if(slider.id && slider.id.startsWith("cat-slider-")) {
            initSlider("#" + slider.id, null, ".product-mini");
        }
    });
});
