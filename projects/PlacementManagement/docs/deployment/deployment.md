````markdown
# Deployment Guide

## Placement Management System

This document explains how a developer can obtain the Placement Management System source code, connect a Salesforce org, deploy the project, run tests, verify the deployment, and troubleshoot common problems.

The deployment process follows the source-driven development approach used during the training:

```text
Git Repository
      ↓
Feature Branch
      ↓
Commit
      ↓
Pull Request
      ↓
Review
      ↓
Merge
      ↓
Salesforce CLI
      ↓
Target Salesforce Org
      ↓
Test
      ↓
Verify
````

The goal is not simply to move Apex code into Salesforce. The complete application contains metadata such as Apex, LWC, Custom Objects, Fields, Flows, Triggers, Permissions and integration configuration, so dependencies must be considered during deployment.

---

## 1. Prerequisites

A developer working with this project should have:

* Salesforce CLI
* Git
* Access to a Salesforce org
* Appropriate permissions in the target org
* VS Code with the Salesforce Extension Pack
* The project repository

The Salesforce CLI is used to authenticate Salesforce orgs, retrieve metadata and deploy metadata.

Git is used to maintain the source code and its history.

---

## 2. Clone the Repository

Obtain the project from GitHub:

```bash
git clone <repository-url>
```

Move into the project:

```bash
cd PlacementManagement
```

The repository is the source-controlled representation of the Salesforce project.

The Salesforce org should be treated as an environment where the application is deployed, rather than the only place where the application's source exists.

---

## 3. Verify the Git Repository

Check the current branch:

```bash
git branch
```

Check the working tree:

```bash
git status
```

A clean working tree is preferred before beginning a deployment.

To retrieve the latest changes from the remote repository:

```bash
git pull origin main
```

---

## 4. Salesforce CLI Authentication

Before deploying, authenticate the Salesforce org through the CLI.

The exact authentication method can vary depending on the environment.

After authentication, verify the connected org.

For example:

```bash
sf org list
```

The important point is to verify that the CLI is connected to the **correct Salesforce org before deploying**.

Never assume that the currently authenticated org is the intended target.

---

## 5. Verify the Target Org

Before deployment, confirm:

```text
Org
Username
Alias
Environment
```

For this training project, the development org has been used through the CLI target alias:

```text
placement
```

Therefore, commands can be executed against the target using:

```bash
--target-org placement
```

Example:

```bash
sf data query --query "SELECT Id, Name FROM Student__c LIMIT 5" --target-org placement
```

This provides an additional check that the CLI is communicating with the expected org.

---

## 6. Understand What Is Being Deployed

The project contains multiple Salesforce metadata types.

```text
force-app/main/default/
│
├── classes/
├── flows/
├── flexipages/
├── layouts/
├── lwc/
├── objects/
├── permissionsets/
├── tabs/
└── triggers/
```

Deployment therefore means deploying the **system and its dependencies**, not simply deploying individual Apex classes.

For example:

```text
LWC
 ↓
Apex Method
 ↓
Apex Class
 ↓
Custom Object
 ↓
Custom Field
```

If a component depends on metadata that does not exist in the target org, deployment may fail.

---

## 7. Deploy the Project

The Salesforce CLI deployment command used during the project is:

```bash
sf project deploy start
```

For a specific target org:

```bash
sf project deploy start --target-org placement
```

For a more controlled deployment, specific metadata or source directories can also be supplied when required.

For example:

```bash
sf project deploy start --source-dir force-app/main/default --target-org placement
```

The deployment should be performed from the source-controlled project.

---

## 8. Deployment Process

The recommended process is:

```text
Check Git Status
      ↓
Review Changes
      ↓
Verify Target Org
      ↓
Deploy Metadata
      ↓
Run Tests
      ↓
Verify Deployment
      ↓
Manual Functional Testing
```

Do not treat deployment as:

```text
Build
 ↓
Deploy
 ↓
Hope
```

Instead:

```text
Build
 ↓
Test
 ↓
Validate
 ↓
Deploy
 ↓
Verify
```

---

## 9. Run Apex Tests

Apex tests should be executed before considering the deployment complete.

To run a specific test class:

```bash
sf apex run test --tests CandidateSyncQueueableTest --target-org placement --result-format human --wait 10
```

The project contains tests for the candidate synchronization functionality.

Important scenarios include:

* Successful candidate synchronization
* Server error handling
* Retry-required behaviour

A successful test execution should show:

```text
Outcome: Passed
```

for the executed tests.

---

## 10. Verify the Deployment

After deployment, verify that the metadata was successfully deployed.

Then verify the important application functionality manually.

For the Placement Management System, check areas such as:

### Student Profile

Verify that the Student Profile component can:

* Load a student
* Create a student
* Update a student
* Delete a student

### Eligible Jobs

Verify that eligible jobs are displayed correctly.

### Job Application

Verify that a student can apply for a job.

### My Applications

Verify that the student's applications are displayed correctly.

### Application Status

Verify that application status changes are reflected correctly.

### Automation

Verify that the required Salesforce automation executes after the relevant record changes.

### Candidate Synchronization

Verify the Queueable execution and integration tracking fields where applicable.

---

## 11. Verify Queueable Processing

Asynchronous jobs can be inspected through `AsyncApexJob`.

Example:

```sql
SELECT Id, Status, JobType, ApexClass.Name
FROM AsyncApexJob
WHERE JobType = 'Queueable'
ORDER BY CreatedDate DESC
LIMIT 5
```

For the Placement Management System, a successful candidate synchronization job should appear with:

```text
Job Type: Queueable
Apex Class: CandidateSyncQueueable
Status: Completed
```

---

## 12. Verify Integration Status

The Application object contains integration tracking fields.

Use:

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

These fields allow us to inspect the result of candidate synchronization.

Possible integration states include:

```text
Sent
Failed
Retry Required
```

Temporary server-side errors such as a `503 Service Temporarily Unavailable` response can result in:

```text
Integration Status = Retry Required
```

with the error stored in:

```text
Integration_Error__c
```

The external recruitment API used during the training exercise was not consistently available for successful candidate creation, so successful external candidate creation should not be assumed merely because the Salesforce deployment succeeds.

---

## 13. Verify Metadata

The deployment should be checked for the major metadata categories used by the application.

Important areas include:

```text
Apex Classes
Triggers
Lightning Web Components
Custom Objects
Custom Fields
Flows
Layouts
Permission Sets
Flexipages
```

The goal is to verify that the target environment contains the dependencies required by the application.

---

## 14. Git-Based Deployment Workflow

The project follows a feature-based Git workflow.

```text
main
  ↓
feature branch
  ↓
Development
  ↓
Commit
  ↓
Push
  ↓
Pull Request
  ↓
Review
  ↓
Merge
  ↓
Deployment
```

For example:

```bash
git switch -c feature/day-12-external-integration
```

Make the required changes and verify them:

```bash
git status
```

Stage the changes:

```bash
git add .
```

Create a logical commit:

```bash
git commit -m "complete day 12 external recruitment integration"
```

Push the feature branch:

```bash
git push -u origin feature/day-12-external-integration
```

Create a Pull Request from:

```text
feature/day-12-external-integration
                ↓
               main
```

After review and approval, merge the Pull Request.

Then update the local main branch:

```bash
git switch main
git pull origin main
```

---

## 15. Pull Request Review

A Pull Request should not simply be treated as:

```text
"Looks good."
```

The reviewer should consider:

### Apex

* Is the code bulkified?
* Does each class have a clear responsibility?
* Is SOQL appropriate?
* Is DML outside loops?
* Is error handling present?
* Are tests included?

### LWC

* Does the component have a clear responsibility?
* Is naming clear?
* Are loading states handled?
* Are error states handled?
* Is business logic unnecessarily duplicated in JavaScript?

### Security

* Are secrets hard-coded?
* Has appropriate Salesforce security been considered?

### Integration

* Is a Named Credential used?
* Are failures handled?
* Is duplicate processing considered?

---

## 16. Deployment Environments

A professional Salesforce team normally works with controlled environments.

A conceptual flow is:

```text
Developer
   ↓
QA
   ↓
UAT
   ↓
Production
```

The exact environment structure depends on the organisation.

The important principle is controlled progression between environments rather than directly modifying Production.

---

## 17. Sandboxes

A Salesforce Sandbox provides a separate environment for development, testing or other purposes depending on its type and configuration.

Conceptually:

```text
Production
     ↓
Sandbox
     ↓
Development / Testing / UAT
```

The main purpose is to allow teams to work and test without directly changing Production.

---

## 18. Scratch Orgs

Scratch Orgs are temporary, source-driven Salesforce environments used for development and testing.

The conceptual workflow is:

```text
Source
  ↓
Scratch Org
  ↓
Develop
  ↓
Test
  ↓
Destroy
```

They support reproducibility because the environment can be created from a defined project configuration.

The important principle is:

```text
Source
 ↓
Environment Setup
 ↓
Deploy
 ↓
Test
 ↓
Works
```

rather than:

```text
My Org
 ↓
Unknown Configuration
 ↓
Works Somehow
```

---

## 19. Changesets

Changesets are a Salesforce-native mechanism for moving metadata between related Salesforce orgs, commonly in Sandbox-based development workflows.

Conceptually:

```text
Sandbox
   ↓
Outbound Change Set
   ↓
Target Org
```

Changesets are useful in organisations that use traditional Salesforce deployment processes.

They are one deployment approach among several and should be understood in the context of the team's development model.

---

## 20. Metadata API

The Salesforce Metadata API provides programmatic mechanisms for deploying and retrieving Salesforce metadata.

Conceptually:

```text
Salesforce Metadata
        ↕
Deployment / Retrieval
        ↕
Salesforce Org
```

Developers do not need to implement the Metadata API themselves for this project, but should understand its role in Salesforce metadata deployment.

---

## 21. Deployment Approaches

The major approaches covered during training can be viewed as:

| Approach       | Best understood as                                       |
| -------------- | -------------------------------------------------------- |
| Changesets     | Salesforce-native metadata movement between related orgs |
| Salesforce CLI | Developer-oriented command-line workflow                 |
| Metadata API   | Programmatic metadata deployment/retrieval mechanism     |
| Scratch Orgs   | Temporary source-driven development environments         |
| Sandboxes      | Longer-lived environments for development/testing/UAT    |

For this Git-based project, the Salesforce CLI and source-controlled metadata provide the primary development workflow.

---

## 22. Deployment Dependencies

Deployment failures can occur even when an individual Apex class is correct.

For example:

```text
LWC
 ↓
Apex Method
 ↓
Apex Class
 ↓
Custom Object
 ↓
Custom Field
```

The target environment must contain the required dependencies.

Therefore, before deployment ask:

```text
What does this component depend upon?
```

and:

```text
Does the target environment already contain those dependencies?
```

The principle is:

> Deploy the system, not just the file.

---

## 23. Testing Before Deployment

Before deployment, consider:

* Apex tests
* Functional tests
* Integration tests
* LWC testing where applicable
* Permission checks
* Deployment validation
* Regression testing

The exact Salesforce deployment and testing requirements depend on the target environment.

For Production deployments, successful Apex test execution and required coverage are particularly important.

---

## 24. Troubleshooting

### Problem 1 — Authentication Failure

Possible causes:

* CLI is not authenticated
* Wrong Salesforce org
* Session expired
* Insufficient permissions

First verify the authenticated org:

```bash
sf org list
```

Then authenticate again if necessary.

---

### Problem 2 — Missing Metadata Dependency

Example:

```text
No such column 'Some_Field__c'
```

Possible cause:

The Apex class references a custom field that does not exist in the target org.

Check:

```text
Custom Object
 ↓
Custom Field
 ↓
Apex Reference
```

Deploy the required metadata dependency before or together with the dependent code.

---

### Problem 3 — Apex Test Failure

If deployment or test execution fails:

1. Read the test error.
2. Identify the failing test class and method.
3. Check whether the failure is caused by:

   * test data
   * Flow automation
   * Apex logic
   * permissions
   * missing metadata
   * external callout behaviour
4. Fix the actual cause.
5. Run the test again.

Do not assume that an Apex failure automatically means the Apex class itself is wrong.

---

### Problem 4 — Git Conflict

A Git conflict occurs when multiple developers make incompatible changes to the same part of a file.

Git can identify that the lines differ, but it cannot determine which business behaviour is correct.

The correct process is:

```text
Understand the changes
        ↓
Understand the business requirement
        ↓
Resolve the conflict
        ↓
Test
        ↓
Commit the resolution
```

Do not blindly choose `ours` or `theirs`.

---

### Problem 5 — Deployment Error

When deployment fails:

1. Read the component failure.
2. Identify the metadata type.
3. Identify the dependency or configuration problem.
4. Fix the source.
5. Run the relevant tests.
6. Deploy again.
7. Verify the target org.

Example dependency chain:

```text
LWC
 ↓
Apex
 ↓
Object
 ↓
Field
```

The failure may therefore be caused by metadata outside the file reported in the error.

---

## 25. Reproducibility

A successful deployment should be reproducible.

The desired model is:

```text
Git Repository
      ↓
Environment Setup
      ↓
Metadata Deployment
      ↓
Tests
      ↓
Verification
      ↓
Working Application
```

The goal is to avoid a situation where the application works only because of undocumented configuration in one developer org.

---

## 26. Deployment Definition of Done

Before considering the deployment workflow complete, verify:

```text
□ Git repository exists
□ Branching strategy is documented
□ Feature branch was used
□ Pull Request was created and reviewed
□ Salesforce metadata is source-controlled
□ CLI authentication works
□ Target org is verified
□ Metadata can be retrieved
□ Metadata can be deployed
□ Apex tests run successfully
□ Application can be manually verified
□ Deployment process is documented
```

---

## 27. Final Deployment Pipeline

The complete deployment lifecycle for the Placement Management System is:

```text
                 Developer
                     ↓
                Git Branch
                     ↓
                Code Changes
                     ↓
                   Commit
                     ↓
                    Push
                     ↓
               Pull Request
                     ↓
                  Review
                     ↓
                   Merge
                     ↓
            Developer / Test Org
                     ↓
             Automated Tests
                     ↓
              Manual Testing
                     ↓
                    QA
                     ↓
                   UAT
                     ↓
                Production
```

Each stage answers a different question:

```text
Development
→ Does it work?

Code Review
→ Is it well designed?

QA
→ Does it behave correctly?

UAT
→ Does it satisfy the business?

Production
→ Can real users safely use it?
```

---

## 28. Deployment Philosophy

The Placement Management System should be treated as a complete Salesforce application rather than a collection of individual files.

A professional deployment process is:

```text
Build
 ↓
Test
 ↓
Validate
 ↓
Review
 ↓
Deploy
 ↓
Verify
```

The repository provides the source of development, Git provides version history and collaboration, Salesforce CLI provides the developer-oriented deployment workflow, and Salesforce orgs provide the environments in which the application runs.

The final objective is reproducibility:

```text
Source
  ↓
Environment
  ↓
Deployment
  ↓
Testing
  ↓
Verification
  ↓
Working Salesforce Application
```

```
```
