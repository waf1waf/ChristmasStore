package cc.nhf;

public interface Mail {
    boolean sendMail(String host, String[] to, String[] cc, String[] bcc, String subject, String text);
}
