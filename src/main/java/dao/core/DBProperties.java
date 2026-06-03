package dao.core;

import util.ConfigUtil;

import java.util.Properties;

public class DBProperties {
    private static Properties prop = new Properties();
    static {
        try{
            prop.load(DBProperties.class.getClassLoader().getResourceAsStream("db.properties"));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public static String host() {return readConfig("DB_HOST", "db.host", "localhost");}
    public static int port(){
        try {
            return Integer.parseInt(readConfig("DB_PORT", "db.port", "3306"));
        } catch (NumberFormatException e) {
            return 3306;
        }
    }
    public static String user() {return readConfig("DB_USER", "db.user", "root");}
    public static String password() {return readConfig("DB_PASS", "db.pass", "");}
    public static String dbname() {return readConfig("DB_NAME", "db.name", "aurastudio");}
    public static String option() {return readConfig("DB_OPTION", "db.option", "");}

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

    public static void main(String[] args) {
        System.out.println(dbname());
    }
}
