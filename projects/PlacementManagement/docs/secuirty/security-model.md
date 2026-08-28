````
# Salesforce Security Model

## Overview

The Placement Management System uses multiple layers of Salesforce security to control what each type of user can access and modify.

The security model follows the principle of least privilege: users receive only the access required for their responsibilities.

## User Personas

The application is designed around four main personas:

- **Student** — manages their own profile and applications.
- **Placement Officer** — manages placement activities and accesses relevant student and application information.
- **Recruiter** — accesses authorised candidate and recruitment information.
- **Administrator** — has elevated access for configuration and administration.

## Security Layers

The application uses the following security layers:

```text
User
  ↓
Profile + Permission Set
  ↓
Object-Level Security
  ↓
Field-Level Security
  ↓
OWD
  ↓
Role Hierarchy
  ↓
Sharing Rules
  ↓
Apex Security
  ↓
Effective Record Access
````

### Profiles and Permission Sets

Profiles provide the user's base permissions, while Permission Sets provide additional access required for specific responsibilities.

The project uses dedicated permission sets for:

* `Placement_Student_Access`
* `Placement_Officer_Access`
* `Recruiter_Access`

### Object-Level Security

Object permissions control whether a user can Create, Read, Edit, or Delete records.

Access is configured according to the responsibilities of each persona rather than giving every user unrestricted access.

### Field-Level Security

Field-Level Security protects individual fields that should not be available to every user.

This ensures that having access to an object does not automatically expose every field on that object.

### Record-Level Security

Record access is controlled using:

* Organization-Wide Defaults
* Role Hierarchy
* Sharing Rules
* Ownership
* Appropriate programmatic sharing where required

The Application object uses a restrictive record-sharing approach so that access can be granted deliberately.

## Apex Security

Security is not dependent only on the Lightning Web Component.

Apex services are reviewed for their sharing behaviour and must have an explicit sharing intent. Server-side validation and access controls are important because users can potentially call Apex operations without going through the expected UI.

## Integration Security

External integration credentials are kept outside Apex source code using Salesforce configuration such as Named Credentials.

This prevents authentication details from being hard-coded into the application.

## Security Principles

The project follows these principles:

* Start with restrictive access and grant only what is required.
* Separate object access from record access.
* Protect sensitive fields using Field-Level Security.
* Do not rely only on UI restrictions.
* Apply least privilege.
* Keep integration credentials outside source code.
* Validate important operations on the server side.
* Consider security requirements as part of each feature.

## Security Architecture

```text
                    USER
                      ↓
              Lightning Web UI
                      ↓
                Secure Apex
                      ↓
              Business Services
                 ↙        ↘
        Salesforce DB    External Systems
              ↓                ↓
       Security Model    Secure Integration
```

The goal is not simply to make the application functional, but to ensure that each user can access only the data and operations appropriate to their role.

```
```
