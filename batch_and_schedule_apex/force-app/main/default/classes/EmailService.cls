public with sharing class EmailService {

    public static void sendSingleEmailToRecordOwners(List<Id> receipients,String subject,String body){
        List <User> users=[select Email from user where ID in :receipients with SECURITY_ENFORCED];
        List <String> emails=new List<String>();
        for(User user:users){
            emails.add(user.Email);
        }
        for(Id receipientId:receipients){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(emails);
            mail.setSubject(subject);
            mail.setPlainTextBody(body);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        }
    }


    public static void sendMailToSystemAdmins(String subject,String body){
        List <User> users=[SELECT Id, Name, Email from USER where Profile.Name='System Administrator'];
        List <String> emails=new List<String>();
        for(User user:users){
            emails.add(user.Email);
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(emails);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
}