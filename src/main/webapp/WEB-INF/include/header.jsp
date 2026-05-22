<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="dao.user.CartDao" %>
<%@ page import="dao.user.CartItemDao" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle != null ? pageTitle : "AURA Studio"}</title>


    <c:if test="${not empty pageCss}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${pageCss}">
    </c:if>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/include/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>


<body>


<%
    if (session.getAttribute("userlogin") != null) {
        User userLog = (User) session.getAttribute("userlogin");
        CartDao cDao = new CartDao();
        Integer cId = cDao.findCartIdByUser(userLog.getId());
        if (cId != null) {
            int size = new CartItemDao().countTotalQuantity(cId);
            session.setAttribute("cartSize", size);
        }
    }
%>
<header class="header" id="header">
    <div class="header-top">
        <div class="logo">
            <a href="home" class="iconUser">
                <img src="img/logo.png" alt="AURA Studio Logo">
            </a>
        </div>


        <div class="search-bar">
            <form action="search" method="get">
                <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm sản phẩm..." required />
                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>
        </div>


        <div class="actions">


            <c:choose>
                <c:when test="${not empty sessionScope.userlogin}">
                    <div class="user-menu">
                        <a href="#" class="iconUser">
                            <i class="fa-regular fa-user"></i>
                                ${not empty sessionScope.userlogin.fullName ? sessionScope.userlogin.fullName : sessionScope.userlogin.username}
                        </a>
                        <ul class="user-dropdown">
                            <li><a href="profile">Thông tin cá nhân</a></li>
                            <li><a href="order-user">Đơn hàng của tôi</a></li>
                            <li><a href="logout">Đăng xuất</a></li>
                        </ul>
                    </div>
                </c:when>


                <c:otherwise>
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
                        <span class="cart-count" id="cartCountBadge"
                              style="${(sessionScope.cartSize == null || sessionScope.cartSize == 0) ? 'display:none' : 'display:inline-block'}">
                                ${sessionScope.cartSize != null ? sessionScope.cartSize : 0}
                        </span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="login" class="iconCart">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </a>
                </c:otherwise>
            </c:choose>


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


    <nav class="header-bottom">
        <div class="menu">
            <ul>
                <li><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
                <li><a href="product">Danh mục ▾</a>
                    <ul class="sub">
                        <jsp:useBean id="categoryDao" class="dao.user.CategoryDao" />
                        <c:set var="categoryTree" value="${categoryDao.categoryTree}" />
                        <c:forEach var="parentCat" items="${categoryTree}">
                            <li class="subItem">
                                <a href="product?category=${parentCat.id}">${parentCat.name}</a>
                            </li>
                        </c:forEach>
                    </ul>
                </li>
                <li><a href="blog">Bài viết</a></li>
                <li><a href="sales">Khuyến mãi</a></li>
                <li><a href="contact">Liên hệ</a></li>
            </ul>
        </div>
    </nav>
</header>

<div class="logout-confirm-modal" id="logoutConfirmModal" aria-hidden="true">
    <div class="logout-confirm-dialog" role="dialog" aria-modal="true" aria-labelledby="logoutConfirmTitle">
        <div class="logout-confirm-icon">
            <i class="fa-solid fa-right-from-bracket"></i>
        </div>
        <h3 id="logoutConfirmTitle">Xác nhận đăng xuất</h3>
        <p>Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại không?</p>
        <div class="logout-confirm-actions">
            <button type="button" class="logout-cancel-btn" id="logoutCancelBtn">Ở lại</button>
            <button type="button" class="logout-submit-btn" id="logoutSubmitBtn">Đăng xuất</button>
        </div>
    </div>
</div>

<script>
    (function () {
        var modal = document.getElementById("logoutConfirmModal");
        var cancelBtn = document.getElementById("logoutCancelBtn");
        var submitBtn = document.getElementById("logoutSubmitBtn");
        var logoutUrl = "";

        function isLogoutLink(link) {
            if (!link) return false;
            var href = link.getAttribute("href");
            return href && /(^|\/)logout(\?.*)?$/.test(href);
        }

        function openLogoutModal(url) {
            logoutUrl = url;
            modal.classList.add("is-open");
            modal.setAttribute("aria-hidden", "false");
        }

        function closeLogoutModal() {
            modal.classList.remove("is-open");
            modal.setAttribute("aria-hidden", "true");
            logoutUrl = "";
        }

        document.addEventListener("click", function (event) {
            var link = event.target.closest ? event.target.closest("a") : null;
            if (!isLogoutLink(link)) return;

            event.preventDefault();
            openLogoutModal(link.href);
        });

        if (cancelBtn) {
            cancelBtn.addEventListener("click", closeLogoutModal);
        }

        if (submitBtn) {
            submitBtn.addEventListener("click", function () {
                if (logoutUrl) {
                    window.location.href = logoutUrl;
                }
            });
        }

        if (modal) {
            modal.addEventListener("click", function (event) {
                if (event.target === modal) {
                    closeLogoutModal();
                }
            });
        }

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape" && modal.classList.contains("is-open")) {
                closeLogoutModal();
            }
        });
    })();
</script>




</body>
</html>

