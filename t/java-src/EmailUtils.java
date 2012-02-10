package bookletski;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public final class EmailUtils {
    private EmailUtils() {
    }
    
    public static void send(String from, String to, String subject, String body) throws AddressException, MessagingException {
        Properties props = new Properties();

        // Assume there is an SMTP server on the same machine as the webserver
        props.put("mail.smtp.host", "localhost");

        Session s = Session.getInstance(props,null);
        
        InternetAddress fromAddr = new InternetAddress(from);
        InternetAddress toAddr = new InternetAddress(to);
        
        MimeMessage message = new MimeMessage(s);

        message.setFrom(fromAddr);
        message.addRecipient(Message.RecipientType.TO, toAddr);
        message.setSubject(subject);
        message.setText(body);
        
        Transport.send(message);
    }
}
