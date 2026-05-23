<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Contact Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formContact.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="container">

    <!-- HEADER -->
    <div class="form-header">
        <a href="contactAdmin" class="btn-back">← Quay lại</a>
        <h2>Xử lý liên hệ</h2>
    </div>


    <form method="post" action="contactAdmin">

        <div class="card">
            <h3>Thông tin liên hệ</h3>

            <div class="row">
                <div class="col">
                    <label>ID</label>
                    <input type="text" value="${contact.id}" readonly class="readonly-bg">
                </div>

                <div class="col">
                    <label>Tên</label>
                    <input type="text" name="name"
                           value="${contact.name}"
                           readonly class="readonly-bg">

                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Email</label>
                    <input type="text" name="email"
                           value="${contact.email}"
                           readonly class="readonly-bg">
                </div>


                <div class="col">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone"
                           value="${contact.phone}"
                           readonly class="readonly-bg">
                </div>

            </div>

            <div class="row">
                <div class="col">
                    <label>Địa chỉ</label>
                    <input type="text" name="address"
                           value="${contact.address}"
                           readonly class="readonly-bg">
                </div>
                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="New" ${contact.status == 'New' ? "selected" : ""}>Mới</option>
                        <option value="Processing" ${contact.status == 'Processing' ? "selected" : ""}>Đang xử lý</option>
                        <option value="Closed" ${contact.status == 'Closed' ? "selected" : ""}>Đã xử lý</option>
                    </select>
                </div>

            </div>

            <div class="row">
                <div class="col">
                    <label>Nội dung</label>
                    <textarea name="message"
                              rows="5"
                              readonly class="readonly-bg"
                    >${contact.message}</textarea>
                </div>
            </div>

        </div>


        <!-- FOOTER -->
        <div class="form-footer">
            <button type="submit" name="action"
                    value="update"
                    class="btn-primary">
                Cập nhật trạng thái
            </button>
            <a href="contactAdmin" class="btn-secondary">Hủy</a>
        </div>

        <!-- HIDDEN -->
        <input type="hidden" name="id" value="${contact.id}">

    </form>

</div>
<style>
    .readonly-bg {
        background-color: #f5f5f5 !important;
        color: #000 !important;
        cursor: not-allowed;
    }
    .readonly-bg:focus {
        outline: none !important;
        border-color: #ddd !important;
    }
</style>
</body>
</html>

