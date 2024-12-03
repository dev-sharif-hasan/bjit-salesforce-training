public with sharing class AccountTriggerHandler {
    private AccountTriggerHandlerBuilder builder;

    private AccountTriggerHandler(AccountTriggerHandlerBuilder builder){
        this.builder=builder;
    }

    private Double getChange(Account oldAccount,Account newAccount){
        if(oldAccount.AnnualRevenue==null){
            return 100;
        }
        Double revenueOld=oldAccount.AnnualRevenue;
        Double revenueNew=newAccount.AnnualRevenue;
        Double percentageChange=(revenueNew-revenueOld)*100.0/revenueOld;
        return percentageChange;
    }
    private String renderEmailBody(Account account,Double change){
        String body = 'Dear Concern\n';
        body+='You account: '+account.Name+' has a significant revenue change.\n';
        body+='Your current revenue is: '+account.AnnualRevenue+'\n';
        body+='The expected revenue change is: '+change+'%';
        return body;
    }

    private void handleEmailAndNotification(){
        List <Id> recepients=new List<Id>();
        for(Id objectId:builder.oldAccountsMap.keySet()){
            Account newAccount=builder.newAccountsMap.get(objectId);
            Account oldAccount=builder.oldAccountsMap.get(objectId);
            recepients.add(newAccount.OwnerId);
            Double change=getChange(oldAccount, newAccount);
            if(Math.abs(change)>20){
                NotificationService.sendNotification(recepients, new List<Id>{newAccount.Id}, renderEmailBody(newAccount,change));
                EmailService.sendSingleEmailToRecordOwners(recepients, 'Account revenue changed significantly', renderEmailBody(newAccount,change));
            }
        }
    }

    private void handlePhoneUpdate(){
        List <Account> accounts=builder.newAccounts;
        List <Account> oldAccount=builder.oldAccounts;
        for(Account account:accounts){
            if(!String.isBlank(account.Phone)&&String.isBlank(account.country_code__c)){
                account.country_code__c.addError('Country code must be selected');
            }else if(!String.isBlank(account.country_code__c)){
                String []code=account.country_code__c.split(':');
                String []phoneWithoutCountry=account.Phone.split(' ');
                account.Phone=code[1]+' '+(phoneWithoutCountry.size()==2?phoneWithoutCountry[1]:account.Phone);
                account.Phone=account.Phone.trim();
            }
        }
    }

    public void execute(){
        if(builder.isUpdate&&builder.operationType.equals(System.TriggerOperation.AFTER_UPDATE)){
            handleEmailAndNotification();
        }
        if(builder.operationType.equals(System.TriggerOperation.BEFORE_UPDATE)|| 
           builder.operationType.equals(System.TriggerOperation.BEFORE_INSERT)
          ){
            handlePhoneUpdate();
        }
    }


    /**
     * Builder: Provides builder methods to build the handler class.
     * Eliminates requirement for unnecessary data.
     */
    public static AccountTriggerHandlerBuilder builder(){
        return new AccountTriggerHandlerBuilder();
    }

    public class AccountTriggerHandlerBuilder{
        private List<Account> oldAccounts;
        private List<Account> newAccounts;
        private Map<Id,Account> oldAccountsMap;
        private Map<Id,Account> newAccountsMap;
        private Boolean isExecuting;
        private TriggerOperation operationType;
        private Boolean isNew;
        private Boolean isInsert;
        private Boolean isUpdate;
        private Boolean isDelete;

        public AccountTriggerHandlerBuilder oldAccounts(List<Account> oldAccounts){
            this.oldAccounts=oldAccounts;
            return this;
        }
        public AccountTriggerHandlerBuilder newAccounts(List<Account> newAccounts){
            this.newAccounts=newAccounts;
            return this;
        }
        public AccountTriggerHandlerBuilder isExecuting(Boolean isExecuting){
            this.isExecuting=isExecuting;
            return this;
        }
        public AccountTriggerHandlerBuilder operationType(TriggerOperation operationType){
            this.operationType=operationType;
            return this;
        }
        public AccountTriggerHandlerBuilder isInsert(Boolean isInsert){
            this.isInsert=isInsert;
            return this;
        }
        public AccountTriggerHandlerBuilder isUpdate(Boolean isUpdate){
            this.isUpdate=isUpdate;
            return this;
        }
        public AccountTriggerHandlerBuilder isDelete(Boolean isDelete){
            this.isDelete=isDelete;
            return this;
        }

        public AccountTriggerHandlerBuilder oldAccountsMap(Map<Id,Account> oldAccountsMap){
            this.oldAccountsMap=oldAccountsMap;
            return this;
        }
        public AccountTriggerHandlerBuilder newAccountsMap(Map<Id,Account> newAccountsMap){
            this.newAccountsMap=newAccountsMap;
            return this;
        }


        public AccountTriggerHandler build(){
            return new AccountTriggerHandler(this);
        }

    } 
}