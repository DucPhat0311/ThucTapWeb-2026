package dao.admin;

import java.util.List;

import dao.core.BaseDao;
import model.Product;

public class ProductDaoAdmin extends BaseDao {

    public List<Product> findAll() {
        String sql = """
        SELECT p.*, c.name AS categoryName
        FROM products p
        JOIN categories c ON p.category_id = c.id
        ORDER BY p.id DESC
    """;

        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Product.class)
                        .list()
        );
    }

    public Product findById(int id) {
        return getJdbi().withHandle(h ->
                h.createQuery("""
                SELECT p.*, c.name AS categoryName
                FROM products p
                JOIN categories c ON p.category_id = c.id
                WHERE p.id = :id
            """)
                        .bind("id", id)
                        .mapToBean(Product.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public List<Product> searchByName(String keyword) {
        String sql = """
        SELECT p.*, c.name AS categoryName
        FROM products p
        JOIN categories c ON p.category_id = c.id
        WHERE p.name LIKE :kw
    """;        
        return getJdbi().withHandle(h ->
                h.createQuery(sql)
                        .bind("kw", "%" + keyword + "%")
                        .mapToBean(Product.class)
                        .list()
        );
    }


    public void insert(Product p) {
        String sql = """
        INSERT INTO products
        (category_id, name, price, sale_price,  thumbnail, description, status)
        VALUES (:category_id, :name, :price, :sale_price, :thumbnail, :description, :status)
    """;

        getJdbi().withHandle(h ->
                h.createUpdate(sql)
                        .bind("category_id", p.getCategory_id())
                        .bind("name", p.getName())
                        .bind("price", p.getPrice())
                        .bind("sale_price", p.getSale_price())
                        .bind("thumbnail", p.getThumbnail())
                        .bind("description", p.getDescription())
                        .bind("status", p.getStatus())
                        .execute()
        );
    }

    public void update(Product p) {
        String sql = """
        UPDATE products
        SET name = :name,
            price = :price,
            sale_price = :sale_price,
            category_id = :category_id,
            thumbnail = :thumbnail,
            description = :description,
            status = :status
        WHERE id = :id
    """;

        getJdbi().withHandle(h ->
                h.createUpdate(sql)
                        .bind("id", p.getId())
                        .bind("name", p.getName())
                        .bind("price", p.getPrice())
                        .bind("sale_price", p.getSale_price())
                        .bind("category_id", p.getCategory_id())
                        .bind("thumbnail", p.getThumbnail())
                        .bind("description", p.getDescription())
                        .bind("status", p.getStatus())
                        .execute()
        );
    }


    public void softDelete(int id) {
        String sql = """
        UPDATE products SET status = 'Đã xoá' WHERE id = :id
        """;
        getJdbi().withHandle(h ->
                h.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }


}
