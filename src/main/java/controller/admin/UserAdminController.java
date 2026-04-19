package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import service.UserService;
import java.io.IOException;
import java.util.List;

import model.User;

import java.time.LocalDate;

@WebServlet(name = "UserAdminController", value = "/userAdmin")

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
            List<User> allUsers = userService.getAllUser();
            int total = allUsers.size();
            int countActive = userService.getCountActive();
            int countBlock = userService.getCountBlock();

            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                allUsers = userService.searchByUsernameOrEmail(keyword);
            }

            String status = request.getParameter("status");
            if (status != null && !status.trim().isEmpty()) {
                allUsers = allUsers.stream()
                        .filter(u -> status.equalsIgnoreCase(u.getStatus()))
                        .collect(java.util.stream.Collectors.toList());
            }

            int page = 1;
            int pageSize = 5;
            
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int totalUsers = allUsers.size();
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
            
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;
            
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, totalUsers);
            List<User> users = allUsers.subList(start, end);

            request.setAttribute("total", total);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("countActive", countActive);
            request.setAttribute("countBlock", countBlock);
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("page", "user");

            if (status != null) {
                request.setAttribute("currentStatus", status);
            }
            if (keyword != null) {
                request.setAttribute("currentKeyword", keyword);
            }
            
            request.getRequestDispatcher("/WEB-INF/admin/userAdmin.jsp").forward(request,response);
            return;
        }

        if("edit".equals(mode) || "view".equals(mode)){
            int id = Integer.parseInt(request.getParameter("id"));
            User user = userService.findById(id);

            request.setAttribute("user", user);
            request.setAttribute("mode", mode);

            request.setAttribute("page", "user");
            request.getRequestDispatcher("/WEB-INF/admin/form-userAdmin.jsp").forward(request,response);

            return;
        }

        if("add".equals(mode)){
            request.setAttribute("mode", "add");
            request.setAttribute("page", "user");
            request.getRequestDispatcher("/WEB-INF/admin/form-userAdmin.jsp").forward(request, response);
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

            response.sendRedirect("userAdmin");
          
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

            response.sendRedirect("userAdmin?mode=view&id=" + id);

        }

        if ("block".equals(action)){

            int id = Integer.parseInt(request.getParameter("id"));

            userService.blockUser(id);

            response.sendRedirect("userAdmin");

            return;
        }

        if ("unblock".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));

            userService.unblockUser(id);

            response.sendRedirect("userAdmin");

            return;
        }

    }
}