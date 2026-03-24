<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tin tức - AURA Studio</title>

    <link rel="stylesheet" href="css/views/blog.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
</head>
<body>

<%@include file="../include/header.jsp"%>


<!-- TITLE -->
<div class="title">
    <span>BÀI VIẾT</span>
</div>

<!-- MAIN -->
<main class="container">
    <div class="newsContainer">

        <!-- BÀI VIẾT RANDOM nào đó -->
        <div class="newsItem">
            <a href="">
                <img src="img/.jpg" alt="Tiêu đề bài viết 1">
            </a>
            <div class="news-content">
                <h3>
                    <a href="">Tiêu đề bài viết 1</a>
                </h3>
                <p>Mô tả ngắn gọn về nội dung bài viết 1, tóm tắt ý chính và hấp dẫn người đọc.</p>
                <div class="news-meta">
                    <span class="news-date">
                        <i class="fa-regular fa-calendar"></i>
                        15/03/2026
                    </span>
                </div>
            </div>
        </div>

        <div class="newsItem">
            <a href="">
                <img src="img/.jpg" alt="Tiêu đề bài viết 2">
            </a>
            <div class="news-content">
                <h3>
                    <a href="">Tiêu đề bài viết 2</a>
                </h3>
                <p>Mô tả ngắn gọn về nội dung bài viết 2, tóm tắt ý chính và hấp dẫn người đọc.</p>
                <div class="news-meta">
                    <span class="news-date">
                        <i class="fa-regular fa-calendar"></i>
                        10/03/2026
                    </span>
                </div>
            </div>
        </div>

        <!-- Nếu không có bài viết -->
        <!-- <p style="text-align:center">Hiện chưa có bài viết nào.</p> -->

    </div>



</main>

<%@include file="../include/footer.jsp"%>



</body>
</html>