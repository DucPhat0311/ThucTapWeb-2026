<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Form Người dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/formUser.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>

<body>

<div class="container">

    <div class="form-header">
        <a href="userAdmin" class="btn-back">← Quay lại</a>
        <h2>Chỉnh sửa người dùng</h2>
    </div>

    <form method="post" action="userAdmin">

        <div class="card">
            <h3>Thông tin tài khoản</h3>

            <div class="row">
                <div class="col">
                    <label>ID</label>
                    <input type="text" value="1024" readonly>
                </div>

                <div class="col">
                    <label>Username</label>
                    <input type="text" name="username" value="nguyenvana" readonly>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Email</label>
                    <input type="email" name="email" value="vana@gmail.com" readonly>
                </div>

                <div class="col">
                    <label>Vai trò</label>
                    <select name="role">
                        <option value="admin">Quản trị</option>
                        <option value="customer" selected>Khách hàng</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="ACTIVE" selected>Hoạt động</option>
                        <option value="BLOCKED">Bị khóa</option>
                    </select>
                </div>
            </div>
        </div>


        <div class="card">
            <h3>Thông tin cá nhân</h3>

            <div class="row">
                <div class="col">
                    <label>Họ tên</label>
                    <input type="text" name="full_name" value="Nguyễn Văn An">
                </div>

                <div class="col">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="0901234567">
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Giới tính</label>
                    <select name="gender">
                        <option value="">-- Chọn --</option>
                        <option value="male" selected>Nam</option>
                        <option value="female">Nữ</option>
                        <option value="other">Khác</option>
                    </select>
                </div>

                <div class="col">
                    <label>Ngày sinh</label>
                    <input type="date" name="birthday" value="2000-01-01">
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <label>Địa chỉ</label>
                    <textarea name="address" rows="3">Số 123, đường Kha Vạn Cân, Linh Trung, Thủ Đức, TP. HCM</textarea>
                </div>
            </div>
        </div>


        <div class="form-footer">
            <button type="submit" name="action" value="update" class="btn-primary">
                Lưu
            </button>
            <a href="userAdmin" class="btn-secondary">Hủy</a>
        </div>

        <input type="hidden" name="id" value="1024">
        <input type="hidden" name="mode" value="edit">

    </form>

</div>

<style>
    input[readonly], textarea[readonly] {
        background: #f2f2f2;
        cursor: not-allowed;
    }
</style>

</body>
</html>

