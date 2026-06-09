package controller.web;

import dao.user.ProductDao;
import model.SearchHistory;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/search-history")
public class SearchHistoryController extends HttpServlet {
    private final ProductDao productDao = new ProductDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        User userLog = (User) request.getSession().getAttribute("userlogin");

        // chưa đăng nhap thì ko có lịch sử
        if (userLog == null) {
            response.getWriter().write("[]");
            return;
        }
        List<SearchHistory> history = productDao.getSearchHistory(userLog.getId());

        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < history.size(); i++) {
            String keyword = history.get(i).getKeyword();

            if (keyword == null) {
                keyword = "";
            }
            json.append("\"").append(keyword).append("\"");

            if (i < history.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }
}