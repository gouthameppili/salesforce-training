````markdown
# Day 14 - Securing the Salesforce Application

## Objective

Secure the Placement Management System by applying Salesforce security at the user, object, field, and record levels.

## Concepts Covered

- Profiles and Permission Sets
- User Roles and Role Hierarchy
- Object-Level Security (CRUD)
- Field-Level Security (FLS)
- Organization-Wide Defaults (OWD)
- Sharing Rules
- Record-Level Security
- Apex sharing behaviour
- Least Privilege
- Security testing and unauthorised access

## Security Implementation

Created security personas for the Placement Management System:

- **Student** — can create and view their own Applications.
- **Placement Officer** — can review Applications and update appropriate statuses.
- **Recruiter** — can access authorised candidate information and permitted recruitment data.

Created and assigned the following Permission Sets:

- `Placement_Student_Access`
- `Placement_Officer_Access`
- `Recruiter_Access`

Verified the permission set assignments for the test users.

## Object and Field Security

Reviewed object-level permissions and configured Field-Level Security for the relevant Placement Management objects.

Sensitive and business-critical fields were restricted according to the user's responsibility instead of relying only on the Lightning Web Component UI.

The security model follows:

```text
Profile / Permission Set
        ↓
Object Permissions
        ↓
Field-Level Security
        ↓
Record-Level Security
````

## Record-Level Security

Configured the Application sharing model with a private OWD approach so that Applications are not automatically visible to every user.

Created a sharing rule to provide the required Application access to the Placement Officer while keeping the underlying record access controlled.

```text
Application__c
      ↓
OWD = Private
      ↓
Record Ownership
      ↓
Role Hierarchy / Sharing Rule
      ↓
Authorised Users
```

## Apex Security Review

Reviewed Apex classes with respect to record-sharing behaviour and explicit sharing intent.

The security review considered:

* `with sharing`
* `without sharing`
* `inherited sharing`
* CRUD and FLS considerations
* Server-side enforcement
* Least-privilege access

Security is not enforced only through the LWC. Important permissions must be enforced at the server and data layers.

## Security Testing

Reviewed the application from an unauthorised-user perspective instead of testing only the normal user workflow.

The required security scenarios include:

| Scenario                                       | Expected |
| ---------------------------------------------- | -------- |
| Student views own Application                  | Allowed  |
| Student views another student's Application    | Denied   |
| Student changes Selection Status               | Denied   |
| Placement Officer reviews Application          | Allowed  |
| Recruiter views authorised candidate           | Allowed  |
| Recruiter accesses unrelated confidential data | Denied   |
| Student edits restricted recruiter information | Denied   |
| Student modifies another student's profile     | Denied   |

The testing approach also considers direct attempts to change record Ids or bypass the UI through Apex/API requests.

## Key Learnings

* Salesforce security is a combination of multiple layers rather than a single feature.
* Profiles and Permission Sets control what users are allowed to do.
* FLS protects individual fields.
* OWD, ownership, roles, and sharing rules control record access.
* Hiding a field or button in an LWC is not a security boundary.
* Apex must have deliberate sharing and data-access behaviour.
* Least privilege should be applied to both users and integrations.
* Security testing must verify that unauthorised users cannot access or modify protected data.

## Outcome

The Placement Management System now has a defined security architecture covering user access, object permissions, field security, record sharing, Apex security, and security testing.

```text
User
 ↓
Lightning Web UI
 ↓
Secure Apex Layer
 ↓
Business Services
 ↓
Salesforce Database
 ↓
Security Model
```

The application is no longer treated only as a functional Salesforce project; its security model is now part of the overall application architecture.

```
```
