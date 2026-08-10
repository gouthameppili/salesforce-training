# Day 10 - LWC and Apex Integration

## Objective

Learn how Lightning Web Components communicate with Apex and how multiple LWC components can communicate with each other in a real Salesforce application.

## Concepts Learned

- LWC and Apex integration
- @wire
- Imperative Apex
- Apex Controller
- Service Layer integration
- Parent to Child communication
- Child to Parent communication
- @api
- Custom Events
- dispatchEvent()
- Component Composition
- Handling Apex responses in LWC

## Implementation

### LWC and Apex Integration

Connected the Eligible Jobs LWC with the existing Apex Controller to retrieve actual Job records from Salesforce.

The component uses `@wire` to retrieve job data and display it dynamically instead of using mock data.

### Application Submission

Implemented the Apply functionality using imperative Apex.

The flow is:

LWC

↓

DashboardController

↓

ApplicationService

↓

Business Validation

↓

Application Record

↓

Response back to LWC

The application result is displayed directly to the student in the UI.

### Parent and Child Components

Created a separate `jobCard` component to display individual job records.

The `eligibleJobs` component acts as the parent component and passes each Job record to the child component.

### Parent to Child Communication

Used `@api` to pass the Job record from `eligibleJobs` to `jobCard`.

### Child to Parent Communication

Used `CustomEvent` and `dispatchEvent()` to notify the parent component when the student clicks the Apply button.

The parent receives the selected Job Id and continues the application process through Apex.

## Project Structure

- `eligibleJobs`
- `jobCard`
- `DashboardController.cls`
- `ApplicationService.cls`

## Key Learnings

- LWC should focus on presentation and user interaction while business logic belongs in Apex.
- `@wire` is useful for reactive data retrieval from Apex.
- Imperative Apex is useful when an Apex method needs to be called as a result of a user action.
- `@api` is used for Parent to Child communication.
- Custom Events are used for Child to Parent communication.
- Breaking a large component into smaller components makes the application easier to maintain and reuse.
- Apex remains responsible for validating and processing the actual business operation.

## Outcome

Successfully integrated Lightning Web Components with the Apex backend and implemented reusable parent-child component architecture in the Placement Management System.
