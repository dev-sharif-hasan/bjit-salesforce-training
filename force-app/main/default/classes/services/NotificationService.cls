public with sharing class NotificationService {
    public static void sendNotification(List <Id> accountIds,List <Id> targetIds,String content){
        CustomNotificationType notificationType = 
            [SELECT Id, DeveloperName 
             FROM CustomNotificationType 
             WHERE DeveloperName='Notification_When_Revenue_Dropped'];

        for(Integer i=0;i<targetIds.size();i++){
            Messaging.CustomNotification customNotification=new Messaging.CustomNotification();
            customNotification.setNotificationTypeId(notificationType.Id);
            customNotification.setTargetId(targetIds[i]);
            customNotification.setBody(content);
            customNotification.setSenderId(UserInfo.getUserId());
            customNotification.setTitle('Opportunity revenue changed more than 20%');
            customNotification.send(new Set<String>{(String)accountIds[i]});
        }
    }
}