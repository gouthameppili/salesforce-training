public with sharing class DashboardController {

    /*
     * Dashboard statistics
     */
    public class DashboardStats {
        @AuraEnabled public Integer companyCount;
        @AuraEnabled public Integer jobCount;
        @AuraEnabled public Integer applicationCount;

        public DashboardStats(
            Integer companyCount,
            Integer jobCount,
            Integer applicationCount
        ) {
            this.companyCount = companyCount;
            this.jobCount = jobCount;
            this.applicationCount = applicationCount;
        }
    }


    /*
     * Get dashboard statistics from actual Salesforce data.
     */
    @AuraEnabled(cacheable=true)
    public static DashboardStats getDashboardStats() {

        List<Job__c> jobs = [
            SELECT Id, Company__c
            FROM Job__c
        ];

        Set<String> companies = new Set<String>();

        for (Job__c job : jobs) {

            if (String.isNotBlank(job.Company__c)) {
                companies.add(job.Company__c);
            }
        }

        Integer applicationCount = [
            SELECT COUNT()
            FROM Application__c
        ];

        return new DashboardStats(
            companies.size(),
            jobs.size(),
            applicationCount
        );
    }


    /*
     * Get all jobs for the main dashboard.
     */
    @AuraEnabled(cacheable=true)
    public static List<Job__c> getDashboardJobs() {

        return [
            SELECT Id,
                   Name,
                   Company__c,
                   Minimum_CGPA__c,
                   Last_Date__c
            FROM Job__c
            ORDER BY Last_Date__c ASC
        ];
    }


    /*
     * Get all students.
     */
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


    /*
     * Get eligible jobs for a selected student.
     *
     * This method is kept separate because the
     * Eligible Jobs component uses student eligibility.
     */
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


    /*
     * Submit an application.
     */
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


    /*
     * Get applications for a selected student.
     */
    @AuraEnabled(cacheable=true)
    public static List<Application__c> getMyApplications(
        Id studentId
    ) {

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