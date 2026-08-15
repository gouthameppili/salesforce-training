public class RecruitmentApiService {

    public static void sendTestCandidate() {

        HttpRequest request = new HttpRequest();

        request.setEndpoint('callout:Recruitment_API/post');

        request.setMethod('POST');

        request.setHeader(
            'Content-Type',
            'application/json'
        );

        String requestBody = JSON.serialize(
            new Map<String, Object>{
                'studentId' => 'STU001',
                'name' => 'Goutham',
                'cgpa' => 8.5,
                'jobId' => 'JOB001',
                'role' => 'Salesforce Developer'
            }
        );

        request.setBody(requestBody);

        Http http = new Http();

        try {

            HttpResponse response = http.send(request);

            System.debug(
                'Status Code: ' +
                response.getStatusCode()
            );

            System.debug(
                'Response Body: ' +
                response.getBody()
            );

        } catch (Exception e) {

            System.debug(
                'Callout Error: ' +
                e.getMessage()
            );
        }
    }
}