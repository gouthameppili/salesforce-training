public with sharing class ApplicationService {

    public static String submitApplication(Id studentId, Id jobId) {

        Student__c student = [
            SELECT Id, Name, CGPA__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        Job__c job = [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Last_Date__c
            FROM Job__c
            WHERE Id = :jobId
            LIMIT 1
        ];

        if(student.CGPA__c < job.Minimum_CGPA__c){
            return 'Student CGPA is below the minimum required CGPA.';
        }
        if(Date.today() > job.Last_Date__c){
            return 'Application deadline has passed.';
        }
        List<Application__c> existingApplications = [
            SELECT Id
            FROM Application__c
            WHERE Student__c = :studentId
            AND Job__c = :jobId
        ];
        if(!existingApplications.isEmpty()){
            return 'Student has already applied for this job.';
        }
        Application__c application = new Application__c();

        application.Student__c = studentId;
        application.Job__c = jobId;
        application.Status__c = 'Applied';
        application.Application_Date__c = Date.today();

        insert application;
        return 'Application Submitted Successfully';

    }

    public static String updateApplicationStatus(Id applicationId, String newStatus){

        Application__c application = [
            SELECT Id, Status__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        application.Status__c = newStatus;

        update application;

        return 'Application Status Updated Successfully';

    }

    public static void validateApplications(List<Application__c> applications){

        Set<Id> studentIds = new Set<Id>();
        Set<Id> jobIds = new Set<Id>();

        for(Application__c app : applications){

            if(app.Student__c != null){
                studentIds.add(app.Student__c);
            }

            if(app.Job__c != null){
                jobIds.add(app.Job__c);
            }
        }

        Map<Id, Student__c> studentMap = new Map<Id, Student__c>([
            SELECT Id, CGPA__c
            FROM Student__c
            WHERE Id IN :studentIds
        ]);

        Map<Id, Job__c> jobMap = new Map<Id, Job__c>([
            SELECT Id, Minimum_CGPA__c, Last_Date__c
            FROM Job__c
            WHERE Id IN :jobIds
        ]);

        List<Application__c> existingApplications = [
            SELECT Student__c, Job__c
            FROM Application__c
            WHERE Student__c IN :studentIds
            AND Job__c IN :jobIds
        ];

        Set<String> existingKeys = new Set<String>();

        for(Application__c app : existingApplications){
            existingKeys.add(app.Student__c + '-' + app.Job__c);
        }

        Set<String> currentKeys = new Set<String>();

        for(Application__c app : applications){

            Student__c student = studentMap.get(app.Student__c);
            Job__c job = jobMap.get(app.Job__c);

            if(student != null && job != null){

                app.Status__c = 'Applied';

                if(student.CGPA__c < job.Minimum_CGPA__c){
                    app.addError('Student CGPA is below the minimum required CGPA.');
                }

                if(Date.today() > job.Last_Date__c){
                    app.addError('Application cannot be submitted after the last application date.');
                }

                String key = app.Student__c + '-' + app.Job__c;

                if(existingKeys.contains(key)){
                    app.addError('Student has already applied for this job.');
                }

                if(currentKeys.contains(key)){
                    app.addError('Duplicate application found in the same transaction.');
                }else{
                    currentKeys.add(key);
                }

            }

        }

    }

    public static void processShortlistedApplications(List<Application__c> newApplications, Map<Id, Application__c> oldMap){

        Set<Id> studentIds = new Set<Id>();

        for(Application__c app : newApplications){

            Application__c oldApp = oldMap.get(app.Id);

            if(oldApp.Status__c != 'Shortlisted' && app.Status__c == 'Shortlisted'){
                System.debug('Status changed to Shortlisted');
                studentIds.add(app.Student__c);
            }

        }

        if(studentIds.isEmpty()){
            return;
        }

        List<Student__c> studentsToUpdate = [
            SELECT Id, Placement_Status__c
            FROM Student__c
            WHERE Id IN :studentIds
        ];

        for(Student__c student : studentsToUpdate){

            student.Placement_Status__c = 'Shortlisted';

        }

        update studentsToUpdate;

        for(Application__c app : newApplications){

            Application__c oldApp = oldMap.get(app.Id);

            if(oldApp.Status__c != 'Shortlisted' && app.Status__c == 'Shortlisted'){
                System.debug('Queueable is about to be enqueued');
                System.enqueueJob(new ApplicationPostProcessingJob(app.Id));
                NotificationService.sendApplicationEmail(app.Id);
            }

        }

    }
}