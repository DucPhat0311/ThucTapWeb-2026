<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import="model.User" %>
        <% User userLogin=(User) session.getAttribute("userlogin"); boolean isAdminStaff=userLogin !=null && "admin"
            .equalsIgnoreCase(userLogin.getRole()); String backAction=isAdminStaff ? "history.back()"
            : "window.location.href='" + request.getContextPath() + "/home'" ; %>
            <!DOCTYPE html>
            <html>

            <body
                style="margin:0;padding:0;display:flex;flex-direction:column;align-items:center;justify-content:center;height:100vh;background:#fff;gap:24px;">
                <img src="<%= request.getContextPath() %>/img/403.png" alt="403 Forbidden"
                    style="max-width:90vw;max-height:80vh;object-fit:contain;" />
                <button onclick="<%= backAction %>" style="padding:12px 36px;background:#8B6F47;color:#fff;border:none;border-radius:8px;
                   font-size:15px;font-family:inherit;cursor:pointer;letter-spacing:0.5px;
                   transition:background 0.2s,transform 0.15s;box-shadow:0 2px 8px rgba(139,111,71,0.3);"
                    onmouseover="this.style.background='#6d5538';this.style.transform='translateY(-2px)'"
                    onmouseout="this.style.background='#8B6F47';this.style.transform='translateY(0)'">
                    &#8592; Quay lại
                </button>
            </body>

            </html>