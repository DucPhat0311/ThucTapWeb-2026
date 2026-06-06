<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <%@ taglib prefix="aura" uri="/WEB-INF/tlds/aura.tld" %>
                <!DOCTYPE html>
                <html lang="vi">

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formProductVariant.css">
                    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">

                    <title>
                        <c:choose>
                            <c:when test="${mode == 'add'}">Thêm Ảnh</c:when>
                            <c:when test="${mode == 'edit'}">Sửa Ảnh</c:when>
                            <c:otherwise>Xem Ảnh</c:otherwise>
                        </c:choose>
                    </title>

                </head>

                <body>
                    <div class="container">
                        <div class="form-header">
                            <a href="${pageContext.request.contextPath}/productImgAdmin?productId=${productId}"
                                class="btn-back">
                                <i class="fa fa-arrow-left"></i> Quay lại
                            </a>

                            <h2>
                                <c:choose>
                                    <c:when test="${mode == 'add'}">Thêm Ảnh Mới</c:when>
                                    <c:when test="${mode == 'edit'}">Sửa Ảnh</c:when>
                                    <c:otherwise>Chi Tiết Ảnh</c:otherwise>
                                </c:choose>
                            </h2>
                        </div>


                        <div class="card">
                            <form action="${pageContext.request.contextPath}/productImgAdmin" method="post"
                                enctype="multipart/form-data">
                                <input type="hidden" name="productId" value="${productId}">
                                <c:if test="${mode == 'edit'}">
                                    <input type="hidden" name="id" value="${image.id}">
                                </c:if>
                                <input type="hidden" name="action" value="${mode == 'add' ? 'create' : 'update'}">


                                <div class="col">
                                    <label>
                                        Hình Ảnh
                                        <c:if test="${mode == 'add'}"><span style="color: red;">*</span></c:if>
                                    </label>


                                    <c:if test="${mode != 'add' && image.imageUrl != null}">
                                        <div class="image-preview">
                                            <img src="${aura:resolve(pageContext.request.contextPath, '/img/products', image.imageUrl, 'img/logo.png')}"
                                                alt="Current Image" id="currentImage">
                                        </div>
                                    </c:if>

                                    <c:if test="${mode != 'view'}">
                                        <input type="file" name="imageFiles" id="imageFiles" accept="image/*"
                                            ${mode=='add' ? 'multiple required' : '' } onchange="previewImage(event)">
                                        <small id="fileName" style="color: #666; display: block; margin-top: 5px;">
                                            ${mode == 'add' ? 'Chọn ảnh sản phẩm (có thể chọn nhiều ảnh cùng lúc)' :
                                            'Chọn 1 ảnh mới để thay thế ảnh hiện tại'}
                                        </small>

                                        <div id="newImagePreview"
                                            style="margin-top: 15px; display: flex; flex-wrap: wrap; gap: 15px;">
                                        </div>
                                    </c:if>

                                    <c:if test="${mode == 'edit'}">
                                        <div class="col" style="margin-top: 15px;">
                                            <label>Đặt làm ảnh chính</label>
                                            <div class="checkbox-wrapper">
                                                <input type="checkbox" id="isMain" name="isMain" value="true"
                                                    ${image.main ? 'checked' : '' }>
                                                <small class="form-text">Ảnh chính sẽ được hiển thị đầu tiên</small>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>


                                <c:if test="${mode != 'view'}">
                                    <div class="form-footer" style="margin-top: 25px;">
                                        <a href="${pageContext.request.contextPath}/productImgAdmin?productId=${productId}"
                                            class="btn-secondary">
                                            <i class="fa fa-times"></i> Hủy
                                        </a>
                                        <button type="submit" class="btn-primary">
                                            <i class="fa fa-save"></i>
                                            ${mode == 'add' ? 'Thêm Ảnh' : 'Cập Nhật'}
                                        </button>
                                    </div>
                                </c:if>

                            </form>
                        </div>
                    </div>



                    <script
                        src="${pageContext.request.contextPath}/js/admin/adminProductImg.js?v=<%= System.currentTimeMillis() %>"></script>
                    <input type="hidden" id="formMode" value="${mode}">
                </body>

                </html>