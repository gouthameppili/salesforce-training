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
    public static List<Job__c> getJobs() {

        return [
            SELECT Id,
                Name,
                Minimum_CGPA__c,
                Last_Date__c
            FROM Job__c
            ORDER BY Name
        ];

    }

}