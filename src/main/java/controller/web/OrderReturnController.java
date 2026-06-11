package controller.web;

import dao.user.OrderDao;
import dao.user.OrderReturnDao;
import dao.user.OrderReturnMediaDao;
import dao.user.OrderTrackingLogDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Order;
import model.OrderReturnMedia;
import model.User;
import model.constant.OrderReturnReason;
import model.constant.OrderStatus;
import util.CloudinaryUtil;

import java.io.IOException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@WebServlet("/order-return")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 30L * 1024 * 1024,
        maxRequestSize = 50L * 1024 * 1024
)
public class OrderReturnController extends HttpServlet {
    private static final int RETURN_PERIOD_DAYS = 7;
    private static final int DESCRIPTION_MAX_LENGTH = 1000;
    private static final int MAX_IMAGE_COUNT = 3;
    private static final int MAX_VIDEO_COUNT = 1;
    private static final long MAX_IMAGE_SIZE = 5L * 1024 * 1024;
    private static final long MAX_VIDEO_SIZE = 30L * 1024 * 1024;
    private static final String RETURN_MEDIA_FOLDER = "order-returns";

    private OrderDao orderDao;
    private OrderReturnDao orderReturnDao;
    private OrderReturnMediaDao orderReturnMediaDao;
    private OrderTrackingLogDao trackingLogDao;

    @Override
    public void init() {
        orderDao = new OrderDao();
        orderReturnDao = new OrderReturnDao();
        orderReturnMediaDao = new OrderReturnMediaDao();
        trackingLogDao = new OrderTrackingLogDao();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userlogin") == null) {
            response.sendRedirect("login");
            return;
        }

        Integer orderId = parseOrderId(request.getParameter("orderId"));
        if (orderId == null) {
            response.sendRedirect("order-user");
            return;
        }

        User user = (User) session.getAttribute("userlogin");
        Order order = orderDao.getById(orderId);
        if (order == null || order.getUserId() != user.getId()) {
            response.sendRedirect("order-user");
            return;
        }

        if (!OrderStatus.COMPLETED.equals(order.getOrderStatus())) {
            redirectWithError(response, orderId, "not_delivered");
            return;
        }

        LocalDateTime deliveredAt = trackingLogDao.findDeliveredAt(orderId).orElse(null);
        if (deliveredAt == null || LocalDateTime.now().isAfter(deliveredAt.plusDays(RETURN_PERIOD_DAYS))) {
            redirectWithError(response, orderId, "expired");
            return;
        }

        if (orderReturnDao.existsByOrderId(orderId)) {
            redirectWithError(response, orderId, "duplicate");
            return;
        }

        String reasonCode = trimToEmpty(request.getParameter("reasonCode"));
        String description = trimToEmpty(request.getParameter("description"));
        if (!OrderReturnReason.isCustomerReason(reasonCode)
                || description.isBlank()
                || description.length() > DESCRIPTION_MAX_LENGTH) {
            redirectWithError(response, orderId, "invalid");
            return;
        }

        List<Part> imageParts = new ArrayList<>();
        List<Part> videoParts = new ArrayList<>();
        if (!collectAndValidateMedia(request.getParts(), imageParts, videoParts)) {
            redirectWithError(response, orderId, "invalid_media");
            return;
        }

        List<UploadedReturnMedia> uploadedMedia = uploadMedia(imageParts, videoParts);

        try {
            int orderReturnId = orderReturnDao.createCustomerRequest(orderId, user.getId(), reasonCode, description);
            for (UploadedReturnMedia media : uploadedMedia) {
                orderReturnMediaDao.insert(orderReturnId, media.mediaType(), media.mediaUrl(), media.originalName());
            }
        } catch (RuntimeException e) {
            if (isDuplicateRequest(e)) {
                redirectWithError(response, orderId, "duplicate");
                return;
            }
            throw e;
        }

        response.sendRedirect("order-detail?id=" + orderId + "&returnRequest=success");
    }

    private void redirectWithError(HttpServletResponse response, int orderId, String error) throws IOException {
        response.sendRedirect("order-detail?id=" + orderId + "&returnError=" + error);
    }

    private boolean isDuplicateRequest(Throwable throwable) {
        Throwable cause = throwable;
        while (cause != null) {
            if (cause instanceof SQLIntegrityConstraintViolationException) {
                return true;
            }
            cause = cause.getCause();
        }
        return false;
    }

    private Integer parseOrderId(String rawOrderId) {
        try {
            return Integer.parseInt(trimToEmpty(rawOrderId));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean collectAndValidateMedia(Collection<Part> parts,
                                            List<Part> imageParts,
                                            List<Part> videoParts) {
        for (Part part : parts) {
            if (part == null || part.getSize() == 0 || trimToEmpty(part.getSubmittedFileName()).isBlank()) {
                continue;
            }

            String partName = trimToEmpty(part.getName());
            if ("returnImages".equals(partName)) {
                if (!isAllowedImage(part) || part.getSize() > MAX_IMAGE_SIZE) {
                    return false;
                }
                imageParts.add(part);
            } else if ("returnVideo".equals(partName)) {
                if (!isAllowedVideo(part) || part.getSize() > MAX_VIDEO_SIZE) {
                    return false;
                }
                videoParts.add(part);
            }
        }

        return imageParts.size() <= MAX_IMAGE_COUNT && videoParts.size() <= MAX_VIDEO_COUNT;
    }

    private List<UploadedReturnMedia> uploadMedia(List<Part> imageParts, List<Part> videoParts) throws IOException {
        List<UploadedReturnMedia> uploadedMedia = new ArrayList<>();
        for (Part imagePart : imageParts) {
            String mediaUrl = CloudinaryUtil.uploadImage(imagePart, RETURN_MEDIA_FOLDER);
            if (mediaUrl != null) {
                uploadedMedia.add(new UploadedReturnMedia(
                        OrderReturnMedia.TYPE_IMAGE,
                        mediaUrl,
                        trimToEmpty(imagePart.getSubmittedFileName())
                ));
            }
        }

        for (Part videoPart : videoParts) {
            String mediaUrl = CloudinaryUtil.uploadVideo(videoPart, RETURN_MEDIA_FOLDER);
            if (mediaUrl != null) {
                uploadedMedia.add(new UploadedReturnMedia(
                        OrderReturnMedia.TYPE_VIDEO,
                        mediaUrl,
                        trimToEmpty(videoPart.getSubmittedFileName())
                ));
            }
        }
        return uploadedMedia;
    }

    private boolean isAllowedImage(Part part) {
        String contentType = trimToEmpty(part.getContentType()).toLowerCase();
        return "image/jpeg".equals(contentType)
                || "image/png".equals(contentType)
                || "image/webp".equals(contentType);
    }

    private boolean isAllowedVideo(Part part) {
        String contentType = trimToEmpty(part.getContentType()).toLowerCase();
        return "video/mp4".equals(contentType)
                || "video/webm".equals(contentType);
    }

    private record UploadedReturnMedia(String mediaType, String mediaUrl, String originalName) {
    }
}
