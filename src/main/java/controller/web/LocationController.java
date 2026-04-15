package controller.web;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.location.LocationItem;
import service.location.LocationApiException;
import service.location.VietnamLocationService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/locations/*")
public class LocationController extends HttpServlet {
    private final VietnamLocationService locationService = VietnamLocationService.getInstance();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null) {
            sendError(res, HttpServletResponse.SC_NOT_FOUND, "Endpoint địa chỉ không tồn tại");
            return;
        }

        try {
            switch (path) {
                case "/provinces" -> sendJson(res, locationService.getProvinces());
                case "/districts" -> {
                    int provinceCode = requireIntParameter(req, "provinceCode");
                    sendJson(res, locationService.getDistricts(provinceCode));
                }
                case "/wards" -> {
                    int districtCode = requireIntParameter(req, "districtCode");
                    sendJson(res, locationService.getWards(districtCode));
                }
                default -> sendError(res, HttpServletResponse.SC_NOT_FOUND, "Endpoint địa chỉ không tồn tại");
            }
        } catch (IllegalArgumentException e) {
            sendError(res, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (LocationApiException e) {
            sendError(res, HttpServletResponse.SC_BAD_GATEWAY, e.getMessage());
        }
    }

    private int requireIntParameter(HttpServletRequest req, String name) {
        String value = req.getParameter(name);
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Thiếu tham số " + name);
        }

        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Tham số " + name + " không hợp lệ");
        }
    }

    private void sendJson(HttpServletResponse res, List<LocationItem> data) throws IOException {
        res.setCharacterEncoding("UTF-8");
        res.setContentType("application/json;charset=UTF-8");
        objectMapper.writeValue(res.getWriter(), data);
    }

    private void sendError(HttpServletResponse res, int status, String message) throws IOException {
        res.setStatus(status);
        res.setCharacterEncoding("UTF-8");
        res.setContentType("application/json;charset=UTF-8");
        objectMapper.writeValue(res.getWriter(), Map.of("message", message));
    }
}
