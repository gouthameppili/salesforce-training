# Day 6 - SOQL, DML & Apex Controller Integration

## Objective

Learn how to retrieve, validate, and store Salesforce data using SOQL, DML, Apex Controllers, and Lightning Web Components.

---

## Concepts Learned

- SOQL
- DML
- Apex Controller
- @AuraEnabled
- @wire
- Client-Server Architecture
- Business Validation
- CRUD Operations

---

## Practical Work

### Apex Controller

Created a **DashboardController** to expose Salesforce data to Lightning Web Components.

Implemented:

- getStudents()
- getJobs()

---

### Lightning Web Component

Connected the Placement Dashboard with Apex using:

- @wire
- @AuraEnabled(cacheable=true)

Displayed live data for:

- Students
- Jobs

instead of using mock data.

---

### Application Service

Enhanced the **ApplicationService** by implementing:

- Student Retrieval
- Job Retrieval
- CGPA Validation
- Deadline Validation
- Duplicate Application Check
- Create Application
- Update Application Status
- Meaningful Success and Error Messages

---

### SOQL & DML

Practiced:

- Retrieving records using SOQL.
- Creating records using `insert`.
- Updating records using `update`.

Also understood the correct order of execution:

```
Retrieve Data

↓

Validate Business Rules

↓

Perform DML

↓

Return Response
```

---

## Project Structure

Classes:

- DashboardController.cls
- ApplicationService.cls

LWC:

- placementHome

---

## Key Learnings

- SOQL is used to retrieve Salesforce records.
- DML is used to create and update records.
- LWC cannot directly access the Salesforce database.
- Apex Controllers act as the bridge between LWC and Salesforce.
- Business validations should be completed before performing DML operations.
- Retrieve only the fields required for the business logic.

---

## Outcome

Connected Lightning Web Components with Apex Controllers to display live Salesforce data and implemented business operations using SOQL, DML, and the Service Layer approach.