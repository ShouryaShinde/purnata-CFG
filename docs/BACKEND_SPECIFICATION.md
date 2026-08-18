# BACKEND_SPECIFICATION.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Specification  
**Backend:** Node.js + Express.js  
**Database:** PostgreSQL  
**Database Access:** Direct PostgreSQL using `pg` / node-postgres  
**ORM:** None / Prisma not used

**Parent Documents:** `PRD.md`, `USER_FLOWS.md`, `ACCESS_CONTROL_MATRIX.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`, `TECHNICAL_ARCHITECTURE.md`, `VALIDATION_RULES.md`, `ANALYTICS_SPECIFICATION.md`, `AUDIT_LOGGING.md`, `AUTHENTICATION_AUTHORIZATION.md`, `TESTING_STRATEGY.md`

---

# 1. Purpose

This document defines the backend implementation specification for Purnata.

The backend is responsible for:

- REST API
- Authentication
- Authorization
- Business rules
- Validation
- Resource-scope enforcement
- PostgreSQL access
- Transactions
- Beneficiary management
- Program management
- Activity management
- Enrollment
- Volunteer assignments
- Tasks
- Attendance
- Progress
- Timeline events
- Analytics
- Reports
- Audit logging
- Error handling

The PRD defines Purnata as a role-based digital case and program management system connecting beneficiary records, programs, activities, volunteers, attendance, progress, timelines, and organizational analytics. fileciteturn9file2L356-L380

---

# 2. Critical Architecture Decision

The backend must use:

```text
React
   ↓
REST API
   ↓
Node.js + Express.js
   ↓
PostgreSQL
```

Database access is **direct PostgreSQL using `pg` / node-postgres**.

Prisma is **not used**.

A previous database document version contains Prisma references, but the current database decision explicitly specifies direct PostgreSQL using `pg` and identifies that as the final architecture. fileciteturn9file1L176-L199 fileciteturn9file3L437-L453

Therefore:

```text
NO Prisma
NO Prisma Client
NO schema.prisma
NO Prisma migrations
```

The database implementation chain is:

```text
DATA_DICTIONARY.md
        ↓
DATABASE_SCHEMA.md
        ↓
SQL Migration Files
        ↓
PostgreSQL
```

This direct PostgreSQL chain is explicitly defined in the database specification. fileciteturn9file3L417-L433

---

# 3. Backend Responsibilities

The backend is the authoritative application layer for:

```text
Authentication
Authorization
Validation
Business Logic
Scope Enforcement
Database Access
Transactions
Analytics
Audit Logging
API Responses
```

The frontend must not connect directly to PostgreSQL.

---

# 4. Backend Architecture

Recommended architecture:

```text
                 React Frontend
                       │
                       ▼
                  REST API
                       │
                       ▼
              Express Application
                       │
       ┌───────────────┼────────────────┐
       ▼               ▼                ▼
 Authentication   Authorization     Validation
 Middleware       Middleware        Middleware
       │               │                │
       └───────────────┼────────────────┘
                       ▼
                    Routes
                       │
                       ▼
                  Controllers
                       │
                       ▼
                    Services
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
     Repositories   Analytics    Audit Service
          │
          ▼
     `pg` / node-postgres
          │
          ▼
      PostgreSQL
```

The exact folder names may vary, but these responsibilities should remain separated.

---

# 5. Backend Layer Responsibilities

## Routes

Responsible for:

```text
HTTP method
URL
Middleware composition
Controller selection
```

## Middleware

Responsible for cross-cutting concerns:

```text
Authentication
Authorization
Validation
Request context
Error handling
```

## Controllers

Responsible for:

```text
Read request
Call service
Return HTTP response
```

Controllers should remain thin.

## Services

Responsible for:

```text
Business logic
Workflow orchestration
Transactions
Authorization-related business checks
```

## Repositories / Data Access

Responsible for:

```text
SQL
Database queries
Database transactions
Mapping database rows
```

## Analytics Services

Responsible for:

```text
Approved metric calculations
Aggregations
Filters
Reporting datasets
```

## Audit Service

Responsible for:

```text
Creating audit records
Capturing actor/action/resource
```

---

# 6. Recommended Folder Structure

```text
backend/
├── src/
│   ├── config/
│   │   ├── env.js
│   │   └── database.js
│   │
│   ├── middleware/
│   │   ├── authenticate.js
│   │   ├── authorize.js
│   │   ├── validate.js
│   │   └── errorHandler.js
│   │
│   ├── routes/
│   │   ├── auth.routes.js
│   │   ├── programs.routes.js
│   │   ├── beneficiaries.routes.js
│   │   ├── activities.routes.js
│   │   ├── volunteers.routes.js
│   │   ├── tasks.routes.js
│   │   ├── attendance.routes.js
│   │   ├── progress.routes.js
│   │   ├── analytics.routes.js
│   │   ├── reports.routes.js
│   │   └── audit.routes.js
│   │
│   ├── controllers/
│   │   ├── auth.controller.js
│   │   ├── programs.controller.js
│   │   ├── beneficiaries.controller.js
│   │   ├── activities.controller.js
│   │   ├── volunteers.controller.js
│   │   ├── tasks.controller.js
│   │   ├── attendance.controller.js
│   │   ├── progress.controller.js
│   │   ├── analytics.controller.js
│   │   ├── reports.controller.js
│   │   └── audit.controller.js
│   │
│   ├── services/
│   │   ├── auth.service.js
│   │   ├── programs.service.js
│   │   ├── beneficiaries.service.js
│   │   ├── activities.service.js
│   │   ├── volunteers.service.js
│   │   ├── tasks.service.js
│   │   ├── attendance.service.js
│   │   ├── progress.service.js
│   │   ├── analytics.service.js
│   │   ├── reports.service.js
│   │   └── audit.service.js
│   │
│   ├── repositories/
│   │   ├── user.repository.js
│   │   ├── program.repository.js
│   │   ├── beneficiary.repository.js
│   │   ├── activity.repository.js
│   │   ├── volunteer.repository.js
│   │   ├── task.repository.js
│   │   ├── attendance.repository.js
│   │   ├── progress.repository.js
│   │   ├── timeline.repository.js
│   │   └── audit.repository.js
│   │
│   ├── validators/
│   │
│   ├── permissions/
│   │   └── permissions.js
│   │
│   ├── utils/
│   │
│   ├── app.js
│   └── server.js
│
├── migrations/
├── tests/
└── package.json
```

This is a recommended implementation structure, not a requirement to use these exact filenames.

---

# 7. Application Startup

Recommended startup flow:

```text
Load environment
      ↓
Validate required configuration
      ↓
Create PostgreSQL Pool
      ↓
Create Express Application
      ↓
Register middleware
      ↓
Register routes
      ↓
Register error handler
      ↓
Start HTTP server
```

Database connectivity should be verified appropriately before accepting application traffic.

---

# 8. PostgreSQL Connection

Use the `pg` package.

Conceptually:

```js
import pg from "pg";

const { Pool } = pg;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});
```

The exact configuration should follow the deployment environment.

Do not create a new PostgreSQL connection for every request.

Use a connection pool.

---

# 9. Database Pooling

The shared PostgreSQL pool should be used by repositories/services.

Conceptually:

```text
Express Request
      ↓
Service
      ↓
Repository
      ↓
Pool
      ↓
PostgreSQL
```

Pool configuration must be appropriate for the deployment environment.

Do not expose database connection details to the frontend.

---

# 10. Environment Configuration

Backend configuration should come from environment variables or secure deployment configuration.

Possible variables:

```text
DATABASE_URL
PORT
NODE_ENV
AUTH_SECRET
CORS_ORIGIN
```

Additional variables may be added when required by the selected authentication/deployment design.

Never commit secrets to Git.

---

# 11. Database Schema Source of Truth

Backend SQL must follow:

```text
DATA_DICTIONARY.md
        ↓
DATABASE_SCHEMA.md
        ↓
SQL migrations
        ↓
PostgreSQL
```

The database schema defines:

```text
tables
columns
types
primary keys
foreign keys
relationships
constraints
enums
indexes
unique constraints
delete/update behavior
```

fileciteturn9file1L152-L172

AI agents must not independently redesign the schema.

---

# 12. Core Database Entities

The backend must support the database entities defined by the schema:

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

fileciteturn9file1L203-L223

---

# 13. PostgreSQL UUID Strategy

All primary keys use UUID.

Conceptually:

```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

The backend should treat UUIDs as opaque identifiers and pass them as parameterized query values.

The database schema explicitly specifies UUID primary keys and PostgreSQL-generated UUID values. fileciteturn9file4L491-L515

---

# 14. Timestamp Handling

The database uses timestamp fields such as:

```text
created_at
updated_at
```

Historical entities such as attendance and audit records also maintain event/record timestamps. fileciteturn9file4L519-L539

API responses should expose timestamps according to the API specification and approved naming convention.

---

# 15. SQL Query Rules

All user-controlled values must use parameterized queries.

Correct:

```js
await pool.query(
  "SELECT * FROM programs WHERE id = $1",
  [programId]
);
```

Do not construct SQL by concatenating user input.

Incorrect:

```js
`SELECT * FROM programs WHERE id = '${programId}'`
```

---

# 16. Repository Layer

Repositories should contain database access.

Example:

```text
program.repository.js
```

may expose:

```text
findById()
findMany()
create()
update()
archive()
```

Repositories should not contain HTTP response logic.

---

# 17. Service Layer

Services coordinate business workflows.

Example:

```text
createProgram()
```

may perform:

```text
validate input
↓
check authorization scope
↓
insert program
↓
create timeline event if required
↓
create audit event
↓
commit transaction
```

The service should return domain/application data to the controller.

---

# 18. Controller Layer

Controllers should:

```text
read request
↓
extract authenticated user
↓
call service
↓
map result to API response
```

Controllers should not contain large SQL statements.

---

# 19. Route Layer

Routes should define:

```text
HTTP method
path
authentication middleware
authorization middleware
validation middleware
controller
```

Example:

```text
POST /api/programs
        ↓
authenticate
        ↓
authorize PROGRAM_CREATE
        ↓
validate
        ↓
createProgramController
```

---

# 20. Authentication Middleware

Authentication must happen before protected business operations.

Flow:

```text
Request
 ↓
authenticate
 ↓
Identify User
 ↓
Attach trusted identity
 ↓
Next Middleware
```

The backend must be the authoritative authentication boundary.

---

# 21. Authorization Middleware

Authorization must follow:

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
 ↓
Scope
 ↓
Allow / Deny
```

This is the authorization decision flow defined in the Access Control Matrix. fileciteturn9file6L842-L867

---

# 22. Permission Definitions

The standard actions are:

```text
CREATE
READ
UPDATE
DELETE
ASSIGN
COMPLETE
EXPORT
ANALYZE
REPORT
```

These are defined in the Access Control Matrix. fileciteturn9file8L1368-L1382

Permissions should use a consistent convention such as:

```text
PROGRAM_CREATE
BENEFICIARY_READ
ACTIVITY_UPDATE
ATTENDANCE_CREATE
ANALYTICS_PROGRAM_READ
```

---

# 23. Role Definitions

MVP roles:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

No additional role should be silently introduced. fileciteturn9file8L1326-L1334

---

# 24. Program Lead Backend Access

Program Lead backend permissions include broad operational management:

```text
Programs
Activities
Beneficiaries
Program Enrollment
Volunteers
Volunteer Assignment
Tasks
Attendance
Progress
Program Analytics
```

The exact operation-level permissions remain governed by `ACCESS_CONTROL_MATRIX.md`. fileciteturn9file8L1386-L1405

---

# 25. Volunteer Backend Access

Volunteer access is scoped to assigned work:

```text
Assigned Programs
Assigned Activities
Assigned Beneficiaries
Assigned Tasks
Attendance
Relevant Progress
```

A Volunteer must not browse unrelated programs or beneficiaries. fileciteturn9file8L1440-L1453

---

# 26. Executive Director Backend Access

Executive Director access includes:

```text
Organization Analytics
Centre Analytics
Program Analytics
Beneficiary Journey Overview
Reports
Impact Metrics
```

The exact beneficiary-level field visibility remains subject to the authorization specification.

---

# 27. Scope Enforcement

Scope must be checked at the backend.

Example:

```text
GET /api/beneficiaries/:id
        ↓
Authenticate
        ↓
User = Volunteer A
        ↓
Check assignment
        ↓
Authorized?
   ├── YES → Return permitted fields
   └── NO → 403
```

The Access Control Matrix explicitly requires backend authorization and assignment checks. fileciteturn9file6L953-L981

---

# 28. Field-Level Authorization

Some beneficiary information may require different visibility.

Conceptually:

```text
Beneficiary
├── Basic Information
├── Program Information
├── Attendance
├── Progress
└── Sensitive Case Information
```

The backend must return only fields authorized for the requesting role/scope.

The exact sensitive fields must follow the finalized Data Dictionary. fileciteturn9file6L985-L1013

---

# 29. Business Rule Boundary

Business rules belong in the backend service layer.

Examples:

```text
beneficiary unique identity
active enrollment uniqueness
attendance validity
assignment scope
status transitions
progress score limits
```

Do not rely only on frontend validation.

---

# 30. Validation Layer

Validation should happen before business processing.

Flow:

```text
Request
 ↓
Schema / Input Validation
 ↓
Authorization
 ↓
Business Rules
 ↓
Database
```

The exact middleware ordering may be adjusted where authorization requires resource lookup.

---

# 31. Validation Source of Truth

Backend validation must follow:

```text
VALIDATION_RULES.md
DATA_DICTIONARY.md
DATABASE_SCHEMA.md
```

The backend remains authoritative even when the frontend performs the same validation for user experience.

---

# 32. Beneficiary Registration

Backend flow:

```text
POST /api/beneficiaries
        ↓
Authenticate
        ↓
Authorize PROGRAM_LEAD
        ↓
Validate beneficiary
        ↓
Check uniqueness
        ↓
Generate UUID
        ↓
Generate unique beneficiary business ID
        ↓
Insert beneficiary
        ↓
Create initial timeline event if required
        ↓
Audit
        ↓
Commit
```

The PRD requires each beneficiary to receive a unique ID that remains associated throughout the beneficiary journey. fileciteturn9file7L1078-L1112

---

# 33. Beneficiary Identity

The backend must distinguish:

```text
Internal UUID
```

from:

```text
User-facing beneficiary unique ID
```

The internal UUID identifies the database record.

The beneficiary unique ID represents the persistent business identity.

If a beneficiary enters multiple programs:

```text
One beneficiary
   ↓
Multiple program enrollments
```

Do not create duplicate beneficiary records. fileciteturn9file7L1116-L1140

---

# 34. Program Enrollment

Enrollment should be represented as:

```text
Beneficiary
      ↓
Program Enrollment
      ↓
Program
```

The enrollment record tracks:

```text
beneficiary
program
enrollment date
status
participation
progress
completion date where applicable
```

fileciteturn9file7L1116-L1140

---

# 35. Enrollment Transaction

When enrollment requires multiple writes:

```text
BEGIN
 ↓
Validate beneficiary
 ↓
Validate program
 ↓
Check duplicate active enrollment
 ↓
Insert enrollment
 ↓
Create timeline event if required
 ↓
Audit
 ↓
COMMIT
```

Any failure should roll back the transaction.

---

# 36. Program Management

Program Lead backend operations:

```text
create program
read program
update program
manage status
manage beneficiaries
manage activities
assign volunteers
view analytics
```

Program deletion should be treated carefully because historical records depend on programs. The Access Control Matrix recommends controlled status change rather than permanent deletion where history depends on the program. fileciteturn9file8L1412-L1436

---

# 37. Activity Management

Backend should support:

```text
create activity
read activity
update activity
manage participants
manage volunteer assignment
record attendance
activity status/outcome
```

Volunteer access is limited to assigned activities.

---

# 38. Volunteer Management

Program Leads can:

```text
view volunteers
assign volunteers to programs
assign volunteers to activities
assign tasks
view relevant skills
view involvement
```

These responsibilities are defined in the PRD. fileciteturn9file7L1144-L1160

---

# 39. Volunteer Assignment

Assignment flow:

```text
Authenticate
 ↓
Authorize Program Lead
 ↓
Validate volunteer
 ↓
Validate program/activity
 ↓
Check assignment duplication
 ↓
Create assignment
 ↓
Audit
```

The backend must enforce scope and relationship validity.

---

# 40. Task Management

Task fields include:

```text
title
description
volunteer
program
activity
beneficiary/group where applicable
priority
due date
status
```

Approved statuses:

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

The PRD defines these task concepts and statuses. fileciteturn9file7L1164-L1187

---

# 41. Task Authorization

Program Lead:

```text
create
assign
update
manage
```

Volunteer:

```text
view own tasks
update permitted task state
complete assigned tasks
```

Executive Director:

```text
read authorized task information
```

Exact operation-level permissions must follow the Access Control Matrix.

---

# 42. Attendance Management

Attendance information includes:

```text
Beneficiary
Activity
Program
Date
Attendance Status
Recorded By
Timestamp
```

Approved statuses:

```text
PRESENT
ABSENT
EXCUSED
```

fileciteturn9file7L1230-L1252

---

# 43. Attendance Transaction

Attendance creation should:

```text
authenticate
↓
authorize
↓
validate activity
↓
validate beneficiary participation
↓
check duplicate attendance
↓
insert attendance
↓
audit
↓
commit
```

---

# 44. Progress Management

Progress can be associated with:

```text
Programs
Activities
Skills
Training
Interventions
Milestones
Attendance
Other approved indicators
```

The exact measurable indicators are intentionally not finalized in the PRD. fileciteturn9file7L1256-L1271

Therefore the backend must not invent additional progress categories or calculations.

---

# 45. Progress Score

If the approved Data Dictionary defines a numeric progress score, the backend must enforce its defined range through:

```text
request validation
+
database constraints where applicable
```

The exact score rules must remain synchronized with `VALIDATION_RULES.md`.

---

# 46. Timeline Management

The backend maintains the chronological beneficiary journey.

Conceptually:

```text
Outreach
 ↓
Registration
 ↓
Enrollment
 ↓
Activity
 ↓
Attendance
 ↓
Progress Milestone
 ↓
Reintegration
 ↓
Follow-up
```

The PRD requires authorized users to understand intervention and progress history over time. fileciteturn9file7L1084-L1112

---

# 47. Timeline Consistency

Timeline events should reference valid entities.

Examples:

```text
Activity event → valid activity
Enrollment event → valid enrollment
Progress milestone → valid progress record
```

The service layer should create related timeline records transactionally where the business workflow requires it.

---

# 48. Analytics Service

Analytics should be implemented separately from CRUD services.

Conceptually:

```text
analytics.service.js
       ↓
approved metric definitions
       ↓
parameterized SQL
       ↓
PostgreSQL aggregation
       ↓
API response
```

Do not calculate large analytics datasets in Node.js by loading all records into memory unnecessarily.

---

# 49. Program Analytics

Possible metrics include:

```text
total beneficiaries
active beneficiaries
program enrollments
activity count
attendance
volunteer participation
progress milestones
completion statistics
program timeline
approved program KPIs
```

These are identified in the PRD. fileciteturn9file5L580-L591

Only finalized metrics from `ANALYTICS_SPECIFICATION.md` should be implemented.

---

# 50. Centre Analytics

Possible metrics:

```text
beneficiaries per centre
active programs
program participation
activity count
attendance
volunteer involvement
progress indicators
centre outcomes
```

fileciteturn9file5L595-L608

---

# 51. Executive Analytics

Executive analytics may include:

```text
total beneficiaries
active beneficiaries
total programs
active programs
total centres
total volunteers
program participation
activity statistics
centre comparisons
program comparisons
beneficiary journey overview
impact visualization
```

fileciteturn9file5L612-L643

---

# 52. Analytics Authorization

Analytics endpoints must enforce:

```text
authentication
role
permission
scope
```

Knowing a program UUID must not bypass analytics authorization.

---

# 53. Search and Filtering

The backend should support authorized search/filtering.

Possible beneficiary filters:

```text
unique ID
centre
program
status
```

Program filters:

```text
centre
status
date
program type
```

Volunteer filters:

```text
skill
program
assignment
status
```

These are defined by the PRD. fileciteturn9file5L690-L717

---

# 54. Search Authorization

Search must enforce the same scope rules as direct resource retrieval.

Example:

```text
Volunteer
 ↓
Search beneficiaries
 ↓
Only assigned/authorized beneficiaries
```

Never implement unrestricted global search and rely on the frontend to hide results.

---

# 55. Pagination

Large list endpoints should support server-side pagination.

Conceptual parameters:

```text
page
limit
```

or the pagination contract defined by `API_SPECIFICATION.md`.

Pagination must be applied after authorization scope has been established.

---

# 56. Sorting

Only approved sortable fields should be accepted.

Sorting parameters must be safely mapped to known SQL columns.

Never interpolate arbitrary client strings directly into an SQL `ORDER BY`.

---

# 57. Filtering

Filter values must be parameterized.

Column names must come from a controlled allowlist.

Example:

```text
status → programs.status
centreId → programs.centre_id
```

Do not allow the client to supply arbitrary SQL identifiers.

---

# 58. Reports

Reports should be generated from approved reporting/analytics queries.

The PRD requires reporting for program managers and leadership, including beneficiary, program, centre, volunteer, attendance, progress, outcome, and impact information. fileciteturn9file5L647-L667

Exact report formats remain open.

---

# 59. Audit Service

Important actions should be auditable.

Examples:

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

fileciteturn9file6L1041-L1067

The final event list must follow `AUDIT_LOGGING.md`.

---

# 60. Audit Actor

The audit actor must come from the authenticated backend context.

Correct:

```text
req.user.id
```

Incorrect:

```text
req.body.userId
```

The client must not be able to impersonate another audit actor.

---

# 61. Audit Transaction Behavior

Where an audit event describes a successful business mutation:

```text
business change
+
audit record
```

should normally be committed atomically.

If the business operation rolls back:

```text
success audit event must not remain
```

---

# 62. Error Handling

Use centralized error handling.

Conceptual flow:

```text
Route
 ↓
Controller
 ↓
Service
 ↓
Error
 ↓
Central Error Middleware
 ↓
Safe API Response
```

Do not expose:

```text
stack traces
SQL statements
database credentials
internal file paths
authentication secrets
```

in production API responses.

---

# 63. HTTP Error Categories

Conceptual mapping:

```text
400 → malformed/invalid request
401 → unauthenticated
403 → authenticated but forbidden
404 → resource not found
409 → conflict
422 → validation error where defined
500 → unexpected server error
```

The final status-code contract must remain synchronized with `API_SPECIFICATION.md`.

---

# 64. Error Response

Use the API's standardized error structure.

Conceptually:

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "You do not have permission to perform this action."
  }
}
```

Do not return raw PostgreSQL errors.

---

# 65. Database Error Mapping

Known PostgreSQL errors should be translated into safe application errors.

Examples:

```text
unique violation → conflict
foreign key violation → invalid related resource
check violation → validation/business error
```

The exact mapping should be centralized.

---

# 66. Transactions

Use PostgreSQL transactions for operations that require multiple related writes.

Example:

```text
BEGIN
 ↓
insert enrollment
 ↓
insert timeline event
 ↓
insert audit event
 ↓
COMMIT
```

On failure:

```text
ROLLBACK
```

---

# 67. Transaction Client Usage

When a transaction is used, all queries belonging to that transaction must use the same PostgreSQL client.

Conceptually:

```js
const client = await pool.connect();

try {
  await client.query("BEGIN");

  // related queries

  await client.query("COMMIT");
} catch (error) {
  await client.query("ROLLBACK");
  throw error;
} finally {
  client.release();
}
```

Do not accidentally use the global pool for one query inside an otherwise transactional workflow.

---

# 68. SQL Migrations

Database migrations must be SQL-based.

Recommended:

```text
migrations/
├── 001_create_extensions.sql
├── 002_create_enums.sql
├── 003_create_users.sql
├── 004_create_centres.sql
├── ...
└── N_create_audit_logs.sql
```

The exact migration tooling is an implementation decision.

Prisma migrations must not be used.

---

# 69. Migration Principles

Migrations should be:

```text
ordered
repeatable through deployment process
reviewable
version controlled
```

Do not manually modify production schema outside the approved migration process.

---

# 70. Database Constraints

Where specified by the schema, rely on PostgreSQL constraints for integrity.

Examples:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
NOT NULL
CHECK
```

Application validation improves error messages but does not replace database constraints.

---

# 71. Delete Policy

Because Purnata stores long-term beneficiary/program history, permanent deletion must be treated carefully.

Preferred pattern:

```text
Active
 ↓
Archived / Inactive
```

rather than:

```text
Active
 ↓
Permanent DELETE
```

Permanent deletion should only be implemented when explicitly approved. fileciteturn9file6L1017-L1037

---

# 72. API Route Organization

Conceptually:

```text
/api/auth
/api/programs
/api/beneficiaries
/api/activities
/api/volunteers
/api/tasks
/api/attendance
/api/progress
/api/analytics
/api/reports
/api/audit-logs
```

Exact endpoint names must follow `API_SPECIFICATION.md`.

This document does not replace the API specification.

---

# 73. Authentication Routes

Conceptually:

```text
POST /api/auth/login
POST /api/auth/logout
GET  /api/auth/me
```

Only implement routes actually approved by `API_SPECIFICATION.md`.

---

# 74. Beneficiary API Responsibilities

The backend should support the approved operations for:

```text
register
list/search
retrieve
update
enroll
timeline
progress
attendance
```

Every endpoint must enforce authorization and validation.

---

# 75. Program API Responsibilities

The backend should support approved operations for:

```text
create
list
retrieve
update
status management
beneficiary enrollment
activity management
volunteer assignment
analytics
```

Program deletion/archive behavior must follow the approved access matrix and delete policy.

---

# 76. Activity API Responsibilities

The backend should support:

```text
create
list
retrieve
update
assignment
participants
attendance
completion/outcome
```

Activity scope must be enforced for Volunteers.

---

# 77. Volunteer API Responsibilities

The backend should support approved operations for:

```text
volunteer profile
skills
program assignment
activity assignment
task assignment
volunteer analytics
```

Volunteer users must only access their own or assigned information according to the authorization matrix.

---

# 78. Task API Responsibilities

The backend should support:

```text
create
assign
list
retrieve
update
complete
```

Task access must respect:

```text
Program Lead scope
Volunteer ownership/assignment
Executive read scope
```

---

# 79. Attendance API Responsibilities

The backend should support:

```text
record attendance
retrieve attendance
filter attendance
```

It must validate:

```text
activity
beneficiary
program relationship
status
authorization
duplicate rules
```

---

# 80. Progress API Responsibilities

The backend should support approved operations for:

```text
create progress
retrieve progress
update progress
filter progress
```

Progress must remain associated with valid beneficiary/program/activity relationships where applicable.

---

# 81. Timeline API Responsibilities

The backend should support:

```text
retrieve beneficiary timeline
create timeline events where approved
```

Automatic timeline events should preferably be created by the corresponding business workflow rather than requiring the frontend to manually construct historical events.

---

# 82. Analytics API Responsibilities

Analytics endpoints should:

```text
authenticate
authorize
validate filters
apply scope
execute approved aggregate query
return metric response
```

They should not return unauthorized raw records simply because an aggregate endpoint was requested.

---

# 83. Report API Responsibilities

Report endpoints should:

```text
authenticate
authorize
validate report parameters
apply scope
generate approved dataset
return report result
```

Exact file/export behavior must follow the finalized report specification.

---

# 84. Audit API Responsibilities

Audit log retrieval should be:

```text
authenticated
role-restricted
scope-aware
paginated
```

Volunteers should not receive unrestricted audit-log access.

The Access Control Matrix identifies Audit Logs as role-restricted. fileciteturn9file8L1386-L1405

---

# 85. Business Workflow: Program Creation

```text
POST /programs
      ↓
Authenticate
      ↓
Authorize Program Lead
      ↓
Validate
      ↓
Check centre/program rules
      ↓
Insert program
      ↓
Audit
      ↓
Return created program
```

---

# 86. Business Workflow: Beneficiary Registration

```text
POST /beneficiaries
      ↓
Authenticate
      ↓
Authorize Program Lead
      ↓
Validate
      ↓
Check uniqueness
      ↓
Generate beneficiary ID
      ↓
Insert beneficiary
      ↓
Create timeline event where required
      ↓
Audit
      ↓
Return beneficiary
```

---

# 87. Business Workflow: Volunteer Assignment

```text
POST /volunteer-assignments
      ↓
Authenticate
      ↓
Authorize Program Lead
      ↓
Validate volunteer
      ↓
Validate program/activity
      ↓
Check scope
      ↓
Create assignment
      ↓
Audit
      ↓
Return assignment
```

---

# 88. Business Workflow: Attendance

```text
POST /attendance
      ↓
Authenticate
      ↓
Authorize
      ↓
Validate activity
      ↓
Validate beneficiary participation
      ↓
Validate attendance status
      ↓
Check duplicate
      ↓
Insert attendance
      ↓
Audit
      ↓
Return attendance
```

---

# 89. Business Workflow: Progress

```text
POST /progress
      ↓
Authenticate
      ↓
Authorize
      ↓
Validate beneficiary/program/activity
      ↓
Validate category/score
      ↓
Insert progress
      ↓
Create timeline milestone where required
      ↓
Audit
      ↓
Return progress
```

---

# 90. Business Workflow: Volunteer Task Completion

```text
PATCH /tasks/:id
      ↓
Authenticate
      ↓
Identify volunteer
      ↓
Check task assignment
      ↓
Validate allowed transition
      ↓
Update task
      ↓
Audit where required
      ↓
Return task
```

---

# 91. Backend Security Principles

The backend must:

```text
authenticate every protected request
authorize every protected action
enforce resource scope
enforce field restrictions
validate inputs
parameterize SQL
protect secrets
use secure transport in production
avoid sensitive error leakage
audit important actions
```

---

# 92. Client-Supplied Identity

Never trust client fields for authority:

```text
userId
role
createdBy
updatedBy
recordedBy
assignedBy
```

The backend must derive actor identity from authenticated context.

---

# 93. Client-Supplied Scope

Do not trust:

```text
centreId
programId
assignmentId
```

as proof of authorization.

These values identify requested resources.

The backend must verify that the authenticated user has permission and scope over them.

---

# 94. SQL Injection Protection

Use PostgreSQL parameterized queries:

```sql
WHERE id = $1
```

Never concatenate user input into SQL.

For dynamic sorting/filter columns, use explicit server-side allowlists.

---

# 95. Sensitive Data

Do not log or return:

```text
passwords
password hashes
authentication secrets
database credentials
private keys
unnecessary sensitive beneficiary data
```

Beneficiary responses must follow field-level authorization.

---

# 96. CORS

Production CORS should allow only approved frontend origins.

Avoid:

```text
Access-Control-Allow-Origin: *
```

for authenticated production APIs unless explicitly approved.

---

# 97. Request Size Limits

The Express application should define reasonable request-size limits to prevent unnecessarily large payloads.

The exact limit should be an implementation/deployment decision.

---

# 98. Rate Limiting

Rate limiting is a recommended security measure, particularly for authentication endpoints.

The exact policy is not finalized in the current source documents.

Therefore:

```text
Rate limiting = implementation/security decision
```

not a silently assumed product requirement.

---

# 99. Logging

Application logs should support:

```text
startup
shutdown
database connectivity
request errors
unexpected exceptions
important operational failures
```

Do not log secrets or unnecessary sensitive beneficiary data.

Audit logging is separate from normal application logging.

---

# 100. Health Check

The backend should provide an appropriate health-check endpoint for deployment/monitoring.

Conceptually:

```text
GET /health
```

Possible response:

```json
{
  "status": "ok"
}
```

The exact production health-check contract is an implementation decision.

---

# 101. Graceful Shutdown

The server should:

```text
stop accepting new requests
finish active requests where possible
close PostgreSQL pool
exit cleanly
```

This is particularly important for deployments and database connections.

---

# 102. Backend Testing

Backend tests must follow `TESTING_STRATEGY.md`.

Priority areas:

```text
authentication
authorization
scope
validation
business logic
PostgreSQL integration
transactions
analytics
audit
error handling
```

The MVP Definition of Done requires role enforcement, beneficiary registration, enrollment, assignments, attendance, timelines, analytics, sensitive-data protection, and auditability. fileciteturn9file2L257-L278

---

# 103. Unit Tests

Unit-test:

```text
permission functions
validation
business rules
status transitions
data mapping
analytics calculations
utility functions
```

---

# 104. Integration Tests

Integration-test:

```text
Express route
 ↓
middleware
 ↓
controller
 ↓
service
 ↓
repository
 ↓
PostgreSQL
```

Use a real PostgreSQL test database for database behavior that depends on PostgreSQL constraints or SQL semantics.

---

# 105. Authorization Tests

Minimum backend security tests:

```text
unauthenticated → rejected
wrong role → rejected
wrong scope → rejected
cross-program access → rejected
cross-centre access → rejected where applicable
field restriction → enforced
client role forgery → rejected
client userId forgery → ignored/rejected
```

---

# 106. Database Tests

Test:

```text
foreign keys
unique constraints
check constraints
transactions
rollback
UUID generation
timestamp behavior
duplicate prevention
```

---

# 107. Analytics Tests

For every finalized metric:

```text
known dataset
 ↓
expected calculation
 ↓
SQL result
 ↓
API result
```

Do not test invented metrics.

---

# 108. API Contract Tests

Verify:

```text
HTTP status
JSON structure
field naming
types
error codes
pagination
filters
```

The backend API must remain compatible with `API_SPECIFICATION.md`.

---

# 109. Error Testing

Every important endpoint should test:

```text
400/validation failure
401/authentication failure
403/authorization failure
404/resource missing
409/conflict
500/unexpected failure
```

Only status codes actually defined by the API contract should be exposed as final behavior.

---

# 110. Backend Performance

Performance priorities:

```text
beneficiary search
program search
activity retrieval
attendance queries
progress history
analytics aggregation
reports
```

Use:

```text
indexes
pagination
SQL aggregation
appropriate joins
connection pooling
```

Do not load entire large datasets into Node.js merely to perform calculations that PostgreSQL can perform efficiently.

---

# 111. N+1 Query Avoidance

Avoid patterns such as:

```text
SELECT programs
then for every program:
    SELECT beneficiaries
```

when a suitable join or aggregate query can safely retrieve the required data.

However, do not create unnecessarily complex queries merely to eliminate every small query.

---

# 112. Query Performance

Use database indexes defined in `DATABASE_SCHEMA.md`.

Do not add indexes arbitrarily without considering:

```text
query pattern
write cost
storage
```

Schema changes should update the database specification and migrations.

---

# 113. API Response Mapping

Database names may use:

```text
snake_case
```

while API responses use:

```text
camelCase
```

Example:

```text
database:
created_at

API:
createdAt
```

This follows the project data-contract convention. fileciteturn9file4L519-L539

---

# 114. Database-to-API Mapping

Keep mapping predictable.

Example:

```text
beneficiary_id → beneficiaryId
program_id     → programId
activity_date  → activityDate
created_at     → createdAt
updated_at     → updatedAt
```

Do not expose raw database naming inconsistently across endpoints.

---

# 115. Service-to-Repository Rule

Preferred:

```text
Controller
   ↓
Service
   ↓
Repository
   ↓
PostgreSQL
```

Avoid:

```text
Controller
   ↓
Raw SQL everywhere
```

This separation makes authorization, business logic, testing, and database changes easier to manage.

---

# 116. Repository-to-HTTP Rule

Repositories must not know about:

```text
req
res
HTTP status
Express
```

They should operate on data/database concerns.

---

# 117. Service-to-HTTP Rule

Services should preferably not directly write HTTP responses.

They should return:

```text
data
domain result
known application error
```

Controllers translate the result into the API response.

---

# 118. Middleware-to-Business Rule

Middleware should handle cross-cutting concerns.

Complex business rules should remain in services.

Example:

```text
authenticate → middleware
check permission → middleware/service
beneficiary eligibility → service
```

---

# 119. Backend Source of Truth

When implementing a feature:

```text
PRD
 ↓
ACCESS_CONTROL_MATRIX
 ↓
DATA_DICTIONARY
 ↓
DATABASE_SCHEMA
 ↓
API_SPECIFICATION
 ↓
VALIDATION_RULES
 ↓
AUTHENTICATION_AUTHORIZATION
 ↓
BACKEND
```

If documents conflict, resolve the conflict before implementation.

---

# 120. AI Coding Agent Rules

Any AI coding agent implementing backend functionality must:

1. Read `PRD.md`.
2. Read `USER_FLOWS.md`.
3. Read `ACCESS_CONTROL_MATRIX.md`.
4. Read `DATA_DICTIONARY.md`.
5. Read `DATABASE_SCHEMA.md`.
6. Read `API_SPECIFICATION.md`.
7. Read `TECHNICAL_ARCHITECTURE.md`.
8. Read `VALIDATION_RULES.md`.
9. Read `ANALYTICS_SPECIFICATION.md`.
10. Read `AUDIT_LOGGING.md`.
11. Read `AUTHENTICATION_AUTHORIZATION.md`.
12. Read `TESTING_STRATEGY.md`.
13. Never use Prisma.
14. Never create `schema.prisma`.
15. Never use Prisma Client.
16. Use direct PostgreSQL through `pg` / node-postgres.
17. Use parameterized SQL.
18. Never invent database relationships.
19. Never invent API contracts.
20. Never invent roles.
21. Never silently broaden permissions.
22. Never trust client-supplied actor identity.
23. Enforce authorization on the backend.
24. Enforce resource scope.
25. Respect field-level authorization.
26. Follow approved validation rules.
27. Add/update tests for changed behavior.
28. Update documentation when an approved contract changes.
29. Ask for clarification when a requirement is explicitly open.
30. Never silently resolve specification conflicts.

The PRD explicitly requires AI agents to determine role, business requirement, entities, API, authorization, UI, validation, success, and failure behavior before implementation, and prohibits independent changes to core contracts without approval. fileciteturn9file2L282-L323

---

# 121. Open Backend Decisions

The current source documents leave some implementation details open:

1. Exact authentication mechanism: session vs token.
2. Exact password hashing library/configuration.
3. Exact session/token lifetime.
4. Refresh strategy if token authentication is selected.
5. Password-reset workflow.
6. Account-recovery workflow.
7. Rate-limiting policy.
8. Exact report/export formats.
9. Exact analytics metrics where the analytics specification remains open.
10. Exact sensitive beneficiary fields.
11. Exact centre-scope rules.
12. Exact Volunteer edit permissions.
13. Exact timeline visibility for Volunteers.
14. Exact attendance correction permissions.
15. Exact deletion/archive behavior where not finalized.
16. Exact CI/deployment infrastructure.

These must not be silently invented by implementation agents.

---

# 122. MVP Backend Scope

The MVP backend must support:

```text
Authentication
Authorization
Programs
Activities
Beneficiaries
Program Enrollment
Volunteers
Volunteer Assignments
Tasks
Attendance
Progress
Timeline
Program Analytics
Centre Analytics
Executive Analytics
Reports where finalized
Audit Logging
```

The PRD's product-level Definition of Done requires these core capabilities to function together. fileciteturn9file2L257-L278

---

# 123. Backend Out of Scope

Do not silently add:

```text
Public beneficiary portal
Public registration
Advanced AI recommendations
Predictive analytics
Full administrative user-management system
External identity integrations
Offline-first backend workflows
```

unless these become approved requirements.

---

# 124. Final Backend Architecture

```text
                           React
                             │
                             ▼
                        REST API
                             │
                             ▼
                     Node.js + Express
                             │
              ┌──────────────┼──────────────┐
              │              │              │
              ▼              ▼              ▼
       Authentication   Authorization   Validation
          Middleware       Middleware     Middleware
              │              │              │
              └──────────────┼──────────────┘
                             ▼
                          Routes
                             │
                             ▼
                       Controllers
                             │
                             ▼
                         Services
                             │
            ┌────────────────┼────────────────┐
            ▼                ▼                ▼
      Repositories       Analytics        Audit Service
            │
            ▼
       pg / node-postgres
            │
            ▼
        PostgreSQL
```

---

# 125. Final Backend Principle

The backend must be the authoritative enforcement layer.

```text
Authentication
      +
Authorization
      +
Validation
      +
Business Logic
      +
PostgreSQL Integrity
      +
Transactions
      +
Auditability
      =
Reliable Backend
```

The core security boundary is:

```text
React
  ↓
REST API
  ↓
Express Middleware
  ↓
Services
  ↓
Parameterized PostgreSQL
```

The backend must never rely on the frontend for security.

The most important implementation rule for this project is:

```text
Direct PostgreSQL with `pg`
—not Prisma.
```

The current database specification explicitly records PostgreSQL with direct `pg`/node-postgres access as the final project decision. fileciteturn9file3L437-L453
