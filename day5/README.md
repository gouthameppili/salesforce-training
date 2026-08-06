# Day 5 - Business Logic & Service Layer

## Objective

Learn how to organize business logic in Salesforce using the Service Layer approach instead of placing all logic inside Triggers or Lightning Web Components.

---

## Topics Covered

- Business Logic
- Business Rules
- Service Layer
- Single Responsibility Principle
- Method Design
- Parameters
- Return Values
- Software Architecture

---

## Practical Work

Created an Apex Service Class named **ApplicationService** to handle the business logic for student applications.

Implemented the following methods:

### submitApplication()

Business rules implemented:

- Retrieve Student details
- Retrieve Job details
- Validate student CGPA
- Check application deadline
- Prevent duplicate applications
- Create a new Application record
- Return meaningful success or error messages

### updateApplicationStatus()

- Update the status of an existing application.

---

## Project Structure

Classes:

- ApplicationService.cls
- ApplicationTriggerHandler.cls
- ApplicationTrigger.trigger

---

## Key Learnings

- Business logic should be placed inside a Service Class.
- A Trigger or LWC should delegate work to the Service Layer.
- Methods should perform one specific responsibility.
- Clear method names make the code easier to understand and maintain.
- Good software architecture makes future enhancements easier.

---

## Outcome

Built the Service Layer for the Placement Management System and moved the application's business rules into reusable Apex methods following Salesforce development best practices.