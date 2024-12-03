trigger AccountTrigger on Account (after insert,after update,before insert,before update) {
    AccountTriggerHandler.builder()
    .oldAccounts(Trigger.old)
    .newAccounts(Trigger.new)
    .isExecuting(Trigger.isExecuting)
    .operationType(Trigger.operationType)
    .isInsert(Trigger.isInsert)
    .isUpdate(Trigger.isUpdate)
    .isDelete(Trigger.isDelete)
    .oldAccountsMap(Trigger.oldMap)
    .newAccountsMap(Trigger.newMap)
    .build().execute();
}