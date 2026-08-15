# Day 12 - External Recruitment Integration

## Objective
Learn how Salesforce communicates with external systems using REST APIs and build an external recruitment integration for the Placement Management System to send candidate details to an external recruitment platform asynchronously.

## Concepts Learned
- API and API contracts
- REST APIs and HTTP methods (GET, POST, PUT, PATCH, DELETE)
- HTTP requests, responses, and JSON serialization
- HTTP status codes (2xx, 400, 401, 403, 5xx)
- Apex HTTP callouts (`HttpRequest`, `Http`, `HttpResponse`)
- Named Credentials and Auth Providers
- Authentication vs Authorisation
- Queueable Apex with callouts (`Database.AllowsCallouts`)
- Integration status tracking and error handling
- Retry handling and idempotency strategies
- Salesforce Connect and External Objects
- Point-to-point integration vs Middleware architecture
- Synchronous vs Asynchronous integration patterns

## Implementation

### REST API Fundamentals & API Contract
Learned that an API acts as a structured communication contract between independent systems without exposing internal database structures.

Created an API contract for sending selected candidate details to the external recruitment system:

**Endpoint:** `POST /candidates`
**Headers:** `Content-Type: application/json`

**Request Body (JSON):**
```json
{
  "studentId": "STU10045",
  "studentName": "Ananya",
  "email": "ananya@example.com",
  "branch": "CSE",
  "cgpa": 8.4,
  "jobId": "JOB1007",
  "company": "KSquare",
  "role": "Salesforce Developer",
  "selectionDate": "2026-08-11"
}
```

### Named Credentials Configuration
Configured a Named Credential (`Recruitment_API`) to manage external endpoint details and authentication credentials outside of Apex source code:

```
callout:Recruitment_API/candidates
```

This pattern separates platform configuration from business code, enhancing security and preventing secrets from leaking into version control repositories.

### Queueable Apex Callout Implementation
Created `CandidateSyncQueueable` to handle external HTTP callouts in the background, ensuring users are not blocked during standard UI operations.

- Implemented `Queueable` and `Database.AllowsCallouts` interfaces.
- Queried related `Student__c`, `Job__c`, and `Application__c` record data.
- Built and serialized the candidate JSON payload.
- Executed the HTTP POST callout **before** updating database records to avoid `System.CalloutException: You have uncommitted work pending`.

### Integration Tracking & Error Handling
Added tracking fields to `Application__c` to decouple business status from integration status:

- `Integration_Status__c` (Pending, Sent, Failed, Retry Required)
- `External_Candidate_Id__c`
- `Last_Integration_Time__c`
- `Integration_Error__c`

Mapped HTTP status responses directly to integration states:

| Status Range | Meaning | Resulting Integration Status |
|---|---|---|
| 2xx | Success | `Sent` — store `External_Candidate_Id__c` |
| 400 / 401 / 403 | Client Errors | `Failed` — capture error message |
| 500–599 | Server Errors (e.g., 503 Unavailable) | `Retry Required` — allow re-processing |

### Retry Logic & Idempotency Safeguards
Designed retry handling to ensure transient external network or server errors do not cause permanent business failures.

To prevent duplicate records on external systems during retries, implemented an idempotency check:
- If `Integration_Status__c == 'Sent'`, skip candidate re-transmission.
- Combined Application Id and External Candidate Id as unique transactional identifiers.

### Testing and Verification
- Wrote `CandidateSyncQueueableTest` using `HttpCalloutMock` to verify both success and server-error retry pathways.
- Executed manual verification via Salesforce CLI:
```bash
sf apex run --file scripts/apex/testCandidateSync.apex --target-org placement
```
- Queried `AsyncApexJob` and `Application__c` via SOQL to verify job completion and field status updates.

### Integration Architecture & Patterns
- **Point-to-Point vs Middleware:** Evaluated point-to-point connections for simple integrations versus middleware platforms (e.g., MuleSoft) for enterprise multi-system routing, transformation, and orchestration.
- **Synchronous vs Asynchronous:** Used asynchronous execution because candidate sync is secondary to the primary Salesforce transaction.
- **Data Virtualization vs Copying:** Compared data replication against Salesforce Connect and External Objects for real-time external data viewing without local storage.

## Final Application Flow

```
Application Status updated to Shortlisted
  → CandidateSyncQueueable queued with Application Id
  → Query Application, Student, and Job details
  → Build JSON candidate payload
  → Reference Named Credential (callout:Recruitment_API/candidates)
  → Execute Http.send(HttpRequest)
  → Process HTTP Response status code
  → Update Integration_Status__c, Last_Integration_Time__c, and Integration_Error__c on Application__c
```

## Key Learnings
- APIs define structural communication contracts between independent systems.
- Callouts in Apex must never hard-code credentials; Named Credentials decouple endpoint configuration from code.
- Asynchronous Apex (Queueable with `Database.AllowsCallouts`) prevents UI blocking and handles long-running integration tasks.
- HTTP callouts must take place before DML operations within the same transaction context to avoid uncommitted work exceptions.
- Business status must be tracked separately from integration status.
- HTTP status codes dictate downstream handling: 2xx (Success), 4xx (Client/Auth failure), 5xx (Server error / Retryable).
- Idempotency ensures that retrying failed integration requests does not produce duplicate records.
- Middleware and External Objects provide scalable architecture options when scaling across enterprise systems.

## Outcome
Successfully built an end-to-end external recruitment integration for the Placement Management System. The application automatically serializes candidate records and transmits them asynchronously to an external system using Queueable Apex, HTTP callouts, and Named Credentials. It robustly tracks synchronization state, handles HTTP errors, supports retry processing, and enforces idempotency.



