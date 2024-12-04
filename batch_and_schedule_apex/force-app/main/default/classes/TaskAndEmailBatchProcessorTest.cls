@isTest
public with sharing class TaskAndEmailBatchProcessorTest {
    @isTest
    private static void testTaskAndEmailBatchProcessing_Positive(){
        Project__c project=new Project__c(
            Name='Project_Test',
            Start_Date__c=Date.today().addDays(-1)
            );
        insert project;
        List <Task__c> tasks=new List<Task__c>();
        for(Integer j=0;j<10;j++){
            tasks.add(new Task__c(
                Name='Task_'+j,
                 Due_Date__c=Date.today().addDays((Integer)(j*Math.pow(-1,j))),
                 Project__c=project.Id,
                 Task_Cost__c=j
                 ));
        }
        tasks.add(new Task__c());
        Database.SaveResult []results=Database.insert(tasks,false);
        ApexDatabaseLogger.log(results);
        Test.startTest();
            Database.executeBatch(new TaskAndEmailBatchProcessor(),10);
        Test.stopTest();
        Project__c updatedProject=[SELECT Total_Cost__c FROM Project__c WHERE Id=:project.Id];
        System.Assert.areEqual(45,updatedProject.Total_Cost__c,'Expected total cost to be 45');
    }
}