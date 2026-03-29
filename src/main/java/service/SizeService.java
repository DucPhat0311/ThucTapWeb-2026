package service;

import dao.user.SizeDao;
import dao.admin.SizeDaoAdmin;
import model.Size;

import java.util.List;

public class SizeService {
    private final SizeDao sizeDao = new SizeDao();
    private final SizeDaoAdmin sizeDaoAdmin = new SizeDaoAdmin();


    public List<Size> getSizeByProductId(int id) {
        return sizeDao.getSizeByProductId(id);
    }

    public int findOrCreateSize(String sizeCode) {
        return sizeDaoAdmin.findOrCreateSize(sizeCode);
    }
}
