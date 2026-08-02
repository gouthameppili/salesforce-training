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

}