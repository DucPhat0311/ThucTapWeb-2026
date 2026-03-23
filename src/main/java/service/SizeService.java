package service;

import dao.user.SizeDao;
import model.Size;

import java.util.List;

public class SizeService {
    private final SizeDao sizeDao = new SizeDao();


    public List<Size> getSizeByProductId(int id) {
        return sizeDao.getSizeByProductId(id);
    }
}
