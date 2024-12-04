/**
 * @description     : EmailService class is responsible to manage email functionalities from one place. It have two methods,
 *                    one is responsible to send email to targeted users, and another one is responsible to send email to admin users.
 * @author          : Sharif Hasan
 * @created date    : 04 December, 2024
 * @last modified by: Sharif Hasan
 * @last modified on: 04 December, 2024
 */
public with sharing class EmailService {

    /**
     * @description : Sends an email to targeted users.
     * @param receipients : A list of receipients to whom the email is sent.
     * @param subject : The subject of the email.
     * @param body : The body of the email.
     */
    public static void sendSingleEmailToRecordOwners(List<Id> receipients,String subject,String body){
        List <User> users=[select Email from user where ID in :receipients with SECURITY_ENFORCED];
        List <String> emails=new List<String>();
        for(User user:users){
            emails.add(user.Email);
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emails);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }


    /**
     * @description : Sends an email to system administrators.
     * @param subject : The subject of the email.
     * @param body : The body of the email.
     */
    public static void sendMailToSystemAdmins(String subject,String body){
        List <User> users=[SELECT Id, Name, Email from USER where Profile.Name='System Administrator' WITH SECURITY_ENFORCED];
        List <String> emails=new List<String>();
        for(User user:users){
            emails.add(user.Email);
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emails);
        mail.setSaveAsActivity(false);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        System.debug('Email Sent to '+emails.size()+' users');
        for(String email:emails){
            System.debug('Email Sent to '+email);
        }
    }
}