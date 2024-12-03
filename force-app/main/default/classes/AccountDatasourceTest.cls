@isTest
private class AccountDatasourceTest {

    @TestSetup
    static void setup(){
        
    }

    @isTest
    private static void testInsertAccount_Positive(){
        String title='Account Name Should Start With Uppercase Latin Laters';
        try{
            Test.startTest();
            Boolean result = AccountDatasource.insertAccount('JS ENTERPRICE','https://www.salesforce.com');
            Test.stopTest();
            System.Assert.isTrue(result,title);
        }catch(Exception e){
            System.Assert.fail(title);
        }
    }

    @isTest
    private static void testInsertAccount_Negative(){
        String title='Account Name With Non Latin Uppercase Charecter Will Fail';
        try{
            Test.startTest();
            Boolean result = AccountDatasource.insertAccount('[JS ENTERPRICE]','https://www.salesforce.com');
            Test.stopTest();
            System.Assert.fail(title);
        }catch(Exception e){
            System.Assert.isTrue(e instanceOf IllegalArgumentException,title);
        }
    }

    @IsTest
    private static void testGetTheUniueNumberOfIndustries_Positive(){
        TestDataFactory.createAccounts(new List<String>{
            'Agriculture',
            'Agriculture',
            'Banking',
            'Media',
            'Energy',
            'Consulting',
            'Engineering'
        });
        Test.startTest();
        Set <String> industries = AccountDatasource.getTheUniueNumberOfIndustries();
        Test.stopTest();
        System.Assert.areEqual(6, industries.size(),'6 Industries are not Equal');
    }


    @isTest
    private static void testNavigateAccountWebsiteSecurly_Negative(){
        List <Account> accounts = TestDataFactory.createAccounts(new List<String>{'Agriculture','Education'}, new List<String>{'js.com',null});
        Test.startTest();
        Boolean result = AccountDatasource.navigateAccountWebsiteSecurly(accounts[0]);
        Boolean blankTestResult = AccountDatasource.navigateAccountWebsiteSecurly(accounts[1]);
        Test.stopTest();
        System.Assert.areNotEqual(result||blankTestResult, true,'Website should not start with http:// or be blank or any segment other than https://');
    }

    @isTest
    private static void testNavigateAccountWebsiteSecurly_Positive(){
        List <Account> accounts = TestDataFactory.createAccounts(new List<String>{'Agriculture'}, new List<String>{'https://iishanto.com'});
        Test.startTest();
        Boolean result = AccountDatasource.navigateAccountWebsiteSecurly(accounts[0]);
        Test.stopTest();
        System.Assert.areEqual(result, true,'Website Should Start With https://');
    }

    @isTest
    private static void serviceAgentShouldNotHaveAccessToAccountData(){
        User user=TestDataFactory.createNewAgentUser();
        User admin=TestDataFactory.createNewAdminUser();
        System.runAs(admin){
            TestDataFactory.createAccounts(new List<String>{'Agriculture'});
        }
        System.runAs(user){
            Test.startTest();
            List <Account> accounts=AccountDatasource.getAllAccounts();
            Test.stopTest();
            System.Assert.areEqual(true,accounts==null||accounts.size()==0,'Agent user should not have access to data');
        }
    }


    @isTest
    private static void testGetDscountOffering_Technology_Education(){
        List<Account> account=TestDataFactory.createAccounts(new List<String> {'Technology','Education'});
        Test.startTest();
        Double discountTech=AccountDatasource.getDscountOffering(account[0]);
        Double discountEducation=AccountDatasource.getDscountOffering(account[1]);
        System.Assert.areEqual(true,discountTech==10&&discountEducation==10,'Technology and education should get 10% discount');
        Test.stopTest();
    }

    @isTest
    private static void testGetDscountOffering_Agriculture(){
        List<Account> account=TestDataFactory.createAccounts(new List<String> {'Agriculture'});
        Test.startTest();
        Double discountAgriculture=AccountDatasource.getDscountOffering(account[0]);
        System.Assert.areEqual(20,discountAgriculture,'Agriculture should get 10% discount');
        Test.stopTest();
    }


    @isTest
    private static void testGetDscountOffering_All_Other(){
        List<Account> account=TestDataFactory.createAccounts(new List<String> {'Energy'});
        Test.startTest();
        Double discountAll=AccountDatasource.getDscountOffering(account[0]);
        System.Assert.areEqual(5,discountAll,'All Industry except Agriculture,Education, and Technology should get 5% discount');
        Test.stopTest();
    }



}