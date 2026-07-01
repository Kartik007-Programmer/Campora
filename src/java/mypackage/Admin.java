package mypackage;

import java.util.Base64;

public class Admin {
    private int adminId;
    private byte[] adminPhoto;
    private String adminName;
    private String adminUsername;
    private String adminPassword;

    // Constructor
    public Admin() {
        this.adminId = 0;
        this.adminPhoto = new byte[0];
        this.adminName = "";
        this.adminUsername = "";
        this.adminPassword = "";
    }

    // Getters and Setters
    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public byte[] getAdminPhoto() {
        return adminPhoto;
    }
    
    public String getImageBase64() {
        if (this.adminPhoto == null || this.adminPhoto.length == 0) {
               return "";
            }
        return Base64.getEncoder().encodeToString(this.adminPhoto);
    }

    public void setAdminPhoto(byte[] adminPhoto) {
        this.adminPhoto = adminPhoto;
    }

    public String getAdminName() {
        return adminName;
    }

    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }

    public String getAdminUsername() {
        return adminUsername;
    }

    public void setAdminUsername(String adminUsername) {
        this.adminUsername = adminUsername;
    }

    public String getAdminPassword() {
        return adminPassword;
    }

    public void setAdminPassword(String adminPassword) {
        this.adminPassword = adminPassword;
    }

 
}
