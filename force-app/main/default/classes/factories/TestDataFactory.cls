@isTest
public class TestDataFactory {
    public static List <Account> createAccounts(Integer amount,List <String> industries,List <String> websites){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < amount; i++){
            Account account = new Account(
                name = 'Test Smith' + i,
                Website = websites!=null?websites[i]:null,
                Industry = industries!=null?industries[i]:null
                );
            accounts.add(account);
        }
        Database.insert(accounts,false);
        return accounts;
    }
    public static List <Account> createAccounts(List <String> industries){
        return createAccounts(industries.size(), industries, null);
    }
    public static List <Account> createAccounts(List <String> industries,List <String> websites){
        return createAccounts(industries.size(), industries, websites);
    }

    public static List<Opportunity> createOpportunities(Account account,integer count){
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Integer i = 0; i < count; i++){
            Opportunity opportunity = new Opportunity();
            opportunity.accountId = account.id;
            opportunity.name = 'Opportunity for '+account.name;
            opportunity.stageName = 'Prospecting';
            opportunity.closeDate = Date.today().addMonths(1);
            opportunities.add(opportunity);
        }
        insert opportunities;
        return opportunities;
    }


    public static User createNewAgentUser(){
        Profile pf= [Select Id from profile where Name='Customer Support Agent']; 
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                        lastName = 'XYZ', 
                        email = uniqueName + '@test' + orgId + '.org', 
                        Username = uniqueName + '@test' + orgId + '.org', 
                        EmailEncodingKey = 'ISO-8859-1', 
                        Alias = uniqueName.substring(18, 23), 
                        TimeZoneSidKey = 'America/Los_Angeles', 
                        LocaleSidKey = 'en_US', 
                        LanguageLocaleKey = 'en_US', 
                        ProfileId = pf.Id
                        ); 
        insert uu;
        return uu;
    }


    public static User createNewAdminUser(){
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'Admin', 
                        lastName = 'XYZ', 
                        email = uniqueName + '@test' + orgId + '.org', 
                        Username = uniqueName + '@Admin' + orgId + '.org', 
                        EmailEncodingKey = 'ISO-8859-1', 
                        Alias = uniqueName.substring(18, 23), 
                        TimeZoneSidKey = 'America/Los_Angeles', 
                        LocaleSidKey = 'en_US', 
                        LanguageLocaleKey = 'en_US', 
                        ProfileId = pf.Id
                        ); 
        insert uu;
        return uu;
    }
}