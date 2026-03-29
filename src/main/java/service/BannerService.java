package service;

import dao.admin.BannerDaoAdmin;
import model.Banner;

import java.util.List;

public class BannerService {

    private final BannerDaoAdmin bannerDaoAdmin = new BannerDaoAdmin();

    public List<Banner> getActiveBanners() {
        return  bannerDaoAdmin.findActiveBanners();
    }

    public List<Banner> getAllBanner() {
        return bannerDaoAdmin.getAllBanner();
    }

    public void createBanner(Banner banner) {
        bannerDaoAdmin.createBanner(banner);
    }


    public void updateBanner(Banner banner) {
        bannerDaoAdmin.updateBanner(banner);
    }

    public void deleteBanner(int id) {
        bannerDaoAdmin.deleteBanner(id);
    }

    public void lockOrUnlockBanner(int id, boolean status) {
        bannerDaoAdmin.lockOrUnlockBanner(id, status);
    }

    public Banner getBannerById(int id) {
        return bannerDaoAdmin.getBannerById(id);
    }
}
