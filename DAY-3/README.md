# Day 3 - Validation Rules & Flow Automation

## Objective

Learn how to automate business processes using Salesforce Flows and Validation Rules without writing Apex code.

---

## Topics Covered

- Validation Rules
- Record-Triggered Flow
- Before Save Flow
- After Save Flow
- Flow Builder
- Flow vs Trigger

---

## Practical Work

### Before Save Flow

Created a Before Save Flow to automatically populate the Application Date when a new application is created.

### After Save Flow

Created an After Save Flow to send an email notification to the Placement Officer whenever a student submits an application.

### Offer Letter Automation

Built another Record-Triggered Flow to automatically create an Offer Letter record when an application's status changes to **Shortlisted**.

### Validation Rule

Created a validation rule to prevent students from applying if their CGPA does not meet the minimum CGPA required for the selected job.

---

## Project Structure

- Application_Before_Save_Flow
- Send_Placement_Officer_Email
- Application_Offer_Letter_Flow
- CGPA_Validation

---

## Key Learnings

- Use Flows whenever business requirements can be implemented declaratively.
- Before Save Flows are best for updating the same record.
- After Save Flows are useful for creating related records and sending notifications.
- Validation Rules help maintain data quality before records are saved.
- Apex should be used only when declarative tools cannot satisfy the requirement.

---

## Outcome

Automated the application process using Salesforce Flows and Validation Rules by populating fields automatically, sending email notifications, generating offer letters, and enforcing business validations without additional Apex code.