package controller.web;

import model.Address;
import model.User;
import service.AddressService;
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

    private final AddressService addressService = new AddressService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            res.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");

        List<Address> addressList = addressService.getByUser(user.getId());
        moveFlashMessageToRequest(session, req);

        req.setAttribute("addressList", addressList);
        req.getRequestDispatcher("/WEB-INF/views/address.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            res.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        String action = req.getParameter("action");
        if (action == null) {
            res.sendRedirect("address");
            return;
        }

        switch (action) {
            case "add" -> {
                Address address = buildAddressFromRequest(req, user);
                AddressService.SaveResult result = addressService.add(address);
                if (!result.successful()) {
                    redirectWithError(session, res, result.errorMessage());
                    return;
                }
            }
            case "update" -> {
                Address address = buildAddressFromRequest(req, user);
                address.setId(Integer.parseInt(req.getParameter("id")));
                AddressService.SaveResult result = addressService.update(address);
                if (!result.successful()) {
                    redirectWithError(session, res, result.errorMessage());
                    return;
                }
            }
            case "setDefault" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                addressService.setDefault(id, user.getId());
            }
            case "delete" -> {
                int id = Integer.parseInt(req.getParameter("id"));
                addressService.delete(id, user.getId());
            }
            default -> {
            }
        }

        res.sendRedirect("address");
    }

    private Address buildAddressFromRequest(HttpServletRequest req, User user) {
        Address address = new Address();
        address.setUserId(user.getId());
        address.setName(req.getParameter("name"));
        address.setPhone(req.getParameter("phone"));
        address.setCity(req.getParameter("city"));
        address.setProvinceCode(parseNullableInt(req.getParameter("provinceCode")));
        address.setDistrict(req.getParameter("district"));
        address.setDistrictCode(parseNullableInt(req.getParameter("districtCode")));
        address.setWard(req.getParameter("ward"));
        address.setWardCode(parseNullableInt(req.getParameter("wardCode")));
        address.setDetailAddress(req.getParameter("detailAddress"));
        address.setIsDefault(req.getParameter("isDefault") != null);
        return address;
    }

    private void redirectWithError(HttpSession session, HttpServletResponse res, String message)
            throws IOException {
        session.setAttribute("addressError", message);
        res.sendRedirect("address");
    }

    private void moveFlashMessageToRequest(HttpSession session, HttpServletRequest req) {
        Object addressError = session.getAttribute("addressError");
        if (addressError != null) {
            req.setAttribute("addressError", addressError);
            session.removeAttribute("addressError");
        }
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

