<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="${blog.title} - AURA Studio" scope="request"/>
<c:set var="pageCss" value="views/blog-detail.css" scope="request"/>

<%@ include file="../include/header.jsp" %>

<!-- MAIN CONTENT -->
<main class="detail-container">
    <!-- BAI VIET CHINH -->
    <article class="main-article">
        <a href="${pageContext.request.contextPath}/blog" class="btn-back">
            <i class="fa-solid fa-arrow-left"></i> Quay lại trang bài viết
        </a>

        <h1 class="article-title">${blog.title}</h1>

        <p class="article-meta">
            <i class="fa-regular fa-calendar"></i>
            <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
        </p>

        <div class="article-img">
            <img src="${pageContext.request.contextPath}/${blog.img}" alt="${blog.title}">
        </div>

        <p class="article-lead">${blog.description}</p>

        <div class="article-content">
            ${blog.content}
        </div>
    </article>

    <!-- BAI VIET LIEN QUAN -->
    <aside class="related-sidebar">
        <h3 class="sidebar-title">Bài viết khác</h3>

        <c:choose>
            <c:when test="${not empty relatedBlogs}">
                <c:forEach var="related" items="${relatedBlogs}" varStatus="status">
                    <c:if test="${status.index < 3}">
                        <div class="related-item">
                            <a href="${pageContext.request.contextPath}/blogs?id=${related.id}">
                                <img src="${pageContext.request.contextPath}/${related.img}" alt="${related.title}">
                                <div class="related-info">
                                    <h4>${related.title}</h4>
                                    <p class="related-date">
                                        <i class="fa-regular fa-calendar"></i>
                                        <fmt:formatDate value="${related.createdAt}" pattern="dd/MM/yyyy"/>
                                    </p>
                                </div>
                            </a>
                        </div>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="no-related">Không có bài viết khác.</p>
            </c:otherwise>
        </c:choose>
    </aside>
</main>

<!-- FOOTER -->
<jsp:include page="../include/footer.jsp"/>