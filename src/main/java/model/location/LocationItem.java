package model.location;


public class LocationItem {
    private final int code;
    private String codeString; // wardcode
    private final String name;


    public LocationItem(int code, String name) {
        this.code = code;
        this.name = name;
    }


    public LocationItem(int code, String codeString, String name) {
        this.code = code;
        this.codeString = codeString;
        this.name = name;
    }


    public int getCode() {
        return code;
    }


    public String getCodeString() {
        return codeString;
    }


    public void setCodeString(String codeString) {
        this.codeString = codeString;
    }


    public String getName() {
        return name;
    }
}

