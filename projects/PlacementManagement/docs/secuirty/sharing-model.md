````markdown
# Sharing Model

## Overview

The Placement Management System uses Salesforce record-level security to control which users can access individual records.

The sharing model is designed around private record access first, followed by controlled access through ownership, roles, and sharing rules.

## Organization-Wide Defaults

The `Application__c` object uses a **Private** OWD model.

This means users do not automatically receive access to every Application record. Access must be provided through ownership or an appropriate sharing mechanism.

```text
Application
    ↓
OWD = Private
    ↓
Record Ownership
    ↓
Role Hierarchy / Sharing Rules
    ↓
Required User Access
````

The instructor specifically uses a private Application OWD scenario where a Placement Officer needs access to Applications owned by different students. 

## Record Ownership

Application records have an owner.

With a Private OWD model, ownership becomes an important part of determining who can access the record.

Students should not automatically gain access to Applications belonging to other students.

```text
Student A
   ↓
Application A

Student B
   ↓
Application B
```

A Placement Officer may still need access to both records, so additional record-level access is required.

## Role Hierarchy

The role hierarchy was considered as part of the record-sharing design.

Roles can provide access to records owned by users lower in the hierarchy when the organization requires that model.

The security design therefore considers:

```text
OWD
 ↓
Ownership
 ↓
Role Hierarchy
 ↓
Sharing Rules
```

The instructor specifically requires the role hierarchy to be documented and considered as part of the security model. 

## Sharing Rules

A sharing rule was created for the Placement Management System to provide the required Application access to the Placement Officer.

This allows the system to keep the Application object private while still providing controlled access to users who need to review placement records.

The sharing rule is therefore used to **extend access**, rather than making the Application object globally accessible.

Salesforce sharing rules are intended to grant wider access to records; they are not used to restrict access below the existing security model. 

## Final Sharing Model

The resulting record-level security model is:

```text
Application__c
      ↓
OWD = Private
      ↓
Record Owner
      ↓
Role Hierarchy
      ↓
Sharing Rule
      ↓
Placement Officer
      ↓
Access to required Applications
```

## Security Behaviour

The intended behaviour is:

| Scenario                                        | Expected Access |
| ----------------------------------------------- | --------------- |
| Student accesses own Application                | Allowed         |
| Student accesses another student's Application  | Denied          |
| Placement Officer reviews Applications          | Allowed         |
| Recruiter accesses authorised candidate records | Allowed         |
| User accesses unrelated records                 | Denied          |

The instructor's security testing matrix follows the same principle: intended users should be able to perform their work while access to other users' data remains restricted. 

## Security Principle

The sharing model follows the principle that knowing or guessing a Salesforce record Id must not automatically provide access to that record.

The server-side security model must enforce record access rather than relying on the LWC or user interface to hide records. 

```
```
