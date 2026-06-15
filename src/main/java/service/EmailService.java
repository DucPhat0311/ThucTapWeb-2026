package service;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import util.ConfigUtil;

import java.util.Properties;

public class EmailService {

    public static void sendEmail(String to, String subject, String content) {
        String emailFrom = readRequired("SMTP_EMAIL_FROM");
        String emailPassword = readRequired("SMTP_EMAIL_PASSWORD");
        String smtpHost = ConfigUtil.getOrDefault("SMTP_HOST", "smtp.gmail.com");
        String smtpPort = ConfigUtil.getOrDefault("SMTP_PORT", "587");

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", smtpHost);
        props.put("mail.smtp.port", smtpPort);
        props.put("mail.smtp.ssl.trust", smtpHost);
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(emailFrom, emailPassword);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(emailFrom));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("Email sent successfully to: " + to);
        } catch (MessagingException e) {
            throw new EmailDeliveryException("Unable to send email to " + to, e);
        }
    }

    private static String readRequired(String name) {
        String value = ConfigUtil.get(name);
        if (value.isBlank()) {
            throw new EmailDeliveryException("Missing required mail configuration: " + name);
        }
        return value;
    }

    public static class EmailDeliveryException extends RuntimeException {
        public EmailDeliveryException(String message) {
            super(message);
        }

        public EmailDeliveryException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
