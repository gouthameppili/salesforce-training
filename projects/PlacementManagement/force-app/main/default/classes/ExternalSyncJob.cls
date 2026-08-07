public with sharing class ExternalSyncJob implements Queueable {

    private Id applicationId;

    public ExternalSyncJob(Id applicationId){
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context){

        System.debug('External Sync Started');
        System.debug('Application Id : ' + applicationId);

    }

}