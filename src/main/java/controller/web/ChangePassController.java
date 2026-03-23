package controller.web;

import model.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ChangePassController", value = "/change-password")
public class ChangePassController extends HttpServlet {

    private UserService userService;

    @Override
    public void init(){
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher("/WEB-INF/views/change-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if ( session == null || session.getAttribute("userlogin") == null){
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        String oldPass = request.getParameter("oldpass");
        String newPass = request.getParameter("newpass");
        String rePass = request.getParameter("repass");

        if (oldPass == null || newPass == null || rePass == null || oldPass.isEmpty() || newPass.isEmpty() || rePass.isEmpty()){
           request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
           request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request,response);
           return;
        }

        if (!newPass.equals(rePass)){
            request.setAttribute("error", "Mật khẩu xác nhập không khớp!");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request,response);
            return;
        }

        if (!newPass.matches("^(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$")) {
            request.setAttribute("error",
                    "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, số và ký tự đặc biệt");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }

        // Check mật khẩu cũ
        boolean checkOldPass = userService.checkOldPass(user.getId() , oldPass);
        if (!checkOldPass){
            request.setAttribute("error", "Mật khẩu hiện tại không đúng!");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);
            return;
        }


        boolean update = userService.updatePass(user.getId(), newPass);

        if(update){
            session.invalidate();
            response.sendRedirect("login");
        } else {
            request.setAttribute("error", "Đổi mật khẩu thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("/WEB-INF/views/change-password.jsp").forward(request, response);

        }
    }
}
