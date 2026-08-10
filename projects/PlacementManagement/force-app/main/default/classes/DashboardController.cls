public with sharing class DashboardController {

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {

        return [
            SELECT Id,
                   Name,
                   CGPA__c
            FROM Student__c
            ORDER BY Name
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Job__c> getJobs(Id studentId) {

        if (studentId == null) {
            return new List<Job__c>();
        }

        Student__c student = [
            SELECT CGPA__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];

        return [
            SELECT Id,
                   Name,
                   Minimum_CGPA__c,
                   Last_Date__c
            FROM Job__c
            WHERE Minimum_CGPA__c <= :student.CGPA__c
            ORDER BY Last_Date__c ASC
        ];
    }

    @AuraEnabled
    public static String submitApplication(
        Id studentId,
        Id jobId
    ) {

        return ApplicationService.submitApplication(
            studentId,
            jobId
        );
    }

    @AuraEnabled(cacheable=true)
    public static List<Application__c> getMyApplications(Id studentId) {

    if (studentId == null) {
        return new List<Application__c>();
    }

    return [
        SELECT Id,
               Name,
               Application_Date__c,
               Status__c,
               Student__c,
               Job__c,
               Job__r.Name
        FROM Application__c
        WHERE Student__c = :studentId
        ORDER BY Application_Date__c DESC
    ];
}
}