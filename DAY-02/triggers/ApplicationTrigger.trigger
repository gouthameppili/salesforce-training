trigger ApplicationTrigger on Application__c (before insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        ApplicationTriggerHandler.beforeInsert(Trigger.new);
    }

}