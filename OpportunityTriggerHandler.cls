public with sharing class OppotunityTriggerHandler {
   
    public static void handleOppOnInsertOrUpdate(Opportunity newOpp){
        if(newOpp.Stage__c == 'Pending' && Trigger.Old[0].Stage__c != 'Pending'){
            //Query all the Sales Agents from Commissions where the Opportunity Id of the commision is the trigger opportunity id.
            List<Commission__c> commList = [SELECT Sales_Agent__c FROM Commission__c WHERE Opportunity__c := newOpp.Id];
            List<Id> salesIds = new List <Id>();
            
            for(Commission__c commList: comm){
                salesIds.add(comm.Sales_Agent__c);
            }
            
            // Get all the Sales Agents related that is related to salesIds
            List<Sales_Agent__c> salesList = [SELECT Amount_Pending__c FROM Sales_Agent__c WHERE Id IN salesIds];
            List<Sales_Agent__c> salesListToBeUpdated = new List<Sales_Agent__c>();
            for(Sales_Agent__c salesList: perSale){
                perSale.Amount_Pending__c = Amount_Pending__c + newOpp.Amount__c;
                salesListToBeUpdated.add(perSale);
            }
            update salesListToBeUpdated;
        }
    }

    public static void handleOppOnDelete(Opportunity newOpp){
        //Get all the Commission__c where the Opportunity__c is the same as the trigger is running on i.e. newOpp.
        List<Commission__c> commList = [SELECT Id, Opportunity__c, Sales_Agent__c FROM Commission__c WHERE Opportunity__c := newOpp.Id];
        List<Id> salesIds = new List <Id>();
            
        for(Commission__c commList: comm){
            salesIds.add(comm.Sales_Agent__c);
        }

        List<Commission__c> commListToBeUpdated = new List<Commission__c>();
        //Run a loop and make all the Opportunity__c to null of Commission__c and update Commission__c
        for(Commission__c commList: perComm){
            perComm.Opportunity__c = null;
            commListToBeUpdated.add(perComm);
        }
        update commListToBeUpdated;

        //Update the related Sales_Agent__c.Amount_Pending__c by subtracting the Opportunity__c.Amount_c
        List<Sales_Agent__c> salesList = [SELECT Amount_Pending__c FROM Sales_Agent__c WHERE Id IN salesIds];
        List<Sales_Agent__c> salesListToBeUpdated = new List<Sales_Agent__c>();
        for(Sales_Agent__c salesList: perSale){
            perSale.Amount_Pending__c = Amount_Pending__c - newOpp.Amount__c;
            salesListToBeUpdated.add(perSale);
        }
        update salesListToBeUpdated;
    }
}