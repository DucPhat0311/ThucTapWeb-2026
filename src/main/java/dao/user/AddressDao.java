package dao.user;

import dao.core.BaseDao;
import model.Address;

import java.util.List;

public class AddressDao extends BaseDao {

    public List<Address> getByUser(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT
                        id,
                        user_id        AS userId,
                        name,
                        phone,
                        city,
                        province_code AS provinceCode,
                        district,
                        district_code AS districtCode,
                        ward,
                        ward_code     AS wardCode,
                        detailAddress,
                        is_default     AS isDefault
                    FROM addresses
                    WHERE user_id = :uid
                    ORDER BY is_default DESC, id DESC
                """)
                        .bind("uid", userId)
                        .mapToBean(Address.class)
                        .list()
        );
    }

    public Address findById(int id, int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT
                        id,
                        user_id        AS userId,
                        name,
                        phone,
                        city,
                        province_code AS provinceCode,
                        district,
                        district_code AS districtCode,
                        ward,
                        ward_code     AS wardCode,
                        detailAddress,
                        is_default     AS isDefault
                    FROM addresses
                    WHERE id = :id
                      AND user_id = :uid
                """)
                        .bind("id", id)
                        .bind("uid", userId)
                        .mapToBean(Address.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public Address findDefaultByUser(int userId) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                    SELECT
                        id,
                        user_id        AS userId,
                        name,
                        phone,
                        city,
                        province_code AS provinceCode,
                        district,
                        district_code AS districtCode,
                        ward,
                        ward_code     AS wardCode,
                        detailAddress,
                        is_default     AS isDefault
                    FROM addresses
                    WHERE user_id = :uid
                      AND is_default = 1
                    ORDER BY id DESC
                    LIMIT 1
                """)
                        .bind("uid", userId)
                        .mapToBean(Address.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void insert(Address a) {
        getJdbi().useTransaction(h -> {

            if (a.getIsDefault()) {
                h.createUpdate("""
                    UPDATE addresses
                    SET is_default = 0
                    WHERE user_id = :uid
                """)
                        .bind("uid", a.getUserId())
                        .execute();
            }

            h.createUpdate("""
                INSERT INTO addresses
                (user_id, name, phone, city, province_code, district,
                 district_code, ward, ward_code, detailAddress, is_default)
                VALUES
                (:uid, :name, :phone, :city, :provinceCode, :district,
                 :districtCode, :ward, :wardCode, :detail, :def)
            """)
                    .bind("uid", a.getUserId())
                    .bind("name", a.getName())
                    .bind("phone", a.getPhone())
                    .bind("city", a.getCity())
                    .bind("provinceCode", a.getProvinceCode())
                    .bind("district", a.getDistrict())
                    .bind("districtCode", a.getDistrictCode())
                    .bind("ward", a.getWard())
                    .bind("wardCode", a.getWardCode())
                    .bind("detail", a.getDetailAddress())
                    .bind("def", a.getIsDefault() ? 1 : 0)
                    .execute();
        });
    }

    public void delete(int id, int userId) {
        getJdbi().withHandle(h ->
                h.createUpdate("""
                    DELETE FROM addresses
                    WHERE id = :id
                      AND user_id = :uid
                """)
                        .bind("id", id)
                        .bind("uid", userId)
                        .execute()
        );
    }

    public void setDefault(int id, int userId) {
        getJdbi().useTransaction(h -> {

            h.createUpdate("""
                UPDATE addresses
                SET is_default = 0
                WHERE user_id = :uid
            """)
                    .bind("uid", userId)
                    .execute();

            h.createUpdate("""
                UPDATE addresses
                SET is_default = 1
                WHERE id = :id
                  AND user_id = :uid
            """)
                    .bind("id", id)
                    .bind("uid", userId)
                    .execute();
        });
    }

    public void update(Address a) {
        getJdbi().useTransaction(h -> {

            if (a.getIsDefault()) {
                h.createUpdate("""
                UPDATE addresses
                SET is_default = 0
                WHERE user_id = :uid
            """)
                        .bind("uid", a.getUserId())
                        .execute();
            }

            h.createUpdate("""
            UPDATE addresses
            SET name = :name,
                phone = :phone,
                city = :city,
                province_code = :provinceCode,
                district = :district,
                district_code = :districtCode,
                ward = :ward,
                ward_code = :wardCode,
                detailAddress = :detail,
                is_default = :def
            WHERE id = :id
              AND user_id = :uid
        """)
                    .bind("id", a.getId())
                    .bind("uid", a.getUserId())
                    .bind("name", a.getName())
                    .bind("phone", a.getPhone())
                    .bind("city", a.getCity())
                    .bind("provinceCode", a.getProvinceCode())
                    .bind("district", a.getDistrict())
                    .bind("districtCode", a.getDistrictCode())
                    .bind("ward", a.getWard())
                    .bind("wardCode", a.getWardCode())
                    .bind("detail", a.getDetailAddress())
                    .bind("def", a.getIsDefault() ? 1 : 0)
                    .execute();
        });
    }

}
