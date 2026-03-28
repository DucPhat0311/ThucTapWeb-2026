<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <title>${pageTitle != null ? pageTitle : "AURA Studio"}</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>

<body><header class="header" id="header">

    <div class="header-top">
        <div class="logo">
            <img src="img/logo.png" alt="AURA Studio Logo">
        </div>

        <div class="search-bar">
            <form action="search" method="get">
                <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm sản phẩm..." required />
                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>

        <!-- ACTIONS -->
        <div class="actions">

            <c:choose>
                <c:when test="${not empty sessionScope.userlogin}">
                    <!-- ĐÃ LOGIN -->
                    <div class="user-menu">
                        <a href="#" class="iconUser">
                            <i class="fa-regular fa-user"></i>
                                ${sessionScope.userlogin.username}
                        </a>
                        <ul class="user-dropdown">
                            <li><a href="profile">Thông tin cá nhân</a></li>
                            <li><a href="order-user">Đơn hàng của tôi</a></li>
                            <li><a href="logout">Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>

                <c:otherwise>
                    <!-- CHƯA LOGIN -->
                    <div class="user-menu">
                        <a href="#" class="iconUser">
                            <i class="fa-regular fa-user"></i>
                        </a>
                        <ul class="user-dropdown">
                            <li><a href="login">Đăng nhập</a></li>
                            <li><a href="register">Đăng ký</a></li>
                        </ul>
                    </div>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${not empty sessionScope.userlogin}">
                    <a href="my-cart" class="iconCart">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <c:if test="${sessionScope.cartSize != null && sessionScope.cartSize > 0}">
                            <span class="cart-count">
                                ${sessionScope.cartSize != null ? sessionScope.cartSize : 0}
                            </span>
                        </c:if>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="iconCart">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </c:otherwise>
            </c:choose>

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
            <ul><li><a href="home">Trang chủ</a></li>

                <li>
                    <a href="product">Danh Mục ▾</a>
                    <ul class="sub">
                        <li class="subItem"><a>Thời trang Nam</a></li>
                        <li class="subItem"><a>Thời trang Nữ</a></li>
                        <li class="subItem"><a>Phụ kiện</a></li>
                    </ul>
                </li>

                <li><a href="blog">Bài viết</a></li>
                <li><a href="sales">Khuyến mãi</a></li>
                <li><a href="contact">Liên hệ</a></li>
            </ul>
        </div>
    </nav>

</header></body>