package service.location;

import model.location.LocationItem;

import java.util.List;

public interface LocationProvider {
    String getProviderKey();

    List<LocationItem> getProvinces();

    List<LocationItem> getDistricts(int provinceCode);

    List<LocationItem> getWards(int districtCode);
}
