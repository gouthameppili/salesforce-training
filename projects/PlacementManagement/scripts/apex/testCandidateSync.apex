Id applicationId = 'a06hg000000uxVlAAI';

System.enqueueJob(
    new CandidateSyncQueueable(applicationId)
);