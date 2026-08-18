# TECHNICAL_ARCHITECTURE.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Architecture  
**Parent Document:** `PRD.md`  
**Related Documents:** `USER_FLOWS.md`, `ACCESS_CONTROL_MATRIX.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`

---

# 1. Purpose

This document defines the technical architecture for the Purnata Digital Case & Program Management Platform.

It translates the product requirements, user workflows, authorization rules, data model, and API contract into a technical system structure.

The architecture is intentionally based on the finalized technology decision:

```text
Frontend:
React

Backend:
Node.js + Express.js

Database Access:
pg / node-postgres

Database:
PostgreSQL
```

No ORM is part of the architecture.

---

# 2. Architecture Goals

The technical architecture must support the product goals defined in the PRD:

1. Centralized beneficiary records.
2. Persistent unique beneficiary identity.
3. Complete beneficiary journey tracking.
4. Program and program-enrollment management.
5. Activity and attendance management.
6. Volunteer assignment and task management.
7. Beneficiary progress tracking.
8. Program, centre, and organization analytics.
9. Secure role-based and scope-based access.
10. Auditable important records.
11. Mobile-usable core workflows.
12. A single source of truth for operational data.

The architecture should remain simple enough for the MVP while allowing future expansion.

---

# 3. High-Level Architecture

```text
┌─────────────────────────────────────────────┐
│                 React Frontend              │
│                                             │
│  Dashboards • Forms • Tables • Analytics    │
│  Beneficiary Journey • Tasks • Activities   │
└──────────────────────┬──────────────────────┘
                       │
                       │ HTTPS / REST / JSON
                       ▼
┌─────────────────────────────────────────────┐
│            Node.js + Express.js              │
│                                             │
│  Routes                                     │
│     ↓                                       │
│  Authentication                             │
│     ↓                                       │
│  Authorization / Scope Checks               │
│     ↓                                       │
│  Validation                                 │
│     ↓                                       │
│  Controllers                                │
│     ↓                                       │
│  Services / Business Logic                  │
│     ↓                                       │
│  PostgreSQL Repository / Query Layer        │
└──────────────────────┬──────────────────────┘
                       │
                       │ Parameterized SQL
                       │ Transactions
                       ▼
┌─────────────────────────────────────────────┐
│                PostgreSQL                   │
│                                             │
│ Users • Centres • Beneficiaries • Programs  │
│ Activities • Attendance • Volunteers        │
│ Tasks • Progress • Timeline • Audit Logs    │
└─────────────────────────────────────────────┘
```

The React application never connects directly to PostgreSQL.

---

# 4. Technology Stack

## 4.1 Frontend

```text
React
```

Responsibilities:

- User interface
- Role-specific dashboards
- Forms
- Tables
- Search and filtering
- Beneficiary journey visualization
- Activity and attendance interfaces
- Task interfaces
- Analytics visualization
- API communication
- Client-side UX validation

The frontend must not be treated as the security boundary.

---

## 4.2 Backend

```text
Node.js
Express.js
```

Responsibilities:

- HTTP API
- Authentication
- Authorization
- Scope enforcement
- Request validation
- Business rules
- PostgreSQL access
- Transactions
- Error handling
- Audit logging
- Analytics queries
- Report generation

---

## 4.3 Database Driver

```text
pg / node-postgres
```

The backend communicates with PostgreSQL directly using parameterized SQL.

No Prisma or other ORM is required by this architecture.

---

## 4.4 Database

```text
PostgreSQL
```

PostgreSQL is responsible for:

- Persistent storage
- Primary keys
- Foreign keys
- Unique constraints
- Check constraints
- Indexes
- Transactions
- Enum types
- Referential integrity

---

# 5. Architectural Principles

## 5.1 Single Source of Truth

Operational data must be stored centrally in PostgreSQL.

The frontend must not maintain an independent authoritative copy of business data.

Conceptually:

```text
PostgreSQL
    ↓
Backend API
    ↓
Frontend
```

---

## 5.2 Backend as Security Boundary

Authorization must be enforced by the backend.

Frontend behavior such as:

```text
hiding a button
```

must never be considered authorization.

The backend must independently validate:

```text
Identity
Role
Resource
Action
Scope
```

---

## 5.3 Role + Scope = Access

The authorization model is:

```text
ROLE + SCOPE = ACCESS
```

Example:

```text
Volunteer A
     ↓
Assigned Program
     ↓
Assigned Beneficiary
     ↓
Permitted beneficiary information
```

A volunteer assigned to one program must not automatically gain access to unrelated programs or beneficiaries.

---

## 5.4 Persistent Beneficiary Identity

Every beneficiary receives a persistent human-readable identifier:

```text
BEN-000001
BEN-000002
BEN-000003
```

The identifier must remain associated with the beneficiary throughout the beneficiary's journey.

Participation in multiple programs must use the same beneficiary record.

---

## 5.5 API Contract First

The backend and frontend must implement the contract defined in:

```text
API_SPECIFICATION.md
```

Neither side should independently invent different field names, endpoint behavior, or authorization rules.

---

## 5.6 Database Integrity

Business logic belongs in the backend, while fundamental data integrity should also be enforced at the PostgreSQL layer.

Examples:

```text
PRIMARY KEY
FOREIGN KEY
UNIQUE
CHECK
NOT NULL
```

---

# 6. Layered Backend Architecture

Recommended backend structure:

```text
HTTP Request
     ↓
Route
     ↓
Authentication Middleware
     ↓
Authorization Middleware
     ↓
Validation Middleware
     ↓
Controller
     ↓
Service
     ↓
Repository / SQL Query Layer
     ↓
PostgreSQL
```

---

# 7. Route Layer

Routes define the HTTP interface.

Example:

```text
POST /api/beneficiaries
GET  /api/beneficiaries
GET  /api/beneficiaries/:beneficiaryId
PATCH /api/beneficiaries/:beneficiaryId
```

Routes should remain thin.

They should not contain large amounts of business logic or raw SQL.

---

# 8. Middleware Layer

Middleware handles cross-cutting concerns.

Recommended responsibilities:

```text
authentication
authorization
request validation
error handling
request logging
```

Conceptual flow:

```text
Request
  ↓
Authentication
  ↓
Authorization
  ↓
Validation
  ↓
Controller
```

---

# 9. Controller Layer

Controllers translate HTTP requests into application operations.

Example:

```text
POST /beneficiaries
        ↓
beneficiaryController.create()
        ↓
beneficiaryService.create()
```

Controllers should handle:

- Request parameters
- Request body
- Calling services
- HTTP response status
- Response formatting

Controllers should not contain complex database workflows.

---

# 10. Service Layer

Services contain business logic.

Examples:

```text
BeneficiaryService
ProgramService
EnrollmentService
ActivityService
AttendanceService
VolunteerService
TaskService
ProgressService
TimelineService
AnalyticsService
ReportService
```

A service may coordinate multiple database operations.

For example:

```text
registerBeneficiary()
       ↓
create beneficiary
       ↓
create timeline event
       ↓
create audit log
```

This operation should use a PostgreSQL transaction.

---

# 11. PostgreSQL Query / Repository Layer

The database layer is responsible for executing SQL through `pg`.

Example conceptual structure:

```text
repositories/
├── userRepository
├── centreRepository
├── beneficiaryRepository
├── programRepository
├── enrollmentRepository
├── activityRepository
├── attendanceRepository
├── volunteerRepository
├── assignmentRepository
├── taskRepository
├── progressRepository
├── timelineRepository
├── analyticsRepository
└── auditRepository
```

The exact implementation structure may be adjusted without changing the API contract.

---

# 12. PostgreSQL Connection Architecture

Recommended connection model:

```text
Express Application
       ↓
pg Pool
       ↓
PostgreSQL
```

The application should use a connection pool rather than creating a new database connection for every request.

For transactions:

```text
Pool
 ↓
Client
 ↓
BEGIN
 ↓
SQL operations
 ↓
COMMIT / ROLLBACK
 ↓
Release client
```

---

# 13. Parameterized SQL

All user-controlled values must be passed as PostgreSQL query parameters.

Example:

```js
const result = await pool.query(
  `
    SELECT *
    FROM beneficiaries
    WHERE id = $1
  `,
  [beneficiaryId]
);
```

Do not construct SQL using direct interpolation of user input.

Incorrect:

```js
`SELECT * FROM beneficiaries WHERE id = '${beneficiaryId}'`
```

Correct:

```js
'SELECT * FROM beneficiaries WHERE id = $1'
```

---

# 14. Transaction Architecture

Multi-table operations must use PostgreSQL transactions.

Example:

```text
BEGIN
   ↓
Operation 1
   ↓
Operation 2
   ↓
Operation 3
   ↓
COMMIT
```

If any operation fails:

```text
ROLLBACK
```

---

# 15. Transaction Example — Beneficiary Registration

Registering a beneficiary may involve:

```text
beneficiaries
timeline_events
audit_logs
```

Architecture:

```text
POST /beneficiaries
        ↓
Authentication
        ↓
Authorization
        ↓
Validation
        ↓
Beneficiary Service
        ↓
BEGIN
        ↓
Create Beneficiary
        ↓
Create REGISTRATION Timeline Event
        ↓
Create Audit Log
        ↓
COMMIT
```

If any step fails:

```text
ROLLBACK
```

This prevents partial state.

---

# 16. Transaction Example — Program Enrollment

```text
POST /program-enrollments
        ↓
Validate beneficiary
        ↓
Validate program
        ↓
Check duplicate enrollment
        ↓
BEGIN
        ↓
Create Enrollment
        ↓
Create PROGRAM_ENROLLMENT Timeline Event
        ↓
Create Audit Log
        ↓
COMMIT
```

---

# 17. Transaction Example — Activity Completion

Where applicable:

```text
Update Activity Status
        ↓
Create Timeline Event
        ↓
Create Audit Log
```

These operations should be committed together.

---

# 18. Database Architecture

The PostgreSQL database follows the entity model defined in `DATABASE_SCHEMA.md`.

Core structure:

```text
USERS
  │
  ├── VOLUNTEER_PROFILES
  │       │
  │       ├── VOLUNTEER_SKILLS
  │       │
  │       └── VOLUNTEER_ASSIGNMENTS
  │
  └── CENTRES

CENTRES
  │
  ├── BENEFICIARIES
  └── PROGRAMS
          │
          ├── ACTIVITIES
          ├── PROGRAM_ENROLLMENTS
          ├── VOLUNTEER_ASSIGNMENTS
          └── TASKS

BENEFICIARIES
  │
  ├── PROGRAM_ENROLLMENTS
  ├── ATTENDANCES
  ├── PROGRESS_RECORDS
  └── TIMELINE_EVENTS

ACTIVITIES
  │
  ├── ATTENDANCES
  ├── VOLUNTEER_ASSIGNMENTS
  ├── TASKS
  ├── PROGRESS_RECORDS
  └── TIMELINE_EVENTS

ALL IMPORTANT OPERATIONS
  ↓
AUDIT_LOGS
```

---

# 19. Primary Key Strategy

All core tables use PostgreSQL UUID primary keys.

Recommended:

```sql
id UUID PRIMARY KEY DEFAULT gen_random_uuid()
```

The human-readable beneficiary identifier is separate:

```text
id
    ↓
technical UUID

beneficiary_id
    ↓
BEN-000001
```

The beneficiary identifier must not replace the UUID primary key.

---

# 20. Timestamp Strategy

Most tables contain:

```text
created_at
updated_at
```

Historical records may additionally contain event-specific timestamps.

Examples:

```text
attendance.recorded_at
progress_record.recorded_at
timeline_event.event_date
audit_log.timestamp
```

PostgreSQL defaults, triggers, or explicit backend updates may be used according to the database schema.

---

# 21. Database Migration Architecture

Database changes must be represented through version-controlled SQL migration files.

Recommended structure:

```text
database/
├── migrations/
│   ├── 001_extensions.sql
│   ├── 002_enums.sql
│   ├── 003_users.sql
│   ├── 004_centres.sql
│   ├── 005_beneficiaries.sql
│   ├── 006_programs.sql
│   ├── 007_enrollments.sql
│   ├── 008_activities.sql
│   ├── 009_attendance.sql
│   ├── 010_volunteers.sql
│   ├── 011_assignments.sql
│   ├── 012_tasks.sql
│   ├── 013_progress.sql
│   ├── 014_timeline.sql
│   ├── 015_audit_logs.sql
│   └── 016_indexes.sql
└── seed.sql
```

The exact migration runner/tool is not prescribed by the current source documents.

The important requirement is that schema changes are version-controlled and applied consistently.

---

# 22. Data Flow Architecture

## 22.1 Normal CRUD Flow

```text
React
  ↓
REST API
  ↓
Express Route
  ↓
Authentication
  ↓
Authorization
  ↓
Validation
  ↓
Controller
  ↓
Service
  ↓
Repository / SQL
  ↓
PostgreSQL
  ↓
Response
  ↓
React
```

---

# 23. Beneficiary Data Flow

```text
Program Lead
     ↓
React Beneficiary Form
     ↓
POST /api/beneficiaries
     ↓
Authentication
     ↓
PROGRAM_LEAD authorization
     ↓
Validation
     ↓
Beneficiary Service
     ↓
PostgreSQL Transaction
     ├── beneficiaries
     ├── timeline_events
     └── audit_logs
     ↓
201 Created
     ↓
React
```

---

# 24. Volunteer Activity Data Flow

```text
Volunteer
     ↓
My Activities
     ↓
GET /api/activities
     ↓
Authentication
     ↓
VOLUNTEER authorization
     ↓
Assignment Scope Check
     ↓
Activity Service
     ↓
PostgreSQL
     ↓
Permitted Activity Data
```

A volunteer must only receive activities within their assigned scope.

---

# 25. Attendance Data Flow

```text
Volunteer / Program Lead
        ↓
Open Activity
        ↓
View Participants
        ↓
Record Attendance
        ↓
POST /api/activities/:activityId/attendance
        ↓
Authorization
        ↓
Scope Check
        ↓
Validation
        ↓
Create Attendance
        ↓
Audit Log
        ↓
Response
```

Attendance must respect the unique:

```text
(activity_id, beneficiary_id)
```

constraint.

---

# 26. Analytics Architecture

Analytics should be calculated from the same operational data stored in PostgreSQL.

Conceptually:

```text
Operational Data
       ↓
PostgreSQL Queries
       ↓
Analytics Service
       ↓
REST API
       ↓
React Dashboard
```

The frontend must not maintain separate authoritative analytics data.

---

# 27. Program Analytics

Program analytics may use:

```text
beneficiaries
program_enrollments
activities
attendances
volunteer_assignments
progress_records
```

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
```

Only metrics supported by reliable collected data should be displayed.

---

# 28. Centre Analytics

Centre analytics may aggregate:

```text
beneficiaries
programs
activities
attendance
volunteer involvement
progress
```

The Executive Director can access organization-wide centre comparisons.

A Program Lead receives centre analytics according to their authorized scope.

---

# 29. Organization Analytics

Organization analytics are intended primarily for the Executive Director.

Possible metrics:

```text
total beneficiaries
active beneficiaries
total programs
active programs
total centres
total volunteers
program participation
activity statistics
attendance
progress
```

---

# 30. Beneficiary Journey Architecture

The beneficiary journey is represented through persistent records.

Conceptually:

```text
Initial Outreach
       ↓
Risk Identification
       ↓
Rescue / Case Registration
       ↓
Rehabilitation
       ↓
Program Enrollment
       ↓
Activities
       ↓
Attendance
       ↓
Progress Milestones
       ↓
Reintegration
       ↓
Long-Term Follow-up
```

The timeline is reconstructed from authorized timeline events and related operational records.

---

# 31. Timeline Event Generation

Where an important system action already represents a timeline event, the backend should generate the timeline event automatically.

Examples:

```text
Beneficiary Created
        ↓
REGISTRATION

Enrollment Created
        ↓
PROGRAM_ENROLLMENT

Activity Completed
        ↓
ACTIVITY

Progress Record Created
        ↓
PROGRESS_MILESTONE
```

This reduces duplicate manual entry.

---

# 32. Authentication Architecture

The PRD requires:

- Login
- Logout
- Role-based access
- Protected routes
- Session/token management
- Password security
- Unauthorized-access handling

The exact authentication mechanism was intentionally left open in the PRD.

Therefore, the implementation must finalize one secure session/token strategy before coding authentication.

The selected strategy must provide:

```text
Authenticated identity
       ↓
User ID
       ↓
Role
       ↓
Authorization
       ↓
Scope
```

Authentication credentials and password hashes must never be returned through normal API responses.

---

# 33. Authorization Architecture

Authorization is performed after authentication.

```text
Request
  ↓
Authenticate
  ↓
Identify User
  ↓
Identify Role
  ↓
Identify Resource
  ↓
Identify Action
  ↓
Check Scope
  ↓
Allow / Deny
```

A denied request returns:

```http
403 Forbidden
```

The backend must enforce permissions independently of the frontend.

---

# 34. Role Architecture

## PROGRAM_LEAD

Primary operational role.

```text
Programs
Beneficiaries
Activities
Volunteers
Assignments
Tasks
Attendance
Progress
Program Analytics
Relevant Centre Analytics
Reports
```

---

## VOLUNTEER

Assignment-scoped operational role.

```text
Assigned Programs
Assigned Beneficiaries
Assigned Activities
Own Tasks
Attendance for permitted activities
Relevant Progress
Own Performance
```

---

## EXECUTIVE_DIRECTOR

Organization-level oversight role.

```text
Organization Analytics
Centre Analytics
Program Analytics
Authorized Beneficiary Journey
Reports
```

---

# 35. Field-Level Authorization

Beneficiary records can contain information with different sensitivity levels.

The backend may therefore need to construct different response shapes for different roles.

Conceptually:

```text
Beneficiary
├── Basic Information
├── Program Information
├── Attendance
├── Progress
└── Sensitive Case Information
```

A volunteer should receive only the fields necessary for assigned responsibilities.

The exact sensitive fields must follow the Data Dictionary and Access Control Matrix.

---

# 36. Frontend Architecture

Recommended React structure:

```text
src/
├── components/
├── pages/
├── layouts/
├── routes/
├── services/
├── hooks/
├── context/
├── utils/
├── validation/
└── assets/
```

The exact structure may be changed during implementation without changing API or business contracts.

---

# 37. Frontend Route Architecture

Role-aware navigation should follow:

```text
Authenticated User
       ↓
Identify Role
       ↓
Role-specific Application Routes
```

Program Lead:

```text
/dashboard
/programs
/beneficiaries
/activities
/volunteers
/tasks
/analytics
/reports
```

Volunteer:

```text
/dashboard
/my-programs
/my-beneficiaries
/my-activities
/my-tasks
/my-performance
```

Executive Director:

```text
/dashboard
/organization-analytics
/centre-analytics
/program-analytics
/beneficiary-journey
/reports
```

Frontend route protection improves user experience but does not replace backend authorization.

---

# 38. API Client Architecture

The React application should communicate with the backend through a centralized API client/service layer.

Conceptually:

```text
React Component
      ↓
API Service
      ↓
HTTP Request
      ↓
Express API
```

Avoid scattering raw HTTP requests throughout unrelated components.

Recommended logical grouping:

```text
services/
├── authApi
├── beneficiaryApi
├── programApi
├── activityApi
├── attendanceApi
├── volunteerApi
├── taskApi
├── progressApi
├── timelineApi
├── analyticsApi
└── reportApi
```

---

# 39. Frontend State Principle

The frontend may cache or hold API data for user experience.

However:

```text
Frontend state ≠ source of truth
```

PostgreSQL remains the persistent source of truth.

After important mutations, the frontend should update or refetch affected data from the API.

---

# 40. Validation Architecture

Validation occurs at multiple layers.

```text
Frontend Validation
        ↓
API Request Validation
        ↓
Business Rule Validation
        ↓
PostgreSQL Constraints
```

Frontend validation is for usability.

Backend validation is required for correctness and security.

Database constraints are the final data-integrity layer.

---

# 41. Error Handling Architecture

Errors should flow through a centralized backend error-handling mechanism.

Conceptually:

```text
Database / Service Error
        ↓
Service
        ↓
Controller
        ↓
Error Middleware
        ↓
Standard API Error
        ↓
React
```

Example:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": []
  }
}
```

Sensitive implementation details must not be exposed to clients.

---

# 42. Security Architecture

The architecture must protect beneficiary information and enforce the access-control rules.

Required principles:

```text
HTTPS
Authentication
Authorization
Scope checks
Parameterized SQL
Password security
Input validation
Protected secrets
Audit logging
Restricted sensitive fields
```

The exact production security configuration must be finalized during implementation.

---

# 43. Secret Management

Secrets must not be committed to source control.

Examples:

```text
DATABASE_URL
DATABASE_PASSWORD
AUTH_SECRET
API keys
other credentials
```

Use environment-based configuration.

Example:

```text
.env
```

The actual `.env` file must not be committed.

A safe example file may be maintained as:

```text
.env.example
```

---

# 44. Environment Configuration

At minimum, the backend will require configuration for:

```text
database connection
server port
authentication/session configuration
frontend origin
environment mode
```

Exact variable names should be finalized in the implementation documentation.

---

# 45. CORS Architecture

The backend should allow requests only from the configured frontend origin(s).

Conceptually:

```text
React Frontend
      ↓
Allowed Origin
      ↓
Express API
```

Production origins should not be left unrestricted.

---

# 46. Logging Architecture

The backend should maintain useful application logs for:

```text
startup
database connection errors
request failures
unexpected exceptions
important operational events
```

Audit logs are separate from ordinary application logs.

Audit logs represent business/system actions that require traceability.

---

# 47. Audit Architecture

Important operations should create audit records.

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
Sensitive Record Accessed
```

Audit records contain:

```text
userId
action
entityType
entityId
description
timestamp
metadata
```

Audit logging should be integrated into the relevant service operations.

---

# 48. Performance Architecture

The architecture should support efficient retrieval of operational records.

Important mechanisms include:

```text
PostgreSQL indexes
Pagination
Filtered queries
Scoped queries
Connection pooling
Aggregated analytics queries
```

The existing database schema defines indexes for frequently accessed fields such as:

```text
beneficiary_id
centre_id
case_status
risk_level
program status
program category
program dates
activity date
activity status
attendance status
```

The frontend should avoid requesting unnecessarily large datasets.

---

# 49. Search Architecture

Search is performed through the backend API.

```text
React Search
      ↓
GET /api/...
      ↓
Authorization Scope
      ↓
Parameterized PostgreSQL Query
      ↓
Filtered Results
```

Search results must never bypass authorization scope.

A volunteer must not receive unrestricted global beneficiary search results.

---

# 50. Pagination Architecture

Large collections should use server-side pagination.

Example:

```text
GET /api/beneficiaries?page=1&limit=20
```

The API returns:

```json
{
  "success": true,
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

---

# 51. Mobile Architecture

The PRD requires core workflows to be usable on mobile devices.

The React frontend should therefore use responsive layouts for:

```text
Login
Dashboards
Beneficiary registration
Beneficiary lookup
Activity management
Attendance
Task management
Volunteer workflows
```

The backend remains device-independent.

---

# 52. Deployment Architecture

The exact hosting providers are not specified in the source documents.

Therefore, the deployment architecture should remain provider-independent.

Conceptually:

```text
User Browser
      ↓
HTTPS
      ↓
Frontend Hosting
      ↓
Node.js / Express API Hosting
      ↓
PostgreSQL Hosting
```

The selected providers can be finalized separately without changing the application architecture.

---

# 53. Production Deployment Separation

Production should separate:

```text
Frontend
Backend API
PostgreSQL Database
```

Example:

```text
React Build
    ↓
Static/Web Hosting

Node.js + Express
    ↓
API Hosting

PostgreSQL
    ↓
Managed/Hosted Database
```

The backend should communicate with PostgreSQL over a secure database connection.

---

# 54. Development Environment

Recommended local architecture:

```text
Developer Machine
│
├── React Dev Server
│
├── Node.js + Express
│
└── PostgreSQL
```

The frontend calls the local backend API.

The backend connects to local/development PostgreSQL.

---

# 55. Project Structure

A recommended full-stack repository structure is:

```text
purnata/
│
├── frontend/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
│
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   ├── controllers/
│   │   ├── services/
│   │   ├── repositories/
│   │   ├── middleware/
│   │   ├── validators/
│   │   ├── utils/
│   │   ├── config/
│   │   └── app.js
│   ├── package.json
│   └── ...
│
├── database/
│   ├── migrations/
│   └── seed.sql
│
├── docs/
│   ├── PRD.md
│   ├── USER_FLOWS.md
│   ├── ACCESS_CONTROL_MATRIX.md
│   ├── DATA_DICTIONARY.md
│   ├── DATABASE_SCHEMA.md
│   ├── API_SPECIFICATION.md
│   └── TECHNICAL_ARCHITECTURE.md
│
└── README.md
```

This is a recommended organization rather than a mandatory folder structure.

---

# 56. Backend Module Organization

A logical module structure can follow business domains:

```text
backend/src/
│
├── modules/
│   ├── auth/
│   ├── users/
│   ├── centres/
│   ├── beneficiaries/
│   ├── programs/
│   ├── enrollments/
│   ├── activities/
│   ├── attendance/
│   ├── volunteers/
│   ├── assignments/
│   ├── tasks/
│   ├── progress/
│   ├── timeline/
│   ├── analytics/
│   ├── reports/
│   └── audit/
│
├── middleware/
├── config/
└── app.js
```

Either domain-based modules or a flat controller/service/repository structure can be used as long as responsibilities remain separated.

---

# 57. Request Lifecycle

A protected request should follow:

```text
1. Browser sends request
          ↓
2. Express receives request
          ↓
3. Authentication middleware
          ↓
4. User identity established
          ↓
5. Authorization middleware
          ↓
6. Resource-level scope check
          ↓
7. Request validation
          ↓
8. Controller
          ↓
9. Service
          ↓
10. PostgreSQL query
          ↓
11. Response formatting
          ↓
12. React receives response
```

---

# 58. Example Request Lifecycle

Example:

```http
GET /api/beneficiaries/550e8400-e29b-41d4-a716-446655440000
```

Flow:

```text
Request
  ↓
Authenticate
  ↓
User = Volunteer A
  ↓
Role = VOLUNTEER
  ↓
Find beneficiary
  ↓
Check assignment relationship
  ↓
Authorized?
 ├── NO → 403
 └── YES
       ↓
Select permitted fields
       ↓
Return JSON
```

---

# 59. Data Consistency Rules

The backend must preserve important cross-entity relationships.

Examples:

```text
Activity.programId
    must reference an existing Program

Activity.centreId
    must match Program.centreId

Enrollment.beneficiaryId
    must reference an existing Beneficiary

Enrollment.programId
    must reference an existing Program

Attendance.activityId
    must reference an existing Activity

Attendance.beneficiaryId
    must reference an existing Beneficiary

Task.volunteerId
    must reference a Volunteer

Assignment.volunteerId
    must reference a Volunteer
```

Some relationships are enforced through PostgreSQL constraints and others through backend business logic as defined in the database schema.

---

# 60. Status Management

Status values must use the enums defined in the Data Dictionary and Database Schema.

Examples:

```text
Program:
PLANNED
ACTIVE
COMPLETED
CANCELLED

Activity:
PLANNED
ONGOING
COMPLETED
CANCELLED

Task:
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED

Attendance:
PRESENT
ABSENT
EXCUSED
```

The backend should validate status transitions rather than accepting arbitrary enum values.

---

# 61. Analytics Data Principle

All dashboards should use the same underlying operational data.

Conceptually:

```text
Activities
    │
    ├── Attendance
    ├── Volunteers
    └── Beneficiaries
             ↓
         Progress
             ↓
         Analytics
```

The frontend must not manually calculate authoritative organizational metrics from incomplete local data.

---

# 62. Reporting Architecture

Reports are generated from authorized operational data.

```text
Authorized User
      ↓
Report Request
      ↓
Authorization
      ↓
Filter Validation
      ↓
Analytics / Reporting Query
      ↓
Report Data
      ↓
Display / Export
```

Potential report categories:

```text
Beneficiary
Program
Centre
Volunteer
Attendance
Progress
Impact
```

Exact report formats remain to be finalized with stakeholders.

---

# 63. Backup and Recovery

The PRD requires long-term beneficiary history, but the current source documents do not specify:

- Backup frequency
- Recovery point objective
- Recovery time objective
- Retention period
- Disaster recovery provider

These must be finalized before production deployment.

The production database should nevertheless have a documented backup and recovery strategy.

---

# 64. Scalability Approach

The MVP should use a simple layered architecture.

Initial scaling strategy:

```text
React
   ↓
Express API
   ↓
PostgreSQL
```

The architecture should avoid unnecessary distributed systems for the MVP.

Potential future scaling options, if required by actual usage, include:

```text
API horizontal scaling
database read optimization
caching
background jobs
separate analytics workloads
```

These are future options, not MVP requirements.

---

# 65. Notifications

The PRD identifies notifications as an open question.

Therefore:

```text
Notification Service
```

is not a mandatory MVP architecture component unless stakeholders approve notification requirements.

If notifications are later required, they should be integrated behind a service boundary rather than embedded throughout business logic.

---

# 66. Offline Data Entry

Offline data entry is also an open product question.

Therefore, the MVP architecture does not assume offline synchronization.

If offline operation is approved later, synchronization requirements must be separately designed before implementation.

---

# 67. External Integrations

No mandatory external integration is defined by the current source documents.

The architecture should therefore avoid coupling the core domain model to external services.

External integrations, if later required, should be isolated behind dedicated service modules.

---

# 68. Testing Architecture

Testing should cover the system at multiple levels.

```text
Unit Tests
    ↓
Service / Business Logic Tests
    ↓
API / Integration Tests
    ↓
Database Tests
    ↓
Authorization Tests
    ↓
End-to-End Tests
```

Critical workflows should be tested end-to-end.

---

# 69. Critical Test Workflows

At minimum, the implementation should test:

```text
User login
Role-based access
Beneficiary registration
Unique beneficiary ID
Duplicate beneficiary prevention
Program creation
Program enrollment
Duplicate enrollment prevention
Activity creation
Activity completion
Volunteer assignment
Task assignment
Task completion
Attendance recording
Duplicate attendance prevention
Progress recording
Timeline generation
Audit logging
Program analytics
Centre analytics
Executive analytics
```

---

# 70. Authorization Testing

Authorization tests must verify both:

```text
Role
```

and:

```text
Scope
```

Example:

```text
Volunteer A
   ↓
Program X
   ↓
Beneficiary 101
```

Expected:

```text
GET /beneficiaries/101
→ permitted if authorized
```

But:

```text
Volunteer A
   ↓
Program Y
   ↓
Beneficiary 205
```

Expected:

```text
GET /beneficiaries/205
→ 403 Forbidden
```

---

# 71. Observability Boundaries

The system should distinguish:

```text
Application Logs
Audit Logs
Database Errors
API Errors
```

They serve different purposes.

Application logs:

```text
technical diagnosis
```

Audit logs:

```text
business/system accountability
```

API errors:

```text
client-facing failure handling
```

---

# 72. AI Coding Agent Rules

Any AI coding agent working on the project must first understand:

```text
PRD.md
USER_FLOWS.md
ACCESS_CONTROL_MATRIX.md
DATA_DICTIONARY.md
DATABASE_SCHEMA.md
API_SPECIFICATION.md
TECHNICAL_ARCHITECTURE.md
```

For every implementation task, determine:

```text
User Role
    ↓
Business Requirement
    ↓
Entity / Data
    ↓
API
    ↓
Authorization
    ↓
Validation
    ↓
UI
    ↓
Success Behavior
    ↓
Failure Behavior
```

AI agents must not independently change:

```text
Database relationships
API contracts
Authentication rules
Role permissions
Core business logic
Beneficiary identity rules
```

without updating the appropriate specification or obtaining approval.

---

# 73. Architecture Decision Summary

| Area | Decision |
|---|---|
| Frontend | React |
| Backend | Node.js + Express.js |
| API | REST / JSON |
| Database | PostgreSQL |
| DB Access | `pg` / node-postgres |
| ORM | None |
| Primary Keys | PostgreSQL UUID |
| Human Beneficiary ID | `BEN-XXXXXX` style persistent ID |
| Authorization | Role + Scope |
| Database Queries | Parameterized SQL |
| Transactions | PostgreSQL transactions |
| Source of Truth | PostgreSQL |
| Analytics Source | Operational PostgreSQL data |
| Frontend Security | UX only; backend is security boundary |
| Schema Changes | Version-controlled SQL migrations |
| Mobile Support | Responsive React frontend |
| Notifications | Not fixed for MVP |
| Offline Mode | Not fixed for MVP |
| Deployment Provider | Not fixed |
| Backup Policy | To be finalized |

---

# 74. Open Technical Decisions

The following items remain to be finalized because the source documents do not yet specify them completely:

1. Exact authentication/session/token mechanism.
2. Password hashing implementation.
3. Exact production hosting providers.
4. PostgreSQL hosting configuration.
5. Database backup and recovery policy.
6. Production monitoring solution.
7. Exact migration runner.
8. Exact report export formats.
9. Notification requirements.
10. Offline data-entry requirements.
11. Initial deployment centres.
12. Data retention period.
13. Exact sensitive beneficiary fields.
14. Final analytics KPI definitions.

These decisions should be recorded in the relevant specification documents before implementation of the affected feature.

---

# 75. Final Architecture

The Purnata MVP follows this architecture:

```text
                         PURNATA PLATFORM
                                │
                                ▼
                    ┌──────────────────────┐
                    │    React Frontend    │
                    │                      │
                    │ Dashboards           │
                    │ Forms                │
                    │ Beneficiary Journey  │
                    │ Activities           │
                    │ Tasks                │
                    │ Analytics             │
                    └──────────┬───────────┘
                               │
                          HTTPS / REST
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Node.js + Express.js │
                    │                      │
                    │ Routes               │
                    │ Authentication      │
                    │ Authorization       │
                    │ Validation          │
                    │ Controllers         │
                    │ Services            │
                    │ SQL / Repositories  │
                    └──────────┬───────────┘
                               │
                       pg / node-postgres
                               │
                       Parameterized SQL
                               │
                               ▼
                    ┌──────────────────────┐
                    │      PostgreSQL      │
                    │                      │
                    │ Users                │
                    │ Centres              │
                    │ Beneficiaries        │
                    │ Programs             │
                    │ Enrollments          │
                    │ Activities           │
                    │ Attendance            │
                    │ Volunteers           │
                    │ Assignments          │
                    │ Tasks                │
                    │ Progress             │
                    │ Timeline              │
                    │ Audit Logs            │
                    └──────────────────────┘
```

The architecture keeps the system centralized, role-aware, auditable, and consistent with the finalized PostgreSQL database and REST API design.

The central rule is:

```text
PRD
 ↓
User Flows
 ↓
Access Control
 ↓
Data Dictionary
 ↓
Database Schema
 ↓
API Specification
 ↓
Technical Architecture
 ↓
Implementation
```

No implementation should bypass this specification chain.
