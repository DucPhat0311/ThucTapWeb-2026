package service;

import dao.user.AddressDao;
import model.Address;
import service.location.LocationApiException;
import service.location.LocationService;

import java.util.List;

public class AddressService {
    private static final String INVALID_LOCATION_MESSAGE =
            "Địa chỉ không hợp lệ, vui lòng chọn lại tỉnh, huyện, xã.";
    private static final String LOCATION_CHECK_FAILED_MESSAGE =
            "Không thể kiểm tra địa chỉ lúc này, vui lòng thử lại sau.";

    private final AddressDao addressDao;
    private final LocationService locationService;

    public AddressService() {
        this(new AddressDao(), LocationService.getInstance());
    }

    public AddressService(AddressDao addressDao, LocationService locationService) {
        this.addressDao = addressDao;
        this.locationService = locationService;
    }

    public List<Address> getByUser(int userId) {
        return addressDao.getByUser(userId);
    }

    public Address getDefaultByUser(int userId) {
        return addressDao.findDefaultByUser(userId);
    }

    public Address getPrimaryByUser(int userId) {
        return addressDao.findPrimaryByUser(userId);
    }

    public SaveResult add(Address address) {
        SaveResult validationResult = validateLocation(address);
        if (!validationResult.successful()) {
            return validationResult;
        }

        addressDao.insert(address);
        return SaveResult.success();
    }

    public SaveResult update(Address address) {
        SaveResult validationResult = validateLocation(address);
        if (!validationResult.successful()) {
            return validationResult;
        }

        addressDao.update(address);
        return SaveResult.success();
    }

    public void setDefault(int id, int userId) {
        addressDao.setDefault(id, userId);
    }

    public void delete(int id, int userId) {
        addressDao.delete(id, userId);
    }

    private SaveResult validateLocation(Address address) {
        try {
            boolean valid = locationService.isValidLocation(
                    address.getProvinceCode(),
                    address.getDistrictCode(),
                    address.getWardCode()
            );

            if (valid) {
                return SaveResult.success();
            }

            return SaveResult.failure(INVALID_LOCATION_MESSAGE);
        } catch (LocationApiException e) {
            return SaveResult.failure(LOCATION_CHECK_FAILED_MESSAGE);
        }
    }

    public record SaveResult(boolean successful, String errorMessage) {
        public static SaveResult success() {
            return new SaveResult(true, null);
        }

        public static SaveResult failure(String errorMessage) {
            return new SaveResult(false, errorMessage);
        }
    }
}
