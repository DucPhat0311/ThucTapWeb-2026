<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Bài viết - AURA Studio" scope="request"/>
<c:set var="pageCss" value="views/blog.css" scope="request"/>

<%@ include file="../include/header.jsp" %>

<div class="title">
    <span>BÀI VIẾT</span>
</div>

<!-- MAIN -->
<main class="container">
    <div class="blogContainer">

        <c:choose>
            <c:when test="${not empty blogList}">
                <c:forEach var="blog" items="${blogList}">
                    <div class="blogItem">
                        <a href="${pageContext.request.contextPath}/blog?id=${blog.id}">
                            <img src="${pageContext.request.contextPath}/${blog.img}" alt="${blog.title}">
                        </a>

                        <div class="blog-content">
                            <h3>
                                <a href="${pageContext.request.contextPath}/blog?id=${blog.id}">
                                        ${blog.title}
                                </a>
                            </h3>

                            <p>${blog.description}</p>

                            <div class="blog-meta">
                                <span class="blog-date">
                                    <i class="fa-regular fa-calendar"></i>
                                    <fmt:formatDate value="${blog.createdAt}" pattern="dd/MM/yyyy"/>
                                </span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>

            <c:otherwise>
                <p style="text-align:center">Hiện chưa có bài viết nào.</p>
            </c:otherwise>
        </c:choose>

    </div>

    <div class="pagination">
        <c:if test="${currentPage > 1}">
            <a href="blog?page=${currentPage - 1}">&laquo;</a>
        </c:if>

        <c:if test="${currentPage > 3}">
            <a href="blog/page=1">1</a>
            <c:if test="${currentPage > 4}">
                <span class="paging-sep">...</span>
            </c:if>
        </c:if>

        <c:set var="begin" value="${currentPage - 2 > 1 ? currentPage - 2 : 1}" />
        <c:set var="end" value="${currentPage + 2 < totalPages ? currentPage + 2 : totalPages}" />

        <c:forEach var="i" begin="${begin}" end="${end}">
            <a href="blog?page=${i}"
               class="${currentPage == i ? 'active' : ''}">${i}</a>
        </c:forEach>

        <c:if test="${currentPage < totalPages - 2}">
            <c:if test="${currentPage < totalPages - 3}">
                <span class="paging-sep">...</span>
            </c:if>
            <a href="blog?page=${totalPages}">${totalPages}</a>
        </c:if>

        <c:if test="${currentPage < totalPages}">
            <a href="blog?page=${currentPage + 1}">&raquo;</a>
        </c:if>
    </div>


</main>

<!-- FOOTER -->
<jsp:include page="../include/footer.jsp"/>