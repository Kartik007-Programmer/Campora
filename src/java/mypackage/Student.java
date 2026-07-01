package mypackage;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.Base64;

public class Student {
    private int id;
    private byte[] photo;
    private String firstName;
    private String lastName;
    private long mobile;
    private String email;
    private String password;
    private String gender;
    private Date dob;
    private String course;
    private String qualification;
    private double lastYearPercentage;
    private String addressLine1;
    private String addressLine2;
    private String landmark;
    private String pincode;
    private String state;
    private String city;
    private boolean rememberMe;
    private Timestamp registrationDate;
    private String status;
    private Timestamp processedDate;

    public Student() {
        this.id = 0;
        this.photo = new byte[0];
        this.firstName = "";
        this.lastName = "";
        this.mobile = 0L;
        this.email = "";
        this.password = "";
        this.gender = "";
        this.dob = null;
        this.course = "";
        this.qualification = "";
        this.lastYearPercentage = 0;
        this.addressLine1 = "";
        this.addressLine2 = "";
        this.landmark = "";
        this.pincode = "";
        this.state = "";
        this.city = "";
        this.rememberMe = false;
        this.registrationDate = null;
        this.status = "";
        this.processedDate = null;
    }


    public void setId(int id) {
        this.id = id;
    }

    public void setPhoto(byte[] photo) {
        this.photo = photo;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    
    public void setMobile(long mobile) {
        this.mobile = mobile;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setCourse(String course) {
        this.course = course;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public void setLastYearPercentage(double lastYearPercentage) {
        this.lastYearPercentage = lastYearPercentage;
    }

    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }

    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }

    public void setLandmark(String landmark) {
        this.landmark = landmark;
    }

    public void setPincode(String pincode) {
        this.pincode = pincode;
    }

    public void setState(String state) {
        this.state = state;
    }

    public void setCity(String city) {
        this.city = city;
    }
    
    public void setRememberMe(boolean rememberMe) {
        this.rememberMe = rememberMe;
    }

    public void setRegistrationDate(Timestamp registrationDate) {
        this.registrationDate = registrationDate;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }

    public void setProcessedDate(Timestamp processedDate) {
        this.processedDate = processedDate;
    }

    public int getId() {
        return id;
    }

    public byte[] getPhoto() {
        return photo;
    }
    
    public String getImageBase64() {
         if (this.photo == null || this.photo.length == 0) {
               return "";
            }
            return Base64.getEncoder().encodeToString(this.photo);
    }

    public String getFirstName() {
        return firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public long getMobile() {
        return mobile;
    }

    public String getEmail() {
        return email;
    }

    public String getPassword() {
        return password;
    }

    public String getCourse() {
        return course;
    }

    public String getQualification() {
        return qualification;
    }

    public Date getDob() {
        return dob;
    }

    public String getGender() {
        return gender;
    }

    public double getLastYearPercentage() {
        return lastYearPercentage;
    }

    public String getAddressLine1() {
        return addressLine1;
    }

    public String getAddressLine2() {
        return addressLine2;
    }

    public String getLandmark() {
        return landmark;
    }

    public String getPincode() {
        return pincode;
    }

    public String getState() {
        return state;
    }

    public String getCity() {
        return city;
    }
    
    public boolean isRememberMe() {
        return rememberMe;
    }

    public Timestamp getRegistrationDate() {
        return registrationDate;
    }
    
    public String getStatus() {
        return status;
    }

    public Timestamp getProcessedDate() {
        return processedDate;
    }

 
}
