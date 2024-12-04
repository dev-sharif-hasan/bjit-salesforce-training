public with sharing class ApexDatabaseLogger {
    public static void log(Database.SaveResult[] srList){
        for (Database.SaveResult sr : srList) {
            if (!sr.isSuccess()) {               
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }else{
                    System.debug('Success!!!!');
            }
        }
    }
}