# DATA_DICTIONARY.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Final — Hackathon Implementation Specification  
**Parent Documents:**
- `PRD.md`
- `USER_FLOWS.md`
- `ACCESS_CONTROL_MATRIX.md`

---

# 1. Purpose

This document defines the exact data structure to be used by the Purnata platform.

It is the shared data contract for:

- Frontend
- Backend
- Database
- API
- Analytics
- AI coding agents
- Testing

All developers and AI agents must use the field names, types, relationships, and enum values defined here.

---

# 2. Core Data Model

The platform will use the following core entities:

```text
User
Centre
Beneficiary
Program
ProgramEnrollment
Activity
Attendance
VolunteerAssignment
Task
ProgressRecord
TimelineEvent
AuditLog
```

The overall relationship is:

```text
                         User
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
      Program Lead     Volunteer     Executive Director
          │               │
          │               │
          ▼               ▼
       Program       VolunteerAssignment
          │               │
          ▼               ▼
       Activity          Task
          │
          ▼
      Attendance
          │
          ▼
     Beneficiary
          │
    ┌─────┼──────────────┐
    ▼     ▼              ▼
Enrollment Progress    Timeline
    │
    ▼
  Program
```

---

# 3. Common Conventions

## 3.1 Internal IDs

Every database entity will have:

```text
id
```

Type:

```text
UUID
```

UUIDs are used internally to avoid exposing sequential database IDs.

---

## 3.2 Dates and Times

All timestamps stored by the backend will use UTC.

Fields:

```text
createdAt
updatedAt
```

Date-only fields:

```text
dateOfBirth
registrationDate
startDate
endDate
activityDate
enrollmentDate
completionDate
dueDate
```

---

## 3.3 Naming Convention

Frontend/API field names use:

```text
camelCase
```

Examples:

```text
beneficiaryId
programId
activityDate
createdAt
updatedAt
```

Database naming can be adapted to the selected database convention, but API field names must remain consistent with this document.

---

# 4. User

Represents every person who can access the system.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Internal user ID |
| fullName | String | Yes | User's full name |
| email | String | Yes | Login email |
| passwordHash | String | Yes | Hashed password |
| role | Enum | Yes | User role |
| phone | String | Yes | Contact number |
| centreId | UUID | No | Associated centre |
| status | Enum | Yes | Account status |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 5. User Roles

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

---

# 6. User Status

```text
ACTIVE
INACTIVE
SUSPENDED
```

---

# 7. Centre

Represents a Purnata operational centre.

The platform needs centre-level monitoring and analytics.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Centre ID |
| name | String | Yes | Centre name |
| address | String | Yes | Centre address |
| city | String | Yes | City |
| state | String | Yes | State |
| contactNumber | String | No | Centre contact number |
| status | Enum | Yes | Centre status |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 8. Centre Status

```text
ACTIVE
INACTIVE
```

---

# 9. Beneficiary

The beneficiary is the central entity of the system.

The platform must maintain one continuous identity for a beneficiary throughout their journey.

The problem statement specifically requires unique identifiers and continuity across multiple programs.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Internal database ID |
| beneficiaryId | String | Yes | Human-readable unique ID |
| fullName | String | Yes | Beneficiary name |
| dateOfBirth | Date | Yes | Date of birth |
| gender | Enum | Yes | Gender |
| phone | String | No | Contact number |
| address | String | Yes | Current address |
| city | String | Yes | City |
| state | String | Yes | State |
| centreId | UUID | Yes | Primary centre |
| registrationDate | Date | Yes | Registration date |
| caseStatus | Enum | Yes | Current case status |
| riskLevel | Enum | Yes | Current risk level |
| educationLevel | Enum | No | Education level |
| occupation | String | No | Current occupation |
| emergencyContactName | String | No | Emergency contact |
| emergencyContactPhone | String | No | Emergency contact number |
| notes | Text | No | General case notes |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 10. Beneficiary ID

Every beneficiary receives a unique human-readable identifier.

Format:

```text
BEN-000001
BEN-000002
BEN-000003
```

Rules:

1. `beneficiaryId` must be unique.
2. It must never be reused.
3. It must remain unchanged throughout the beneficiary journey.
4. Joining another program must not create another beneficiary.
5. All program enrollments must reference the existing beneficiary.

---

# 11. Gender

```text
FEMALE
MALE
OTHER
PREFER_NOT_TO_SAY
```

---

# 12. Case Status

The beneficiary journey is represented using:

```text
OUTREACH
RESCUED
REHABILITATION
REINTEGRATION
FOLLOW_UP
CLOSED
```

These stages reflect the Purnata requirement for tracking the journey from outreach/risk identification through rehabilitation, reintegration and long-term follow-up.

---

# 13. Risk Level

```text
LOW
MEDIUM
HIGH
CRITICAL
```

This is an operational classification used to prioritize case attention.

It is not a medical or legal diagnosis.

---

# 14. Education Level

```text
NO_FORMAL_EDUCATION
PRIMARY
SECONDARY
HIGHER_SECONDARY
UNDERGRADUATE
POSTGRADUATE
VOCATIONAL
OTHER
```

---

# 15. Program

Represents an organized Purnata intervention/program.

The problem statement requires program tracking, program participation monitoring, and program effectiveness analysis.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Program ID |
| name | String | Yes | Program name |
| description | Text | Yes | Program description |
| category | Enum | Yes | Program category |
| centreId | UUID | Yes | Centre conducting program |
| startDate | Date | Yes | Start date |
| endDate | Date | No | End date |
| objectives | Text | Yes | Program objectives |
| status | Enum | Yes | Program status |
| createdBy | UUID | Yes | Program Lead who created it |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 16. Program Category

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

These categories are aligned with the types of interventions described in the Purnata problem statement, including vocational training, counselling, legal aid, economic empowerment, education, day-care and skills training.

---

# 17. Program Status

```text
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

---

# 18. Program Enrollment

Represents the relationship between a beneficiary and a program.

This is critical because one beneficiary can participate in multiple programs.

```text
Beneficiary
     │
     ├── Enrollment → Program A
     ├── Enrollment → Program B
     └── Enrollment → Program C
```

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Enrollment ID |
| beneficiaryId | UUID | Yes | Beneficiary |
| programId | UUID | Yes | Program |
| enrollmentDate | Date | Yes | Enrollment date |
| status | Enum | Yes | Enrollment status |
| completionDate | Date | No | Completion date |
| progressPercentage | Integer | Yes | Current progress |
| notes | Text | No | Enrollment notes |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 19. Enrollment Status

```text
ACTIVE
COMPLETED
WITHDRAWN
PAUSED
```

---

# 20. Progress Percentage

Range:

```text
0 - 100
```

Example:

```text
0    = Not started
25   = Early progress
50   = Halfway
75   = Near completion
100  = Completed
```

This is a program-level progress indicator and should not replace detailed progress records.

---

# 21. Activity

Represents an individual session/activity conducted under a program.

The Purnata problem statement explicitly requires monitoring centre-specific activities and session attendance.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Activity ID |
| programId | UUID | Yes | Parent program |
| centreId | UUID | Yes | Centre |
| name | String | Yes | Activity name |
| description | Text | Yes | Activity description |
| activityType | Enum | Yes | Activity type |
| activityDate | Date | Yes | Activity date |
| startTime | Time | Yes | Start time |
| endTime | Time | Yes | End time |
| location | String | Yes | Activity location |
| status | Enum | Yes | Activity status |
| createdBy | UUID | Yes | Creator |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 22. Activity Type

```text
TRAINING
COUNSELLING_SESSION
EDUCATION_SESSION
SKILL_DEVELOPMENT
AWARENESS_SESSION
HEALTH_SESSION
LEGAL_SESSION
LIFE_SKILLS_SESSION
GROUP_ACTIVITY
OTHER
```

---

# 23. Activity Status

```text
PLANNED
ONGOING
COMPLETED
CANCELLED
```

---

# 24. Attendance

Records beneficiary attendance for an activity.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Attendance ID |
| activityId | UUID | Yes | Activity |
| beneficiaryId | UUID | Yes | Beneficiary |
| status | Enum | Yes | Attendance status |
| remarks | String | No | Attendance remarks |
| recordedBy | UUID | Yes | User who recorded attendance |
| recordedAt | DateTime | Yes | Recording timestamp |

---

# 25. Attendance Status

```text
PRESENT
ABSENT
EXCUSED
```

---

# 26. Attendance Rule

A beneficiary should have at most one attendance record for a particular activity.

Conceptually:

```text
(activityId + beneficiaryId)
```

must be unique.

---

# 27. Volunteer Profile

A volunteer is represented by a `User` with:

```text
role = VOLUNTEER
```

Additional volunteer-specific information is stored separately.

## Volunteer Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Volunteer profile ID |
| userId | UUID | Yes | Associated user |
| bio | Text | No | Volunteer description |
| availability | Enum | Yes | General availability |
| experience | Text | No | Previous experience |
| status | Enum | Yes | Volunteer status |
| joinedDate | Date | Yes | Joining date |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 28. Volunteer Availability

```text
WEEKDAYS
WEEKENDS
BOTH
FLEXIBLE
```

---

# 29. Volunteer Status

```text
ACTIVE
INACTIVE
ON_LEAVE
```

---

# 30. Volunteer Skill

Volunteers should be matched to suitable programs/tasks based on their skills.

## Fields

| Field | Type | Required |
|---|---|---:|
| id | UUID | Yes |
| name | String | Yes |
| description | String | No |

---

# 31. Volunteer Skill Mapping

Represents a volunteer's skill.

## Fields

| Field | Type | Required |
|---|---|---:|
| id | UUID | Yes |
| volunteerId | UUID | Yes |
| skillId | UUID | Yes |
| proficiencyLevel | Enum | Yes |

---

# 32. Skill Proficiency

```text
BEGINNER
INTERMEDIATE
ADVANCED
EXPERT
```

---

# 33. Volunteer Assignment

Connects a volunteer to a program and/or activity.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Assignment ID |
| volunteerId | UUID | Yes | Volunteer |
| programId | UUID | Yes | Program |
| activityId | UUID | No | Specific activity |
| assignedBy | UUID | Yes | Program Lead |
| assignmentDate | Date | Yes | Assignment date |
| status | Enum | Yes | Assignment status |
| notes | Text | No | Assignment notes |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 34. Volunteer Assignment Status

```text
ASSIGNED
ACTIVE
COMPLETED
CANCELLED
```

---

# 35. Task

Represents a specific task assigned to a volunteer.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Task ID |
| title | String | Yes | Task title |
| description | Text | Yes | Task description |
| volunteerId | UUID | Yes | Assigned volunteer |
| programId | UUID | Yes | Related program |
| activityId | UUID | No | Related activity |
| dueDate | Date | Yes | Task deadline |
| priority | Enum | Yes | Task priority |
| status | Enum | Yes | Task status |
| createdBy | UUID | Yes | Program Lead |
| completedAt | DateTime | No | Completion timestamp |
| createdAt | DateTime | Yes | Creation timestamp |
| updatedAt | DateTime | Yes | Last update timestamp |

---

# 36. Task Priority

```text
LOW
MEDIUM
HIGH
URGENT
```

---

# 37. Task Status

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

---

# 38. Progress Record

Stores individual progress observations for a beneficiary.

The Purnata problem statement requires tracking individualized interventions and progress milestones across the beneficiary journey.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Progress record ID |
| beneficiaryId | UUID | Yes | Beneficiary |
| programId | UUID | Yes | Related program |
| activityId | UUID | No | Related activity |
| category | Enum | Yes | Progress category |
| title | String | Yes | Progress milestone |
| description | Text | Yes | Detailed observation |
| score | Integer | Yes | Progress score |
| recordedBy | UUID | Yes | User recording progress |
| recordedAt | DateTime | Yes | Record timestamp |

---

# 39. Progress Categories

```text
EDUCATION
VOCATIONAL_SKILL
LIFE_SKILL
HEALTH
COUNSELLING
EMPLOYMENT
ECONOMIC_INDEPENDENCE
SOCIAL_REINTEGRATION
OTHER
```

---

# 40. Progress Score

Range:

```text
0 - 100
```

Interpretation:

```text
0-20     Initial
21-40    Early Progress
41-60    Developing
61-80    Good Progress
81-100   Strong Progress
```

The score is an application-level indicator used for hackathon analytics and visualization.

---

# 41. Timeline Event

Represents an important event in the beneficiary's journey.

The platform must maintain continuity from outreach/risk identification through rehabilitation, reintegration, and long-term follow-up.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Timeline event ID |
| beneficiaryId | UUID | Yes | Beneficiary |
| eventType | Enum | Yes | Event category |
| title | String | Yes | Event title |
| description | Text | Yes | Event details |
| eventDate | Date | Yes | Event date |
| programId | UUID | No | Related program |
| activityId | UUID | No | Related activity |
| createdBy | UUID | Yes | User who created event |
| createdAt | DateTime | Yes | Creation timestamp |

---

# 42. Timeline Event Types

```text
OUTREACH
RISK_IDENTIFICATION
REGISTRATION
RESCUE
REHABILITATION
PROGRAM_ENROLLMENT
ACTIVITY
PROGRESS_MILESTONE
REINTEGRATION
FOLLOW_UP
CASE_UPDATE
OTHER
```

---

# 43. Timeline Rules

The timeline should be chronological.

Events can be generated automatically from system actions.

Examples:

```text
Beneficiary Registered
        ↓
REGISTRATION event

Program Enrollment Created
        ↓
PROGRAM_ENROLLMENT event

Activity Completed
        ↓
ACTIVITY event

Progress Record Created
        ↓
PROGRESS_MILESTONE event
```

This prevents the Program Lead from manually entering duplicate timeline information.

---

# 44. Audit Log

Stores important system actions.

## Fields

| Field | Type | Required | Description |
|---|---|---:|---|
| id | UUID | Yes | Audit ID |
| userId | UUID | Yes | User performing action |
| action | Enum | Yes | Action performed |
| entityType | String | Yes | Entity affected |
| entityId | UUID | Yes | Affected record |
| description | String | Yes | Human-readable description |
| timestamp | DateTime | Yes | Action timestamp |
| metadata | JSON | No | Additional information |

---

# 45. Audit Actions

```text
CREATE
UPDATE
DELETE
LOGIN
LOGOUT
ASSIGN
COMPLETE
VIEW_SENSITIVE
```

---

# 46. Relationships

## User → Centre

```text
Centre
   │
   └── Users
```

A Program Lead or Volunteer can belong to a centre.

The Executive Director may have:

```text
centreId = NULL
```

because their scope is organization-wide.

---

## Centre → Beneficiary

```text
Centre
   │
   └── Beneficiaries
```

A beneficiary has one primary centre.

---

## Centre → Program

```text
Centre
   │
   └── Programs
```

A program belongs to one centre.

---

## Program → Activity

```text
Program
   │
   └── Activities
```

A program can have many activities.

---

## Beneficiary → Program

```text
Beneficiary
     │
     └── ProgramEnrollment
             │
             └── Program
```

This is a many-to-many relationship implemented through `ProgramEnrollment`.

---

## Activity → Attendance

```text
Activity
   │
   └── Attendance
          │
          └── Beneficiary
```

---

## Volunteer → Assignment

```text
Volunteer
    │
    └── VolunteerAssignment
             │
             ├── Program
             └── Activity
```

---

## Volunteer → Task

```text
Volunteer
    │
    └── Tasks
```

---

## Beneficiary → Progress

```text
Beneficiary
    │
    └── ProgressRecord
```

---

## Beneficiary → Timeline

```text
Beneficiary
    │
    └── TimelineEvent
```

---

# 47. Important Uniqueness Constraints

The following values must be unique:

```text
User.email
Beneficiary.beneficiaryId
Centre.name
```

Additionally:

```text
ProgramEnrollment
(beneficiaryId + programId)
```

must be unique for an active enrollment.

And:

```text
Attendance
(activityId + beneficiaryId)
```

must be unique.

---

# 48. Important Validation Rules

## Beneficiary

```text
fullName             → required
dateOfBirth          → required
gender               → required
centreId             → required
registrationDate     → required
caseStatus           → required
riskLevel            → required
```

## Program

```text
name                 → required
description          → required
category             → required
centreId             → required
startDate            → required
objectives           → required
status               → required
```

## Activity

```text
programId            → required
name                 → required
activityType         → required
activityDate         → required
startTime            → required
endTime              → required
location             → required
```

## Task

```text
title                → required
description          → required
volunteerId          → required
programId            → required
dueDate              → required
priority             → required
status               → required
```

---

# 49. Derived Analytics

Analytics should be calculated from the core entities.

## Program Analytics

Derived from:

```text
Program
ProgramEnrollment
Activity
Attendance
ProgressRecord
VolunteerAssignment
```

Possible metrics:

```text
Total Beneficiaries
Active Beneficiaries
Activities Conducted
Average Attendance
Volunteer Participation
Average Progress
Completion Rate
```

---

# 50. Centre Analytics

Derived from:

```text
Centre
Beneficiary
Program
Activity
Attendance
VolunteerAssignment
ProgressRecord
```

Possible metrics:

```text
Total Beneficiaries
Active Programs
Activities Conducted
Average Attendance
Volunteer Count
Average Beneficiary Progress
```

---

# 51. Organization Analytics

Derived across all centres.

```text
Centre
   ↓
Programs
   ↓
Beneficiaries
   ↓
Activities
   ↓
Attendance
   ↓
Progress
```

Possible metrics:

```text
Total Centres
Total Beneficiaries
Active Beneficiaries
Total Programs
Active Programs
Total Activities
Total Volunteers
Average Attendance
Average Progress
Successful Completions
```

---

# 52. Volunteer Performance Analytics

Derived from:

```text
VolunteerAssignment
Task
Activity
Attendance
```

Possible metrics:

```text
Programs Assigned
Activities Supported
Tasks Assigned
Tasks Completed
Task Completion Rate
Beneficiaries Supported
```

Task completion rate:

```text
completedTasks / totalAssignedTasks × 100
```

---

# 53. Beneficiary Progress Analytics

Derived from:

```text
ProgressRecord
ProgramEnrollment
Attendance
TimelineEvent
```

Possible visualizations:

```text
Progress Over Time
Program-wise Progress
Attendance Rate
Skill-wise Progress
Journey Timeline
```

---

# 54. No Duplicate Data Rule

The same business information must not be stored unnecessarily in multiple entities.

Example:

Do not store:

```text
beneficiaryName
```

inside every attendance record.

Instead:

```text
Attendance
    ↓
beneficiaryId
    ↓
Beneficiary
    ↓
fullName
```

This keeps the database consistent.

---

# 55. Historical Data Rule

Historical records must not be overwritten unnecessarily.

For example:

If a beneficiary changes their program status:

```text
ACTIVE
   ↓
COMPLETED
```

the system should preserve relevant historical records.

Similarly, attendance and timeline records must remain traceable.

---

# 56. Soft Delete Rule

For core historical entities, use status/archival rather than permanent deletion wherever possible.

Especially:

```text
Beneficiary
Program
Activity
Attendance
ProgressRecord
TimelineEvent
```

Permanent deletion should not be part of the normal user workflow.

---

# 57. API Contract Rule

The API must use the exact field names defined here.

Example:

```json
{
  "beneficiaryId": "BEN-000001",
  "fullName": "Example Name",
  "centreId": "uuid",
  "caseStatus": "REHABILITATION",
  "riskLevel": "MEDIUM"
}
```

The frontend AI must not rename these fields.

For example, it must not independently use:

```text
beneficiaryID
beneficiary_id
caseId
survivorId
```

when referring to the same concept.

---

# 58. AI Agent Rules

Every AI agent working on the project must follow these rules:

1. Read `PRD.md`.
2. Read `USER_FLOWS.md`.
3. Read `ACCESS_CONTROL_MATRIX.md`.
4. Read `DATA_DICTIONARY.md`.
5. Use the exact entity names.
6. Use the exact field names.
7. Use the exact enum values.
8. Do not invent alternative fields for an existing concept.
9. Do not rename fields without updating all dependent documents.
10. Do not create duplicate entities for the same business concept.
11. Maintain the one-beneficiary-one-identity rule.
12. Maintain the defined relationships.
13. If implementation requires a new field, update this document before using it across the system.

---

# 59. Hackathon Simplification Rules

This project is being developed for a hackathon.

Therefore the following decisions apply:

### Rule 1

Prefer simple data structures over unnecessary enterprise complexity.

### Rule 2

Analytics should be calculated from existing records.

### Rule 3

Do not create separate tables for every small UI concept.

### Rule 4

Do not implement features not defined in the PRD.

### Rule 5

Use realistic demo data to demonstrate the complete beneficiary journey.

### Rule 6

Prioritize the end-to-end flow:

```text
Beneficiary
    ↓
Program
    ↓
Enrollment
    ↓
Activity
    ↓
Attendance
    ↓
Progress
    ↓
Timeline
    ↓
Analytics
```

---

# 60. Final Entity List

The final MVP data model is:

```text
1.  User
2.  Centre
3.  Beneficiary
4.  Program
5.  ProgramEnrollment
6.  Activity
7.  Attendance
8.  VolunteerProfile
9.  Skill
10. VolunteerSkill
11. VolunteerAssignment
12. Task
13. ProgressRecord
14. TimelineEvent
15. AuditLog
```

---

# 61. Final Data Architecture

```text
                         ┌──────────────┐
                         │     USER     │
                         └──────┬───────┘
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
       PROGRAM_LEAD         VOLUNTEER      EXECUTIVE_DIRECTOR
              │                 │
              │                 ▼
              │          VolunteerProfile
              │                 │
              │                 ▼
              │              Skills
              │                 │
              │                 ▼
              │          VolunteerAssignment
              │                 │
              ▼                 ▼
           PROGRAM ─────────── ACTIVITY
              │                   │
              │                   ▼
              │              ATTENDANCE
              │                   │
              ▼                   │
      PROGRAM ENROLLMENT          │
              │                   │
              ▼                   ▼
        BENEFICIARY ──────── PROGRESS
              │
              │
              ▼
       TIMELINE EVENT
              │
              ▼
          ANALYTICS
              │
       ┌──────┼──────┐
       ▼      ▼      ▼
     PROGRAM CENTRE ORGANIZATION
```

---

# 62. Source-of-Truth Rule

For this hackathon, this document is the **single source of truth for data definitions**.

If another document conflicts with this document:

```text
DATA_DICTIONARY.md
        ↓
Review conflict
        ↓
Update affected documents
        ↓
Do not silently choose different field names
```

The next document to be created, `DATABASE_SCHEMA.md`, must be generated directly from this finalized data dictionary.