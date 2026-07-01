package mypackage;

import java.util.Base64;
import java.sql.Date;

public class Event {
    private int id;
    private String title;
    private byte[] image;
    private String description;
    private Date date;
    private double price;
    private String category;

    public Event() {
        this.id = 0;
        this.title = "";
        this.image =  new byte[0];
        this.description = "";
        this.date = null;
        this.price = 0;
        this.category = "";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public byte[] getImage() {
        return image;
    }

    public void setImage(byte[] image) {
        this.image = image;
    }

    public String getImageBase64() {
        if (this.image == null || this.image.length == 0) {
            return "";
        }
        return Base64.getEncoder().encodeToString(this.image);
    }
    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    
    
    
    
    
}
