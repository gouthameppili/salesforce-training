````
# Day 13 - From Developer Org to Production

## Objective

Learn how to move a Salesforce application from development toward a controlled deployment workflow using Git, Salesforce CLI, Pull Requests, testing, verification, and documentation.

## Concepts Learned

- Git and source control for Salesforce
- Git repositories and branching
- Feature branches
- Commits and remote repositories
- Pull Requests and code review
- Salesforce metadata and source tracking
- Salesforce CLI authentication
- Metadata retrieval and deployment
- Development, test, and production environments
- Sandboxes, Scratch Orgs, Changesets, and Metadata API
- Apex testing and deployment verification
- Deployment troubleshooting and documentation

## Implementation

### Git & Branching Workflow

Used Git to maintain the Placement Management System as a source-controlled Salesforce project.

Created and worked on the feature branch:

```text
feature/day-12-external-integration
````

The development workflow followed:

```text
Feature Branch
  → Make Changes
  → Commit
  → Push
  → Pull Request
  → Code Review
  → Merge
```

This keeps feature development isolated from the main branch until the changes are reviewed.

### Salesforce CLI

Used Salesforce CLI to interact with the development org and perform common development operations.

Examples:

```bash
sf org list
sf data query --query "..."
sf apex run --file scripts/apex/testCandidateSync.apex --target-org placement
sf apex run test --tests CandidateSyncQueueableTest --target-org placement --result-format human --wait 10
sf project deploy start --target-org placement
```

The CLI was used for authentication, querying data, executing Apex, running tests, and deploying metadata.

### Metadata & Deployment

Learned that Salesforce metadata represents the application configuration and source code, including:

* Custom objects and fields
* Apex classes
* Triggers
* Lightning Web Components
* Flows
* Layouts
* Permission Sets

The project metadata is maintained inside:

```text
force-app/main/default/
```

Deployment was performed from the local Salesforce project to the target development org using Salesforce CLI.

### Pull Request & Code Review

Created a Pull Request from:

```text
feature/day-12-external-integration
```

into:

```text
main
```

The Pull Request was reviewed and merged after verifying the implementation.

The review focused on:

* Apex implementation
* LWC changes
* Tests
* Metadata dependencies
* Documentation
* Overall project structure

### Testing & Verification

Apex tests were executed to verify the candidate synchronization functionality.

Queueable execution was also verified using `AsyncApexJob`:

```sql
SELECT Id, Status, JobType, ApexClass.Name
FROM AsyncApexJob
WHERE JobType = 'Queueable'
ORDER BY CreatedDate DESC
LIMIT 5
```

Manual Salesforce data verification was performed using SOQL after deployment and asynchronous processing.

### Documentation

Added project documentation covering:

* Project overview
* Architecture
* Candidate API
* Deployment process
* Day 12 implementation
* Day 13 deployment workflow

Project screenshots were also added to provide evidence of important application functionality.

## Final Development Flow

```text
Develop Salesforce Feature
  → Store Metadata in Git
  → Create Feature Branch
  → Commit Changes
  → Push to GitHub
  → Create Pull Request
  → Review Changes
  → Merge into Main
  → Deploy Metadata
  → Run Apex Tests
  → Verify Salesforce Org
  → Document the Deployment
```

## Key Learnings

* Salesforce development should be managed through source control rather than relying only on changes inside an org.
* Feature branches allow development to happen independently from the main codebase.
* Pull Requests provide a controlled process for reviewing changes before merging.
* Salesforce CLI can be used for authentication, data queries, Apex execution, testing, and metadata deployment.
* Salesforce metadata and Salesforce business data are separate concepts.
* Successful deployment should be followed by automated tests and manual verification.
* Deployment failures can be caused by missing metadata dependencies, configuration, tests, or automation.
* GitHub provides a history of the development, review, and deployment process.
* Documentation makes the project easier to understand, reproduce, and maintain.

## Outcome

Successfully completed the Day 13 development and deployment workflow for the Placement Management System. The project was maintained in Git, developed through a feature branch, reviewed through a Pull Request, merged into `main`, deployed using Salesforce CLI, tested, verified, and documented.

```
```
