package model;

import java.sql.Timestamp;

public class SearchHistory {
    private int id;
    private int userId;
    private String keyword;
    private Timestamp createdAt;

    public SearchHistory() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }
}