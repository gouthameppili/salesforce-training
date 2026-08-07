public with sharing class CloseExpiredJobsBatch
implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator([
            SELECT Id, Name, Last_Date__c
            FROM Job__c
            WHERE Last_Date__c < TODAY
        ]);

    }

    public void execute(Database.BatchableContext bc,
                        List<Job__c> scope){

        System.debug('Processing Batch Size : ' + scope.size());

    }

    public void finish(Database.BatchableContext bc){

        System.debug('Batch Processing Completed');

    }

}