package model;

import model.constant.OrderReturnReason;
import model.constant.OrderReturnStatus;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class OrderReturn {
    private int id;
    private int orderId;
    private int userId;
    private String requestSource;
    private String reasonCode;
    private String description;
    private String returnStatus;
    private String refundStatus;
    private String adminNote;
    private LocalDateTime requestedAt;
    private LocalDateTime processedAt;
    private LocalDateTime returningAt;
    private LocalDateTime returnedAt;
    private LocalDateTime refundedAt;
    private boolean stockRestored;
    private String customerName;
    private String customerPhone;
    private double orderAmount;
    private String paymentMethod;
    private String paymentStatus;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRequestSource() {
        return requestSource;
    }

    public void setRequestSource(String requestSource) {
        this.requestSource = requestSource;
    }

    public String getReasonCode() {
        return reasonCode;
    }

    public void setReasonCode(String reasonCode) {
        this.reasonCode = reasonCode;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getReturnStatus() {
        return returnStatus;
    }

    public void setReturnStatus(String returnStatus) {
        this.returnStatus = returnStatus;
    }

    public String getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(String refundStatus) {
        this.refundStatus = refundStatus;
    }

    public String getAdminNote() {
        return adminNote;
    }

    public void setAdminNote(String adminNote) {
        this.adminNote = adminNote;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public LocalDateTime getProcessedAt() {
        return processedAt;
    }

    public void setProcessedAt(LocalDateTime processedAt) {
        this.processedAt = processedAt;
    }

    public LocalDateTime getReturningAt() {
        return returningAt;
    }

    public void setReturningAt(LocalDateTime returningAt) {
        this.returningAt = returningAt;
    }

    public LocalDateTime getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(LocalDateTime returnedAt) {
        this.returnedAt = returnedAt;
    }

    public LocalDateTime getRefundedAt() {
        return refundedAt;
    }

    public void setRefundedAt(LocalDateTime refundedAt) {
        this.refundedAt = refundedAt;
    }

    public boolean isStockRestored() {
        return stockRestored;
    }

    public void setStockRestored(boolean stockRestored) {
        this.stockRestored = stockRestored;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public double getOrderAmount() {
        return orderAmount;
    }

    public void setOrderAmount(double orderAmount) {
        this.orderAmount = orderAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getReasonLabel() {
        return OrderReturnReason.getLabel(reasonCode);
    }

    public String getReturnStatusLabel() {
        return OrderReturnStatus.getReturnLabel(returnStatus);
    }

    public String getRefundStatusLabel() {
        return OrderReturnStatus.getRefundLabel(refundStatus);
    }

    public String getRequestedAtFormatted() {
        return formatDateTime(requestedAt);
    }

    public String getProcessedAtFormatted() {
        return formatDateTime(processedAt);
    }

    public String getReturningAtFormatted() {
        return formatDateTime(returningAt);
    }

    public String getReturnedAtFormatted() {
        return formatDateTime(returnedAt);
    }

    public String getRefundedAtFormatted() {
        return formatDateTime(refundedAt);
    }

    private String formatDateTime(LocalDateTime value) {
        if (value == null) {
            return "";
        }
        return value.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
