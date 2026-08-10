# Day 2 - Apex Triggers

## Objective

Learn how Apex Triggers work and implement business rules for the Placement Management System using Salesforce best practices.

---

## Topics Covered

- Before Trigger
- After Trigger
- Trigger Context Variables
- Trigger Handler Pattern
- Governor Limits
- Bulkification
- Lists
- Sets
- Maps

---

## Practical Work

Created an Apex Trigger for the `Application__c` object.

Implemented the following business rules:

- Validate student CGPA before allowing an application.
- Prevent duplicate applications for the same job.
- Prevent applications after the job deadline.
- Automatically set the application status to **Applied**.
- Display meaningful validation messages using `addError()`.

---

## Bulkification

Applied bulk processing techniques to make the trigger scalable.

Used:

- Set<Id>
- Map<Id, Student__c>
- Map<Id, Job__c>

Ensured:

- No SOQL inside loops.
- Trigger supports multiple records in a single transaction.

---

## Project Structure

- ApplicationTrigger.trigger
- ApplicationTriggerHandler.cls

---

## Key Learnings

- A Trigger should respond only to record events.
- Business logic should be moved to a Trigger Handler.
- Bulkification is essential to avoid governor limit exceptions.
- Use Sets and Maps to retrieve related records efficiently.

---

## Outcome

Built a bulk-safe Apex Trigger that validates applications and follows Salesforce development best practices.