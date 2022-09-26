trigger SalesAgentTrigger on Sales_Agent__c (before delete) {

    Sales_Agent__c newSalesAgent = Trigger.new[0];

    if(Trigger.isDelete){
        SalesAgentTriggerHandler.handleSalesAgentOnDelete(newSalesAgent);
    }

}