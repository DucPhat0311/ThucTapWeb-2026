package service;


import dao.user.ProductDao;
import model.Product;


import java.util.Comparator;
import java.util.List;


public class ProductService {
    private final ProductDao productDao = new ProductDao();


    public List<Product> getAllProducts() {
        return productDao.findAll();
    }


    // lấy các sản phẩm MỚI NHẤT cho trang home
    public List<Product> getLatestProducts(int limit) {
        return productDao.findLatest(limit);
    }


    // lấy sản phẩm liên quan
    public List<Product> ralatedProduct(int currentProductId, int limit) {
        Product currentProduct = productDao.findById(currentProductId);


        int categoryId = currentProduct.getCategory_id();


        return productDao.getRelatedProductByCategory(categoryId, currentProductId, limit);
    }


    // lấy chi tiết sản phẩm theo id
    public Product getProductById(int id) {
        return productDao.findById(id);
    }


    // tìm kiếm theo tên
    public List<Product> searchProducts(String keyword) {
        return productDao.searchByName(keyword);
    }




    // Mới nhất theo ngày tạo
    public List<Product> sortByNewest(List<Product> products) {
        products.sort(Comparator.comparing(Product::getCreated_at).reversed());
        return products;
    }




    //Bán chạy
    public List<Product> sortByBestSeller(List<Product> products) {
        products.sort(Comparator.comparing(Product::getViews).reversed());
        return products;
    }


    // Khuyến mãi sale_price
    public List<Product> sortBySale(List<Product> products) {
        products.sort(Comparator.comparing((Product p) -> p.getSale_price() > 0 ? 0 : 1)
                .thenComparing(Product::getSale_price));
        return products;
    }


    // Theo giá
    public List<Product> sortByPriceAsc(List<Product> products) {
        products.sort(Comparator.comparing(Product::getSale_price));
        return products;
    }


    public List<Product> sortByPriceDesc(List<Product> products) {
        products.sort(Comparator.comparing((Product::getSale_price))
                .reversed());


        return products;
    }


    public List<Product> getBoyProducts(int limit) {
        return productDao.findBoyProducts(limit);
    }


    public List<Product> getGirlProducts(int limit) {
        return productDao.findGirlProducts(limit);
    }


    public List<Product> getAccessoryProducts(int limit) {
        return productDao.findAccessoryProducts(limit);
    }


    public List<Product> getProductsByCategories(List<Integer> categoryIds) {
        return productDao.findByCategories(categoryIds);
    }


//    public List<Product> handleFilterProducts(String groupId, String categoryId, String sortType, String minPrice, String maxPrice,int pageSize, int offset) {
//        return productDao.filterProducts(groupId,categoryId,sortType, minPrice, maxPrice,pageSize,offset);
//    }


    public List<Product> handleFilterProducts(String categoryId, String sortType, String minPrice, String maxPrice,int pageSize, int offset) {
        return productDao.filterProducts(categoryId,sortType, minPrice, maxPrice,pageSize,offset);
    }


    public int handleCountProducts(String categoryId, String minPrice, String maxPrice){
        return productDao.countProducts(categoryId, minPrice, maxPrice);
    }

}
