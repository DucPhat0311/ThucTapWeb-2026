package service;

import dao.user.ProductVariantDao;
import model.Address;
import model.ProductVariant;

import java.util.ArrayList;
import java.util.List;

public class CheckoutService {
    private final ProductVariantDao variantDao;
    private final AddressService addressService;

    public CheckoutService() {
        this(new ProductVariantDao(), new AddressService());
    }

    public CheckoutService(ProductVariantDao variantDao, AddressService addressService) {
        this.variantDao = variantDao;
        this.addressService = addressService;
    }

    public PreparedCheckout prepareOrder(int userId, Integer cartId, String[] variantIds, String[] quantities)
            throws CheckoutValidationException {
        validateCart(cartId);
        validateSelection(variantIds, quantities);

        Address shippingAddress = addressService.getPrimaryByUser(userId);
        if (shippingAddress == null) {
            throw new CheckoutValidationException(CheckoutError.ADDRESS_REQUIRED);
        }

        List<PreparedOrderItem> items = new ArrayList<>();
        double totalPrice = 0;

        for (int i = 0; i < variantIds.length; i++) {
            int variantId = parsePositiveInt(variantIds[i]);
            int quantity = parsePositiveInt(quantities[i]);

            int stock = variantDao.getStockByVariantId(variantId);
            if (stock < quantity) {
                throw new CheckoutValidationException(CheckoutError.OUT_OF_STOCK);
            }

            ProductVariant variantDetail = variantDao.getVariantDetails(variantId);
            if (variantDetail == null) {
                throw new CheckoutValidationException(CheckoutError.INVALID_REQUEST);
            }

            double unitPrice = variantDao.getPriceByVariantId(variantId);
            double lineTotal = unitPrice * quantity;

            items.add(new PreparedOrderItem(
                    variantId,
                    quantity,
                    unitPrice,
                    lineTotal,
                    variantDetail
            ));
            totalPrice += lineTotal;
        }

        return new PreparedCheckout(
                trimToEmpty(shippingAddress.getName()),
                trimToEmpty(shippingAddress.getPhone()),
                formatAddress(shippingAddress),
                totalPrice,
                items
        );
    }

    private void validateCart(Integer cartId) throws CheckoutValidationException {
        if (cartId == null) {
            throw new CheckoutValidationException(CheckoutError.CART_NOT_FOUND);
        }
    }

    private void validateSelection(String[] variantIds, String[] quantities) throws CheckoutValidationException {
        if (variantIds == null || quantities == null || variantIds.length == 0 || variantIds.length != quantities.length) {
            throw new CheckoutValidationException(CheckoutError.EMPTY_SELECTION);
        }
    }

    private int parsePositiveInt(String value) throws CheckoutValidationException {
        try {
            int parsedValue = Integer.parseInt(trimToEmpty(value));
            if (parsedValue <= 0) {
                throw new CheckoutValidationException(CheckoutError.INVALID_REQUEST);
            }
            return parsedValue;
        } catch (NumberFormatException e) {
            throw new CheckoutValidationException(CheckoutError.INVALID_REQUEST);
        }
    }

    private String formatAddress(Address address) {
        return String.join(", ",
                trimToEmpty(address.getDetailAddress()),
                trimToEmpty(address.getWard()),
                trimToEmpty(address.getDistrict()),
                trimToEmpty(address.getCity()));
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }

    public record PreparedCheckout(
            String recipientName,
            String recipientPhone,
            String shippingAddress,
            double totalPrice,
            List<PreparedOrderItem> items
    ) {
    }

    public record PreparedOrderItem(
            int variantId,
            int quantity,
            double unitPrice,
            double lineTotal,
            ProductVariant variantDetail
    ) {
    }

    public enum CheckoutError {
        CART_NOT_FOUND,
        EMPTY_SELECTION,
        ADDRESS_REQUIRED,
        OUT_OF_STOCK,
        INVALID_REQUEST
    }

    public static class CheckoutValidationException extends Exception {
        private final CheckoutError error;

        public CheckoutValidationException(CheckoutError error) {
            this.error = error;
        }

        public CheckoutError getError() {
            return error;
        }
    }
}
