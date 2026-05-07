package controller.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ApiConstant;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.stream.Collectors;

@WebServlet("/api/shipping-time")
public class ShippingTimeController extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String payloadJson = request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));

        String apiUrl = "https://online-gateway.ghn.vn/shiip/public-api/v2/shipping-order/leadtime";
        HttpClient client = HttpClient.newHttpClient();

        HttpRequest ghnRequest = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .header("Content-Type", "application/json")
                .header("Token", ApiConstant.GHN_TOKEN)
                .POST(HttpRequest.BodyPublishers.ofString(payloadJson))
                .build();

        try {
            HttpResponse<String> ghnResponse = client.send(ghnRequest, HttpResponse.BodyHandlers.ofString());

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(ghnResponse.body());

        } catch (InterruptedException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Lỗi kết nối tới GHN\"}");
        }
    }
}
