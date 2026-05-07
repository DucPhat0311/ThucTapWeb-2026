package model.location;


public class LocationItem {
    private final Integer code;
    private final String codeString;
    private final String name;


    public LocationItem(Integer code, String name) {
        this.code = code;
        this.codeString = null;
        this.name = name;
    }


    public LocationItem(String codeString, String name) {
        this.code = null;
        this.codeString = codeString;
        this.name = name;
    }


    public Integer getCode() {
        return code;
    }


    public String getCodeString() {
        return codeString;
    }


    public String getName() {
        return name;
    }
}

