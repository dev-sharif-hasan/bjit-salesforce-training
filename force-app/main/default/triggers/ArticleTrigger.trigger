trigger ArticleTrigger on Article__c (after insert,before insert,before update,after update) {
    // if(Trigger.isAfter){
    //     AccountTriggerHandler.detectSignificantChangesThenSendEmail(Trigger.oldMap,Trigger.newMap);

    // }
    // if(Trigger.isBefore){
    //     AccountTriggerHandler.validateInputAccountBeforeCommit(Trigger.new);
    // }else if(Trigger.isInsert){
    //     AccountTriggerHandler.createContactForNewAccount(Trigger.new);
    // }
}