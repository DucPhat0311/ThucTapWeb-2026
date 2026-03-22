<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Contact</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css"><link rel="stylesheet" href="${pageContext.request.contextPath}/css/views/contact.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebarAdmin.css">
</head>
<body>
<div class="admin">
    <jsp:include page="include/sidebarAdmin.jsp" />

    <section class="content">
  
        <header class="topbar">
            <h1 id="pageTitle">Liên hệ</h1>
            <div class="actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Đăng xuất</a>
            </div>
        </header>

        <main id="page">
            <section id="dashboard" class="page active">
                <div class="cards">
                    <div class="card">Tổng liên hệ<br><span id="dashboard-total-contact">5</span></div>
                    <div class="card">Liên hệ mới<br><span id="dashboard-total-contact-new">2</span></div>
                    <div class="card">Liên hệ đang xử lý<br><span id="dashboard-total-contact-processing">1</span></div>
                    <div class="card">Liên hệ đã xử lý<br><span id="dashboard-total-contact-closed">2</span></div>
                </div>

                <div class="contact-toolbar">
                    <a href="#" class="btn-add">
                        <i class="fa fa-plus"></i> Thêm liên hệ
                    </a>
                </div>

                <div class="contact-table-wrapper">
                    <table class="contact-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Nội dung</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody id="contactTableBody">
    <tr>
        <td>1</td>
        <td>Nguyễn Thúy Vy</td>
        <td>thuyvy@gmail.com</td>
        <td>0901234567</td>
        <td class="message-preview">
            Shop ơi, mình muốn hỏi về chính sách đổi trả hàng...
        </td>
        <td>
            <span class="status active">Liên hệ mới</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa liên hệ" onclick="openDeleteModal(1, 'Nguyễn Thúy Vy')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>2</td>
        <td>Trần Hoàng Quân</td>
        <td>hoangquan99@gmail.com</td>
        <td>0987654321</td>
        <td class="message-preview">
            Mình đặt áo size L nhưng muốn đổi sang size XL...
        </td>
        <td>
            <span class="status processing">Đang xử lý</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa liên hệ" onclick="openDeleteModal(2, 'Trần Hoàng Quân')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>

    <tr>
        <td>3</td>
        <td>Lê Thị Hoa</td>
        <td>hoale_fashion@yahoo.com</td>
        <td>0912333444</td>
        <td class="message-preview">
            Sản phẩm Aura Studio mặc rất thoải mái, mình rất...
        </td>
        <td>
            <span class="status blocked">Đã xử lý</span>
        </td>
        <td class="actions">
            <a href="#" class="icon-btn view" title="Xem chi tiết">
                <i class="fa fa-eye"></i>
            </a>
            <a href="#" class="icon-btn edit" title="Chỉnh sửa">
                <i class="fa fa-pen"></i>
            </a>
            <button type="button" class="icon-btn delete" title="Xóa liên hệ" onclick="openDeleteModal(3, 'Lê Thị Hoa')">
                <i class="fa fa-trash"></i>
            </button>
        </td>
    </tr>
                    </tbody>
                    </table>
                </div>
            </section>
        </main>
    </section>


    <div id="deleteModal" class="modal-overlay">
        <div class="modal">
            <h3>Xác nhận xóa</h3>
            <p id="deleteMessage">Bạn có chắc muốn xóa liên hệ này không?</p>

            <form id="deleteForm" method="post" action="contactAdmin">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" id="deleteContactId">

                <div class="modal-actions">
                    <button type="button" class="btn-secondary" onclick="closeDeleteModal()">Hủy</button>
                    <button type="submit" class="btn-danger">Xóa</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/javaScript/admin/adminContact.js"></script>

</body>
</html>

