# ACCESS_CONTROL_MATRIX.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Draft  
**Parent Documents:** `PRD.md`, `USER_FLOWS.md`

---

# 1. Purpose

This document defines the permissions available to each user role in the Purnata platform.

It is the **single source of truth for authorization**.

Both frontend and backend implementations must follow this document.

The backend must enforce all permissions. Frontend restrictions are only for user experience and must never be treated as a security mechanism.

---

# 2. User Roles

The MVP contains three primary roles:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

---

# 3. Permission Model

The platform follows:

```text
User
  ↓
Role
  ↓
Permission
  ↓
Resource
  ↓
Action
```

Example:

```text
PROGRAM_LEAD
      ↓
Beneficiary Management
      ↓
CREATE
      ↓
Beneficiary
```

---

# 4. Permission Actions

The following standard actions are used:

| Action | Meaning |
|---|---|
| CREATE | Create a new record |
| READ | View a record |
| UPDATE | Modify an existing record |
| DELETE | Delete a record |
| ASSIGN | Assign a resource to another user |
| COMPLETE | Mark an activity/task as completed |
| EXPORT | Export information |
| ANALYZE | Access analytics |
| REPORT | Generate/view reports |

---

# 5. High-Level Permission Matrix

| Resource | Program Lead | Volunteer | Executive Director |
|---|---|---|---|
| Programs | Full | Assigned Read | Read |
| Activities | Full | Assigned Read/Update | Read |
| Beneficiaries | Full | Assigned Read | Authorized Read |
| Program Enrollment | Full | Read | Read |
| Beneficiary Timeline | Full | Limited Read | Authorized Read |
| Volunteers | Full | Own Profile | Read |
| Volunteer Assignment | Full | Read Own | Read |
| Tasks | Full | Own Tasks | Read |
| Attendance | Full | Assigned Activity | Read |
| Progress | Full | Relevant/Assigned | Read |
| Program Analytics | Full | Limited/Own | Full |
| Centre Analytics | Relevant | No | Full |
| Organization Analytics | No/Operational | No | Full |
| Reports | Program-level | No | Full |
| User Management | No* | No | Future/Admin |
| Audit Logs | Relevant | Own Actions | Authorized |
| System Configuration | No | No | Future/Admin |

`*` User management is outside the current MVP unless explicitly approved.

---

# 6. Program Permissions

## 6.1 Program Lead

```text
CREATE   ✓
READ     ✓
UPDATE   ✓
DELETE   ✓*
ASSIGN   ✓
ANALYZE  ✓
```

Program Leads can:

- Create programs
- View programs
- Edit programs
- Manage program status
- Manage program beneficiaries
- Manage program activities
- Assign volunteers
- View program analytics

Deletion should preferably be implemented as a controlled status change rather than permanent deletion where historical records depend on the program.

---

## 6.2 Volunteer

```text
CREATE   ✗
READ     ✓ Assigned Programs
UPDATE   ✗
DELETE   ✗
ASSIGN   ✗
ANALYZE  Limited
```

A volunteer can only view programs to which they are assigned or which are required for an assigned activity/task.

A volunteer must not be able to browse unrelated programs.

---

## 6.3 Executive Director

```text
CREATE   ✗
READ     ✓
UPDATE   ✗
DELETE   ✗
ASSIGN   ✗
ANALYZE  ✓
REPORT   ✓
```

The Executive Director primarily consumes organizational information rather than modifying operational records.

---

# 7. Activity Permissions

| Action | Program Lead | Volunteer | Executive Director |
|---|---:|---:|---:|
| Create Activity | ✓ | ✗ | ✗ |
| View Activity | ✓ | Assigned | ✓ |
| Edit Activity | ✓ | Limited* | ✗ |
| Delete Activity | ✓* | ✗ | ✗ |
| Assign Volunteer | ✓ | ✗ | ✗ |
| View Participants | ✓ | Assigned | ✓ |
| Record Attendance | ✓ | Assigned | ✗ |
| Add Activity Notes | ✓ | Assigned | ✗ |
| Mark Complete | ✓ | Assigned | ✗ |
| View Outcome | ✓ | Assigned | ✓ |

`*` Subject to final business rules.

---

# 8. Beneficiary Permissions

Beneficiary information is sensitive and must be protected carefully.

## 8.1 Program Lead

The Program Lead can:

```text
CREATE   ✓
READ     ✓
UPDATE   ✓
DELETE   Restricted
```

Can:

- Register beneficiaries
- Search beneficiaries
- View beneficiary profiles
- Update permitted information
- Enroll beneficiaries into programs
- View beneficiary timelines
- Track progress
- View attendance
- View intervention history

---

## 8.2 Volunteer

Volunteer access must be restricted to information necessary for assigned work.

```text
CREATE   ✗
READ     ✓ Assigned Beneficiaries
UPDATE   Limited
DELETE   ✗
```

A volunteer must not be able to:

- Search all beneficiaries
- Browse unrelated beneficiaries
- Modify core beneficiary identity
- Delete beneficiary records
- Access unrelated sensitive case information

---

## 8.3 Executive Director

```text
CREATE   ✗
READ     Authorized
UPDATE   ✗
DELETE   ✗
ANALYZE  ✓
```

The Executive Director can access beneficiary journey information required for organizational oversight.

Sensitive fields should be exposed only when explicitly authorized.

---

# 9. Beneficiary Unique ID Permissions

The unique beneficiary ID is a core identity attribute.

## Program Lead

```text
Generate   ✓
View       ✓
Update     ✗
Delete     ✗
```

## Volunteer

```text
Generate   ✗
View       ✓ Assigned
Update     ✗
Delete     ✗
```

## Executive Director

```text
Generate   ✗
View       ✓
Update     ✗
Delete     ✗
```

The unique ID must never be regenerated simply because a beneficiary joins another program.

---

# 10. Program Enrollment Permissions

| Action | Program Lead | Volunteer | Executive Director |
|---|---:|---:|---:|
| Create Enrollment | ✓ | ✗ | ✗ |
| View Enrollment | ✓ | Assigned | ✓ |
| Update Enrollment | ✓ | ✗ | ✗ |
| Delete Enrollment | Restricted | ✗ | ✗ |

The system must prevent duplicate active enrollments where the business rules prohibit them.

---

# 11. Beneficiary Timeline Permissions

## Program Lead

```text
READ     ✓
CREATE   ✓*
UPDATE   ✓*
```

The Program Lead can maintain the operational timeline.

---

## Volunteer

```text
READ     Limited
CREATE   Activity-related entries only*
UPDATE   Activity-related entries only*
```

Volunteer timeline access must be restricted to information relevant to their assigned work.

---

## Executive Director

```text
READ     Authorized
CREATE   ✗
UPDATE   ✗
```

The Executive Director primarily views the beneficiary journey rather than modifying it.

---

# 12. Volunteer Permissions

## Program Lead

Can:

```text
CREATE/REGISTER    ✓
READ               ✓
UPDATE             ✓
ASSIGN             ✓
ANALYZE            ✓
```

Can manage:

- Volunteer information
- Skills
- Assignments
- Program participation
- Activity assignments
- Tasks
- Performance information

---

## Volunteer

Can:

```text
READ     Own Profile
UPDATE   Own permitted profile fields
```

A volunteer cannot modify their:

- Role
- Permissions
- Assignment authority
- Performance records
- Administrative information

---

## Executive Director

Can:

```text
READ      ✓
ANALYZE   ✓
```

The Executive Director can view volunteer participation and organizational volunteer metrics.

---

# 13. Volunteer Assignment Permissions

Only authorized operational users can create assignments.

## Program Lead

```text
CREATE   ✓
READ     ✓
UPDATE   ✓
DELETE   Restricted
```

## Volunteer

```text
CREATE   ✗
READ     Own Assignments
UPDATE   ✗
DELETE   ✗
```

## Executive Director

```text
CREATE   ✗
READ     ✓
UPDATE   ✗
DELETE   ✗
```

---

# 14. Task Permissions

## Program Lead

```text
CREATE     ✓
READ       ✓
UPDATE     ✓
ASSIGN     ✓
COMPLETE   ✓
DELETE     Restricted
```

## Volunteer

```text
CREATE     ✗
READ       Own Tasks
UPDATE     Own Task Status
COMPLETE   ✓
DELETE     ✗
```

## Executive Director

```text
CREATE     ✗
READ       ✓
UPDATE     ✗
COMPLETE   ✗
```

---

# 15. Attendance Permissions

Attendance is associated with activities and beneficiaries.

## Program Lead

```text
CREATE   ✓
READ     ✓
UPDATE   ✓
DELETE   Restricted
```

## Volunteer

```text
CREATE   ✓ Assigned Activities
READ     ✓ Assigned Activities
UPDATE   Limited
DELETE   ✗
```

## Executive Director

```text
CREATE   ✗
READ     ✓
UPDATE   ✗
DELETE   ✗
ANALYZE  ✓
```

Attendance records should preserve who recorded the attendance and when.

---

# 16. Beneficiary Progress Permissions

## Program Lead

```text
CREATE   ✓
READ     ✓
UPDATE   ✓
ANALYZE  ✓
```

## Volunteer

```text
CREATE   Activity/Assignment Related
READ     Assigned Beneficiaries
UPDATE   Activity/Assignment Related
```

## Executive Director

```text
READ     ✓
ANALYZE  ✓
```

Progress information should be based on defined indicators rather than arbitrary subjective values unless such scoring is approved.

---

# 17. Analytics Permissions

## 17.1 Program Analytics

| Role | Access |
|---|---|
| Program Lead | ✓ Full |
| Volunteer | Limited / Relevant |
| Executive Director | ✓ Full |

---

## 17.2 Centre Analytics

| Role | Access |
|---|---|
| Program Lead | Relevant Centre |
| Volunteer | ✗ |
| Executive Director | ✓ |

---

## 17.3 Organization Analytics

| Role | Access |
|---|---|
| Program Lead | ✗ |
| Volunteer | ✗ |
| Executive Director | ✓ |

---

# 18. Executive Director Analytics

The Executive Director should be able to view:

```text
Organization
    │
    ├── Centres
    │
    ├── Programs
    │
    ├── Beneficiaries
    │
    ├── Activities
    │
    ├── Attendance
    │
    ├── Volunteers
    │
    └── Progress / Outcomes
```

The dashboard should aggregate information rather than require operational users to manually compile reports.

---

# 19. Reporting Permissions

| Report | Program Lead | Volunteer | Executive Director |
|---|---:|---:|---:|
| Program Report | ✓ | ✗ | ✓ |
| Beneficiary Report | ✓ Authorized | ✗ | Authorized |
| Attendance Report | ✓ | Own/Assigned | ✓ |
| Volunteer Report | ✓ | ✗ | ✓ |
| Centre Report | Relevant | ✗ | ✓ |
| Organization Report | ✗ | ✗ | ✓ |
| Impact Report | Limited | ✗ | ✓ |

---

# 20. Search Permissions

Search must respect authorization.

## Program Lead

Can search:

```text
Programs
Beneficiaries
Activities
Volunteers
Tasks
```

within their authorized operational scope.

---

## Volunteer

Can search only within their assigned scope.

Example:

```text
Volunteer
   ↓
My Programs
   ↓
My Beneficiaries
   ↓
My Activities
```

They must not receive an unrestricted global beneficiary search.

---

## Executive Director

Can search authorized organizational records.

---

# 21. Data Scope Rules

Permissions should not only depend on role.

They should also depend on **scope**.

Conceptually:

```text
ROLE + SCOPE = ACCESS
```

Example:

```text
Volunteer A
     ↓
Program X
     ↓
Beneficiary 101
```

Volunteer A can access Beneficiary 101 if assigned to Program X.

But:

```text
Volunteer A
     ↓
Program Y
     ↓
Beneficiary 205
```

If Volunteer A has no assignment to Program Y, access should be denied.

---

# 22. Authorization Decision Flow

Every protected API request should conceptually follow:

```text
Request
  ↓
Authenticate User
  ↓
Identify User
  ↓
Identify Role
  ↓
Identify Resource
  ↓
Identify Requested Action
  ↓
Check Scope
  ↓
Authorized?
 ├── NO → 403 Forbidden
 │
 └── YES
       ↓
     Execute Request
```

---

# 23. Authentication vs Authorization

These must not be confused.

### Authentication

Answers:

> "Who are you?"

Example:

```text
user@example.com
      ↓
Valid credentials
      ↓
Authenticated User
```

### Authorization

Answers:

> "What are you allowed to do?"

Example:

```text
Authenticated User
      ↓
Role = VOLUNTEER
      ↓
Can access assigned activities
      ↓
Cannot access unrelated beneficiary records
```

---

# 24. Frontend Authorization

The frontend should use role information to:

- Show appropriate navigation
- Hide unavailable actions
- Redirect unauthorized users
- Prevent unnecessary API requests

Example:

```text
PROGRAM_LEAD
 ├── Dashboard
 ├── Programs
 ├── Beneficiaries
 ├── Activities
 ├── Volunteers
 └── Analytics
```

```text
VOLUNTEER
 ├── Dashboard
 ├── My Programs
 ├── My Beneficiaries
 ├── My Activities
 └── My Tasks
```

```text
EXECUTIVE_DIRECTOR
 ├── Dashboard
 ├── Organization Analytics
 ├── Centre Analytics
 ├── Program Analytics
 ├── Beneficiary Journey
 └── Reports
```

---

# 25. Backend Authorization

The backend must independently verify authorization.

Example:

```text
GET /beneficiaries/101
       ↓
Authenticate
       ↓
User = Volunteer A
       ↓
Check assignment
       ↓
Volunteer A assigned to beneficiary 101?
       │
       ├── YES → Return permitted fields
       │
       └── NO → 403 Forbidden
```

Never rely on:

```text
Frontend hiding a button
```

as the authorization mechanism.

---

# 26. Field-Level Authorization

Some resources may contain fields with different sensitivity levels.

Therefore access may need to be controlled at the field level.

Example:

```text
Beneficiary
├── Basic Information
├── Program Information
├── Attendance
├── Progress
└── Sensitive Case Information
```

A volunteer may receive:

```text
Basic Information
Program Information
Attendance
Relevant Progress
```

while restricted case information may not be returned.

The exact sensitive fields must be finalized in `DATA_DICTIONARY.md`.

---

# 27. Delete Policy

Because the platform contains long-term beneficiary and program histories, permanent deletion should be treated carefully.

Preferred approach:

```text
Active Record
      ↓
Archived / Inactive
```

rather than:

```text
Active Record
      ↓
Permanent DELETE
```

Permanent deletion should only be implemented where explicitly approved.

---

# 28. Audit Requirements

The following actions should be auditable:

```text
Beneficiary Created
Beneficiary Updated
Program Created
Program Updated
Activity Created
Activity Updated
Volunteer Assigned
Task Assigned
Attendance Recorded
Progress Updated
Sensitive Record Accessed*
```

Each audit event should capture, where appropriate:

```text
User
Action
Resource
Resource ID
Timestamp
```

The exact audit schema will be defined in `AUDIT_LOGGING.md`.

---

# 29. Unauthorized Access Handling

When a user attempts an unauthorized operation:

### API

Return an appropriate authorization error.

Conceptually:

```text
HTTP 403 Forbidden
```

### Frontend

Display a clear message such as:

```text
You do not have permission to perform this action.
```

Do not reveal sensitive information through the error message.

---

# 30. Permission Inheritance Rule

Permissions must not automatically expand because a user can access a parent resource.

Example:

```text
Volunteer
   ↓
Can view Program X
```

does not automatically mean:

```text
Volunteer
   ↓
Can view every beneficiary in Program X
```

Beneficiary access must still be checked according to the approved access rules.

---

# 31. API Enforcement Rule

Every protected backend endpoint must specify:

```text
Authentication Required
Role(s)
Scope Rule
Allowed Action
```

Example:

```text
POST /programs
```

```text
Authentication: Required
Allowed Role: PROGRAM_LEAD
Action: CREATE
Scope: Authorized Centre
```

---

# 32. AI Agent Implementation Rules

Any AI coding agent implementing authentication or authorization must:

1. Read `PRD.md`.
2. Read `USER_FLOWS.md`.
3. Read this document.
4. Never invent new roles.
5. Never silently broaden permissions.
6. Never implement authorization only in frontend.
7. Enforce authorization at the API/backend layer.
8. Respect resource scope.
9. Respect field-level restrictions.
10. Ask for clarification when a permission is undefined.

---

# 33. Permission Naming Convention

The backend should use consistent permission names.

Recommended format:

```text
RESOURCE_ACTION
```

Examples:

```text
PROGRAM_CREATE
PROGRAM_READ
PROGRAM_UPDATE

BENEFICIARY_CREATE
BENEFICIARY_READ
BENEFICIARY_UPDATE

ACTIVITY_CREATE
ACTIVITY_READ
ACTIVITY_UPDATE

VOLUNTEER_ASSIGN
TASK_CREATE
TASK_UPDATE

ATTENDANCE_CREATE
ATTENDANCE_READ

ANALYTICS_PROGRAM_READ
ANALYTICS_CENTRE_READ
ANALYTICS_ORGANIZATION_READ
```

The final permission list should be maintained centrally.

---

# 34. Open Authorization Questions

The following must be confirmed before final implementation:

1. Can volunteers see the full beneficiary timeline?
2. Which beneficiary fields can volunteers see?
3. Can volunteers edit activity notes after submission?
4. Can volunteers correct attendance records?
5. Can Program Leads access beneficiaries from every centre or only their assigned centre?
6. Can one Program Lead manage multiple centres?
7. Can the Executive Director see all beneficiary-level information?
8. Who can archive beneficiaries?
9. Who can archive programs?
10. Should Program Leads be able to delete activities?
11. Can volunteers see volunteer performance analytics?
12. Can Program Leads export reports?
13. Can volunteers export anything?
14. Which actions require audit logging?
15. Are there additional administrative roles planned?

These questions should be resolved before the permission model is marked **FINAL**.

---

# 35. Final Authorization Principle

The platform follows this rule:

```text
                    USER
                      │
                      ▼
                    ROLE
                      │
                      ▼
                 PERMISSION
                      │
                      ▼
                   SCOPE
                      │
                      ▼
                  RESOURCE
                      │
                      ▼
                   ACTION
                      │
                      ▼
                ALLOW / DENY
```

A user should receive access **only when all required authorization conditions are satisfied**.

This principle must be consistently implemented across the frontend, backend, API, and database access layer.