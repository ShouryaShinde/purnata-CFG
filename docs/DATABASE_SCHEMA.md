# DATABASE_SCHEMA.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Final — Hackathon Implementation Specification  
**Database:** PostgreSQL  
**Database Access:** Direct PostgreSQL connection using `pg` (node-postgres)  
**Backend:** Node.js + Express.js  

**Parent Documents:**

- `PRD.md`
- `USER_FLOWS.md`
- `ACCESS_CONTROL_MATRIX.md`
- `DATA_DICTIONARY.md`

---

# 1. Purpose

This document defines the complete relational database architecture for the Purnata platform.

It defines:

- Tables
- Columns
- Data types
- Primary keys
- Foreign keys
- Relationships
- Constraints
- Enums
- Indexes
- Unique constraints
- Delete/update behavior

The backend implementation must follow this document.

AI coding agents must not independently redesign the database structure.

---

# 2. Database Architecture

The application uses:

```text
React
   ↓
REST API
   ↓
Node.js + Express.js
   ↓
PostgreSQL (`pg` / node-postgres)
```

PostgreSQL is selected because the platform contains strongly related entities and requires:

- Referential integrity
- Unique beneficiary identities
- Many-to-many relationships
- Transactional operations
- Structured analytics
- Aggregation
- Reporting
- Historical records

---

# 3. Core Tables

The database contains the following tables:

```text
users
centres
beneficiaries
programs
program_enrollments
activities
attendances
volunteer_profiles
skills
volunteer_skills
volunteer_assignments
tasks
progress_records
timeline_events
audit_logs
```

---

# 4. High-Level Relationship Diagram

```text
                              USERS
                                │
              ┌─────────────────┼──────────────────┐
              │                 │                  │
              ▼                 ▼                  ▼
       PROGRAM_LEAD          VOLUNTEER       EXECUTIVE_DIRECTOR
              │                 │
              │                 ▼
              │        VOLUNTEER_PROFILES
              │                 │
              │                 ▼
              │          VOLUNTEER_SKILLS
              │                 │
              │                 ▼
              │              SKILLS
              │
              ▼
           PROGRAMS
              │
       ┌──────┼───────────────┐
       │      │               │
       ▼      ▼               ▼
 ACTIVITIES  PROGRAM_      VOLUNTEER_
             ENROLLMENTS   ASSIGNMENTS
       │          │               │
       ▼          ▼               │
 ATTENDANCES  BENEFICIARIES       │
                  │               │
          ┌───────┼────────┐      │
          │       │        │      │
          ▼       ▼        ▼      ▼
      PROGRESS  TIMELINE  ENROLLMENTS
      RECORDS   EVENTS
```

---

# 5. Primary Key Strategy

Every table will use:

```sql
UUID
```

as its primary key.

Example:

```sql
id UUID PRIMARY KEY
```

PostgreSQL should generate UUID values using PostgreSQL's UUID generation strategy.

Recommended approach:

```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

The `pg` (node-postgres) driver is used by the Node.js backend to execute SQL directly against PostgreSQL.

---

# 6. Common Timestamp Fields

Most tables should contain:

```text
created_at
updated_at
```

These should be maintained by the database using PostgreSQL defaults/triggers where required.

Example:

```sql
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
```

If `updated_at` must change automatically on every update, use a PostgreSQL trigger or explicitly update it in the SQL query.

Historical records such as attendance and audit logs additionally use their own event/record timestamps.

---

# 7. PostgreSQL Enums

The following PostgreSQL enums will be used.

---

## 7.1 UserRole

```sql
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

---

## 7.2 UserStatus

```sql
ACTIVE
INACTIVE
SUSPENDED
```

---

## 7.3 CentreStatus

```sql
ACTIVE
INACTIVE
```

---

## 7.4 Gender

```sql
FEMALE
MALE
OTHER
PREFER_NOT_TO_SAY
```

---

## 7.5 CaseStatus

```sql
OUTREACH
RESCUED
REHABILITATION
REINTEGRATION
FOLLOW_UP
CLOSED
```

---

## 7.6 RiskLevel

```sql
LOW
MEDIUM
HIGH
CRITICAL
```

---

## 7.7 EducationLevel

```sql
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

## 7.8 ProgramCategory

```sql
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

---

## 7.9 ProgramStatus

```sql
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

---

## 7.10 EnrollmentStatus

```sql
ACTIVE
COMPLETED
WITHDRAWN
PAUSED
```

---

## 7.11 ActivityType

```sql
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

## 7.12 ActivityStatus

```sql
PLANNED
ONGOING
COMPLETED
CANCELLED
```

---

## 7.13 AttendanceStatus

```sql
PRESENT
ABSENT
EXCUSED
```

---

## 7.14 VolunteerAvailability

```sql
WEEKDAYS
WEEKENDS
BOTH
FLEXIBLE
```

---

## 7.15 VolunteerStatus

```sql
ACTIVE
INACTIVE
ON_LEAVE
```

---

## 7.16 SkillProficiency

```sql
BEGINNER
INTERMEDIATE
ADVANCED
EXPERT
```

---

## 7.17 AssignmentStatus

```sql
ASSIGNED
ACTIVE
COMPLETED
CANCELLED
```

---

## 7.18 TaskPriority

```sql
LOW
MEDIUM
HIGH
URGENT
```

---

## 7.19 TaskStatus

```sql
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

---

## 7.20 ProgressCategory

```sql
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

## 7.21 TimelineEventType

```sql
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

## 7.22 AuditAction

```sql
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

# 8. Users Table

Table:

```text
users
```

Purpose:

Stores all authenticated users.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| full_name | VARCHAR(150) | NOT NULL |
| email | VARCHAR(255) | NOT NULL, UNIQUE |
| password_hash | TEXT | NOT NULL |
| role | UserRole | NOT NULL |
| phone | VARCHAR(20) | NOT NULL |
| centre_id | UUID | FK, NULL allowed |
| status | UserStatus | NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

## Relationships

```text
users.centre_id
        ↓
centres.id
```

A Program Lead or Volunteer can be associated with a centre.

The Executive Director can have:

```text
centre_id = NULL
```

because their access is organization-wide.

---

## Constraints

```text
email UNIQUE
```

---

## Indexes

```sql
CREATE INDEX idx_users_role
ON users(role);

CREATE INDEX idx_users_centre
ON users(centre_id);

CREATE INDEX idx_users_status
ON users(status);
```

---

# 9. Centres Table

Table:

```text
centres
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| name | VARCHAR(150) | NOT NULL, UNIQUE |
| address | TEXT | NOT NULL |
| city | VARCHAR(100) | NOT NULL |
| state | VARCHAR(100) | NOT NULL |
| contact_number | VARCHAR(20) | NULL |
| status | CentreStatus | NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 10. Beneficiaries Table

Table:

```text
beneficiaries
```

This is the central table of the system.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| beneficiary_id | VARCHAR(20) | NOT NULL, UNIQUE |
| full_name | VARCHAR(150) | NOT NULL |
| date_of_birth | DATE | NOT NULL |
| gender | Gender | NOT NULL |
| phone | VARCHAR(20) | NULL |
| address | TEXT | NOT NULL |
| city | VARCHAR(100) | NOT NULL |
| state | VARCHAR(100) | NOT NULL |
| centre_id | UUID | FK, NOT NULL |
| registration_date | DATE | NOT NULL |
| case_status | CaseStatus | NOT NULL |
| risk_level | RiskLevel | NOT NULL |
| education_level | EducationLevel | NULL |
| occupation | VARCHAR(150) | NULL |
| emergency_contact_name | VARCHAR(150) | NULL |
| emergency_contact_phone | VARCHAR(20) | NULL |
| notes | TEXT | NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 11. Beneficiary ID

The human-readable identifier follows:

```text
BEN-000001
BEN-000002
BEN-000003
```

Rules:

1. `beneficiary_id` must be unique.
2. It must never be reused.
3. It must remain unchanged.
4. It is independent of the PostgreSQL UUID.
5. Program enrollment must reference the same beneficiary record.

---

# 12. Beneficiary Relationships

```text
beneficiaries.centre_id
        ↓
centres.id
```

Beneficiary also connects to:

```text
program_enrollments
attendances
progress_records
timeline_events
```

---

# 13. Beneficiary Indexes

```sql
CREATE UNIQUE INDEX idx_beneficiary_id
ON beneficiaries(beneficiary_id);

CREATE INDEX idx_beneficiary_centre
ON beneficiaries(centre_id);

CREATE INDEX idx_beneficiary_status
ON beneficiaries(case_status);

CREATE INDEX idx_beneficiary_risk
ON beneficiaries(risk_level);

CREATE INDEX idx_beneficiary_name
ON beneficiaries(full_name);
```

---

# 14. Programs Table

Table:

```text
programs
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| name | VARCHAR(200) | NOT NULL |
| description | TEXT | NOT NULL |
| category | ProgramCategory | NOT NULL |
| centre_id | UUID | FK, NOT NULL |
| start_date | DATE | NOT NULL |
| end_date | DATE | NULL |
| objectives | TEXT | NOT NULL |
| status | ProgramStatus | NOT NULL |
| created_by | UUID | FK users, NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 15. Program Relationships

```text
programs.centre_id
        ↓
centres.id
```

```text
programs.created_by
        ↓
users.id
```

A program can contain:

```text
activities
program_enrollments
volunteer_assignments
tasks
progress_records
```

---

# 16. Program Indexes

```sql
CREATE INDEX idx_program_centre
ON programs(centre_id);

CREATE INDEX idx_program_status
ON programs(status);

CREATE INDEX idx_program_category
ON programs(category);

CREATE INDEX idx_program_dates
ON programs(start_date, end_date);

CREATE INDEX idx_program_created_by
ON programs(created_by);
```

---

# 17. Program Enrollments Table

Table:

```text
program_enrollments
```

This implements the many-to-many relationship:

```text
Beneficiary N ──── N Program
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| beneficiary_id | UUID | FK, NOT NULL |
| program_id | UUID | FK, NOT NULL |
| enrollment_date | DATE | NOT NULL |
| status | EnrollmentStatus | NOT NULL |
| completion_date | DATE | NULL |
| progress_percentage | INTEGER | NOT NULL |
| notes | TEXT | NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 18. Enrollment Constraints

```sql
CHECK (
    progress_percentage >= 0
    AND progress_percentage <= 100
)
```

Unique:

```sql
UNIQUE (
    beneficiary_id,
    program_id
)
```

This prevents the same beneficiary from being enrolled into the same program multiple times.

---

# 19. Enrollment Relationships

```text
program_enrollments.beneficiary_id
        ↓
beneficiaries.id
```

```text
program_enrollments.program_id
        ↓
programs.id
```

---

# 20. Enrollment Indexes

```sql
CREATE INDEX idx_enrollment_beneficiary
ON program_enrollments(beneficiary_id);

CREATE INDEX idx_enrollment_program
ON program_enrollments(program_id);

CREATE INDEX idx_enrollment_status
ON program_enrollments(status);
```

---

# 21. Activities Table

Table:

```text
activities
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| program_id | UUID | FK, NOT NULL |
| centre_id | UUID | FK, NOT NULL |
| name | VARCHAR(200) | NOT NULL |
| description | TEXT | NOT NULL |
| activity_type | ActivityType | NOT NULL |
| activity_date | DATE | NOT NULL |
| start_time | TIME | NOT NULL |
| end_time | TIME | NOT NULL |
| location | VARCHAR(200) | NOT NULL |
| status | ActivityStatus | NOT NULL |
| created_by | UUID | FK users, NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 22. Activity Constraints

The following should be validated:

```text
end_time > start_time
```

The activity must belong to the same centre as its program.

Conceptually:

```text
activity.centre_id
       =
program.centre_id
```

This should be enforced in backend business logic.

---

# 23. Activity Relationships

```text
activities.program_id
        ↓
programs.id
```

```text
activities.centre_id
        ↓
centres.id
```

```text
activities.created_by
        ↓
users.id
```

Activities connect to:

```text
attendances
volunteer_assignments
tasks
progress_records
timeline_events
```

---

# 24. Activity Indexes

```sql
CREATE INDEX idx_activity_program
ON activities(program_id);

CREATE INDEX idx_activity_centre
ON activities(centre_id);

CREATE INDEX idx_activity_date
ON activities(activity_date);

CREATE INDEX idx_activity_status
ON activities(status);
```

---

# 25. Attendances Table

Table:

```text
attendances
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| activity_id | UUID | FK, NOT NULL |
| beneficiary_id | UUID | FK, NOT NULL |
| status | AttendanceStatus | NOT NULL |
| remarks | TEXT | NULL |
| recorded_by | UUID | FK users, NOT NULL |
| recorded_at | TIMESTAMP | NOT NULL |

---

# 26. Attendance Unique Constraint

A beneficiary can have only one attendance record per activity.

```sql
UNIQUE (
    activity_id,
    beneficiary_id
)
```

This prevents duplicate attendance.

---

# 27. Attendance Relationships

```text
attendances.activity_id
        ↓
activities.id
```

```text
attendances.beneficiary_id
        ↓
beneficiaries.id
```

```text
attendances.recorded_by
        ↓
users.id
```

---

# 28. Attendance Indexes

```sql
CREATE INDEX idx_attendance_activity
ON attendances(activity_id);

CREATE INDEX idx_attendance_beneficiary
ON attendances(beneficiary_id);

CREATE INDEX idx_attendance_status
ON attendances(status);
```

---

# 29. Volunteer Profiles Table

Table:

```text
volunteer_profiles
```

A volunteer is a user where:

```text
users.role = VOLUNTEER
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| user_id | UUID | FK, UNIQUE, NOT NULL |
| bio | TEXT | NULL |
| availability | VolunteerAvailability | NOT NULL |
| experience | TEXT | NULL |
| status | VolunteerStatus | NOT NULL |
| joined_date | DATE | NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 30. Volunteer Profile Relationship

```text
users
  │
  │ 1
  ▼
volunteer_profiles
```

One volunteer profile belongs to exactly one user.

A user with role:

```text
PROGRAM_LEAD
```

must not have a volunteer profile.

This should be enforced through backend business logic.

---

# 31. Skills Table

Table:

```text
skills
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| name | VARCHAR(100) | NOT NULL, UNIQUE |
| description | TEXT | NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 32. Volunteer Skills Table

Table:

```text
volunteer_skills
```

Implements:

```text
Volunteer N ──── N Skill
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| volunteer_id | UUID | FK, NOT NULL |
| skill_id | UUID | FK, NOT NULL |
| proficiency_level | SkillProficiency | NOT NULL |
| created_at | TIMESTAMP | NOT NULL |

---

# 33. Volunteer Skill Constraint

A volunteer cannot have the same skill more than once.

```sql
UNIQUE (
    volunteer_id,
    skill_id
)
```

---

# 34. Volunteer Assignments Table

Table:

```text
volunteer_assignments
```

Connects volunteers with programs and activities.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| volunteer_id | UUID | FK users, NOT NULL |
| program_id | UUID | FK, NOT NULL |
| activity_id | UUID | FK, NULL |
| assigned_by | UUID | FK users, NOT NULL |
| assignment_date | DATE | NOT NULL |
| status | AssignmentStatus | NOT NULL |
| notes | TEXT | NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 35. Volunteer Assignment Rules

`volunteer_id` must reference a user with:

```text
role = VOLUNTEER
```

`assigned_by` must reference a user with:

```text
role = PROGRAM_LEAD
```

If `activity_id` is provided:

```text
activity.program_id = assignment.program_id
```

must be true.

---

# 36. Volunteer Assignment Indexes

```sql
CREATE INDEX idx_assignment_volunteer
ON volunteer_assignments(volunteer_id);

CREATE INDEX idx_assignment_program
ON volunteer_assignments(program_id);

CREATE INDEX idx_assignment_activity
ON volunteer_assignments(activity_id);

CREATE INDEX idx_assignment_status
ON volunteer_assignments(status);
```

---

# 37. Tasks Table

Table:

```text
tasks
```

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | NOT NULL |
| volunteer_id | UUID | FK users, NOT NULL |
| program_id | UUID | FK programs, NOT NULL |
| activity_id | UUID | FK activities, NULL |
| due_date | DATE | NOT NULL |
| priority | TaskPriority | NOT NULL |
| status | TaskStatus | NOT NULL |
| created_by | UUID | FK users, NOT NULL |
| completed_at | TIMESTAMP | NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 38. Task Rules

`volunteer_id` must belong to a Volunteer.

`created_by` must belong to a Program Lead.

If `activity_id` is provided:

```text
activity.program_id = task.program_id
```

---

# 39. Task Indexes

```sql
CREATE INDEX idx_task_volunteer
ON tasks(volunteer_id);

CREATE INDEX idx_task_program
ON tasks(program_id);

CREATE INDEX idx_task_activity
ON tasks(activity_id);

CREATE INDEX idx_task_status
ON tasks(status);

CREATE INDEX idx_task_due_date
ON tasks(due_date);
```

---

# 40. Progress Records Table

Table:

```text
progress_records
```

Stores individual beneficiary progress observations.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| beneficiary_id | UUID | FK, NOT NULL |
| program_id | UUID | FK, NOT NULL |
| activity_id | UUID | FK, NULL |
| category | ProgressCategory | NOT NULL |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | NOT NULL |
| score | INTEGER | NOT NULL |
| recorded_by | UUID | FK users, NOT NULL |
| recorded_at | TIMESTAMP | NOT NULL |
| created_at | TIMESTAMP | NOT NULL |
| updated_at | TIMESTAMP | NOT NULL |

---

# 41. Progress Score Constraint

Score must be:

```text
0 - 100
```

PostgreSQL constraint:

```sql
CHECK (
    score >= 0
    AND score <= 100
)
```

---

# 42. Progress Relationships

```text
progress_records.beneficiary_id
        ↓
beneficiaries.id
```

```text
progress_records.program_id
        ↓
programs.id
```

Optional:

```text
progress_records.activity_id
        ↓
activities.id
```

---

# 43. Progress Indexes

```sql
CREATE INDEX idx_progress_beneficiary
ON progress_records(beneficiary_id);

CREATE INDEX idx_progress_program
ON progress_records(program_id);

CREATE INDEX idx_progress_category
ON progress_records(category);

CREATE INDEX idx_progress_date
ON progress_records(recorded_at);
```

---

# 44. Timeline Events Table

Table:

```text
timeline_events
```

Represents the beneficiary's long-term journey.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| beneficiary_id | UUID | FK, NOT NULL |
| event_type | TimelineEventType | NOT NULL |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | NOT NULL |
| event_date | DATE | NOT NULL |
| program_id | UUID | FK, NULL |
| activity_id | UUID | FK, NULL |
| created_by | UUID | FK users, NOT NULL |
| created_at | TIMESTAMP | NOT NULL |

---

# 45. Timeline Relationships

```text
timeline_events.beneficiary_id
        ↓
beneficiaries.id
```

Optional:

```text
timeline_events.program_id
        ↓
programs.id
```

Optional:

```text
timeline_events.activity_id
        ↓
activities.id
```

---

# 46. Timeline Indexes

```sql
CREATE INDEX idx_timeline_beneficiary
ON timeline_events(beneficiary_id);

CREATE INDEX idx_timeline_date
ON timeline_events(event_date);

CREATE INDEX idx_timeline_type
ON timeline_events(event_type);
```

---

# 47. Audit Logs Table

Table:

```text
audit_logs
```

Stores important system actions.

---

## Columns

| Column | PostgreSQL Type | Constraints |
|---|---|---|
| id | UUID | PK |
| user_id | UUID | FK, NOT NULL |
| action | AuditAction | NOT NULL |
| entity_type | VARCHAR(100) | NOT NULL |
| entity_id | UUID | NOT NULL |
| description | TEXT | NOT NULL |
| timestamp | TIMESTAMP | NOT NULL |
| metadata | JSONB | NULL |

---

# 48. Audit Log Indexes

```sql
CREATE INDEX idx_audit_user
ON audit_logs(user_id);

CREATE INDEX idx_audit_entity
ON audit_logs(entity_type, entity_id);

CREATE INDEX idx_audit_timestamp
ON audit_logs(timestamp);

CREATE INDEX idx_audit_action
ON audit_logs(action);
```

---

# 49. Complete Relationship Map

```text
CENTRE
 │
 ├──────────── USERS
 │
 ├──────────── BENEFICIARIES
 │
 └──────────── PROGRAMS
                    │
                    ├──────── ACTIVITIES
                    │              │
                    │              └──── ATTENDANCES
                    │
                    ├──────── PROGRAM_ENROLLMENTS
                    │              │
                    │              └──── BENEFICIARIES
                    │
                    ├──────── VOLUNTEER_ASSIGNMENTS
                    │              │
                    │              └──── USERS
                    │
                    ├──────── TASKS
                    │
                    └──────── PROGRESS_RECORDS


USER
 │
 ├──── VOLUNTEER_PROFILE
 │            │
 │            └──── VOLUNTEER_SKILLS
 │                         │
 │                         └──── SKILLS
 │
 ├──── PROGRAMS (createdBy)
 ├──── ACTIVITIES (createdBy)
 ├──── ATTENDANCES (recordedBy)
 ├──── TASKS (createdBy)
 ├──── PROGRESS_RECORDS (recordedBy)
 ├──── TIMELINE_EVENTS (createdBy)
 └──── AUDIT_LOGS


BENEFICIARY
 │
 ├──── PROGRAM_ENROLLMENTS
 ├──── ATTENDANCES
 ├──── PROGRESS_RECORDS
 └──── TIMELINE_EVENTS
```

---

# 50. Foreign Key Delete Rules

Because beneficiary history must be preserved, destructive cascading deletes should be avoided.

## Beneficiary

Do not allow deletion when dependent historical records exist.

```text
Beneficiary
    │
    ├── Enrollment
    ├── Attendance
    ├── Progress
    └── Timeline
```

The normal application behavior should be:

```text
ACTIVE
   ↓
CLOSED
```

rather than:

```text
DELETE
```

---

# 51. Program Delete Rules

Programs should not normally be permanently deleted after activities or enrollments exist.

Use:

```text
CANCELLED
```

or another controlled status.

---

# 52. Activity Delete Rules

Activities with attendance or progress records should not be permanently deleted.

Use:

```text
CANCELLED
```

where appropriate.

---

# 53. Referential Integrity

Every foreign key must point to an existing record.

Examples:

```text
program.centre_id
        ↓
existing centre
```

```text
enrollment.beneficiary_id
        ↓
existing beneficiary
```

```text
attendance.activity_id
        ↓
existing activity
```

The backend must not accept IDs for nonexistent records.

---

# 54. Transaction Requirements

Operations that modify multiple related tables should use PostgreSQL transactions through the `pg` (node-postgres) client.

## Example: Register Beneficiary

The following operation should be treated atomically:

```text
Create Beneficiary
       ↓
Create Timeline Event
       ↓
Create Audit Log
```

Either all succeed or all fail.

---

# 55. Transaction Example — Program Enrollment

```text
Create Enrollment
       ↓
Create Timeline Event
       ↓
Create Audit Log
```

All operations should occur inside one database transaction.

---

# 56. Transaction Example — Complete Activity

When an activity is completed:

```text
Update Activity Status
       ↓
Update related records if required
       ↓
Create Timeline Events where applicable
       ↓
Create Audit Log
```

This should be handled transactionally where multiple writes are involved.

---

# 57. Beneficiary Timeline Automation

The timeline should not depend entirely on manual entry.

Important system actions should automatically generate timeline events.

Examples:

```text
Beneficiary Registration
        ↓
REGISTRATION

Program Enrollment
        ↓
PROGRAM_ENROLLMENT

Activity Completion
        ↓
ACTIVITY

Progress Record
        ↓
PROGRESS_MILESTONE
```

This creates the continuous journey required by the platform.

---

# 58. Data Integrity Rules

The database must enforce or support the following:

```text
✓ User email is unique
✓ Centre name is unique
✓ Beneficiary ID is unique
✓ Program enrollment cannot duplicate beneficiary + program
✓ Attendance cannot duplicate activity + beneficiary
✓ Volunteer skill cannot duplicate volunteer + skill
✓ Progress score must be 0–100
✓ Enrollment progress must be 0–100
✓ Foreign keys must reference valid records
```

---

# 59. Important Business Rules

Some rules require backend validation in addition to database constraints.

## Rule 1 — Volunteer Assignment

Only a Volunteer can be assigned as a volunteer.

## Rule 2 — Program Creation

Only a Program Lead can create a program.

## Rule 3 — Activity Creation

Only authorized Program Leads can create activities.

## Rule 4 — Task Assignment

Only authorized Program Leads can assign tasks.

## Rule 5 — Attendance

Attendance can only be recorded for beneficiaries participating in the relevant program/activity.

## Rule 6 — Progress

Progress must belong to an existing beneficiary and program.

## Rule 7 — Centre Consistency

A program belongs to a centre, and its activities should belong to that same centre.

---

# 60. Analytics Queries

PostgreSQL will be used to calculate analytics from normalized data.

---

## 60.1 Total Beneficiaries

```sql
SELECT COUNT(*)
FROM beneficiaries;
```

---

## 60.2 Active Beneficiaries

```sql
SELECT COUNT(*)
FROM beneficiaries
WHERE case_status != 'CLOSED';
```

---

## 60.3 Beneficiaries Per Centre

```sql
SELECT
    c.name,
    COUNT(b.id) AS beneficiary_count
FROM centres c
LEFT JOIN beneficiaries b
    ON b.centre_id = c.id
GROUP BY c.id, c.name;
```

---

## 60.4 Program Enrollment Count

```sql
SELECT
    p.name,
    COUNT(pe.id) AS enrollment_count
FROM programs p
LEFT JOIN program_enrollments pe
    ON pe.program_id = p.id
GROUP BY p.id, p.name;
```

---

## 60.5 Attendance Rate

Conceptually:

```text
Present Attendance
------------------ × 100
Total Attendance
```

The exact API query will be defined in `ANALYTICS_SPECIFICATION.md`.

---

## 60.6 Volunteer Task Completion Rate

```text
Completed Tasks
--------------- × 100
Assigned Tasks
```

---

## 60.7 Average Progress

```text
AVG(progress_records.score)
```

can be used for relevant program/centre/organization analytics.

---

# 61. Recommended Database Index Strategy

Indexes should be created for:

```text
users.email
users.role
users.centre_id

centres.name

beneficiaries.beneficiary_id
beneficiaries.centre_id
beneficiaries.case_status
beneficiaries.risk_level
beneficiaries.full_name

programs.centre_id
programs.status
programs.category
programs.start_date

program_enrollments.beneficiary_id
program_enrollments.program_id

activities.program_id
activities.centre_id
activities.activity_date

attendances.activity_id
attendances.beneficiary_id

volunteer_profiles.user_id

skills.name

volunteer_skills.volunteer_id
volunteer_skills.skill_id

volunteer_assignments.volunteer_id
volunteer_assignments.program_id
volunteer_assignments.activity_id

tasks.volunteer_id
tasks.program_id
tasks.status
tasks.due_date

progress_records.beneficiary_id
progress_records.program_id
progress_records.recorded_at

timeline_events.beneficiary_id
timeline_events.event_date

audit_logs.user_id
audit_logs.entity_type
audit_logs.entity_id
audit_logs.timestamp
```

Do not add indexes without a reason.

---

# 62. PostgreSQL SQL Structure

The backend should maintain the PostgreSQL schema as SQL definitions/migrations.

Recommended project structure:

```text
database/
├── migrations/
│   ├── 001_create_enums.sql
│   ├── 002_create_tables.sql
│   ├── 003_create_indexes.sql
│   └── 004_create_constraints.sql
└── seed.sql
```

The SQL schema should contain:

```text
CREATE TYPE user_role AS ENUM (...)
CREATE TYPE user_status AS ENUM (...)
CREATE TYPE centre_status AS ENUM (...)
CREATE TYPE gender AS ENUM (...)
CREATE TYPE case_status AS ENUM (...)
CREATE TYPE risk_level AS ENUM (...)
CREATE TYPE education_level AS ENUM (...)
CREATE TYPE program_category AS ENUM (...)
CREATE TYPE program_status AS ENUM (...)
CREATE TYPE enrollment_status AS ENUM (...)
CREATE TYPE activity_type AS ENUM (...)
CREATE TYPE activity_status AS ENUM (...)
CREATE TYPE attendance_status AS ENUM (...)
CREATE TYPE volunteer_availability AS ENUM (...)
CREATE TYPE volunteer_status AS ENUM (...)
CREATE TYPE skill_proficiency AS ENUM (...)
CREATE TYPE assignment_status AS ENUM (...)
CREATE TYPE task_priority AS ENUM (...)
CREATE TYPE task_status AS ENUM (...)
CREATE TYPE progress_category AS ENUM (...)
CREATE TYPE timeline_event_type AS ENUM (...)
CREATE TYPE audit_action AS ENUM (...)

CREATE TABLE users (...);
CREATE TABLE centres (...);
CREATE TABLE beneficiaries (...);
CREATE TABLE programs (...);
CREATE TABLE program_enrollments (...);
CREATE TABLE activities (...);
CREATE TABLE attendances (...);
CREATE TABLE volunteer_profiles (...);
CREATE TABLE skills (...);
CREATE TABLE volunteer_skills (...);
CREATE TABLE volunteer_assignments (...);
CREATE TABLE tasks (...);
CREATE TABLE progress_records (...);
CREATE TABLE timeline_events (...);
CREATE TABLE audit_logs (...);
```

---

# 63. PostgreSQL Relationship Rule

Every relationship must be explicitly defined using PostgreSQL foreign keys.

Example concept:

```text
Centre
 └── beneficiaries[]

Beneficiary
 └── centre

Beneficiary
 └── programEnrollments[]

Program
 └── enrollments[]
```

The AI backend agent must not create duplicated relationship columns or tables that represent different concepts.

---

# 64. Database Migration Strategy

All database changes must be performed through version-controlled PostgreSQL SQL migrations.

Development workflow:

```text
Modify SQL migration
        ↓
Review migration
        ↓
Apply migration to PostgreSQL
        ↓
Verify schema and constraints
        ↓
Run seed/update scripts if required
        ↓
Run tests
```

Do not make untracked schema changes directly in the database. Every structural change must have a corresponding SQL migration committed to the project.

---

# 65. Seed Data

The hackathon application should include realistic seed data.

Minimum seed data:

```text
3 Centres
3 Program Lead users
8–10 Volunteers
10–15 Beneficiaries
5–8 Programs
15–25 Activities
Multiple Program Enrollments
Attendance records
Progress records
Timeline events
Volunteer assignments
Tasks
```

The seed data should demonstrate:

```text
Multiple centres
Multiple programs
One beneficiary in multiple programs
Different beneficiary statuses
Different risk levels
Volunteer assignments
Attendance
Progress
Analytics
```

---

# 66. Demo Data Principle

Seed data must demonstrate the complete business story.

Example:

```text
Beneficiary BEN-000001
        ↓
Registered
        ↓
Rehabilitation
        ↓
Enrolled in Vocational Training
        ↓
Attended Multiple Activities
        ↓
Progress Improved
        ↓
Volunteer Assigned
        ↓
Progress Milestone Recorded
        ↓
Timeline Updated
        ↓
Visible in Program Analytics
        ↓
Visible in Executive Dashboard
```

This is more valuable for the hackathon demo than simply having many random records.

---

# 67. Database Security

The backend must never expose:

```text
password_hash
```

through API responses.

Passwords must be hashed before storage.

Recommended:

```text
bcrypt
```

or another approved password hashing mechanism.

---

# 68. Database Access Rule

Frontend must never connect directly to PostgreSQL.

Correct:

```text
React
  ↓
Express API
  ↓
`pg` (node-postgres)
  ↓
PostgreSQL
```

Incorrect:

```text
React
  ↓
PostgreSQL
```

---

# 69. AI Backend Agent Rules

Before modifying the database, the AI agent must read:

```text
PRD.md
USER_FLOWS.md
ACCESS_CONTROL_MATRIX.md
DATA_DICTIONARY.md
DATABASE_SCHEMA.md
```

The agent must:

1. Use PostgreSQL.
2. Access PostgreSQL directly through the Node.js `pg` (node-postgres) client.
3. Preserve table relationships.
4. Preserve enum values.
5. Preserve foreign keys.
6. Preserve unique constraints.
7. Preserve beneficiary identity rules.
8. Use version-controlled SQL migrations for schema changes.
9. Use PostgreSQL transactions for multi-table operations.
10. Never silently rename fields.
11. Never create duplicate tables for existing concepts.
12. Update documentation if a schema change is intentionally approved.

---

# 70. Frontend/Backend Contract

The database is an internal backend implementation.

The frontend must not depend directly on database column names.

The architecture is:

```text
Frontend
    ↓
API Contract
    ↓
Backend Service
    ↓
PostgreSQL (`pg`)
    ↓
PostgreSQL Database
```

The API contract will be defined in:

```text
API_SPECIFICATION.md
```

---

# 71. Final Database Structure

```text
                    ┌──────────────┐
                    │   CENTRES    │
                    └──────┬───────┘
                           │
              ┌────────────┼────────────┐
              │            │            │
              ▼            ▼            ▼
            USERS    BENEFICIARIES   PROGRAMS
              │            │            │
              │            │            │
              ▼            │            ├──── ACTIVITIES
      VOLUNTEER_PROFILE     │            │
              │            │            ├──── PROGRAM_ENROLLMENTS
              ▼            │            │
           SKILLS          │            ├──── VOLUNTEER_ASSIGNMENTS
              │            │            │
              ▼            │            └──── TASKS
      VOLUNTEER_SKILLS      │
                           │
             ┌─────────────┼───────────────┐
             │             │               │
             ▼             ▼               ▼
       ENROLLMENTS     ATTENDANCES    PROGRESS_RECORDS
             │             │               │
             └─────────────┼───────────────┘
                           │
                           ▼
                    TIMELINE_EVENTS

                           │
                           ▼
                      AUDIT_LOGS
```

---

# 72. Final Source of Truth

For database implementation:

```text
DATA_DICTIONARY.md
        ↓
DATABASE_SCHEMA.md
        ↓
SQL Migration Files
        ↓
PostgreSQL
```

No AI agent should skip this chain.

If an implementation requirement conflicts with this document, the conflict must be resolved before coding rather than allowing frontend and backend agents to make different assumptions.

---

# 73. Final Database Decision

The Purnata hackathon project will use:

```text
Database:
PostgreSQL

Database Access:
Direct PostgreSQL using `pg` (node-postgres)

Backend:
Node.js + Express.js

Frontend:
React
```

Final architecture:

```text
┌──────────────────────┐
│        React         │
│      Frontend        │
└──────────┬───────────┘
           │
           │ REST API
           ▼
┌──────────────────────┐
│   Node.js + Express  │
│       Backend        │
└──────────┬───────────┘
           │
           │ `pg` / SQL
           ▼
┌──────────────────────┐
│      PostgreSQL      │
│      Database        │
└──────────────────────┘
```

This architecture provides the relational integrity required for beneficiary/program/attendance/volunteer relationships while keeping the development stack straightforward for the hackathon.