````markdown
# Placement Management System

A Salesforce-based Placement Management System designed to manage students, job opportunities, applications, placement processing, and communication with an external recruitment system.

The project was built incrementally as part of Salesforce training, starting with the platform fundamentals and gradually adding automation, Apex, Lightning Web Components, asynchronous processing, and external integration.

---

## Project Overview

The Placement Management System provides a centralized platform for managing the placement process.

The major flow is:

```text
Student
   ↓
View Eligible Jobs
   ↓
Apply for Job
   ↓
Application Created
   ↓
Application Processing
   ↓
Shortlisted
   ↓
Candidate Synchronization
   ↓
External Recruitment System
````

The application combines Salesforce declarative features with programmatic development.

---

## Main Users

The system is designed around the following users:

### Students

Students can:

* Maintain their profile
* View eligible jobs
* Apply for jobs
* View their applications
* Track application status

### Placement Officers

Placement officers can:

* Manage students
* Manage job opportunities
* Review applications
* Update application status
* Monitor placement processing
* Monitor external integration status

---

## Main Salesforce Objects

### Student

Stores student information such as:

* Student Name
* Email
* Branch
* CGPA

### Job

Stores available placement opportunities.

Important fields include:

* Job Name
* Company
* Minimum CGPA
* Last Date
* Placement Officer Email

### Application

Represents a student's application for a particular job.

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

### Offer Letter

Stores offer-related information for students who progress through the placement process.

---

## Main Features

### Student Management

Student records can be created and updated through the Student Profile Lightning Web Component.

The component uses Lightning Data Service / UI Record API operations for:

* Create
* Read
* Update
* Delete

---

### Eligible Jobs

Students can select a student profile and view jobs that match the student's eligibility criteria.

Eligibility can be based on information such as:

* CGPA
* Application deadline
* Job requirements

---

### Job Application

Students can apply for available jobs directly from the Lightning Web Component interface.

Applications are stored in `Application__c` and connected to:

```text
Student__c
Job__c
```

---

### My Applications

Students can view the applications they have submitted and track their current application status.

---

### Application Processing

Applications move through the placement process using Salesforce automation.

A key status used in the current application flow is:

```text
Applied
↓
Shortlisted
```

The system keeps the business application status separate from the external integration status.

---

## Lightning Web Components

The project contains reusable Lightning Web Components including:

```text
applicationCard
eligibleJobs
emptyState
jobCard
myApplications
placementHome
statusBadge
studentProfile
```

The components follow a reusable parent-child architecture where appropriate.

For example:

```text
Eligible Jobs
     ↓
Job Card
     ↓
Apply Event
     ↓
Parent Component
     ↓
Application Processing
```

This keeps individual components focused on specific responsibilities.

---

## Apex

Apex is used where the application requires server-side processing and business logic.

The project contains Apex classes supporting:

* Application processing
* Asynchronous processing
* External API communication
* Candidate synchronization
* Testing

---

## Asynchronous Processing

The system uses asynchronous Apex for operations that should not block the user's immediate Salesforce transaction.

The project includes patterns such as:

* Queueable Apex
* Other asynchronous processing used during the training project

The candidate synchronization specifically uses:

```text
CandidateSyncQueueable
```

which implements:

```apex
Queueable
Database.AllowsCallouts
```

---

## External Recruitment Integration

The Placement Management System communicates with an external recruitment system using a REST API.

The integration flow is:

```text
Application
    ↓
Shortlisted
    ↓
CandidateSyncQueueable
    ↓
Build Candidate JSON
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
```

The candidate payload contains information obtained from the related Student, Job and Application records.

---

## Integration Tracking

The Application object contains dedicated fields for tracking external synchronization.

### Integration Status

```text
Integration_Status__c
```

Tracks the state of the external synchronization.

Examples include:

```text
Sent
Failed
Retry Required
```

### External Candidate Id

```text
External_Candidate_Id__c
```

Stores the candidate identifier returned by the external recruitment system when available.

### Last Integration Time

```text
Last_Integration_Time__c
```

Stores the latest integration attempt time.

### Integration Error

```text
Integration_Error__c
```

Stores information about integration failures.

This allows Salesforce users to distinguish between:

```text
Business Status
```

and:

```text
Integration Status
```

---

## Error Handling

The integration handles different types of HTTP responses.

```text
2xx
↓
Success / Sent
```

```text
400
↓
Failed
```

```text
401
↓
Authentication Failure
```

```text
403
↓
Forbidden
```

```text
500–599
↓
Retry Required
```

Temporary external failures are recorded rather than silently ignored.

During development and testing, the external recruitment endpoint returned errors such as `503 Service Temporarily Unavailable`. The system recorded these failures as `Retry Required` and stored the error information in `Integration_Error__c`.

The external endpoint supplied for the training exercise was not consistently available for successful candidate creation, so successful external candidate creation cannot be represented as a guaranteed production integration.

---

## Named Credential

The external API is accessed through a Salesforce Named Credential.

Apex uses:

```text
callout:Recruitment_API/candidates
```

instead of hard-coding the external endpoint and authentication information directly into Apex.

This keeps integration configuration separate from application logic.

---

## Idempotency

Candidate synchronization includes protection against sending an application again after it has already been successfully synchronized.

The Queueable checks the integration status before processing:

```text
Integration Status = Sent
        ↓
Do not send again
```

This helps prevent duplicate candidate submissions during repeated processing.

---

## Testing

The project contains Apex tests for the candidate synchronization logic.

Important test scenarios include:

* Successful candidate synchronization
* Server error handling
* Retry-required behaviour

Queueable execution can also be verified through Salesforce's asynchronous job records.

Example:

```sql
SELECT Id, Status, JobType, ApexClass.Name
FROM AsyncApexJob
WHERE JobType = 'Queueable'
ORDER BY CreatedDate DESC
LIMIT 5
```

Integration tracking can be verified using:

```sql
SELECT
    Id,
    Status__c,
    Integration_Status__c,
    External_Candidate_Id__c,
    Last_Integration_Time__c,
    Integration_Error__c
FROM Application__c
ORDER BY CreatedDate DESC
LIMIT 5
```

---

## Project Structure

The Salesforce source follows the Salesforce DX project structure.

```text
PlacementManagement/
│
├── force-app/
│   └── main/
│       └── default/
│           ├── classes/
│           ├── flows/
│           ├── flexipages/
│           ├── layouts/
│           ├── lwc/
│           ├── objects/
│           ├── permissionsets/
│           ├── tabs/
│           └── triggers/
│
├── scripts/
│   ├── apex/
│   └── soql/
│
├── config/
├── manifest/
├── docs/
├── screenshots/
└── README.md
```

---

## Important Project Areas

### `force-app/main/default`

Contains the Salesforce metadata for the application.

### `classes`

Contains Apex classes and their metadata.

### `lwc`

Contains Lightning Web Components.

### `objects`

Contains custom Salesforce objects and their fields, list views and validation rules.

### `flows`

Contains Salesforce Flow automation.

### `triggers`

Contains Apex triggers.

### `scripts`

Contains Apex and SOQL scripts used for development and testing.

### `docs`

Contains project documentation such as:

```text
architecture
api
deployment
decisions
```

### `screenshots`

Contains selected screenshots demonstrating the important features of the completed application.

---

## Development Workflow

The project is maintained using Git and Salesforce CLI.

The intended development workflow is:

```text
Feature Branch
      ↓
Development
      ↓
Commit
      ↓
Push
      ↓
Pull Request
      ↓
Code Review
      ↓
Merge
      ↓
Deployment
      ↓
Testing
```

The Salesforce org is the execution environment, while the Git repository is the source of truth for the project's Salesforce metadata and code.

---

## Salesforce CLI

The project uses Salesforce CLI for common development activities.

Examples include:

```bash
sf data query
```

for querying Salesforce data,

```bash
sf apex run
```

for executing anonymous Apex,

```bash
sf apex run test
```

for running Apex tests,

and:

```bash
sf project deploy start
```

for deploying Salesforce metadata.

---

## Deployment

Before deployment, the target Salesforce org should always be verified.

The general deployment process is:

```text
Check Git branch
      ↓
Review changes
      ↓
Run tests
      ↓
Deploy metadata
      ↓
Verify deployment
      ↓
Perform manual testing
```

Deployment documentation is maintained separately under:

```text
docs/deployment/
```

---

## Documentation

The project documentation is organized into separate areas:

```text
docs/
│
├── architecture/
│
├── api/
│
├── deployment/
│
└── decisions/
```

### Architecture

Explains the overall Salesforce architecture and how the major components communicate.

### API

Documents the external recruitment API and candidate synchronization.

### Deployment

Documents how to set up, test and deploy the project.

### Decisions

Documents important technical decisions and the reasoning behind them.

---

## Screenshots

The `screenshots/` directory contains selected visual evidence of the main application features, including:

* Placement Home
* Student Profile
* Eligible Jobs
* Job Application
* My Applications
* Application Status
* Application Automation
* Candidate Integration / Integration Status when demonstrable
* Salesforce project structure

Screenshots are intended to demonstrate important final features rather than document every training day.

---

## Current Limitations

The external recruitment API used during the training exercise was not consistently available for successful candidate creation.

Because of this, the integration implementation and error-handling behaviour were tested, but a successful external candidate response could not be guaranteed.

The system is designed to record these failures using:

```text
Integration_Status__c
Integration_Error__c
Last_Integration_Time__c
```

and mark temporary server-side failures as:

```text
Retry Required
```

---

## Future Improvements

Possible future improvements include:

* Production recruitment API integration
* More robust retry scheduling
* Stronger idempotency using external reference keys
* Improved integration monitoring
* Centralized error logging
* Expanded Apex test coverage
* More granular security configuration
* CI/CD automation
* Automated deployment validation
* Improved student and placement officer dashboards
* Production-grade authentication and integration monitoring

---

## Final Outcome

The Placement Management System evolved from a Salesforce learning project into a complete application combining:

```text
Salesforce Data Model
        +
Declarative Automation
        +
Apex
        +
Asynchronous Apex
        +
Lightning Web Components
        +
REST API Integration
        +
Named Credentials
        +
Error Handling
        +
Testing
        +
Git Version Control
```

The project demonstrates how a Salesforce application can be developed incrementally and prepared for team-based development, testing and deployment.

The next stage is to strengthen the project with professional development practices, security, deployment processes and production-readiness considerations.

```
```
