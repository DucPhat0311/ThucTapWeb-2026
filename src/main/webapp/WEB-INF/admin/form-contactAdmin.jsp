<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Liên hệ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formContact.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="container">

    <div class="form-header">
        <a href="contactAdmin" class="btn-back">← Quay lại</a>
        <h2>Xem chi tiết liên hệ</h2>
    </div>

    <form method="post" action="contactAdmin">

        <div class="card">
            <h3>Thông tin liên hệ</h3>

            <div class="row">
                <div class="col">
                    <label>ID</label>
                    <input type="text" value="101" readonly>
                </div>

                <div class="col">
                    <label>Tên</label>
                    <input type="text" name="name" value="Nguyễn Văn An" readonly>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Email</label>
                    <input type="text" name="email" value="an.nguyen@gmail.com" readonly>
                </div>

                <div class="col">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="0901234567" readonly>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Địa chỉ</label>
                    <input type="text" name="address" value="Số 1, đường Võ Văn Ngân, Thủ Đức, TP.HCM" readonly>
                </div>
                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status" disabled>
                        <option value="New">Mới</option>
                        <option value="Processing" selected>Đang xử lý</option>
                        <option value="Closed">Đã xử lý</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Nội dung</label>
                    <textarea name="message" rows="5" readonly>Shop ơi, đơn hàng #10245 của mình khi nào thì giao tới vậy ạ? Mình đang cần gấp để đi tiệc.</textarea>
                </div>
            </div>

        </div>

        <div class="form-footer">
            <a href="contactAdmin" class="btn-secondary">Hủy</a>
        </div>

        <input type="hidden" name="id" value="101">
        <input type="hidden" name="mode" value="view">

    </form>
</div>

</body>
</html>

