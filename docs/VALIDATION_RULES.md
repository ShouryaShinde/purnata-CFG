# VALIDATION_RULES.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Specification  
**Parent Documents:** `PRD.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`, `ACCESS_CONTROL_MATRIX.md`, `TECHNICAL_ARCHITECTURE.md`

---

# 1. Purpose

This document defines the validation rules for the Purnata Digital Case & Program Management Platform.

Validation exists at four levels:

```text
Frontend Validation
        ↓
API Request Validation
        ↓
Business Rule Validation
        ↓
PostgreSQL Constraints
```

Frontend validation improves usability.

Backend validation is mandatory for correctness and security.

PostgreSQL constraints provide the final database integrity layer.

No client-side validation may be treated as a security mechanism.

---

# 2. Validation Principles

The backend must:

1. Validate every externally supplied value.
2. Validate request body fields.
3. Validate route parameters.
4. Validate query parameters.
5. Validate authorization scope.
6. Validate cross-entity relationships.
7. Validate business rules before database writes.
8. Use parameterized PostgreSQL queries.
9. Rely on database constraints for final integrity.
10. Return consistent validation errors.
11. Never trust ownership fields supplied by the frontend.
12. Never silently modify invalid business data.
13. Preserve the persistent beneficiary identity.
14. Use transactions when one operation changes multiple related records.

---

# 3. Validation Error Format

All validation failures should use:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": [
      {
        "field": "fieldName",
        "message": "Validation message"
      }
    ]
  }
}
```

Example:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid beneficiary data",
    "details": [
      {
        "field": "fullName",
        "message": "Full name is required"
      },
      {
        "field": "progressPercentage",
        "message": "Must be between 0 and 100"
      }
    ]
  }
}
```

---

# 4. Validation Error Codes

Recommended application error codes:

```text
VALIDATION_ERROR
INVALID_UUID
INVALID_DATE
INVALID_DATETIME
INVALID_TIME
INVALID_ENUM
INVALID_STATUS
INVALID_STATUS_TRANSITION
REQUIRED_FIELD
INVALID_FORMAT
INVALID_RANGE
DUPLICATE_RESOURCE
DUPLICATE_ENROLLMENT
DUPLICATE_ATTENDANCE
DUPLICATE_SKILL
INVALID_REFERENCE
CENTRE_MISMATCH
PROGRAM_MISMATCH
INVALID_ROLE
INVALID_SCOPE
RESOURCE_NOT_FOUND
FORBIDDEN
```

---

# 5. Common Data-Type Validation

## 5.1 UUID

All UUID fields must contain a valid UUID.

Examples:

```text
userId
centreId
beneficiaryId
programId
activityId
enrollmentId
volunteerId
taskId
progressRecordId
timelineEventId
```

Invalid:

```text
"123"
"abc"
"BEN-000001"
""
```

The human-readable beneficiary ID is not a substitute for the UUID primary key.

---

# 6. String Validation

String fields must:

- Exist when required.
- Not contain only whitespace.
- Be trimmed before processing.
- Respect their defined maximum length.
- Be validated according to their field meaning.

Example:

```text
"   " → invalid
" Example Name " → trim before storage
```

The exact maximum length should follow the Data Dictionary/database schema.

---

# 7. Email Validation

Where an email is required:

```text
must be present
must have a valid email format
must be normalized consistently
must satisfy database uniqueness where defined
```

Example:

```text
user@example.com → valid
invalid-email → invalid
```

---

# 8. Phone Validation

Where a phone number is collected:

```text
must contain a valid phone-number format
must not contain arbitrary unsupported characters
must satisfy the length/format defined by the Data Dictionary
```

The implementation must not silently change a valid phone number into a different number.

---

# 9. Date Validation

Dates must use the API format:

```text
YYYY-MM-DD
```

Example:

```text
2026-08-18
```

Invalid:

```text
18/08/2026
08-18-2026
not-a-date
```

A date must also represent a real calendar date.

---

# 10. DateTime Validation

DateTime fields should use a consistent ISO-compatible format.

Example:

```text
2026-08-18T10:30:00Z
```

The backend must normalize date/time handling consistently.

---

# 11. Time Validation

Time fields should use:

```text
HH:MM
```

Example:

```text
09:30
17:45
```

Where an activity contains both:

```text
startTime
endTime
```

the end time must be later than the start time.

---

# 12. Enum Validation

Enum fields must contain only values defined in the Data Dictionary and PostgreSQL schema.

The backend must reject unknown values.

Example:

```text
Program status:
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

Invalid:

```text
"RUNNING"
"FINISHED"
"random"
```

---

# 13. Nullability

The backend must distinguish between:

```text
missing
null
empty string
valid value
```

A field marked required must not be omitted.

A nullable field may explicitly contain:

```json
null
```

Empty strings should not be used as substitutes for null unless explicitly defined by the field contract.

---

# 14. User Validation

## 14.1 User Creation

Where user creation is supported, validate:

```text
fullName
email
phone
role
status
centreId
password
```

Rules:

- `fullName` is required.
- `email` must be valid.
- Email must satisfy the unique-user rule.
- `role` must be a valid `UserRole`.
- `status` must be a valid `UserStatus`.
- `centreId` must reference an existing centre where required.
- Password must satisfy the authentication security policy.
- Password hashes must never be accepted as normal frontend input.
- `passwordHash` must never be returned in an API response.

---

# 15. User Role Validation

Allowed MVP roles:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

The backend must reject unknown roles.

A normal user must not be able to change their own role through a profile-update API.

---

# 16. User Status Validation

Allowed values:

```text
ACTIVE
INACTIVE
SUSPENDED
```

Inactive or suspended users must not be allowed to perform operations that require an active authenticated account.

---

# 17. Centre Validation

A centre reference must point to an existing centre.

Rules:

```text
centreId must be valid UUID
centreId must exist
centre status must permit the requested operation
```

The backend must not trust a centre ID simply because it was submitted by the frontend.

---

# 18. Beneficiary Validation

Beneficiary registration is a critical workflow.

Required validation must cover:

```text
fullName
dateOfBirth
gender
phone
address
city
state
centreId
registrationDate
caseStatus
riskLevel
educationLevel
```

Optional fields must follow the Data Dictionary.

---

# 19. Beneficiary Full Name

Rules:

- Required.
- Must not be blank.
- Leading/trailing whitespace should be removed.
- Must satisfy the configured maximum length.
- Must not be accepted as an arbitrary identifier.

Example:

```text
" Priya Sharma " → store normalized value
"   " → reject
```

---

# 20. Beneficiary Date of Birth

Rules:

- Must be a valid date.
- Must not be an impossible calendar date.
- Must satisfy the product's age/business requirements where applicable.
- Future birth dates should be rejected.

The exact age-related business rules must follow the finalized Purnata stakeholder requirements.

---

# 21. Beneficiary Registration Date

Rules:

- Must be a valid date.
- Must not be an impossible calendar date.
- Must not violate any finalized case-history date rule.
- The backend should use the authenticated user as the creator where applicable.

---

# 22. Beneficiary Gender

The value must match the enum defined in the Data Dictionary.

Unknown values must be rejected.

Do not invent new enum values in the API implementation without updating the Data Dictionary and database schema.

---

# 23. Beneficiary Case Status

The value must match the PostgreSQL/Data Dictionary enum.

Status changes must follow approved business transitions.

The backend must not allow arbitrary transitions simply because both values are valid enum values.

---

# 24. Beneficiary Risk Level

Risk level must contain only an approved enum value.

The current Data Dictionary defines the available risk-level values.

The backend must reject values outside the approved enum.

---

# 25. Beneficiary Education Level

Education level must contain only an approved enum value.

Unknown education-level strings must be rejected.

---

# 26. Beneficiary Unique ID

Every beneficiary must receive one persistent human-readable identifier.

Example:

```text
BEN-000001
```

Rules:

1. The ID must be unique.
2. It must not be generated separately for each program.
3. It must remain associated with the same beneficiary.
4. It must not be changed during ordinary beneficiary updates.
5. A beneficiary participating in multiple programs must retain the same ID.
6. The backend/database must be responsible for uniqueness.

---

# 27. Duplicate Beneficiary Prevention

The system must reduce duplicate beneficiary records.

Before registration, the backend should perform duplicate checks using available identifying information.

Possible matching information may include:

```text
name
date of birth
phone
other approved identifying information
```

The exact matching algorithm must be finalized with Purnata stakeholders.

The system must not silently merge records based on weak or ambiguous matching.

If a duplicate is confidently identified:

```http
409 Conflict
```

may be returned.

---

# 28. Beneficiary Update Rules

When updating a beneficiary:

Allowed:

```text
permitted profile fields
permitted case fields
permitted status fields
```

Not allowed:

```text
changing the primary UUID
regenerating beneficiary identity
creating another beneficiary record for the same journey
```

The backend must enforce authorization before updating sensitive fields.

---

# 29. Program Validation

Program required fields include:

```text
name
description
category
centreId
startDate
objectives
status
```

`createdBy` must be derived from the authenticated user where applicable.

The frontend must not arbitrarily set another user as the creator.

---

# 30. Program Name

Rules:

- Required.
- Must not be blank.
- Must satisfy configured length.
- Must be trimmed.
- Must not contain unsupported data.

---

# 31. Program Category

Allowed values are defined by the Data Dictionary:

```text
EDUCATION
VOCATIONAL_TRAINING
COUNSELLING
LEGAL_SUPPORT
HEALTHCARE
SKILL_DEVELOPMENT
ECONOMIC_EMPOWERMENT
CHILDCARE
LIFE_SKILLS
REINTEGRATION
OTHER
```

Unknown categories must be rejected.

---

# 32. Program Status

Allowed values:

```text
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

The backend must validate both:

```text
valid status
```

and:

```text
valid transition
```

---

# 33. Program Date Rules

Rules:

```text
startDate must be valid
endDate, when present, must be valid
endDate must not be earlier than startDate
```

Example:

```text
startDate = 2026-08-20
endDate   = 2026-08-19
```

must be rejected.

---

# 34. Program Centre Consistency

Every program belongs to a centre.

The referenced centre must exist.

When an activity belongs to the program:

```text
activity.centreId
        =
program.centreId
```

must hold.

A cross-centre relationship must be rejected unless explicitly supported by the approved data model.

---

# 35. Program Enrollment Validation

Enrollment connects:

```text
Beneficiary
      ↓
Program
```

Required:

```text
beneficiaryId
programId
enrollmentDate
status
progressPercentage
```

---

# 36. Enrollment Reference Validation

Before creating an enrollment:

```text
beneficiary must exist
program must exist
```

Both IDs must be valid UUIDs.

---

# 37. Duplicate Enrollment Rule

A beneficiary must not have duplicate enrollment records for the same program where the database schema defines uniqueness.

Conceptually:

```text
beneficiaryId + programId
```

must be unique for the applicable enrollment rule.

Duplicate enrollment:

```http
409 Conflict
```

---

# 38. Enrollment Progress Validation

`progressPercentage` must be:

```text
0–100
```

Examples:

```text
0   → valid
25  → valid
50  → valid
75  → valid
100 → valid
-1  → invalid
101 → invalid
```

It is a program-level progress indicator and does not replace detailed progress records.

---

# 39. Enrollment Completion Date

If an enrollment is marked completed:

```text
status = COMPLETED
```

the completion-date requirement must follow the Data Dictionary/database contract.

A completion date must not be earlier than the enrollment date.

---

# 40. Enrollment Status

Allowed values:

```text
ACTIVE
COMPLETED
WITHDRAWN
PAUSED
```

Status transitions must follow approved business logic.

---

# 41. Activity Validation

Activity validation must cover:

```text
programId
centreId
name
description
activityType
activityDate
startTime
endTime
location
status
```

Where applicable, `createdBy` is derived from the authenticated user.

---

# 42. Activity Program Validation

The referenced program must exist.

An activity must belong to the referenced program.

---

# 43. Activity Centre Validation

The activity centre must match the program centre:

```text
activity.centreId = program.centreId
```

A mismatch must return a business validation error such as:

```text
CENTRE_MISMATCH
```

---

# 44. Activity Time Validation

Rules:

```text
startTime must be valid
endTime must be valid
endTime > startTime
```

Invalid:

```text
startTime = 14:00
endTime   = 13:00
```

---

# 45. Activity Date Validation

The activity date must be a valid date.

Additional date restrictions should be applied only when defined by the finalized business requirements.

---

# 46. Activity Status

The API must accept only the activity-status enum defined in the Data Dictionary/database schema.

The backend must reject unknown values.

Status transitions must be validated.

---

# 47. Volunteer Validation

A volunteer is a user whose role is:

```text
VOLUNTEER
```

Before assigning a user as a volunteer:

```text
user exists
AND
user.role = VOLUNTEER
```

must be true.

---

# 48. Volunteer Profile Validation

Volunteer profile data must:

- Reference an existing user.
- Belong to a user with `VOLUNTEER` role.
- Respect required field types.
- Respect enum values.
- Respect allowed status values.

---

# 49. Volunteer Skill Validation

Required:

```text
volunteerId
skillId
proficiencyLevel
```

Rules:

```text
volunteer must exist
volunteer must have VOLUNTEER role
skill must exist
proficiencyLevel must be valid
```

Duplicate volunteer + skill combinations must be rejected where the database defines uniqueness.

---

# 50. Volunteer Assignment Validation

Assignment can connect a volunteer to:

```text
program
activity
```

Rules:

1. Volunteer must exist.
2. Volunteer must have `VOLUNTEER` role.
3. Program must exist.
4. Activity must exist when supplied.
5. If an activity is supplied, it must belong to the same program.
6. The assigning user must be authorized.
7. Duplicate assignments must follow database uniqueness rules.
8. Assignment status must be a valid enum.

---

# 51. Assignment Program/Activity Consistency

If:

```text
activityId != null
```

then:

```text
activity.programId = programId
```

must be true.

Otherwise:

```text
PROGRAM_MISMATCH
```

must be returned.

---

# 52. Assignment Scope Validation

The Program Lead must be authorized to assign the volunteer to the specified program/activity.

The backend must not accept arbitrary IDs supplied by the frontend.

---

# 53. Task Validation

Task information may include:

```text
title
description
volunteerId
programId
activityId
dueDate
priority
status
```

The creator must be derived from the authenticated user where applicable.

---

# 54. Task Volunteer Validation

The referenced user must:

```text
exist
AND
have VOLUNTEER role
```

A task must not be assigned to a non-volunteer user unless the approved data model explicitly supports it.

---

# 55. Task Program Validation

If a program is supplied:

```text
program must exist
```

If an activity is supplied:

```text
activity must exist
```

---

# 56. Task Activity Consistency

If both are supplied:

```text
activity.programId = task.programId
```

must be true.

Otherwise:

```text
PROGRAM_MISMATCH
```

---

# 57. Task Due Date

The due date must be a valid date.

The backend should not impose additional past/future restrictions unless they are explicitly defined by the product requirements.

---

# 58. Task Priority

The value must match the approved `TaskPriority` enum.

Unknown priorities must be rejected.

---

# 59. Task Status

Allowed values defined by the PRD include:

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

The backend must validate status transitions.

---

# 60. Task Completion

When a task is marked:

```text
COMPLETED
```

the backend should maintain the completion timestamp where the database schema supports it.

A completed task should not be silently moved back to an earlier status without an approved transition rule.

---

# 61. Attendance Validation

Attendance connects:

```text
Beneficiary
      ↓
Activity
```

Required information includes:

```text
beneficiaryId
activityId
status
recordedBy
timestamp
```

`recordedBy` must be derived from the authenticated user.

---

# 62. Attendance Reference Validation

Before recording attendance:

```text
activity must exist
beneficiary must exist
```

The backend must also verify that the beneficiary is eligible to appear in the relevant activity/program according to the approved business model.

---

# 63. Attendance Status

Allowed values:

```text
PRESENT
ABSENT
EXCUSED
```

Unknown values must be rejected.

---

# 64. Duplicate Attendance

The same beneficiary must not receive multiple attendance records for the same activity where the schema defines:

```text
activityId + beneficiaryId
```

as unique.

Duplicate:

```http
409 Conflict
```

---

# 65. Attendance Authorization

A Program Lead may record attendance within their authorized scope.

A Volunteer may record attendance only for activities they are permitted to conduct.

The backend must check assignment scope.

---

# 66. Progress Record Validation

Progress records may be associated with:

```text
beneficiary
program
activity
skill
training
intervention
milestone
```

The exact fields must follow the Data Dictionary.

---

# 67. Progress Score Validation

Where a progress score is used:

```text
0 <= score <= 100
```

Examples:

```text
0   → valid
50  → valid
100 → valid
-5  → invalid
120 → invalid
```

---

# 68. Progress Relationship Validation

If a progress record references:

```text
beneficiaryId
programId
activityId
```

the referenced records must exist.

Where both program and activity are provided:

```text
activity.programId = programId
```

must be true.

---

# 69. Progress Authorization

A progress record may only be created or modified by a user authorized for the relevant beneficiary/program/activity scope.

Volunteers must not modify unrelated beneficiary progress.

---

# 70. Timeline Validation

Timeline events must contain valid references and event information.

Possible references include:

```text
beneficiaryId
programId
activityId
createdBy
```

Referenced entities must exist where supplied.

---

# 71. Timeline Event Type

The event type must be one of the approved `TimelineEventType` enum values.

The backend must reject invented event types.

---

# 72. Timeline Date

`eventDate` must be a valid date.

The backend must preserve chronological history.

The system should not silently alter historical event dates.

---

# 73. System-Generated Timeline Events

Where a system operation already represents a timeline event, the backend should generate the timeline event as part of the same transaction.

Examples:

```text
Beneficiary registration
        ↓
REGISTRATION

Program enrollment
        ↓
PROGRAM_ENROLLMENT

Progress milestone
        ↓
PROGRESS_MILESTONE
```

---

# 74. Audit Log Validation

Audit logs should normally be generated by backend operations rather than accepted as arbitrary client-created records.

The backend should derive:

```text
userId
action
entityType
entityId
timestamp
```

from the operation and authenticated identity.

Client users must not be able to forge audit-log ownership.

---

# 75. Audit Action Validation

The action must match the approved `AuditAction` enum.

Examples include actions for:

```text
CREATE
UPDATE
ASSIGN
COMPLETE
```

The final enum must remain consistent with the Data Dictionary and Database Schema.

---

# 76. Analytics Validation

Analytics endpoints must validate:

```text
date ranges
centre IDs
program IDs
filters
pagination
sorting
```

The backend must verify that the requesting user is authorized to access the requested analytics scope.

---

# 77. Date Range Validation

For requests containing:

```text
startDate
endDate
```

the backend must verify:

```text
both are valid dates
endDate >= startDate
```

Invalid range:

```text
startDate = 2026-08-31
endDate   = 2026-08-01
```

must be rejected.

---

# 78. Pagination Validation

Supported parameters:

```text
page
limit
```

Rules:

```text
page >= 1
limit >= 1
```

The backend must enforce a maximum page size.

Example:

```text
page=0 → invalid
limit=0 → invalid
limit=-1 → invalid
```

---

# 79. Sorting Validation

If sorting is supported:

```text
sortBy
sortOrder
```

must be validated against an allowlist.

`sortOrder` may be:

```text
asc
desc
```

The backend must never insert arbitrary client-provided sorting expressions directly into SQL.

---

# 80. Filter Validation

Supported filter values must be validated according to their field types.

Examples:

```text
status → valid enum
centreId → UUID
programId → UUID
startDate → valid date
endDate → valid date
```

Unknown filter fields should be rejected or ignored according to the API contract, but the behavior must be consistent.

---

# 81. Search Validation

Search strings should:

- Be trimmed.
- Respect maximum length.
- Be passed as SQL parameters.
- Be scoped by authorization.
- Not be directly concatenated into SQL.

---

# 82. Authorization Validation

Authorization is part of validation.

The backend must verify:

```text
authenticated user
      ↓
role
      ↓
resource
      ↓
requested action
      ↓
scope
```

A valid UUID does not mean the requester is authorized to access that record.

---

# 83. Ownership Validation

Fields such as:

```text
createdBy
recordedBy
assignedBy
```

must not normally be accepted from the frontend as trusted ownership values.

The backend must derive these from the authenticated user.

---

# 84. Cross-Entity Validation

Important consistency checks include:

```text
Activity → Program
Activity → Centre
Enrollment → Beneficiary
Enrollment → Program
Attendance → Activity
Attendance → Beneficiary
Assignment → Volunteer
Assignment → Program
Assignment → Activity
Task → Volunteer
Task → Program
Task → Activity
Progress → Beneficiary
Progress → Program
Progress → Activity
Timeline → Beneficiary
```

Each relationship must be checked before creating dependent records.

---

# 85. Status Transition Validation

Valid enum values are not enough.

The backend must also determine whether the requested transition is permitted.

Example:

```text
PLANNED → ACTIVE
ACTIVE → COMPLETED
ACTIVE → CANCELLED
```

An unsupported transition should return:

```text
INVALID_STATUS_TRANSITION
```

The exact transition matrix should be finalized per entity before implementing the corresponding workflow.

---

# 86. Delete Validation

Because beneficiary history and program history are important, deletion must be restricted.

Before deleting a record, the backend must check:

```text
authorization
dependent records
historical importance
database foreign-key constraints
```

Controlled status changes should generally be preferred where historical records depend on the resource.

---

# 87. Beneficiary Identity Protection

The following operations are prohibited:

```text
changing beneficiary UUID
regenerating beneficiary ID
creating a new beneficiary record for every program
silently merging two beneficiaries
```

If duplicate or identity conflicts are detected, the system should stop and require an approved resolution process.

---

# 88. Database Constraint Alignment

Backend validation must remain consistent with PostgreSQL constraints.

Important database protections include:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
ENUM
```

The backend should provide user-friendly errors for constraint violations instead of exposing raw PostgreSQL errors.

---

# 89. PostgreSQL Constraint Error Mapping

Database constraint failures should be translated into application errors.

Examples:

```text
unique violation
    ↓
DUPLICATE_RESOURCE / relevant duplicate code

foreign-key violation
    ↓
INVALID_REFERENCE

check violation
    ↓
INVALID_RANGE / VALIDATION_ERROR

enum violation
    ↓
INVALID_ENUM
```

Raw database internals should not be returned to the frontend.

---

# 90. Transaction Validation

Before starting a multi-table transaction, validate the request.

During the transaction:

```text
BEGIN
  ↓
perform operations
  ↓
verify dependent state
  ↓
COMMIT
```

On failure:

```text
ROLLBACK
```

A partially completed workflow must not be left in the database.

---

# 91. Beneficiary Registration Validation Flow

```text
Request
  ↓
Validate fields
  ↓
Validate centre
  ↓
Check duplicate identity
  ↓
Check authorization
  ↓
BEGIN
  ↓
Create beneficiary
  ↓
Generate persistent beneficiary ID
  ↓
Create timeline event
  ↓
Create audit log
  ↓
COMMIT
```

---

# 92. Program Enrollment Validation Flow

```text
Request
  ↓
Validate UUIDs
  ↓
Check beneficiary exists
  ↓
Check program exists
  ↓
Check authorization
  ↓
Check duplicate enrollment
  ↓
Validate progress 0–100
  ↓
BEGIN
  ↓
Create enrollment
  ↓
Create timeline event
  ↓
Create audit log
  ↓
COMMIT
```

---

# 93. Attendance Validation Flow

```text
Request
  ↓
Validate activity
  ↓
Validate beneficiary
  ↓
Validate attendance status
  ↓
Check activity/beneficiary eligibility
  ↓
Check volunteer/program-lead scope
  ↓
Check duplicate attendance
  ↓
BEGIN
  ↓
Create attendance
  ↓
Create audit log
  ↓
COMMIT
```

---

# 94. Progress Validation Flow

```text
Request
  ↓
Validate beneficiary
  ↓
Validate program/activity references
  ↓
Validate score
  ↓
Check authorization
  ↓
Create progress record
  ↓
Create timeline event where required
  ↓
Create audit log
```

If multiple records are written, the operation must use a transaction.

---

# 95. Frontend Validation Responsibilities

The React frontend should validate obvious user-input problems before submitting.

Examples:

```text
required fields
date format
email format
numeric range
empty strings
basic time consistency
```

Frontend validation should provide immediate feedback.

However:

```text
Frontend validation ≠ authorization
Frontend validation ≠ database integrity
```

---

# 96. Backend Validation Responsibilities

The backend must always repeat security- and business-critical validation.

Examples:

```text
role
scope
ownership
resource existence
duplicate records
status transitions
cross-entity consistency
numeric ranges
enum values
```

---

# 97. PostgreSQL Responsibilities

PostgreSQL should enforce fundamental integrity such as:

```text
UUID primary keys
foreign keys
unique constraints
not-null constraints
check constraints
enum values
```

The database must not be treated as the only validation layer because business authorization belongs in the backend.

---

# 98. Validation Order

Recommended order:

```text
1. Parse request
       ↓
2. Validate basic types
       ↓
3. Validate required fields
       ↓
4. Validate enums/formats/ranges
       ↓
5. Authenticate
       ↓
6. Authorize
       ↓
7. Validate resource existence
       ↓
8. Validate cross-entity relationships
       ↓
9. Validate business rules
       ↓
10. Execute database operation
```

For protected routes, authentication/authorization middleware may execute before request validation as an implementation detail.

The important requirement is that no unauthorized operation reaches business execution.

---

# 99. Validation and Sensitive Data

Validation errors must not expose sensitive beneficiary information.

Avoid responses such as:

```text
"Beneficiary BEN-000001 exists and belongs to another centre"
```

when that information itself is restricted.

Use appropriate generic responses where required by authorization policy.

---

# 100. Validation Logging

Validation failures that indicate suspicious behavior may be logged by the backend.

However, logs must not contain unnecessary sensitive beneficiary information.

Examples:

```text
repeated invalid authentication
repeated unauthorized resource access
repeated malformed requests
```

Audit logging and application logging remain separate concerns.

---

# 101. Validation Test Matrix

Minimum test categories:

| Area | Valid Case | Invalid Case |
|---|---|---|
| UUID | Valid UUID | Malformed UUID |
| Required field | Value supplied | Missing value |
| String | Non-empty | Whitespace only |
| Email | Valid email | Invalid format |
| Date | Valid date | Invalid/future DOB where prohibited |
| Enum | Approved value | Unknown value |
| Progress | 0–100 | <0 or >100 |
| Date range | End ≥ Start | End < Start |
| Time range | End > Start | End ≤ Start |
| Enrollment | New pair | Duplicate pair |
| Attendance | New activity/beneficiary pair | Duplicate pair |
| Volunteer | Role = VOLUNTEER | Other role |
| Activity | Program/centre consistent | Centre mismatch |
| Task | Volunteer valid | Non-volunteer |
| Scope | Authorized resource | Unauthorized resource |
| Status | Valid transition | Invalid transition |

---

# 102. API Validation Mapping

The API must apply these rules to the corresponding resources:

```text
/auth
    → authentication validation

/beneficiaries
    → beneficiary validation

/programs
    → program validation

/program-enrollments
    → enrollment validation

/activities
    → activity validation

/attendance
    → attendance validation

/volunteers
    → volunteer validation

/volunteer-assignments
    → assignment validation

/tasks
    → task validation

/progress-records
    → progress validation

/timeline-events
    → timeline validation

/analytics
    → filter/scope validation

/reports
    → report/filter/scope validation
```

---

# 103. AI Coding Agent Rules

Any AI coding agent implementing a feature must:

1. Read the relevant source documents.
2. Follow `DATA_DICTIONARY.md`.
3. Follow `DATABASE_SCHEMA.md`.
4. Follow `API_SPECIFICATION.md`.
5. Follow `ACCESS_CONTROL_MATRIX.md`.
6. Follow these validation rules.
7. Use parameterized PostgreSQL queries.
8. Preserve database constraints.
9. Preserve beneficiary identity.
10. Preserve authorization scope.
11. Avoid inventing enum values.
12. Avoid inventing business rules when the source documents leave them open.
13. Update the relevant specification if an approved rule changes.

Agents must not silently resolve open product decisions by inventing validation behavior.

---

# 104. Open Validation Decisions

The source documents leave some business rules open.

These must be finalized with stakeholders before implementation:

1. Exact beneficiary fields that must be collected.
2. Which beneficiary information is sensitive.
3. Exact volunteer permissions.
4. Whether volunteers can see beneficiary timelines.
5. Exact Executive Director access to individual beneficiary information.
6. Exact activity categories.
7. Exact beneficiary progress indicators.
8. Exact definition of successful program completion.
9. Volunteer skill catalogue.
10. Volunteer availability representation.
11. Notification requirements.
12. Offline data-entry requirements.
13. Data retention period.
14. Initial deployment centres.

No implementation should invent these rules without approval.

---

# 105. Validation Architecture Summary

The complete validation model is:

```text
                    USER INPUT
                        │
                        ▼
              ┌──────────────────┐
              │ React Validation │
              │ UX / Basic Rules │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │  Express API     │
              │ Request Parsing  │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ Authentication   │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ Authorization    │
              │ Role + Scope     │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ Backend          │
              │ Validation       │
              │ Business Rules   │
              └────────┬─────────┘
                       │
                       ▼
              ┌──────────────────┐
              │ PostgreSQL       │
              │ Constraints      │
              └────────┬─────────┘
                       │
                       ▼
                  VALID DATA
```

---

# 106. Final Rule

The Purnata validation architecture follows:

```text
Validate the input
        ↓
Verify the user
        ↓
Verify the scope
        ↓
Verify the referenced records
        ↓
Verify business rules
        ↓
Protect database integrity
        ↓
Perform the operation
        ↓
Audit important changes
```

The objective is to ensure that invalid, unauthorized, inconsistent, or duplicate data cannot enter the Purnata system while preserving the long-term integrity of each beneficiary journey.
