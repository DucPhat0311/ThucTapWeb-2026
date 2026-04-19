// Lướt trái phải cho banner
document.addEventListener("DOMContentLoaded", () => {
    const slider = document.querySelector('.img-slides');
    const slides = document.querySelectorAll('.slide');
    const prevBtn = document.querySelector('.slider .prev');
    const nextBtn = document.querySelector('.slider .next');

    let currentIndex = 0;
    const totalSlides = slides.length;


    // cập nhật vị trí slider
    function updateSlider() {
        const offset = -currentIndex * 100;
        slider.style.transform = `translateX(${offset}%)`;
    }

    // Lướt sang trái
    nextBtn.addEventListener('click', () => {
        currentIndex = (currentIndex + 1) % totalSlides;
        updateSlider();
    });

    // Lướt sang phải
    prevBtn.addEventListener('click', () => {
        currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
        updateSlider();
    });

    // chuyển slide sau 5s
    setInterval(() => {
        currentIndex = (currentIndex + 1) % totalSlides;
        updateSlider();
    }, 6000);
});
