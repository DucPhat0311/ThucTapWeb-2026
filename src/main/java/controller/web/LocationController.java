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

    private final VietnamLocationService locationService = new VietnamLocationService();
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");

        try {
            String path = request.getPathInfo();
            if (path == null || path.isBlank()) {
                sendBadRequest(response, "Missing endpoint path.");
                return;
            }

            switch (path) {
                case "/provinces" -> writeJson(response, locationService.getProvinces());
                case "/districts" -> handleDistricts(request, response);
                case "/wards" -> handleWards(request, response);
                default -> sendNotFound(response, "Endpoint not found.");
            }
        } catch (IllegalArgumentException ex) {
            sendBadRequest(response, ex.getMessage());
        } catch (LocationApiException ex) {
            sendGatewayError(response, "Cannot load location data from upstream API.");
        }
    }

    private void handleDistricts(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int provinceCode = parsePositiveInt(request.getParameter("provinceCode"), "provinceCode");
        List<LocationItem> districts = locationService.getDistricts(provinceCode);
        writeJson(response, districts);
    }

    private void handleWards(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int districtCode = parsePositiveInt(request.getParameter("districtCode"), "districtCode");
        List<LocationItem> wards = locationService.getWards(districtCode);
        writeJson(response, wards);
    }

    private int parsePositiveInt(String raw, String fieldName) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException(fieldName + " is required.");
        }

        try {
            int value = Integer.parseInt(raw.trim());
            if (value <= 0) {
                throw new IllegalArgumentException(fieldName + " must be greater than 0.");
            }
            return value;
        } catch (NumberFormatException ex) {
            throw new IllegalArgumentException(fieldName + " must be an integer.");
        }
    }

    private void writeJson(HttpServletResponse response, Object payload) throws IOException {
        response.setStatus(HttpServletResponse.SC_OK);
        objectMapper.writeValue(response.getOutputStream(), payload);
    }

    private void sendBadRequest(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        objectMapper.writeValue(response.getOutputStream(), Map.of("error", message));
    }

    private void sendNotFound(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        objectMapper.writeValue(response.getOutputStream(), Map.of("error", message));
    }

    private void sendGatewayError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_GATEWAY);
        objectMapper.writeValue(response.getOutputStream(), Map.of("error", message));
    }
}
