/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package m.dekmak;

/**
 *
 * @author mdekmak
 */
import java.sql.SQLException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.naming.NamingException;

public class Email {

    public Email() {

    }

    public String send(String toEmail, String content) throws ClassNotFoundException, SQLException, NamingException {
        String response = "";
        Database db = new Database();
        final String username = db.getSystemPreferencesValue("smtpUsername");
        final String password = db.getSystemPreferencesValue("smtpPassword");
        String smtpFromAddress = username;

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpFromAddress));
            message.setRecipients(Message.RecipientType.TO,
                    InternetAddress.parse(toEmail));
            ConfigProperties confProp = new ConfigProperties();
            String appName = confProp.getPropValue("appName");
            message.setSubject("Notification from " + appName);
            message.setText(content);

            Transport.send(message);

            response = "Done";

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
        return response;
    }
}
