````
# Permission Matrix

## Overview

The Placement Management System follows a least-privilege approach. Each persona receives only the object-level access required for their responsibilities.

The main personas are Student, Placement Officer, Recruiter, and Administrator. The instructor requires the permission matrix to define Create, Read, Edit, and Delete access for each object. :contentReference[oaicite:0]{index=0}

## Object Permission Matrix

| Object | Student | Placement Officer | Recruiter | Administrator |
|---|---|---|---|---|
| Student | Create, Read, Edit | Read, Edit | Read | Full Access |
| Job | Read | Create, Read, Edit | Read | Full Access |
| Application | Create, Read, Edit | Create, Read, Edit | Read, Edit | Full Access |
| Offer Letter | Read | Create, Read, Edit | Read | Full Access |

## Student

Students should have access required to maintain their own placement information and applications.

- Can view their own Student information.
- Can view available Jobs.
- Can create Applications.
- Can view and update their permitted Applications.
- Cannot modify another student's Application.
- Cannot modify fields intended only for Placement Officers.
- Cannot delete another student's Application.

The security requirement is that a student can apply only for themselves and cannot modify another student's application. :contentReference[oaicite:1]{index=1}

## Placement Officer

Placement Officers require broader access because they manage placement activities.

- Can review Student information required for placement activities.
- Can manage Jobs.
- Can review Applications.
- Can update appropriate Application statuses.
- Can access records shared through the placement security model.

The Application object is kept private and access is widened through the sharing model so Placement Officers can review the required Applications. :contentReference[oaicite:2]{index=2}

## Recruiter

Recruiters receive access to candidate information relevant to their recruitment activities.

- Can access authorised candidate information.
- Can review relevant Applications.
- Can access Jobs related to recruitment activities.
- Can update permitted recruitment information.
- Should not receive unrelated confidential student information.

The instructor specifically requires recruiters to access only authorised candidate information and update permitted interview information. :contentReference[oaicite:3]{index=3}

## Administrator

The Administrator has elevated access for configuration, troubleshooting, deployment, and security administration.

Administrative access is intentionally different from normal user access. The system should not depend on giving every user broad permissions simply to make development easier. :contentReference[oaicite:4]{index=4}

## Permission Sets

The project uses dedicated Permission Sets instead of creating separate profiles for every persona:

- `Placement_Student_Access`
- `Placement_Officer_Access`
- `Recruiter_Access`

These Permission Sets were created in Salesforce, configured with the required access, retrieved into the project, and assigned to the corresponding test users.

## Field Security

Object access does not automatically mean that every field should be accessible.

Sensitive fields are controlled separately using Field-Level Security. This prevents a user from receiving confidential information simply because they can access the related record.

The security model specifically considers sensitive candidate information and fields that should be restricted from students. :contentReference[oaicite:5]{index=5}

## Record-Level Security

Object permissions are only one layer of access control.

The final record access is determined using:

```text
Object Permissions
        ↓
Field-Level Security
        ↓
OWD
        ↓
Record Ownership
        ↓
Role Hierarchy
        ↓
Sharing Rules
        ↓
Apex Security
````

For the Placement Management System, the Application object uses a private OWD model with controlled sharing to Placement Officers.

## Least Privilege

The permission matrix follows the principle of least privilege:

> Give each user only the access required for their legitimate responsibilities.

This applies to normal users as well as integration identities. 

The purpose of this matrix is therefore not just to list permissions, but to make the expected security behaviour of each persona clear before access is granted.

```
```
