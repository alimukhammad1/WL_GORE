trigger OppotunityTrigger on Opportunity (before insert, before update, before delete) {

    Opportunity newOpp = Trigger.new[0];
    
    // Check if the opportunity is inserted or updated
    if(Trigger.isInsert || Trigger.isUpdate){
        OppotunityTriggerHandler.handleOppOnInsertOrUpdate(newOpp);
    }
    
    // Check if the opportunity is deleted
    if(Trigger.isDelete){
        OppotunityTriggerHandler.handleOppOnDelete(newOpp);
    }
}