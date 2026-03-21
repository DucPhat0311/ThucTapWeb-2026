<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sản phẩm - AURA Studio</title>
    <link rel="stylesheet" href="css/views/product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<section class="products">
    <h2>SẢN PHẨM</h2>

    <div class="shop-container">
        <!-- Thanh lọc sản phẩm  -->
        <aside class="sidebar">
            <div class="filter-bar">
                <div class="filter-section">
                    <h3>Sắp xếp theo</h3>
                    <div class="filter-buttons">
                        <button class="active">Mới nhất</button>
                        <button>Bán chạy</button>
                        <button>Khuyến mãi</button>
                        <div class="dropdown">
                            <button class="dropbtn">Giá <i class="fa-solid fa-caret-down"></i></button>
                            <div class="dropdown-content">
                                <a href="#">Giá thấp đến cao</a>
                                <a href="#">Giá cao đến thấp</a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="filter-section">
                    <h3>Danh mục</h3>
                    <div class="filter-buttons">
                        <button class="active">Tất cả</button>

                        <div class="dropdown">
                            <button class="dropbtn">Thời trang Nam <i class="fa-solid fa-caret-down"></i></button>
                            <div class="dropdown-content">
                                <a href="#">Tất cả</a>
                                <a href="#">Áo</a>
                                <a href="#">Quần</a>
                                <a href="#">Áo khoác</a>
                            </div>
                        </div>

                        <div class="dropdown">
                            <button class="dropbtn">Thời trang Nữ <i class="fa-solid fa-caret-down"></i></button>
                            <div class="dropdown-content">
                                <a href="#">Tất cả</a>
                                <a href="#">Áo</a>
                                <a href="#">Quần</a>
                                <a href="#">Váy / Đầm</a>
                                <a href="#">Áo khoác</a>
                            </div>
                        </div>

                        <div class="dropdown">
                            <button class="dropbtn">Phụ kiện <i class="fa-solid fa-caret-down"></i></button>
                            <div class="dropdown-content">
                                <a href="#">Phụ kiện nam</a>
                                <a href="#">Phụ kiện nữ</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Danh sách sản phẩm -->
        <div class="main-products">
            <div class="product-list">
                <div class="product-card">
                    <a href="" class="link-cover">
                        <img src="img/.jpg" alt="Áo Thun Nam">
                    </a>
                    <h3><a href="">Áo Thun Nam</a></h3>
                    <p class="price">
                        Giá: <span class="new-price">350.000đ</span>
                    </p>
                    <a href="" class="btn-add">Thêm vào giỏ hàng</a>
                </div>

                <div class="product-card">
                    <a href="" class="link-cover">
                        <img src="img/.jpg" alt="Váy Nữ">
                    </a>
                    <h3><a href="">Váy Nữ</a></h3>
                    <p class="price">
                        Giá: <span class="new-price">450.000đ</span>
                    </p>
                    <a href="" class="btn-add">Thêm vào giỏ hàng</a>
                </div>

                <div class="product-card">
                    <a href="" class="link-cover">
                        <img src="img/.jpg" alt="Quần Nam">
                    </a>
                    <h3><a href="">Quần Nam</a></h3>
                    <p class="price">
                        Giá: <span class="new-price">320.000đ</span>
                    </p>
                    <a href="" class="btn-add">Thêm vào giỏ hàng</a>
                </div>
            </div>

            <div class="load-more-container">
                <button id="load-more">Xem thêm</button>
            </div>
        </div>
    </div>
</section>

<%@include file="../include/footer.jsp"%>


</body>
</html>