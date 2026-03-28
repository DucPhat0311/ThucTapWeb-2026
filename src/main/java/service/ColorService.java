package service;

import dao.user.ColorDao;
import dao.admin.ColorDaoAdmin;
import model.Color;

import java.util.List;

public class ColorService {
    private final ColorDao colorDao = new ColorDao();
    private final ColorDaoAdmin colorDaoAdmin = new ColorDaoAdmin();

    public List<Color> getColorByProductId(int id) {
        return colorDao.getColorByProductId(id);
    }

      public int findOrCreateColor(String colorName) {
        return colorDaoAdmin.findOrCreateColor(colorName);
    }
}
