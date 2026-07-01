
package mypackage;
import java.sql.Timestamp;


public class Message {
    
    private int id;
    private String fullName;
    private String email;
    private String subject;
    private String message;
    private Timestamp createdAt;
    private Timestamp viewedAt; 
    private boolean isViewed; 
    
    public Message() {
        this.fullName = "";
        this.email = "";
        this.subject = "";
        this.message = "";
        this.isViewed = false;
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

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getViewedAt() {
        return viewedAt;
    }

    public void setViewedAt(Timestamp viewedAt) {
        this.viewedAt = viewedAt;
    }

    public boolean isIsViewed() {
        return isViewed;
    }
    
    public boolean getViewed() {
    return isViewed;
}

    public void setIsViewed(boolean isViewed) {
        this.isViewed = isViewed;
    }
    
    

}
