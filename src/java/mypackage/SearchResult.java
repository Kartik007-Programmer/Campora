
package mypackage;

public class SearchResult {
    private String id;
    private String type;
    private String title;
    private String description;
    private String email;
    private String imageBase64;
    private String meta1;
    private String meta2;
    private String url;

    public SearchResult(String id, String type, String title, String description,
                        String email, String imageBase64, String meta1, String meta2, String url) {
        this.id = id;
        this.type = type;
        this.title = title;
        this.description = description;
        this.email = email;
        this.imageBase64 = imageBase64;
        this.meta1 = meta1;
        this.meta2 = meta2;
        this.url = url;
    }

    // Getters only
    public String getId() { return id; }
    public String getType() { return type; }
    public String getTitle() { return title; }
    public String getDescription() { return description; }
    public String getEmail() { return email; }
    public String getImageBase64() { return imageBase64; }
    public String getMeta1() { return meta1; }
    public String getMeta2() { return meta2; }
    public String getUrl() { return url; }
}    

