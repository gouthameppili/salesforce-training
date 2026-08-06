# Day 8 - Bulkification & Governor Limits

## Objective

Learn how to write Apex code that can handle multiple records efficiently by following Salesforce bulkification best practices and governor limits.

---

## Topics Covered

- Governor Limits
- Bulkification
- Trigger.new
- Trigger.old
- Trigger.oldMap
- Bulk SOQL
- Bulk DML
- Code Review
- Trigger Best Practices

---

## What I Implemented

### Trigger Enhancements

Updated the Application Trigger to support:

- Before Insert
- Before Update
- After Update

Also added corresponding methods in the Trigger Handler.

---

### Status Change Detection

Implemented logic to detect when an application's status changes from **Applied** to **Shortlisted** using `Trigger.oldMap`.

This ensures the logic runs only when the status actually changes.

---

### Student Placement Status Update

Created a new service method:

`processShortlistedApplications()`

This method:

- Identifies applications whose status changed to Shortlisted.
- Collects Student IDs using a Set.
- Retrieves all required Student records in a single SOQL query.
- Updates the Placement Status field.
- Performs a single bulk DML update.

---

### Bulkification

Applied bulk processing techniques throughout the implementation.

Used:

- Set<Id>
- Map<Id, Student__c>
- List<Student__c>

Ensured:

- No SOQL inside loops.
- No DML inside loops.
- One query for all required records.
- One update statement for all modified records.

---

## Code Review

Reviewed an Apex Trigger containing:

- SOQL inside loops
- DML inside loops
- Business logic inside the Trigger

Discussed why this approach is not scalable and how to redesign it using:

Trigger → Trigger Handler → Service Layer

---

## Key Learnings

- Always assume a Trigger can receive multiple records.
- Use Sets to remove duplicate IDs.
- Use Maps for quick record lookup.
- Perform SOQL outside loops.
- Perform DML outside loops.
- Compare Trigger.oldMap and Trigger.new to detect field changes.
- Keep business logic inside the Service Layer instead of the Trigger.

---

## Files Updated

- ApplicationTrigger.trigger
- ApplicationTriggerHandler.cls
- ApplicationService.cls

---

## Outcome

Built a bulk-safe implementation that updates student placement status when an application is shortlisted while following Salesforce governor limits and clean architecture principles.