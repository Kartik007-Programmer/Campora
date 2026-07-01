package mypackage;

import java.util.*;

public class Course {
    private int id;
    private String name;
    private byte[] img;
    private double fees;
    private double star;
    private String description; 
    private int durationMonths;
    private String category;
    private int maxStudents;
    
    public Course() {
        this.id = 0;
        this.name = "";
        this.img = new byte[0];
        this.fees = 0.0;
        this.star = 0.0;
        this.description = "";
        this.durationMonths = 0;
        this.category = "";
        this.maxStudents = 0;       
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setImg(byte[] img) {
        this.img = img;
    }

    public void setFees(double fees) {
        this.fees = fees;
    }

    public void setStar(double star) {
        this.star = star;
    }

    public void setDescription(String description) {
        this.description = description;
    }

        public int getId() {
            return id;
        }
         
        public String getName() {
            return name;
        }

        public String getImageBase64() {
         if (this.img == null || this.img.length == 0) {
               return "";
            }
            return Base64.getEncoder().encodeToString(this.img);
        }
        
        public byte[] getImg() {
            return img;
        }

        public double getFees() {
             return fees;
         }

        public double getStar() {
            return star;
        }

        public String getDescription() { 
            return description;
        }

        public int getDurationMonths() {
            return durationMonths;
        }

        public void setDurationMonths(int durationMonths) {
            this.durationMonths = durationMonths;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public int getMaxStudents() {
            return maxStudents;
        }

        public void setMaxStudents(int maxStudents) {
            this.maxStudents = maxStudents;
        }
 
}
