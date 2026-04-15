package model;

public class Address {
    private int id;
    private int userId;
    private String name;
    private String phone;
    private String city;
    private Integer provinceCode;
    private String district;
    private Integer districtCode;
    private String ward;
    private Integer wardCode;
    private String detailAddress;
    private boolean isDefault;

    public Address() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Integer getProvinceCode() { return provinceCode; }
    public void setProvinceCode(Integer provinceCode) { this.provinceCode = provinceCode; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public Integer getDistrictCode() { return districtCode; }
    public void setDistrictCode(Integer districtCode) { this.districtCode = districtCode; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public Integer getWardCode() { return wardCode; }
    public void setWardCode(Integer wardCode) { this.wardCode = wardCode; }

    public String getDetailAddress() { return detailAddress; }
    public void setDetailAddress(String detailAddress) { this.detailAddress = detailAddress; }

    public boolean getIsDefault() { return isDefault; }
    public void setIsDefault(boolean isDefault) { this.isDefault = isDefault; }
}
