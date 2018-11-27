package cc.nhf;

public class Email {
    private final String id;

    private String subject;
    private String body;
    private String cc;

    Email(String id, String subject, String body, String cc) {
        this.id = id;
        this.subject = subject;
        this.body = body;
        this.cc = cc;
    }

    public String getId() {
        return id;
    }

    public String getSubject() {
        return subject;
    }

    void setSubject(String subject) {
        this.subject = subject;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getBcc() {
        return cc;
    }

    void setBcc(String cc) {
        this.cc = cc;
    }
}
