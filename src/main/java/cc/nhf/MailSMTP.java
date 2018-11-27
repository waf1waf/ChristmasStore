package cc.nhf;

import org.apache.log4j.Logger;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class MailSMTP implements Mail {
    private final Logger logger = Logger.getLogger(this.getClass());
    public synchronized boolean sendMail(String host, String[] to, String[] cc, String[] bcc,
                                         String subject, String text) {
        Properties props = new Properties();
        props.put("mail.smtp.host", host);

        try {
            Session session = Session.getInstance(props, null);
            MimeMessage msg = new MimeMessage(session);
            msg.setText(text);
            msg.setSubject(subject);
            msg.setFrom(new InternetAddress("The Christmas Store <ChristmasStore@nhf.cc>"));
            for (String aTo : to) {
                msg.addRecipient(Message.RecipientType.TO, new InternetAddress(aTo));
            }
            for (String aCc : cc) {
                msg.addRecipient(Message.RecipientType.CC, new InternetAddress(aCc));
            }
            for (String aBcc : bcc) {
                msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(aBcc));
            }
            Transport.send(msg);
            return true;
        } catch (Exception mex) {
            logger.error(mex.getLocalizedMessage());
            return false;
        }
    }
}
