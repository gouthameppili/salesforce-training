public class CandidateSyncQueueable implements Queueable, Database.AllowsCallouts {

    private Id applicationId;

    public CandidateSyncQueueable(Id applicationId) {
        this.applicationId = applicationId;
    }

    public void execute(QueueableContext context) {

        Application__c application = [
            SELECT Id,
                   Student__c,
                   Student__r.Name,
                   Student__r.Email__c,
                   Student__r.Branch__c,
                   Student__r.CGPA__c,
                   Job__c,
                   Job__r.Name,
                   Job__r.Company__c,
                   Status__c,
                   Selection_Date__c,
                   Integration_Status__c,
                   External_Candidate_Id__c,
                   Last_Integration_Time__c,
                   Integration_Error__c
            FROM Application__c
            WHERE Id = :applicationId
            LIMIT 1
        ];

        /*
         * Idempotency protection.
         *
         * If this application was already successfully
         * synchronized, don't send it again.
         */
        if (application.Integration_Status__c == 'Sent') {

            System.debug(
                'Application already synchronized: ' +
                application.Id
            );

            return;
        }

        /*
         * Build candidate payload.
         */
        Map<String, Object> candidate =
            new Map<String, Object>{

                'studentId' =>
                    application.Student__c,

                'name' =>
                    application.Student__r.Name,

                'email' =>
                    application.Student__r.Email__c,

                'branch' =>
                    application.Student__r.Branch__c,

                'cgpa' =>
                    application.Student__r.CGPA__c,

                'jobId' =>
                    application.Job__c,

                'company' =>
                    application.Job__r.Company__c,

                'role' =>
                    application.Job__r.Name,

                'selectionDate' =>
                    application.Selection_Date__c
            };

        String requestBody =
            JSON.serialize(candidate);

        HttpRequest request =
            new HttpRequest();

        request.setEndpoint('callout:Recruitment_API/candidates');

        request.setMethod('POST');

        request.setHeader(
            'Content-Type',
            'application/json'
        );

        request.setBody(requestBody);

        Http http = new Http();

        /*
         * IMPORTANT:
         *
         * No DML before this callout.
         */
        try {

            HttpResponse response =
                http.send(request);

            Integer statusCode =
                response.getStatusCode();

            String responseBody =
                response.getBody();

            System.debug(
                'Candidate Sync Status: ' +
                statusCode
            );

            System.debug(
                'Candidate Sync Response: ' +
                responseBody
            );

            /*
             * SUCCESS
             */
            if (
                statusCode >= 200 &&
                statusCode < 300
            ) {

                application.Integration_Status__c =
                    'Sent';

                application.Last_Integration_Time__c =
                    System.now();

                application.Integration_Error__c =
                    null;

                /*
                 * Try to capture external Id.
                 */
                try {

                    if (String.isNotBlank(responseBody)) {

                        Map<String, Object> responseData =
                            (Map<String, Object>)
                            JSON.deserializeUntyped(
                                responseBody
                            );

                        if (
                            responseData.containsKey('id')
                        ) {

                            application.External_Candidate_Id__c =
                                String.valueOf(
                                    responseData.get('id')
                                );

                        } else if (
                            responseData.containsKey(
                                'candidateId'
                            )
                        ) {

                            application.External_Candidate_Id__c =
                                String.valueOf(
                                    responseData.get(
                                        'candidateId'
                                    )
                                );

                        } else if (
                            responseData.containsKey(
                                'externalCandidateId'
                            )
                        ) {

                            application.External_Candidate_Id__c =
                                String.valueOf(
                                    responseData.get(
                                        'externalCandidateId'
                                    )
                                );
                        }
                    }

                } catch (Exception parseException) {

                    System.debug(
                        'Response parsing warning: ' +
                        parseException.getMessage()
                    );
                }
            }

            /*
             * BAD REQUEST
             */
            else if (statusCode == 400) {

                application.Integration_Status__c =
                    'Failed';

                application.Integration_Error__c =
                    '400 Bad Request: ' +
                    responseBody;

                application.Last_Integration_Time__c =
                    System.now();
            }

            /*
             * AUTHENTICATION FAILURE
             */
            else if (statusCode == 401) {

                application.Integration_Status__c =
                    'Failed';

                application.Integration_Error__c =
                    '401 Authentication Failure: ' +
                    responseBody;

                application.Last_Integration_Time__c =
                    System.now();
            }

            /*
             * FORBIDDEN
             */
            else if (statusCode == 403) {

                application.Integration_Status__c =
                    'Failed';

                application.Integration_Error__c =
                    '403 Forbidden: ' +
                    responseBody;

                application.Last_Integration_Time__c =
                    System.now();
            }

            /*
             * SERVER ERROR
             */
            else if (
                statusCode >= 500 &&
                statusCode < 600
            ) {

                application.Integration_Status__c =
                    'Retry Required';

                application.Integration_Error__c =
                    statusCode +
                    ' Server Error: ' +
                    responseBody;

                application.Last_Integration_Time__c =
                    System.now();
            }

            /*
             * UNEXPECTED RESPONSE
             */
            else {

                application.Integration_Status__c =
                    'Failed';

                application.Integration_Error__c =
                    'Unexpected HTTP ' +
                    statusCode +
                    ': ' +
                    responseBody;

                application.Last_Integration_Time__c =
                    System.now();
            }

            /*
             * DML happens AFTER the callout.
             */
            update application;

        } catch (Exception e) {

            /*
             * The callout itself failed.
             *
             * Now it is safe to perform DML because
             * the callout attempt has already completed.
             */
            application.Integration_Status__c =
                'Retry Required';

            application.Integration_Error__c =
                'Callout Exception: ' +
                e.getMessage();

            application.Last_Integration_Time__c =
                System.now();

            update application;

            System.debug(
                'Candidate Sync Error: ' +
                e.getMessage()
            );
        }
    }
}