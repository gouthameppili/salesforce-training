@IsTest
private class ApplicationServiceTest {

    /*
     * Create common Student test data.
     */
    private static Student__c createStudent(Decimal cgpa) {

        Student__c student = new Student__c(
            Name = 'Test Student',
            Email__c = 'student@test.com',
            Branch__c = 'CSE',
            CGPA__c = cgpa
        );

        insert student;

        return student;
    }


    /*
     * Create common Job test data.
     */
    private static Job__c createJob(
        Decimal minimumCgpa,
        Date lastDate
    ) {

        Job__c job = new Job__c(
            Name = 'Test Salesforce Developer',
            Company__c = 'Test Company',
            Minimum_CGPA__c = minimumCgpa,
            Last_Date__c = lastDate,
            Placement_Officer_Email__c = 'placement@test.com'
        );

        insert job;

        return job;
    }


    /*
     * TEST 1
     *
     * Successful application submission.
     */
    @IsTest
    static void testSuccessfulApplicationSubmission() {

        Student__c student = createStudent(8.50);

        Job__c job = createJob(
            7.00,
            Date.today().addDays(10)
        );

        Test.startTest();

        String result =
            ApplicationService.submitApplication(
                student.Id,
                job.Id
            );

        Test.stopTest();

        Application__c application = [
            SELECT Id,
                   Student__c,
                   Job__c,
                   Status__c,
                   Application_Date__c
            FROM Application__c
            WHERE Student__c = :student.Id
            AND Job__c = :job.Id
            LIMIT 1
        ];

        System.assertEquals(
            'Application Submitted Successfully',
            result
        );

        System.assertEquals(
            student.Id,
            application.Student__c
        );

        System.assertEquals(
            job.Id,
            application.Job__c
        );

        System.assertEquals(
            'Applied',
            application.Status__c
        );
    }


    /*
     * TEST 2
     *
     * Student CGPA below job requirement.
     */
    @IsTest
    static void testApplicationRejectedForLowCgpa() {

        Student__c student = createStudent(6.50);

        Job__c job = createJob(
            7.50,
            Date.today().addDays(10)
        );

        Test.startTest();

        String result =
            ApplicationService.submitApplication(
                student.Id,
                job.Id
            );

        Test.stopTest();

        System.assertEquals(
            'Student CGPA is below the minimum required CGPA.',
            result
        );

        System.assertEquals(
            0,
            [
                SELECT COUNT()
                FROM Application__c
                WHERE Student__c = :student.Id
                AND Job__c = :job.Id
            ]
        );
    }


    /*
     * TEST 3
     *
     * Application deadline has passed.
     */
    @IsTest
    static void testApplicationRejectedAfterDeadline() {

        Student__c student = createStudent(8.50);

        Job__c job = createJob(
            7.00,
            Date.today().addDays(-1)
        );

        Test.startTest();

        String result =
            ApplicationService.submitApplication(
                student.Id,
                job.Id
            );

        Test.stopTest();

        System.assertEquals(
            'Application deadline has passed.',
            result
        );

        System.assertEquals(
            0,
            [
                SELECT COUNT()
                FROM Application__c
                WHERE Student__c = :student.Id
                AND Job__c = :job.Id
            ]
        );
    }


    /*
     * TEST 4
     *
     * Duplicate application prevention.
     */
    @IsTest
    static void testDuplicateApplicationRejected() {

        Student__c student = createStudent(8.50);

        Job__c job = createJob(
            7.00,
            Date.today().addDays(10)
        );

        ApplicationService.submitApplication(
            student.Id,
            job.Id
        );

        Test.startTest();

        String result =
            ApplicationService.submitApplication(
                student.Id,
                job.Id
            );

        Test.stopTest();

        System.assertEquals(
            'Student has already applied for this job.',
            result
        );

        System.assertEquals(
            1,
            [
                SELECT COUNT()
                FROM Application__c
                WHERE Student__c = :student.Id
                AND Job__c = :job.Id
            ]
        );
    }


    /*
     * TEST 5
     *
     * Application status update.
     */
    @IsTest
    static void testUpdateApplicationStatus() {

        Student__c student = createStudent(8.50);

        Job__c job = createJob(
            7.00,
            Date.today().addDays(10)
        );

        Application__c application = new Application__c(
            Name = 'Status Test Application',
            Student__c = student.Id,
            Job__c = job.Id,
            Status__c = 'Applied',
            Application_Date__c = Date.today()
        );

        insert application;

        Test.startTest();

        String result =
            ApplicationService.updateApplicationStatus(
                application.Id,
                'Shortlisted'
            );

        Test.stopTest();

        Application__c updatedApplication = [
            SELECT Status__c
            FROM Application__c
            WHERE Id = :application.Id
        ];

        System.assertEquals(
            'Application Status Updated Successfully',
            result
        );

        System.assertEquals(
            'Shortlisted',
            updatedApplication.Status__c
        );
    }


    /*
     * TEST 6
     *
     * Bulk validation.
     *
     * Multiple applications are passed to the
     * validation method in a single transaction.
     */
    @IsTest
    static void testBulkApplicationValidation() {

        Student__c student1 = createStudent(8.50);
        Student__c student2 = createStudent(8.00);

        Job__c job = createJob(
            7.00,
            Date.today().addDays(10)
        );

        List<Application__c> applications =
            new List<Application__c>();

        applications.add(
            new Application__c(
                Name = 'Bulk Application 1',
                Student__c = student1.Id,
                Job__c = job.Id,
                Application_Date__c = Date.today()
            )
        );

        applications.add(
            new Application__c(
                Name = 'Bulk Application 2',
                Student__c = student2.Id,
                Job__c = job.Id,
                Application_Date__c = Date.today()
            )
        );

        Test.startTest();

        ApplicationService.validateApplications(
            applications
        );

        Test.stopTest();

        System.assertEquals(
            'Applied',
            applications[0].Status__c
        );

        System.assertEquals(
            'Applied',
            applications[1].Status__c
        );
    }
}