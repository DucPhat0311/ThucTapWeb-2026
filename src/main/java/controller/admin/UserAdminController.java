package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserService;
import java.io.IOException;
import java.util.List;

import model.User;

import java.time.LocalDate;

<<<<<<< HEAD
@WebServlet(name = "UserAdminController", value = "/userAdmin")
=======
@WebServlet(name = "UserAdminController", value = "/user-admin")
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
public class UserAdminController extends HttpServlet {
    private UserService userService;

    @Override
    public void init(){
        userService = new UserService();
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");

        if(mode == null){
            List<User> users = userService.getAllUser();
            int total = users.size();
            int countActive = userService.getCountActive();
            int countBlock = userService.getCountBlock();

            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                users = userService.searchByUsernameOrEmail(keyword);
            }

            request.setAttribute("total", total);
            request.setAttribute("countActive", countActive);
            request.setAttribute("countBlock", countBlock);
            request.setAttribute("users", users);
            request.setAttribute("page", "user");
            request.getRequestDispatcher("/WEB-INF/admin/userAdmin.jsp").forward(request,response);
            return;
        }

        if("edit".equals(mode) || "view".equals(mode)){
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userService.findById(id);

            request.setAttribute("user", user);
            request.setAttribute("mode", mode);

            request.setAttribute("page", "user");
<<<<<<< HEAD
           request.getRequestDispatcher("/WEB-INF/admin/form-userAdmin.jsp").forward(request,response);
=======
           request.getRequestDispatcher("/WEB-INF/admin/user-form.jsp").forward(request,response);
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
            return;
        }

        if("add".equals(mode)){
            request.setAttribute("mode", "add");
            request.setAttribute("page", "user");
<<<<<<< HEAD
            request.getRequestDispatcher("/WEB-INF/admin/form-userAdmin.jsp").forward(request, response);
=======
            request.getRequestDispatcher("/WEB-INF/admin/user-form.jsp").forward(request, response);
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)){
            User user = new User();
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            user.setRole(request.getParameter("role"));
            user.setStatus(request.getParameter("status"));
            user.setFullName(request.getParameter("full_name"));
            user.setPhone(request.getParameter("phone"));
            user.setGender(request.getParameter("gander"));


            String birthdayStr = request.getParameter("birthday");

            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                user.setBirthday(LocalDate.parse(birthdayStr));
            }

            user.setAddress(request.getParameter("address"));

            userService.createUser(user);

<<<<<<< HEAD
            response.sendRedirect("userAdmin");
=======
            response.sendRedirect("user-admin");
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
            return;
        }

        if ("update".equals(action)){
            int id = Integer.parseInt(request.getParameter("id"));

            User user = new User();

            user.setId(id);
            user.setUsername(request.getParameter("username"));
            user.setEmail(request.getParameter("email"));
            user.setRole(request.getParameter("role"));
            user.setStatus(request.getParameter("status"));
            user.setFullName(request.getParameter("full_name"));
            user.setPhone(request.getParameter("phone"));
            user.setGender(request.getParameter("gender"));


            String birthdayStr = request.getParameter("birthday");

            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                user.setBirthday(LocalDate.parse(birthdayStr));
            }

            user.setAddress(request.getParameter("address"));

            userService.updateUser(user);

<<<<<<< HEAD
            response.sendRedirect("userAdmin?mode=view&id=" + id);
=======
            response.sendRedirect("user-admin?mode=view&id=" + id);
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
        }

        if ("block".equals(action)){

            int id = Integer.parseInt(request.getParameter("id"));

            userService.blockUser(id);

<<<<<<< HEAD
            response.sendRedirect("userAdmin");
=======
            response.sendRedirect("user-admin");
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
            return;
        }

        if ("unblock".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            userService.unblockUser(id);

<<<<<<< HEAD
            response.sendRedirect("userAdmin");
=======
            response.sendRedirect("user-admin");
>>>>>>> 5f8211e765d53f77d7fd33869167b09b6163b6f1
            return;
        }

    }
}

