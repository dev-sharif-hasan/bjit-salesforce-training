/**
 * @description     : Batch class for processing tasks and projects. 
 *                    It calculates overdue tasks, updates task statuses, computes total costs for projects, 
 *                    and sends a summary email to system administrators upon completion.
 * @author          : Sharif Hasan
 * @created date    : 04 December, 2024
 * @last modified by: Sharif Hasan
 * @last modified on: 04 December, 2024
 * 
 * @implements      : Database.Batchable<SObject>, Database.Stateful
 */
global with sharing class TaskAndEmailBatchProcessor implements Database.Batchable<SObject>,Database.Stateful {
    private Integer totalOverdueCount=0;
    private Integer numberOfTasks=0;
    private Decimal totalCost=0;

    global Database.QueryLocator start(Database.BatchableContext context){
        return Database.getQueryLocator('SELECT ID,NAME,TASK_STATUS__C,DUE_DATE__C,Task_Cost__c,Project__c,Project__r.Id,Project__r.Total_Cost__c FROM Task__c');
    }

    global void execute(Database.BatchableContext context,List<Task__c> tasks){
        System.debug('Processing task new: '+tasks.size());
        List <SObject> updatables=new List<SObject>();
        Map <Id,Project__c> projects=new Map<Id,Project__c>();
        for(Task__c task:tasks){
            if(!projects.containsKey(task.Project__c)){
                projects.put(task.Project__c,task.Project__r);
                projects.get(task.Project__c).Total_Cost__c=0;
            }
            if(task.Task_Cost__c==null||task.Task_Cost__c==0){
                task.Task_Cost__c=0;
            }
            projects.get(task.Project__c).Total_Cost__c+=task.Task_Cost__c;
            
            System.debug(task.Due_Date__c+' '+Date.today()+' ; '+(task.Due_Date__c<Date.today()));
            if(task.Due_Date__c<Date.today()&&task.Task_Status__c!='Completed'){
                task.Task_Status__c='Overdue';
                totalOverdueCount+=1;
            }
            numberOfTasks+=1;
            updatables.add(task);
        }
        for(Id projectId:projects.keySet()){
            Project__c project=projects.get(projectId);
            totalCost+=project.Total_Cost__c;
            updatables.add(project);
        }
        Database.SaveResult []results=Database.update(updatables,false);
        ApexDatabaseLogger.log(results);
    }

    private String getEmailBody(){
        String html='Dear Admin,<br/> Running Batch Job For Task Overdue Calculation and Summary Report is Done. Here is the short report<br/>';
        html+='<table border="1">';
        html+='<tr>';
        html+='<td>Number Of Overdue</td>';
        html+='<td>'+totalOverdueCount+'</td>';
        html+='</tr>';
        html+='<tr>';
        html+='<td>Total Number Of Tasks</td>';
        html+='<td>'+numberOfTasks+'</td>';
        html+='</tr>';
        html+='<tr>';
        html+='<td>Total Cost</td>';
        html+='<td>'+totalCost+'</td>';
        html+='</tr>';
        html+='</table>';
        return html;
    }

    global void finish(Database.BatchableContext context){
        User []systemAdmins=[SELECT Id, Name, Email from USER where Profile.Name='System Administrator'];
        EmailService.sendMailToSystemAdmins('Batch Job Run Successfull', getEmailBody());
    }
}