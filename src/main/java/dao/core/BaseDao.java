package dao.core;

import com.mysql.cj.jdbc.MysqlDataSource;

import model.User;

import org.jdbi.v3.core.Jdbi;
import java.sql.SQLException;
import java.util.List;

public class BaseDao {

    private Jdbi jdbi;

    protected Jdbi getJdbi() {
        if (jdbi == null) connect();
        return jdbi;
    }

    protected  void connect() {
        MysqlDataSource dataSource = new MysqlDataSource();
        String jdbcUrl = "jdbc:mysql://" + DBProperties.host() + ":" + DBProperties.port() + "/" + DBProperties.dbname() + DBProperties.option();
        System.out.println(jdbcUrl);
        dataSource.setURL(jdbcUrl);
        dataSource.setUser(DBProperties.user());
        dataSource.setPassword(DBProperties.password());
        try {
            dataSource.setUseCompression(true);
        }
        catch (SQLException e) {
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(dataSource);
    }
    public static void main(String[] args) {
        BaseDao baseDao = new BaseDao();
        Jdbi jdbi=baseDao.getJdbi();
        List<User> lu =jdbi.withHandle(handle -> {
            return handle.createQuery("select * from users").mapToBean(User.class).list();
        });
        System.out.println(lu);

    }
}
