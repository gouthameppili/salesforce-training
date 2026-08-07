public with sharing class ApplicationPostProcessingJob implements Queueable {

    private Id applicationId;

    public ApplicationPostProcessingJob(Id applicationId){
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context){

        System.debug('Background processing started...');
        System.debug('Application Id : ' + applicationId);
        System.debug('Job Id : ' + context.getJobId());

        System.enqueueJob(new ExternalSyncJob(applicationId));

    }

}