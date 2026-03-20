<header class="header" id="header">

    <div class="header-top">
        <div class="logo">
            <img src="img/logo.png" alt="AURA Studio Logo">
        </div>

        <!-- SEARCH -->
        <div class="search-bar">
            <form action="#" method="get">
                <input type="text" name="keyword" placeholder="Tìm kiếm sản phẩm..." required />
                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>

        <!-- ACTIONS -->
        <div class="actions">

            <!-- CHƯA Login -->
            <div class="user-menu">
                <a href="#" class="iconUser">
                    <i class="fa-regular fa-user"></i>
                </a>
                <ul class="user-dropdown">
                    <li><a href="login.jsp">Đăng nhập</a></li>
                    <li><a href="register.jsp">Đăng ký</a></li>
                </ul>
            </div>

            <!-- CART -->
            <a href="login.jsp" class="iconCart">
                <i class="fa-solid fa-cart-shopping"></i>
            </a>

            <!-- NOTIFICATION -->
            <div class="notification-wrapper">
                <p id="thongBao" class="iconNotification">
                    <i class="fa-regular fa-bell"></i>
                </p>

                <div id="notification-box">
                    <ul>
                        <li>Hiện không có thông báo nào.</li>
                        <li>Đăng nhập để được nhận thêm nhiều ưu đãi.</li>
                    </ul>
                </div>
            </div>

        </div>
    </div>

    <!-- MENU -->
    <nav class="header-bottom">
        <div class="menu">
            <ul>
                <li><a href="home.jsp">Trang chủ</a></li>

                <li>
                    <a href="product.jsp">Danh Mục ▾</a>
                    <ul class="sub">
                        <li class="subItem"><a>Thời trang Nam</a></li>
                        <li class="subItem"><a>Thời trang Nữ</a></li>
                        <li class="subItem"><a>Phụ kiện</a></li>
                    </ul>
                </li>

                <li><a href="news.jsp">Bài viết</a></li>
                <li><a href="sales.jsp">Khuyến mãi</a></li>
                <li><a href="contact.jsp">Liên hệ</a></li>
            </ul>
        </div>
    </nav>

</header>