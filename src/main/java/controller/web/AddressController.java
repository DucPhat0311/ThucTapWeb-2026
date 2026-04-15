package controller.web;

import dao.user.AddressDao;
import model.Address;
import model.User;
import service.location.LocationApiException;
import service.location.VietnamLocationService;
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
    private final VietnamLocationService locationService = VietnamLocationService.getInstance();

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

        if ("add".equals(action)) {
            Address a = buildAddressFromRequest(req, user);
            if (!ensureValidLocation(a, session, res)) {
                return;
            }

            addressDao.insert(a);
        }

        else if ("update".equals(action)) {
            Address a = buildAddressFromRequest(req, user);
            a.setId(Integer.parseInt(req.getParameter("id")));
            if (!ensureValidLocation(a, session, res)) {
                return;
            }

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

    private boolean ensureValidLocation(Address address, HttpSession session, HttpServletResponse res)
            throws IOException {
        try {
            if (locationService.isValidLocation(
                    address.getProvinceCode(),
                    address.getDistrictCode(),
                    address.getWardCode())) {
                return true;
            }

            session.setAttribute("addressError", "Địa chỉ không hợp lệ, vui lòng chọn lại tỉnh, huyện, xã.");
        } catch (LocationApiException e) {
            session.setAttribute("addressError", "Không thể kiểm tra địa chỉ lúc này, vui lòng thử lại sau.");
        }

        res.sendRedirect("address");
        return false;
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

