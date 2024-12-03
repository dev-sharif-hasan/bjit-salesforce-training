@isTest
private class AccountTriggerTest {

    @isTest
    static void testAccountUpdateForSignificatRevenueChange_Negative_When_Create() {
        List <Account> accounts = TestDataFactory.createAccounts(1, new List<String>{'Technology'}, new List<String>{'https://iishanto.com'});
    }

    @isTest
    static void testAccountUpdateForSignificatRevenueChange_Negative_When_Update(){
        List <Account> accounts = TestDataFactory.createAccounts(1, new List<String>{'Agriculture'}, new List<String>{'https://iishanto.com'});
        Test.startTest();
        accounts[0].AnnualRevenue = 1000000;
        update accounts;
        accounts[0].AnnualRevenue=10;
        update accounts;
        Test.stopTest();
    }

    
    @isTest
    static void updatePhoneNumberWhenCountryCodeIsPresent_Positive(){
        List <Account> accounts = TestDataFactory.createAccounts(1, new List<String>{'Agriculture'}, new List<String>{'https://iishanto.com'});
        Test.startTest();
        accounts[0].Country_Code__c='Bangladesh: +880';
        accounts[0].Phone='099999999';
        update accounts;
        Test.stopTest();
        Account acc=[select Phone from account where Id=:accounts[0].Id];
        System.Assert.areEqual('+880 099999999', acc.Phone, 'Phone number should be updated');
    }

    @isTest
    static void updatePhoneNumberWhenCountryCodeIsPresen_Negative_When_Country_Code_Not_Present(){
        List <Account> accounts = TestDataFactory.createAccounts(1, new List<String>{'Agriculture'}, new List<String>{'https://iishanto.com'});
        try{
            Test.startTest();
            accounts[0].Phone='099999999';
            update accounts;
            Test.stopTest();
            System.Assert.fail('Requires Country code when phone is present');
        }catch(Exception e){
            return;
        }
    }

    @isTest
    static void updatePhoneNumberWhenCountryCodeIsPresen_When_Using_A_Legacy_Record(){
        List <Account> accounts = TestDataFactory.createAccounts(1, new List<String>{'Agriculture'}, new List<String>{'https://iishanto.com'});
        Test.startTest();
        accounts[0].Phone='099999999';
        accounts[0].Country_Code__c='Bangladesh: +880';
        update accounts;
        Test.stopTest();
    }
}