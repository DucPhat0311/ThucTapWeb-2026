<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/notification.css">
</head>
<body>

<%@include file="../include/header.jsp"%>

<div class="notif-container">
    <div class="notif-page-title">Thông báo của tôi</div>

    <ul class="notif-list">
        <c:if test="${not empty allNotifications}">
            <c:forEach var="n" items="${allNotifications}">
                <li class="notif-page-item ${n.isRead()}">
                    <a class="notif-link" href="${not empty n.url and not n.url.isBlank() ? n.url : '#'}" data-id="${n.id}">
                        <div class="notif-page-content">
                            <div class="notif-page-title-text">${n.title}</div>
                            <div class="notif-page-msg">${n.message}</div>
                            <div class="notif-page-time">
                                <i class="fa-regular fa-clock"></i>
                                <c:if test="${not empty n.createdAt}">
                                    <fmt:parseDate value="${n.createdAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDateTime" type="both" />
                                    <fmt:formatDate value="${parsedDateTime}" pattern="HH:mm - dd/MM/yyyy" />
                                </c:if>
                            </div>
                        </div>
                    </a>
                </li>
            </c:forEach>
        </c:if>
        <c:if test="${empty allNotifications}">
            <div class="notif-empty">Hiện tại bạn không có thông báo nào.</div>
        </c:if>
    </ul>
</div>
</body>
</html>