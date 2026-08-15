@IsTest
private class CandidateSyncQueueableTest {

    /*
     * Mock successful external API response.
     */
    private class SuccessMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {

            HttpResponse response = new HttpResponse();

            response.setStatusCode(201);
            response.setHeader(
                'Content-Type',
                'application/json'
            );

            response.setBody(
                '{"id":"EXT-CAND-1001","status":"created"}'
            );

            return response;
        }
    }


    /*
     * Mock server error response.
     */
    private class ServerErrorMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {

            HttpResponse response = new HttpResponse();

            response.setStatusCode(503);

            response.setHeader(
                'Content-Type',
                'application/json'
            );

            response.setBody(
                '{"error":"Service temporarily unavailable"}'
            );

            return response;
        }
    }


    /*
     * Create common test data.
     */
    private static Application__c createApplication() {

        Student__c student = new Student__c(
            Name = 'Test Student',
            Email__c = 'test.student@example.com',
            Branch__c = 'CSE',
            CGPA__c = 8.50
        );

        insert student;


        Job__c job = new Job__c(
            Name = 'Test Developer Job',
            Company__c = 'Test Company',
            Minimum_CGPA__c = 7.00,
            Last_Date__c = Date.today().addDays(10),
            Placement_Officer_Email__c = 'placement.test@example.com'
        );

        insert job;


        Application__c application = new Application__c(
            Name = 'Test Application',
            Student__c = student.Id,
            Job__c = job.Id,
            Status__c = 'Shortlisted',
            Application_Date__c = Date.today(),
            Selection_Date__c = Date.today(),
            Integration_Status__c = null
        );

        insert application;

        return application;
    }


    /*
     * TEST 1
     *
     * 201 Created
     *
     * Expected:
     * Integration Status = Sent
     * External Candidate Id populated
     * Last Integration Time populated
     * Integration Error empty
     */
    @IsTest
    static void testSuccessfulCandidateSync() {

        Application__c application =
            createApplication();


        Test.setMock(
            HttpCalloutMock.class,
            new SuccessMock()
        );


        Test.startTest();

        System.enqueueJob(
            new CandidateSyncQueueable(
                application.Id
            )
        );

        Test.stopTest();


        Application__c result = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c,
                   Last_Integration_Time__c,
                   Integration_Error__c
            FROM Application__c
            WHERE Id = :application.Id
        ];


        System.assertEquals(
            'Sent',
            result.Integration_Status__c,
            'Successful API response should mark integration as Sent.'
        );


        System.assertEquals(
            'EXT-CAND-1001',
            result.External_Candidate_Id__c,
            'External candidate Id should be captured.'
        );


        System.assertNotEquals(
            null,
            result.Last_Integration_Time__c,
            'Last integration time should be populated.'
        );


        System.assertEquals(
            null,
            result.Integration_Error__c,
            'Successful integration should not contain an error.'
        );
    }


    /*
     * TEST 2
     *
     * 503 Server Error
     *
     * Expected:
     * Integration Status = Retry Required
     * Error message populated
     * Last Integration Time populated
     */
    @IsTest
    static void testServerErrorRequiresRetry() {

        Application__c application =
            createApplication();


        Test.setMock(
            HttpCalloutMock.class,
            new ServerErrorMock()
        );


        Test.startTest();

        System.enqueueJob(
            new CandidateSyncQueueable(
                application.Id
            )
        );

        Test.stopTest();


        Application__c result = [
            SELECT Id,
                   Integration_Status__c,
                   External_Candidate_Id__c,
                   Last_Integration_Time__c,
                   Integration_Error__c
            FROM Application__c
            WHERE Id = :application.Id
        ];


        System.assertEquals(
            'Retry Required',
            result.Integration_Status__c,
            '5xx response should require a retry.'
        );


        System.assert(
            result.Integration_Error__c.contains('503'),
            'Integration error should contain the HTTP status.'
        );


        System.assertNotEquals(
            null,
            result.Last_Integration_Time__c,
            'Last integration time should be populated.'
        );
    }
}