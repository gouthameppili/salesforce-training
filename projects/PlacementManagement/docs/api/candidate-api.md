# Candidate API Contract

## 1. Purpose

The Placement Management System sends shortlisted candidate information from
Salesforce to an external recruitment platform.

The integration is performed through a REST API using a `POST` request to the
candidate endpoint.

---

## 2. Endpoint

**HTTP Method**

POST

**Endpoint**

`/candidates`

Salesforce accesses the endpoint through the Named Credential:

`Recruitment_API`

Apex references the endpoint as:

`callout:Recruitment_API/candidates`

The actual external URL and authentication configuration are maintained
outside the Apex code.

---

## 3. Request

Headers

```text
Content-Type: application/json
Request Body

The candidate information is sent as JSON.

{
  "studentId": "Salesforce Student Id",
  "name": "Student Name",
  "email": "Student Email",
  "branch": "Student Branch",
  "cgpa": 8.50,
  "jobId": "Salesforce Job Id",
  "company": "Company Name",
  "role": "Job Role",
  "selectionDate": "2026-08-11"
}
Request Fields
| Field           | Description                                 |
| --------------- | ------------------------------------------- |
| `studentId`     | Id of the Salesforce Student record         |
| `name`          | Name of the student                         |
| `email`         | Email address of the student                |
| `branch`        | Academic branch of the student              |
| `cgpa`          | CGPA of the student                         |
| `jobId`         | Id of the Salesforce Job record             |
| `company`       | Company associated with the job             |
| `role`          | Name of the job/role                        |
| `selectionDate` | Date on which the candidate was shortlisted |


These are the candidate details required by the recruitment integration.

## 4. Request Construction

The request is created using Salesforce HttpRequest.

The implementation:

Creates the candidate data.
Serializes the data into JSON.
Sets the Named Credential endpoint.
Sets the HTTP method to POST.
Sets the Content-Type header.
Sends the request using Http.send().

JSON serialization is used instead of manually constructing a JSON string.

## 5. Success Response

A successful response indicates that the candidate was accepted by the
external recruitment system.

The Salesforce integration treats a successful 2xx HTTP response as
successful synchronization.

The Application is then updated with:

Integration_Status__c = Sent

The latest integration time is recorded in:

Last_Integration_Time__c

If the response contains an external candidate identifier, Salesforce stores
it in:

External_Candidate_Id__c

The implementation can read an external identifier returned using one of the
following response fields:

id
candidateId
externalCandidateId

## 6. Error Responses

The integration distinguishes different types of failures instead of treating
every non-success response as the same error.

400 — Bad Request

The request sent to the external API is invalid.

Salesforce records:

Integration_Status__c = Failed

The response details are stored in:

Integration_Error__c
401 — Authentication Failure

The external API could not authenticate the request.

Salesforce records:

Integration_Status__c = Failed

The authentication configuration should be investigated.

403 — Forbidden

The request was not permitted by the external system.

Salesforce records:

Integration_Status__c = Failed

The permissions or authorisation configuration should be investigated.

500 — Server Error

A server-side error indicates that the external system may be temporarily
unavailable.

Salesforce records:

Integration_Status__c = Retry Required

The error response is stored in:

Integration_Error__c

and the latest attempt time is stored in:

Last_Integration_Time__c

The same retry-oriented handling applies to other 5xx server responses.

## 7. Integration Status

The Application record maintains the state of the external synchronization.

Pending
Sent
Failed
Retry Required

This allows the Salesforce system to distinguish between the business status
of the Application and the status of its external synchronization.

The instructor specifically expects integration state such as Pending,
Sent, Failed, and Retry Required to be considered when designing for
external-system failures.

## 8. Authentication

Authentication is handled through the Salesforce Named Credential rather than
being hard-coded in Apex.

The integration follows this architecture:

Apex
  ↓
Named Credential
  ↓
Authentication
  ↓
External API

Credentials such as access tokens, passwords, and secrets should not be
embedded in Apex code.

## 9. Integration Flow
Application
    ↓
Status = Shortlisted
    ↓
Queueable Job
    ↓
Build Candidate Request
    ↓
Named Credential
    ↓
POST /candidates
    ↓
External Recruitment API
    ↓
Process Response
    ↓
Update Integration Status

The instructor's required integration architecture follows the same pattern:
application status → Queueable → request → Named Credential → REST API →
response processing.

## 10. Failure and Retry Behaviour

A temporary external failure should not remove or undo the Salesforce business
event.

For example:

Salesforce
    ↓
Candidate shortlisted
    ↓
External API
    ↓
503 Server Error

The candidate remains shortlisted while the integration records:

Integration_Status__c = Retry Required

This separates the Salesforce business state from the external integration
state.

A future retry process can identify records requiring another synchronization
attempt.

Retries must also consider idempotency because blindly submitting the same
candidate multiple times could create duplicates.

## 11. API Contract Summary
| Item                   | Details                                  |
| ---------------------- | ---------------------------------------- |
| Method                 | `POST`                                   |
| Endpoint               | `/candidates`                            |
| Content Type           | `application/json`                       |
| Authentication         | Salesforce Named Credential              |
| Request Format         | JSON                                     |
| Success                | `2xx` → `Sent`                           |
| Bad Request            | `400` → `Failed`                         |
| Authentication Failure | `401` → `Failed`                         |
| Forbidden              | `403` → `Failed`                         |
| Server Error           | `5xx` → `Retry Required`                 |
| Integration Tracking   | Status, External Id, Last Attempt, Error |

12. Design Principle

The API contract defines the agreement between Salesforce and the external
recruitment system:

Request
   ↓
External API
   ↓
Response
   ↓
Salesforce Integration State

The contract makes the endpoint, request structure, expected success behaviour,
and likely error responses clear before and during implementation.

This contract is part of the project documentation as required for the
external recruitment integration