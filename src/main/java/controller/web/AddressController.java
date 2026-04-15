package controller.web;

import dao.user.AddressDao;
import model.Address;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/address")
public class AddressController extends HttpServlet {

    private final AddressDao addressDao = new AddressDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            res.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        List<Address> addressList = addressDao.getByUser(user.getId());

        req.setAttribute("addressList", addressList);
        req.getRequestDispatcher("/WEB-INF/views/address.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            res.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        String action = req.getParameter("action");

        if ("add".equals(action)) {
            Address a = new Address();
            a.setUserId(user.getId());
            a.setName(req.getParameter("name"));
            a.setPhone(req.getParameter("phone"));
            a.setCity(req.getParameter("city"));
            a.setProvinceCode(parseNullableInt(req.getParameter("provinceCode")));
            a.setDistrict(req.getParameter("district"));
            a.setDistrictCode(parseNullableInt(req.getParameter("districtCode")));
            a.setWard(req.getParameter("ward"));
            a.setWardCode(parseNullableInt(req.getParameter("wardCode")));
            a.setDetailAddress(req.getParameter("detailAddress"));
            a.setIsDefault(req.getParameter("isDefault") != null);

            addressDao.insert(a);
        }

        else if ("update".equals(action)) {
            Address a = new Address();
            a.setId(Integer.parseInt(req.getParameter("id")));
            a.setUserId(user.getId());
            a.setName(req.getParameter("name"));
            a.setPhone(req.getParameter("phone"));
            a.setCity(req.getParameter("city"));
            a.setProvinceCode(parseNullableInt(req.getParameter("provinceCode")));
            a.setDistrict(req.getParameter("district"));
            a.setDistrictCode(parseNullableInt(req.getParameter("districtCode")));
            a.setWard(req.getParameter("ward"));
            a.setWardCode(parseNullableInt(req.getParameter("wardCode")));
            a.setDetailAddress(req.getParameter("detailAddress"));
            a.setIsDefault(req.getParameter("isDefault") != null);

            addressDao.update(a);
        }

        else if ("setDefault".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            addressDao.setDefault(id, user.getId());
        }

        else if ("delete".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            addressDao.delete(id, user.getId());
        }

        res.sendRedirect("address");
    }

    private Integer parseNullableInt(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}

