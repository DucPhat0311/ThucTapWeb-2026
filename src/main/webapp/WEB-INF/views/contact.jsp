    <%@ page contentType="text/html; charset=UTF-8"
             pageEncoding="UTF-8" %>
    <%@ taglib prefix = "c" uri = "http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>


    <%
        request.setAttribute("pageCss", "views/contact.css");
        request.setAttribute("pageTitle" , "Liên hệ");
    %>

    <%@include file="../include/header.jsp"%>


    <div class="title">
        <span>THÔNG TIN LIÊN HỆ</span>
    </div>
    <main class="container">

        <div class="contactFrom">
            <h2>Gửi thông tin liên hệ với chúng tôi</h2>

            <c:if test="${not empty successMessage}">
                <p style="color: green; font-weight: bold;">${successMessage}</p>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/contact">
                <label>Địa chỉ email:</label>
                <input type="email" name="email" placeholder="Nhập địa chỉ email">

                <label>Họ và tên:</label>
                <input type="text" name="name" placeholder="Nhập họ tên của bạn">

                <label>Điện thoại của bạn:</label>
                <input type="text" name="phone" placeholder="Mời nhập điện thoại">

                <label>Địa chỉ đầy đủ:</label>
                <input type="text" name="address" placeholder="Nhập đầy đủ thông tin địa chỉ">

                <label>Nội dung:</label>
                <textarea rows="5" name="message" placeholder="Nhập nội dung yêu cầu"></textarea>

                <button type="submit">Gửi tin</button>
            </form>
        </div>
        <div class="contact-sidebar">
            <div class="contactInfo">
                <h3>Shop AURA Studio</h3>
                <p><strong>Địa chỉ:</strong> FIT NLU, Đại học Nông Lâm TP.HCM</p>
                <p><strong>Điện thoại:</strong> 0888 888 888</p>
                <p><b>Thời gian làm việc:</b><br>
                    Thứ 2 - Thứ 6: 8h00 - 19h30 <br>
                    Thứ 7 - Chủ nhật: 8h00 - 21h00
                </p>
            </div>

            <div class="google-map">
                <iframe
                        src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3918.231240377644!2d106.788485!3d10.870008!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3175276398465779%3A0xd33d0773f32e2c0e!2zS2hvYSBDw7RuZyBuZ2jhu4cgVGjDtG5nIHRpbiAtIMSQSCBOw7RuZyBMw6Jt!5e0!3m2!1svi!2s!4v1715412345678!5m2!1svi!2s"
                        width="100%"
                        height="300"
                        style="border:0;"
                        allowfullscreen=""
                        loading="lazy">
                </iframe>
            </div>
        </div>

    </main>


    <%@include file="../include/footer.jsp"%>
