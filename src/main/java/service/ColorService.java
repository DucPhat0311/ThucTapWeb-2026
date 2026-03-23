package service;

import dao.user.ColorDao;
import model.Color;

import java.util.List;

public class ColorService {
    private final ColorDao colorDao = new ColorDao();

    public List<Color> getColorByProductId(int id) {
        return colorDao.getColorByProductId(id);
    }
}
