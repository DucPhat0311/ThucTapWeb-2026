package dao.admin;

import dao.core.BaseDao;

public class ColorDaoAdmin extends BaseDao {
    
   public int findOrCreateColor(String colorName) {
        return getJdbi().withHandle(handle -> {
            Integer id = handle.createQuery("SELECT id FROM colors WHERE name = :name")
                               .bind("name", colorName)
                               .mapTo(Integer.class)
                               .findOne().orElse(null);
            if (id != null) {
                return id;
            }
            return handle.createUpdate("INSERT INTO colors (name) VALUES (:name)")
                         .bind("name", colorName)
                         .executeAndReturnGeneratedKeys("id")
                         .mapTo(Integer.class)
                         .one();
        });
    }
}