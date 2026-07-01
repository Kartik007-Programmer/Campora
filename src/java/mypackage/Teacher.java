package mypackage;

import java.util.*;

public class Teacher {
    private byte[] profileImage;
    private int id;
    private String fullName;
    private String email;
    private long phone;
    private String subject;
    private String qualification;
    private String gender;
    private String password;
    private String status;


    // Constructor
    public Teacher() {
        this.fullName = "";
        this.email = "";
        this.status = "";
        this.phone = 0;
        this.subject = "";
        this.qualification = "";
        this.gender = "";
        this.password = "";
        this.profileImage =  new byte[0];
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public long getPhone() {
        return phone;
    }

    public void setPhone(long phone) {
        this.phone = phone;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
  
    public byte[] getProfileImage() {
        return profileImage;
    }

    public void setProfileImage(byte[] profileImage) {
        this.profileImage = profileImage;
    }
    
    public String getImageBase64() {
         if (this.profileImage == null || this.profileImage.length == 0) {
               return "";
            }
            return Base64.getEncoder().encodeToString(this.profileImage);
    }
    
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
