<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.Category" %>
<%@ page import="dao.user.CartDao" %>
<%@ page import="dao.user.CartItemDao" %>
<%@ page import="dao.user.CategoryDao" %>
<%@ page import="java.util.List" %>

<%
    String contextPath = request.getContextPath();
    Object pageCss = request.getAttribute("pageCss");
    Object pageTitle = request.getAttribute("pageTitle");

    User userLog = (User) session.getAttribute("userlogin");
    boolean loggedIn = userLog != null;
    String displayName = "";
    int cartSize = 0;

    if (loggedIn) {
        displayName = userLog.getFullName() != null && !userLog.getFullName().isBlank()
                ? userLog.getFullName()
                : userLog.getUsername();

        CartDao cDao = new CartDao();
        Integer cId = cDao.findCartIdByUser(userLog.getId());
        if (cId != null) {
            cartSize = new CartItemDao().countTotalQuantity(cId);
            session.setAttribute("cartSize", cartSize);
        }
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title><%= pageTitle != null ? pageTitle : "AURA Studio" %></title>

    <% if (pageCss != null && !pageCss.toString().isBlank()) { %>
        <link rel="stylesheet" href="<%= contextPath %>/css/<%= pageCss %>">
    <% } %>
    <link rel="stylesheet" href="<%= contextPath %>/css/include/header.css">
    <link rel="stylesheet" href="<%= contextPath %>/css/include/footer.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>

<body>

<header class="header" id="header">
    <div class="header-top">
        <div class="logo">
            <a href="<%= contextPath %>/home" class="iconUser">
                <img src="<%= contextPath %>/img/logo.png" alt="AURA Studio Logo">
            </a>
        </div>

        <div class="search-bar" style="position: relative;">
            <form action="<%= contextPath %>/search" method="get">
                <input type="text"
                       id="headerSearchInput"
                       name="keyword"
                       value="${param.keyword}"
                       placeholder="Tìm kiếm sản phẩm..."
                       required
                       autocomplete="off"> <button type="submit">
                <i class="fa-solid fa-magnifying-glass"></i>
            </button>
            </form>

            <div id="searchHistoryDropdown" class="search-history-dropdown" style="display: none;"></div>
        </div>

        <div class="actions">
            <a href="<%= loggedIn ? contextPath + "/my-wishlist" : contextPath + "/login" %>" class="iconWishlist">
                <i class="fa-regular fa-heart"></i>
            </a>

            <div class="user-menu">
                <a href="#" class="iconUser">
                    <i class="fa-regular fa-user"></i>
                    <%= loggedIn ? displayName : "" %>
                </a>
                <ul class="user-dropdown">
                    <% if (loggedIn) { %>
                        <li><a href="<%= contextPath %>/profile">Thông tin cá nhân</a></li>
                        <li><a href="<%= contextPath %>/order-user">Đơn hàng của tôi</a></li>
                        <li><a href="<%= contextPath %>/logout">Đăng xuất</a></li>
                    <% } else { %>
                        <li><a href="<%= contextPath %>/login">Đăng nhập</a></li>
                        <li><a href="<%= contextPath %>/register">Đăng ký</a></li>
                    <% } %>
                </ul>
            </div>

            <a href="<%= loggedIn ? contextPath + "/my-cart" : contextPath + "/login" %>" class="iconCart">
                <i class="fa-solid fa-cart-shopping"></i>
                <% if (loggedIn) { %>
                    <span class="cart-count" id="cartCountBadge"
                          style="<%= cartSize == 0 ? "display:none" : "display:inline-block" %>">
                        <%= cartSize %>
                    </span>
                <% } %>
            </a>

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
                <li><a href="<%= contextPath %>/home">Trang chủ</a></li>
                <li><a href="<%= contextPath %>/product">Danh mục ▾</a>
                    <ul class="sub">
                        <%
                            List<Category> categoryTree = new CategoryDao().getCategoryTree();
                            for (Category parentCat : categoryTree) {
                        %>
                            <li class="subItem">
                                <a href="<%= contextPath %>/product?category=<%= parentCat.getId() %>"><%= parentCat.getName() %></a>
                            </li>
                        <% } %>
                    </ul>
                </li>
                <li><a href="<%= contextPath %>/blog">Bài viết</a></li>
                <li><a href="<%= contextPath %>/sales">Khuyến mãi</a></li>
                <li><a href="<%= contextPath %>/contact">Liên hệ</a></li>
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
        var contextPath = "<%= contextPath %>";

        if (!searchInput || !historyDropdown) return;

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
                                var searchUrl = contextPath.endsWith('/') ? contextPath + "search" : contextPath + "/search";
                                window.location.href = searchUrl + "?keyword=" + encodeURIComponent(keyword);
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

</script>
