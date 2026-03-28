package dao.admin;

import dao.core.BaseDao;

public class SizeDaoAdmin extends BaseDao {
    
       public int findOrCreateSize(String sizeCode) {
        return getJdbi().withHandle(handle -> {
            Integer id = handle.createQuery("SELECT id FROM sizes WHERE code = :code")
                               .bind("code", sizeCode)
                               .mapTo(Integer.class)
                               .findOne().orElse(null);
            if (id != null) {
                return id;
            }
            return handle.createUpdate("INSERT INTO sizes (code, sort_order) VALUES (:code, 99)")
                         .bind("code", sizeCode)
                         .executeAndReturnGeneratedKeys("id")
                         .mapTo(Integer.class)
                         .one();
        });
    }
}

