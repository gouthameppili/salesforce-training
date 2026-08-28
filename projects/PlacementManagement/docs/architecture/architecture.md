````
# Architecture Documentation

## Placement Management System

## Overview

The Placement Management System is a Salesforce-based application for managing students, job opportunities, applications, placement processing, and external candidate synchronization.

The application combines:

- Salesforce data model
- Lightning Web Components
- Apex
- Salesforce Flow
- Triggers
- Queueable Apex
- REST API integration
- Named Credentials
- Integration tracking
- Error handling

The overall architecture is:

Student  
↓  
Job  
↓  
Application  
↓  
Application Processing  
↓  
Shortlisted  
↓  
Candidate Synchronization  
↓  
External Recruitment API

---

## High-Level Architecture

```text
                    Salesforce Platform
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ↓                  ↓                  ↓
     Student             Job            Application
        │                  │                  │
        └──────────────────┼──────────────────┘
                           ↓
                  Application Processing
                           │
             ┌─────────────┴─────────────┐
             │                           │
             ↓                           ↓
        Salesforce                    LWC UI
        Automation                      │
             │                           │
             └─────────────┬─────────────┘
                           ↓
                    Application Status
                           │
                           ↓
                      Shortlisted
                           │
                           ↓
                 CandidateSyncQueueable
                           │
                           ↓
                    Named Credential
                           │
                           ↓
                External Recruitment API
````

---

## Salesforce Data Model

The main business objects are:

```text
Student__c
     │
     │
     ↓
Application__c
     ↑
     │
     │
Job__c
```

An Application connects a Student with a Job.

Therefore:

```text
Student
   ↓
Applications
   ↓
Job
```

A student can have multiple applications, and a job can receive applications from multiple students.

---

## Student

`Student__c` represents a student participating in the placement process.

Important information includes:

* Name
* Email
* Branch
* CGPA

The Student Profile LWC provides a user interface for creating, reading, updating and deleting student records.

---

## Job

`Job__c` represents a placement opportunity.

Important information includes:

* Job Name
* Company
* Minimum CGPA
* Last Date
* Placement Officer Email

Jobs are displayed to eligible students through the Lightning Web Component interface.

---

## Application

`Application__c` represents the relationship between a Student and a Job.

Important fields include:

* Student
* Job
* Status
* Application Date
* Selection Date
* Integration Status
* External Candidate Id
* Last Integration Time
* Integration Error

The Application object is central to the placement workflow.

---

## Application Lifecycle

The basic business flow is:

```text
Student
   ↓
View Jobs
   ↓
Check Eligibility
   ↓
Apply
   ↓
Application Created
   ↓
Application Processing
   ↓
Shortlisted
   ↓
Candidate Synchronization
```

The business status and integration status are maintained separately.

For example:

```text
Application Status
        ↓
    Shortlisted

Integration Status
        ↓
    Retry Required
```

This allows the business process to continue even when an external system is temporarily unavailable.

---

## Lightning Web Component Architecture

The application uses multiple reusable Lightning Web Components.

```text
Placement Home
      │
      ├── Eligible Jobs
      │       │
      │       └── Job Card
      │
      ├── Student Profile
      │
      └── My Applications
              │
              └── Application Card
```

Additional reusable components include:

* Empty State
* Status Badge

---

## Parent-Child Component Communication

The application uses parent-child communication between LWC components.

For example:

```text
Eligible Jobs
     │
     ↓
Job Card
     │
     ↓
Custom Event
     │
     ↓
Eligible Jobs
```

The child component dispatches an event when the user clicks Apply.

The parent component handles that event and performs the required application processing.

This keeps the child component focused on displaying the job while the parent handles the larger business operation.

---

## Lightning Data Service

The Student Profile component uses Salesforce UI Record API functionality for record operations.

The component supports:

```text
Create
Read
Update
Delete
```

The architecture is:

```text
Student Profile LWC
       ↓
Lightning UI Record API
       ↓
Salesforce Record
```

This avoids unnecessary custom Apex for basic record operations.

---

## Apex Layer

Apex is used where server-side processing and business logic are required.

The project contains Apex classes responsible for different operations rather than placing all logic inside one class.

This separation helps keep responsibilities clear.

The external integration is separated into dedicated services and asynchronous processing.

---

## Trigger Architecture

Application-related changes are handled through the Application trigger and supporting processing logic.

The conceptual flow is:

```text
Application Record Change
          ↓
Application Trigger
          ↓
Business Processing
          ↓
Asynchronous Processing
```

The trigger is kept focused on responding to the Salesforce record event rather than directly handling complex external communication.

---

## Asynchronous Architecture

Long-running or external operations are handled asynchronously.

The candidate synchronization uses:

```text
CandidateSyncQueueable
```

which implements:

```apex
Queueable
Database.AllowsCallouts
```

The flow is:

```text
Application
     ↓
Shortlisted
     ↓
Queueable Job
     ↓
CandidateSyncQueueable
     ↓
External API Callout
```

This prevents the user-facing transaction from depending directly on the response time of the external system.

---

## Candidate Synchronization Architecture

The candidate synchronization process retrieves the Application and related records.

```text
Application__c
      │
      ├── Student__c
      │      ├── Name
      │      ├── Email
      │      ├── Branch
      │      └── CGPA
      │
      └── Job__c
             ├── Company
             └── Job Name
```

The information is transformed into a candidate payload.

```text
Salesforce Records
       ↓
Candidate Map
       ↓
JSON Serialization
       ↓
HTTP Request
```

---

## External Integration Architecture

The external integration uses a REST API.

```text
Salesforce
     ↓
CandidateSyncQueueable
     ↓
HttpRequest
     ↓
Named Credential
     ↓
External Recruitment API
```

The endpoint is referenced using:

```text
callout:Recruitment_API/candidates
```

The actual endpoint and authentication configuration are kept outside the Apex business logic.

---

## Named Credential

The Named Credential acts as the configuration boundary between Salesforce code and the external service.

```text
Apex
  ↓
Named Credential
  ↓
Authentication / Endpoint Configuration
  ↓
External API
```

This avoids hard-coding authentication information in Apex.

---

## Integration Response Flow

After the callout, the response is evaluated.

```text
HTTP Response
      │
      ├── 2xx
      │     ↓
      │    Sent
      │
      ├── 400
      │     ↓
      │    Failed
      │
      ├── 401
      │     ↓
      │    Failed
      │
      ├── 403
      │     ↓
      │    Failed
      │
      └── 5xx
            ↓
       Retry Required
```

The integration result is stored on the Application record.

---

## Integration Monitoring

The Application contains dedicated fields for monitoring the external integration.

```text
Integration_Status__c
External_Candidate_Id__c
Last_Integration_Time__c
Integration_Error__c
```

The architecture is:

```text
External API Response
        ↓
Integration Processing
        ↓
Application__c
        │
        ├── Integration Status
        ├── External Candidate Id
        ├── Last Integration Time
        └── Integration Error
```

This allows administrators to understand the current state of synchronization.

---

## Error Handling

External communication can fail even when Salesforce is operating normally.

The architecture therefore records integration failures instead of allowing them to disappear.

Example:

```text
External API
     ↓
503 Server Error
     ↓
CandidateSyncQueueable
     ↓
Integration Status = Retry Required
     ↓
Integration Error recorded
```

The external recruitment API used during the training exercise was not consistently available for successful candidate creation. Therefore, the architecture supports and records failure states such as `Retry Required`.

---

## Idempotency

The candidate synchronization process includes a basic idempotency check.

```text
Application
     ↓
Check Integration Status
     ↓
Already Sent?
   /       \
 Yes        No
  ↓          ↓
Stop      Send Candidate
```

If the Application has already been successfully synchronized, the Queueable does not send the candidate again.

This reduces the possibility of duplicate external candidate records.

---

## Testing Architecture

The integration has dedicated Apex tests.

```text
CandidateSyncQueueable
          ↓
CandidateSyncQueueableTest
```

The tests verify important scenarios such as:

* Successful synchronization
* Server error handling
* Retry-required behaviour

Asynchronous jobs can also be inspected through `AsyncApexJob`.

---

## Project Layers

The application can be viewed as several logical layers.

```text
┌─────────────────────────────┐
│        User Interface       │
│            LWC              │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│      Salesforce Logic       │
│      Apex / Triggers        │
│          Flows              │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│       Salesforce Data       │
│ Student / Job / Application │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│     Async Processing        │
│     Queueable Apex          │
└──────────────┬──────────────┘
               ↓
┌─────────────────────────────┐
│       Integration           │
│ Named Credential / REST API │
└─────────────────────────────┘
```

---

## Development and Deployment Architecture

The project is maintained using Git and Salesforce CLI.

```text
Developer
    ↓
Feature Branch
    ↓
Code Changes
    ↓
Git Commit
    ↓
Push
    ↓
Pull Request
    ↓
Code Review
    ↓
Merge
    ↓
Salesforce Deployment
    ↓
Testing
```

The Git repository represents the source-controlled project, while the Salesforce org is the environment where the application runs.

---

## Architecture Principles

The project follows several important design principles:

### Separation of Responsibilities

Different components have different responsibilities.

```text
LWC
↓
User Interface

Apex
↓
Server-side Logic

Queueable
↓
Asynchronous Processing

Named Credential
↓
External Integration Configuration
```

### Asynchronous Integration

External API communication is handled asynchronously so the user transaction does not have to wait for the external service.

### Error Visibility

Integration failures are stored on the Application rather than being silently ignored.

### Reusability

Common UI behaviour is separated into reusable Lightning Web Components.

### Maintainability

Business logic, UI logic, asynchronous processing and integration responsibilities are separated as much as practical for the project.

---

## Final Architecture

The complete application can be represented as:

```text
                         Placement Management System

                                  Student
                                     │
                                     ↓
                                  Job
                                     │
                                     ↓
                               Application
                                     │
                   ┌─────────────────┴─────────────────┐
                   │                                   │
                   ↓                                   ↓
              Salesforce UI                     Salesforce Automation
                   │                                   │
                   ↓                                   ↓
                  LWC                         Apex / Flow / Trigger
                   │                                   │
                   └─────────────────┬─────────────────┘
                                     ↓
                              Application Status
                                     │
                                     ↓
                                Shortlisted
                                     │
                                     ↓
                          CandidateSyncQueueable
                                     │
                                     ↓
                              Candidate JSON
                                     │
                                     ↓
                              Named Credential
                                     │
                                     ↓
                         Recruitment REST API
                                     │
                                     ↓
                              HTTP Response
                                     │
                                     ↓
                         Integration Tracking
                                     │
                                     ↓
                              Application__c
```

## Conclusion

The Placement Management System combines Salesforce declarative development, Apex programming, Lightning Web Components, asynchronous processing and external integration into a single application.

The architecture separates the user interface, Salesforce business logic, data model, asynchronous processing and external communication so that each part has a clear responsibility.

The result is a Salesforce application that demonstrates not only how to build features, but also how those features interact across the platform and with an external system.

```
```
