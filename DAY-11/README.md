# Day 11 - Lightning Web Components Integration

## Objective

Continue working with Lightning Web Components and learn how to build reusable components, communicate between components, handle user input, work with Salesforce data, and connect the LWC frontend with Apex backend logic.

## Concepts Learned

- LWC component structure
- Parent to Child communication using @api
- Child to Parent communication using CustomEvent
- Lightning Data Service
- Record creation, retrieval, update and deletion
- Reactive properties and wired Apex methods
- refreshApex()
- Loading and error handling
- Empty states
- Reusable LWC components
- LWC and Apex integration
- Server-side business logic
- Building an end-to-end application flow

## Implementation

### Student Selection and Eligible Jobs

Added student selection to the Eligible Jobs component.

The selected student's Id is passed to Apex, where the student's CGPA is checked against the minimum CGPA required for each job.

Only eligible jobs are returned to the LWC.

This helped demonstrate that business rules should remain in the Apex backend instead of being implemented inside the LWC.

### Job Card Component

Created a reusable `JobCard` component.

The parent `EligibleJobs` component passes job information to the child component using `@api`.

The Job Card displays the job name, minimum CGPA and last date and provides an Apply button.

When the Apply button is clicked, the child component sends the selected job Id back to the parent using a custom event.

### Application Submission

Connected the LWC with the existing Apex application service.

The selected student and job are sent to Apex and the application is created in Salesforce.

The application result is displayed back in the LWC.

Added loading and error states while submitting an application.

### My Applications

Created a `MyApplications` component to display the applications submitted by a selected student.

The component calls Apex to retrieve applications related to the selected student.

Created a reusable `ApplicationCard` component to display:

- Job name
- Application date
- Application status

This completed the flow from applying for a job to viewing the submitted application.

### Reusable Components

Created reusable components such as:

- `JobCard`
- `ApplicationCard`
- `EmptyState`
- `StatusBadge`

These components have focused responsibilities and can be reused by other components instead of duplicating the same UI code.

### Lightning Data Service

Practiced using Lightning Data Service for working with Salesforce records.

Implemented and understood:

- `getRecord()`
- `createRecord()`
- `updateRecord()`
- `deleteRecord()`

Also understood when LDS can be used directly from LWC and when Apex is more appropriate for server-side business logic.

## Final Application Flow

The Placement Management System now follows this flow:

Student Selection

→ Student CGPA is retrieved

→ Eligible Jobs are loaded

→ Job Card displays each eligible job

→ Student clicks Apply

→ LWC sends Student Id and Job Id to Apex

→ Apex calls ApplicationService

→ Application record is created

→ My Applications retrieves the student's applications

→ Application status is displayed to the student

## Key Learnings

- LWC components should have clear and focused responsibilities.
- Parent components can pass data to child components using `@api`.
- Child components can communicate with parents using custom events.
- Business logic should remain in Apex when it involves Salesforce data or business rules.
- Lightning Data Service is useful for standard record operations directly from LWC.
- `@wire` makes Salesforce data reactive.
- `refreshApex()` can be used to refresh wired Apex data after a change.
- Loading, error and empty states make components more reliable and user friendly.
- Reusable components help avoid duplicating the same UI and logic.
- A complete Salesforce application can be built by connecting LWC, Apex services and Salesforce records together.

## Outcome

Completed the main Lightning Web Components integration for the Placement Management System.

The application now supports student selection, CGPA-based eligible jobs, reusable job cards, job applications and viewing submitted applications.

This gave me practical experience in connecting the LWC frontend with Apex backend logic and building a complete Salesforce feature from UI to database and back to the UI.