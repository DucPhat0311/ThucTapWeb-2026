<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" scope="application" />

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${not empty requestScope.pageTitle ? requestScope.pageTitle : 'AURA Studio'}</title>

    <c:if test="${not empty requestScope.pageCss and not requestScope.pageCss.toString().isBlank()}">
        <link rel="stylesheet" href="${contextPath}/css/${requestScope.pageCss}">
    </c:if>
    <link rel="stylesheet" href="${contextPath}/css/include/header.css">
    <link rel="stylesheet" href="${contextPath}/css/include/footer.css">
    <link rel="stylesheet" href="${contextPath}/css/views/notification.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>

<body>

<header class="header" id="header">
    <div class="header-top">
        <div class="logo">
            <a href="${contextPath}/home" class="iconUser">
                <img src="${contextPath}/img/logo.png" alt="AURA Studio Logo">
            </a>
        </div>
        <div class="search-bar" style="position: relative;">
            <form action="${contextPath}/search" method="get">
                <input type="text"
                       id="headerSearchInput"
                       name="keyword"
                       value="${param.keyword}"
                       placeholder="Tìm kiếm sản phẩm..."
                       required
                       autocomplete="off">
                <button type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </form>

            <div id="searchHistoryDropdown" class="search-history-dropdown" style="display: none;"></div>
        </div>

        <div class="actions">
            <a href="${not empty sessionScope.userlogin ? contextPath.concat('/my-wishlist') : contextPath.concat('/login')}" class="iconWishlist">
                <i class="fa-regular fa-heart"></i>
            </a>

            <div class="user-menu">
                <a href="#" class="iconUser">
                    <i class="fa-regular fa-user"></i>
                    <c:if test="${not empty sessionScope.userlogin}">
                        <c:out value="${not empty sessionScope.userlogin.fullName and not sessionScope.userlogin.fullName.isBlank() ? sessionScope.userlogin.fullName : sessionScope.userlogin.username}" />
                    </c:if>
                </a>
                <ul class="user-dropdown">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userlogin}">
                            <li><a href="${contextPath}/profile">Thông tin cá nhân</a></li>
                            <li><a href="${contextPath}/order-user">Đơn hàng của tôi</a></li>
                            <li><a href="${contextPath}/logout">Đăng xuất</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${contextPath}/login">Đăng nhập</a></li>
                            <li><a href="${contextPath}/register">Đăng ký</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>

            <a href="${not empty sessionScope.userlogin ? contextPath.concat('/my-cart') : contextPath.concat('/login')}" class="iconCart">
                <i class="fa-solid fa-cart-shopping"></i>
                <span class="cart-count" id="cartCountBadge"
                      style="display: ${not empty sessionScope.userlogin and sessionScope.cartSize > 0 ? 'inline-block' : 'none'};">
                    ${not empty sessionScope.cartSize ? sessionScope.cartSize : 0}
                </span>
            </a>

            <div class="notification-wrapper">
                <p id="thongBao" class="iconNotification">
                    <i class="fa-regular fa-bell"></i>
                    <c:if test="${not empty sessionScope.userlogin and requestScope.unreadNotifCount > 0}">
                        <span class="notification-badge" id="notificationBadge" data-count="${requestScope.unreadNotifCount}">${requestScope.unreadNotifCount}</span>
                    </c:if>
                </p>

                <div id="notification-box">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userlogin}">
                            <div class="notification-header">
                                <span>Thông báo</span>
                                <button type="button" id="closeNotifBoxBtn" class="close-btn" aria-label="Close">×</button>
                            </div>
                            <ul>
                                <c:choose>
                                    <c:when test="${not empty requestScope.notes}">
                                        <c:forEach var="n" items="${requestScope.notes}">
                                            <li class="notification-item ${n.isRead()}">
                                                <a class="notif-link"
                                                   href="${not empty n.url and not n.url.isBlank() ? n.url : '#'}"
                                                   data-id="${n.id}"
                                                   style="text-decoration: none; color: inherit; display: block; width: 100%;">
                                                    <div class="notif-title">${n.title}</div>
                                                    <div class="notif-message">${n.message}</div>
                                                </a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="empty-message">Hiện không có thông báo nào.</li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>

                            <div class="notification-footer">
                                <a href="${contextPath}/my-notifications">
                                    Xem tất cả thông báo
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <ul>
                                <li class="empty-message">Hiện không có thông báo nào.</li>
                                <li class="empty-message">Đăng nhập để được nhận thêm nhiều ưu đãi.</li>
                            </ul>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <nav class="header-bottom">
        <div class="menu">
            <ul>
                <li>
                    <a href="${contextPath}/home"
                       class="${pageContext.request.requestURI.contains('/home') ? 'active' : ''}">Trang chủ</a>
                </li>
                <li>
                    <a href="${contextPath}/product"
                       class="${pageContext.request.requestURI.contains('/product') ? 'active' : ''}">Danh mục</a>
                </li>
                <li>
                    <a href="${contextPath}/blog"
                       class="${pageContext.request.requestURI.contains('/blog') ? 'active' : ''}">Bài viết</a>
                </li>
                <li>
                    <a href="${contextPath}/contact"
                       class="${pageContext.request.requestURI.contains('/contact') ? 'active' : ''}">Liên hệ</a>
                </li>
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
    (function () {
        var searchInput = document.getElementById("headerSearchInput");
        var historyDropdown = document.getElementById("searchHistoryDropdown");
        if (!searchInput || !historyDropdown) return;
        var contextPath = "${contextPath}";
        var apiUrl = contextPath + "/search-history";

        function checkAndShowHistory() {
            if (searchInput.value.trim() !== "") {
                historyDropdown.style.display = "none";
                return;
            }

            fetch(apiUrl)
                .then(function (response) {
                    if (!response.ok) throw new Error("Chưa đăng nhập hoặc lỗi hệ thống");
                    return response.json();
                })
                .then(function (data) {
                    if (data && data.length > 0) {
                        historyDropdown.innerHTML = "";

                        data.forEach(function (keyword) {
                            var item = document.createElement("div");
                            item.className = "history-item";
                            item.style.display = "flex";
                            item.style.alignItems = "center";
                            item.style.padding = "10px 15px";
                            item.style.cursor = "pointer";

                            item.innerHTML =
                                '<i class="fa-solid fa-clock-rotate-left" style="color: #999; margin-right: 12px; font-size: 0.9rem;"></i>' +
                                '<span style="color: #333; font-size: 0.95rem;">' + keyword + '</span>';

                            item.addEventListener("mousedown", function (e) {
                                e.preventDefault();
                                window.location.href = contextPath + "/search?keyword=" + encodeURIComponent(keyword);
                            });

                            historyDropdown.appendChild(item);
                        });
                        historyDropdown.style.display = "block";
                    } else {
                        historyDropdown.style.display = "none";
                    }
                })
                .catch(function (error) {
                    historyDropdown.style.display = "none";
                });
        }

        searchInput.addEventListener("focus", checkAndShowHistory);
        searchInput.addEventListener("input", checkAndShowHistory);

        document.addEventListener("click", function (event) {
            if (!searchInput.contains(event.target) && !historyDropdown.contains(event.target)) {
                historyDropdown.style.display = "none";
            }
        });
    })();

    (function () {
        var bell = document.getElementById('thongBao');
        var box = document.getElementById('notification-box');
        var closeBtn = document.getElementById('closeNotifBoxBtn');

        if (!bell || !box) return;
        bell.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();
            box.classList.toggle('active');
        });

        if (closeBtn) {
            closeBtn.addEventListener('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                box.classList.remove('active');
            });
        }

        document.addEventListener('click', function (e) {
            if (!bell.contains(e.target) && !box.contains(e.target)) {
                box.classList.remove('active');
            }
        });
    })();
</script>
</body>
</html>