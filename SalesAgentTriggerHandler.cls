public with sharing class SalesAgentTriggerHandler {

    public static void handleSalesAgentOnDelete(){
        //Get all the Commission__c where the Sales_Agent__c is the same as the trigger is running on i.e. newSalesAgent.
        List<Commission__c> commList = [SELECT Id , Sales_Agent__c FROM Commission__c WHERE Sales_Agent__c := newSalesAgent.Id];
            
        List<Commission__c> commListToBeUpdated = new List<Commission__c>();
        //Run a loop and make all the Sales_Agent__c to null of Commission__c and update Commission__c
        for(Commission__c commList: perComm){
            perComm.Sales_Agent__c = null;
            commListToBeUpdated.add(perComm);
        }
        update commListToBeUpdated;
    } 
}