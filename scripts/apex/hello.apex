try{
Account acc=new Account(id='001dM00002BnVOLQA3');
acc.AnnualRevenue=34243;
// acc.Phone='1638757250';
// acc.country_code__c='Bangladesh: +880';
update acc;
}catch(Exception e){
    System.debug('Its a error');
}