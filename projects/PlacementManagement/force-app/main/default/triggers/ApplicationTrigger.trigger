trigger ApplicationTrigger on Application__c (after update) {

    for (Application__c application : Trigger.new) {

        Application__c oldApplication =
            Trigger.oldMap.get(application.Id);

        /*
         * Only synchronize when the Application
         * transitions INTO Shortlisted.
         */
        if (
            application.Status__c == 'Shortlisted' &&
            oldApplication.Status__c != 'Shortlisted'
        ) {

            System.enqueueJob(
                new CandidateSyncQueueable(application.Id)
            );
        }
    }
}