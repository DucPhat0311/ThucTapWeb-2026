package dao.core;

import com.mysql.cj.jdbc.MysqlDataSource;

import model.User;

import org.jdbi.v3.core.Jdbi;
import util.ConfigUtil;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

public class BaseDao {

    private Jdbi jdbi;

    protected Jdbi getJdbi() {
        if (jdbi == null) connect();
        return jdbi;
    }

    protected  void connect() {
        MysqlDataSource dataSource = new MysqlDataSource();
        String jdbcUrl = "jdbc:mysql://" + DBProperties.host + ":" + DBProperties.port + "/" + DBProperties.name;
        System.out.println(jdbcUrl);
        dataSource.setURL(jdbcUrl);
        dataSource.setUser(DBProperties.user);
        dataSource.setPassword(DBProperties.password);
        try {
            dataSource.setUseCompression(true);
        }
        catch (SQLException e) {
            throw new RuntimeException(e);
        }
        jdbi = Jdbi.create(dataSource);
    }

    public static class DBProperties {
        private static Properties prop = new Properties();

        static {
            try {
                File file = new File("..\\src\\main\\resources\\db.properties");
                if (file.exists()) {
                    prop.load(new FileInputStream(file));
                } else {
                    prop.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }

        public static String host = readConfig("DB_HOST", "db.host", "localhost");
        public static String port = readConfig("DB_PORT", "db.port", "3306");
        public static String user = readConfig("DB_USER", "db.user", "root");
        public static String password = readConfig("DB_PASS", "db.pass", "");
        public static String name = readConfig("DB_NAME", "db.name", "aurastudio");

        private static String readConfig(String envName, String propName, String defaultValue) {
            String configValue = ConfigUtil.get(envName);
            if (!configValue.isBlank()) {
                return configValue;
            }

            String propValue = prop.getProperty(propName);
            if (propValue != null && !propValue.isBlank()) {
                return propValue.trim();
            }

            return defaultValue;
        }

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
