package controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Role;
import model.RolePermission;
import service.RoleService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "RoleAdminController", value = "/roleAdmin")
public class RoleAdminController extends HttpServlet {

    private RoleService roleService;

    @Override
    public void init() {
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String mode = request.getParameter("mode");

        List<Role> roles = roleService.getAllRoles();
        request.setAttribute("roles", roles);
        request.setAttribute("modules", roleService.getAllModules());
        request.setAttribute("actions", roleService.getAllActions());
        
        java.util.Map<String, Boolean> applicableMap = new java.util.HashMap<>();
        for (String module1 : roleService.getAllModules()) {
            for (String act : roleService.getAllActions()) {
                applicableMap.put(module1 + "_" + act, RoleService.isActionApplicable(module1, act));
            }
        }
        request.setAttribute("applicableMap", applicableMap);

        String roleIdParam = request.getParameter("roleId");
        if (roleIdParam != null && !roleIdParam.isEmpty()) {
            int roleId = Integer.parseInt(roleIdParam);
            Role selectedRole = roleService.getRoleById(roleId);
            List<RolePermission> permissions = roleService.getPermissionsByRoleId(roleId);

            request.setAttribute("selectedRole", selectedRole);
            request.setAttribute("permissions", permissions);
        } else if (!roles.isEmpty()) {
            Role selectedRole = roles.get(0);
            List<RolePermission> permissions = roleService.getPermissionsByRoleId(selectedRole.getId());

            request.setAttribute("selectedRole", selectedRole);
            request.setAttribute("permissions", permissions);
        }

        request.setAttribute("page", "role");
        request.getRequestDispatcher("/WEB-INF/admin/roleAdmin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            String name = request.getParameter("roleName");
            String description = request.getParameter("roleDescription");

            Role role = new Role();
            role.setName(name);
            role.setDescription(description);

            int roleId = roleService.createRole(role);
            response.sendRedirect("roleAdmin?roleId=" + roleId);
            return;
        }

        if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("roleId"));
            String name = request.getParameter("roleName");
            String description = request.getParameter("roleDescription");

            Role role = new Role();
            role.setId(id);
            role.setName(name);
            role.setDescription(description);

            roleService.updateRole(role);
            response.sendRedirect("roleAdmin?roleId=" + id);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("roleId"));
            roleService.deleteRole(id);
            response.sendRedirect("roleAdmin");
            return;
        }

        if ("savePermissions".equals(action)) {
            int roleId = Integer.parseInt(request.getParameter("roleId"));

            String[] modules = roleService.getAllModules();
            String[] actions = roleService.getAllActions();

            List<RolePermission> permissions = new ArrayList<>();
            for (String module : modules) {
                for (String act : actions) {
                    String paramName = "perm_" + module + "_" + act;
                    String value = request.getParameter(paramName);

                    RolePermission perm = new RolePermission();
                    perm.setRoleId(roleId);
                    perm.setModule(module);
                    perm.setAction(act);
                    perm.setAllowed(value != null ? 1 : 0);
                    permissions.add(perm);
                }
            }

            roleService.savePermissions(roleId, permissions);
            response.sendRedirect("roleAdmin?roleId=" + roleId);
            return;
        }

        response.sendRedirect("roleAdmin");
    }
}
