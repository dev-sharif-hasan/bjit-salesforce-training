public with sharing class AccountDatasource {
    public static Boolean insertAccount(String name,String website){
        Integer firstCharecter = name.charAt(0);
        if(firstCharecter>=65&&firstCharecter<=90){
            Account acc = new Account();
            acc.Name = name;
            acc.Website = website;
            return true;
        }
        throw new IllegalArgumentException('Account Name Starts with Non Latin Charecter');
    }

    public static Set<String> getTheUniueNumberOfIndustries(){
        List <Account> accounts = [SELECT Id, Industry FROM Account Limit 10000];
        Set<String> uniqueIndustries = new Set<String>();
        for(Account account:accounts){
            uniqueIndustries.add(account.Industry);
        }
        return uniqueIndustries;
    }

    public static List<Account> getAllAccounts(){
        return [SELECT Id FROM Account];
    }

    public static Boolean navigateAccountWebsiteSecurly(Account account){
        String website=account.Website;
        if(website==null||!website.startsWithIgnoreCase('https://')){
            return false;
        }else{
            return true;
        }
    }



    public static Double getDscountOffering(Account account){
        if(Trigger.isExecuting){
            System.debug('Trigger is executing');
            return 0;
        }
        switch on account.Industry {
            when 'Technology','Education' {
                return 10;
            }
            when 'Agriculture' {
                return 20;
            } when else{
                return 5;
            }
        }
    }
}