# API_SPECIFICATION.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Final — Hackathon Implementation Specification  
**Database:** PostgreSQL  
**Database Access:** Direct PostgreSQL connection using `pg` (node-postgres)  
**Backend:** Node.js + Express.js  
**API Style:** REST  
**API Field Convention:** camelCase

---

# 1. Purpose

This document defines the REST API contract for the Purnata Digital Case & Program Management Platform.

It defines:

- API endpoints
- HTTP methods
- Authentication requirements
- Role and scope requirements
- Request parameters
- Request bodies
- Response structures
- HTTP status codes
- Validation expectations
- Pagination/filtering conventions
- Error responses
- Analytics endpoints
- Reporting endpoints

The API is the contract between the React frontend and the Node.js + Express.js backend.

The backend must enforce authorization independently of frontend restrictions.

The API must use the field names and enum values defined in `DATA_DICTIONARY.md` and the relationships/constraints defined in `DATABASE_SCHEMA.md`.

---

# 2. Source Documents

The API must remain consistent with:

```text
PRD.md
USER_FLOWS.md
ACCESS_CONTROL_MATRIX.md
DATA_DICTIONARY.md
DATABASE_SCHEMA.md
```

The Data Dictionary defines the shared data contract for the frontend, backend, database, API, analytics, AI coding agents, and testing.

The database schema is PostgreSQL-based and uses direct PostgreSQL access through `pg` (node-postgres).

---

# 3. API Architecture

```text
React Frontend
       ↓
   REST API
       ↓
Node.js + Express.js
       ↓
Authentication / Authorization
       ↓
Service / Business Logic
       ↓
PostgreSQL Client (`pg`)
       ↓
PostgreSQL
```

The frontend must never connect directly to PostgreSQL.

---

# 4. Base URL

Development:

```text
/api
```

Production:

```text
/api
```

All endpoint paths in this document are relative to the API base path.

Example:

```text
GET /api/beneficiaries
```

---

# 5. API Conventions

## 5.1 HTTP Methods

| Method | Purpose |
|---|---|
| GET | Retrieve resource(s) |
| POST | Create resource or perform an action |
| PATCH | Partially update resource |
| DELETE | Delete resource where explicitly permitted |

Permanent deletion should be restricted because the platform maintains long-term beneficiary and program history.

---

## 5.2 Content Type

Requests containing a body must use:

```http
Content-Type: application/json
```

Successful JSON responses use:

```http
Content-Type: application/json
```

---

## 5.3 API Field Naming

API fields use camelCase.

Examples:

```text
beneficiaryId
programId
activityDate
createdAt
updatedAt
recordedBy
```

PostgreSQL column names remain compatible with the database schema, for example:

```text
beneficiary_id
program_id
activity_date
created_at
updated_at
recorded_by
```

The frontend must use the API contract rather than depending directly on database column names.

---

# 6. Authentication

The platform requires:

- Login
- Logout
- Role-based access control
- Protected routes
- Session/token management
- Password security
- Unauthorized-access handling

The exact authentication mechanism is intentionally not fixed here because the PRD states that it will be defined in the Technical Architecture document.

Therefore, this API specification uses the generic concept of an authenticated request.

---

# 7. Authentication Endpoints

## 7.1 Login

```http
POST /auth/login
```

### Access

Public.

### Request

```json
{
  "email": "user@example.com",
  "password": "password"
}
```

### Success

```http
200 OK
```

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "fullName": "Example User",
      "email": "user@example.com",
      "role": "PROGRAM_LEAD",
      "phone": "9999999999",
      "centreId": "uuid",
      "status": "ACTIVE"
    },
    "session": {}
  }
}
```

The exact session/token fields will be finalized by the authentication implementation.

### Errors

```text
400 Bad Request
401 Unauthorized
403 Forbidden
```

---

## 7.2 Logout

```http
POST /auth/logout
```

### Access

Authenticated users.

### Success

```http
200 OK
```

```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 7.3 Current User

```http
GET /auth/me
```

### Access

Authenticated users.

### Success

```http
200 OK
```

Returns the authenticated user's permitted profile information.

---

# 8. Authorization Model

Authorization follows:

```text
ROLE + SCOPE = ACCESS
```

The backend must:

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
Identify Action
  ↓
Check Scope
  ↓
Authorized?
 ├── NO → 403 Forbidden
 └── YES → Execute Request
```

The access-control matrix is the source of truth for authorization.

---

# 9. Roles

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

---

# 10. Authorization Scope

## PROGRAM_LEAD

Program Leads can access operational records within their authorized operational scope.

They can manage:

```text
Programs
Beneficiaries
Activities
Volunteers
Volunteer Assignments
Tasks
Attendance
Progress
Timelines
Program Analytics
Relevant Centre Analytics
Reports
```

---

## VOLUNTEER

Volunteers can access only information required for assigned work.

Their scope is based on assignments.

A volunteer must not receive an unrestricted global beneficiary search.

---

## EXECUTIVE_DIRECTOR

The Executive Director primarily consumes organizational information.

They can access authorized:

```text
Organization Analytics
Centre Analytics
Program Analytics
Beneficiary Journey
Reports
Operational records for oversight
```

---

# 11. Standard Response Format

Successful responses should follow:

```json
{
  "success": true,
  "data": {}
}
```

For collections:

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

For action responses:

```json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {}
}
```

---

# 12. Standard Error Format

All API errors should use a consistent structure:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Request validation failed",
    "details": []
  }
}
```

Example validation error:

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": [
      {
        "field": "progressPercentage",
        "message": "Must be between 0 and 100"
      }
    ]
  }
}
```

---

# 13. Standard HTTP Status Codes

| Status | Meaning |
|---|---|
| 200 | Successful request |
| 201 | Resource created |
| 204 | Successful request with no response body |
| 400 | Invalid request |
| 401 | Authentication required/failed |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict |
| 422 | Validation/business-rule failure |
| 500 | Internal server error |

---

# 14. Pagination

Collection endpoints should support:

```text
?page=1&limit=20
```

Defaults:

```text
page = 1
limit = 20
```

The backend should enforce a reasonable maximum limit.

Example:

```http
GET /beneficiaries?page=1&limit=20
```

---

# 15. Filtering

Where applicable, collection endpoints may support filters.

Example:

```http
GET /beneficiaries?caseStatus=REHABILITATION&riskLevel=HIGH
```

Filters must only expose records within the authenticated user's authorization scope.

---

# 16. Sorting

Where supported:

```text
?sortBy=createdAt&sortOrder=desc
```

Allowed sortable fields must be explicitly defined by each endpoint.

The backend must not directly interpolate arbitrary user-provided values into SQL.

---

# 17. Search

Search must respect authorization scope.

Program Leads may search authorized:

```text
Programs
Beneficiaries
Activities
Volunteers
Tasks
```

Volunteers may search only within their assigned scope.

Executive Directors may search authorized organizational records.

---

# 18. User APIs

## 18.1 Get Current User

```http
GET /auth/me
```

---

## 18.2 Get Volunteers

```http
GET /volunteers
```

### Access

- PROGRAM_LEAD: Authorized operational scope
- VOLUNTEER: Own profile only
- EXECUTIVE_DIRECTOR: Read

### Query Parameters

```text
page
limit
status
skillId
search
```

---

## 18.3 Get Volunteer

```http
GET /volunteers/:userId
```

### Access

Scope-dependent.

Volunteers may access their own profile.

---

## 18.4 Update Own Volunteer Profile

```http
PATCH /volunteers/me
```

### Access

VOLUNTEER.

Only permitted profile fields may be changed.

A volunteer must not change:

```text
role
permissions
administrative information
performance records
assignment authority
```

---

# 19. Centre APIs

## 19.1 List Centres

```http
GET /centres
```

### Access

Authorized users.

### Query Parameters

```text
page
limit
status
search
```

---

## 19.2 Get Centre

```http
GET /centres/:centreId
```

### Access

Authorized users.

---

## 19.3 Centre Analytics

```http
GET /centres/:centreId/analytics
```

### Access

- PROGRAM_LEAD: Relevant centre
- VOLUNTEER: Not permitted
- EXECUTIVE_DIRECTOR: Authorized

Possible metrics:

```text
beneficiaries
active beneficiaries
programs
activities
attendance
volunteer involvement
progress indicators
outcomes
```

---

# 20. Beneficiary APIs

Beneficiary management is a core platform capability.

---

## 20.1 List Beneficiaries

```http
GET /beneficiaries
```

### Access

- PROGRAM_LEAD: Authorized operational scope
- VOLUNTEER: Assigned beneficiaries only
- EXECUTIVE_DIRECTOR: Authorized

### Query Parameters

```text
page
limit
search
centreId
caseStatus
riskLevel
educationLevel
```

The volunteer endpoint behavior must enforce assignment-based scope.

---

## 20.2 Register Beneficiary

```http
POST /beneficiaries
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "fullName": "Example Beneficiary",
  "dateOfBirth": "2005-01-15",
  "gender": "FEMALE",
  "phone": "9999999999",
  "address": "Example Address",
  "city": "Pune",
  "state": "Maharashtra",
  "centreId": "uuid",
  "registrationDate": "2026-08-18",
  "caseStatus": "OUTREACH",
  "riskLevel": "MEDIUM",
  "educationLevel": "SECONDARY",
  "occupation": null,
  "emergencyContactName": null,
  "emergencyContactPhone": null,
  "notes": null
}
```

### Server behavior

The backend must:

1. Validate the request.
2. Check for an existing beneficiary where practical.
3. Create the beneficiary if no existing record is found.
4. Generate a persistent human-readable ID.
5. Create the required timeline event.
6. Create the audit log.
7. Perform multi-table writes transactionally.

### Success

```http
201 Created
```

Response includes:

```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "beneficiaryId": "BEN-000001"
  }
}
```

---

## 20.3 Get Beneficiary

```http
GET /beneficiaries/:beneficiaryId
```

### Access

Scope-dependent.

### Important

Sensitive beneficiary information must not be returned to users who are not authorized to receive it.

---

## 20.4 Update Beneficiary

```http
PATCH /beneficiaries/:beneficiaryId
```

### Access

PROGRAM_LEAD and authorized users according to the access-control matrix.

### Restrictions

The following must not be regenerated:

```text
beneficiaryId
```

A beneficiary must retain one persistent identity across programs.

---

## 20.5 Beneficiary Timeline

```http
GET /beneficiaries/:beneficiaryId/timeline
```

### Access

Authorized users.

### Query Parameters

```text
page
limit
eventType
startDate
endDate
```

### Response

```json
{
  "success": true,
  "data": [
    {
      "id": "uuid",
      "eventType": "PROGRAM_ENROLLMENT",
      "title": "Enrolled in vocational training",
      "description": "Example description",
      "eventDate": "2026-08-18",
      "programId": "uuid",
      "activityId": null,
      "createdBy": "uuid",
      "createdAt": "2026-08-18T10:00:00Z"
    }
  ]
}
```

Timeline information must be filtered according to role and scope.

---

# 21. Program APIs

## 21.1 List Programs

```http
GET /programs
```

### Access

- PROGRAM_LEAD: Full within scope
- VOLUNTEER: Assigned programs
- EXECUTIVE_DIRECTOR: Read

### Query Parameters

```text
page
limit
search
centreId
status
category
startDate
endDate
```

---

## 21.2 Get Program

```http
GET /programs/:programId
```

### Access

Scope-dependent.

---

## 21.3 Create Program

```http
POST /programs
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "name": "Vocational Training Program",
  "description": "Program description",
  "category": "VOCATIONAL_TRAINING",
  "centreId": "uuid",
  "startDate": "2026-08-18",
  "endDate": null,
  "objectives": "Program objectives",
  "status": "PLANNED"
}
```

### Success

```http
201 Created
```

The backend must set `createdBy` from the authenticated user rather than accepting it as an arbitrary client-controlled value.

---

## 21.4 Update Program

```http
PATCH /programs/:programId
```

### Access

PROGRAM_LEAD.

---

## 21.5 Cancel Program

```http
PATCH /programs/:programId/status
```

### Request

```json
{
  "status": "CANCELLED"
}
```

Permanent deletion should not be preferred where historical records depend on the program.

---

## 21.6 Program Beneficiaries

```http
GET /programs/:programId/beneficiaries
```

### Access

Scope-dependent.

---

## 21.7 Program Activities

```http
GET /programs/:programId/activities
```

### Access

Scope-dependent.

---

## 21.8 Program Volunteers

```http
GET /programs/:programId/volunteers
```

### Access

Scope-dependent.

---

## 21.9 Program Analytics

```http
GET /programs/:programId/analytics
```

### Access

- PROGRAM_LEAD: Full
- VOLUNTEER: Limited/relevant
- EXECUTIVE_DIRECTOR: Full

Possible metrics:

```text
total beneficiaries
active beneficiaries
enrollments
activities
attendance
volunteer participation
progress milestones
completion statistics
```

---

# 22. Program Enrollment APIs

## 22.1 List Enrollments

```http
GET /program-enrollments
```

### Query Parameters

```text
page
limit
beneficiaryId
programId
status
```

---

## 22.2 Create Enrollment

```http
POST /program-enrollments
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "beneficiaryId": "uuid",
  "programId": "uuid",
  "enrollmentDate": "2026-08-18",
  "status": "ACTIVE",
  "progressPercentage": 0,
  "notes": null
}
```

### Rules

- Beneficiary must exist.
- Program must exist.
- Duplicate beneficiary + program enrollment must be rejected.
- `progressPercentage` must be between 0 and 100.
- The operation should create the appropriate timeline event.
- The operation should create an audit log.
- Multi-table writes should use a PostgreSQL transaction.

### Success

```http
201 Created
```

### Conflict

```http
409 Conflict
```

for a duplicate enrollment.

---

## 22.3 Get Enrollment

```http
GET /program-enrollments/:enrollmentId
```

---

## 22.4 Update Enrollment

```http
PATCH /program-enrollments/:enrollmentId
```

### Access

PROGRAM_LEAD.

---

# 23. Activity APIs

## 23.1 List Activities

```http
GET /activities
```

### Query Parameters

```text
page
limit
programId
centreId
activityDate
status
activityType
startDate
endDate
```

---

## 23.2 Get Activity

```http
GET /activities/:activityId
```

---

## 23.3 Create Activity

```http
POST /activities
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "programId": "uuid",
  "centreId": "uuid",
  "name": "Skill Development Session",
  "description": "Session description",
  "activityType": "SKILL_DEVELOPMENT",
  "activityDate": "2026-08-20",
  "startTime": "10:00",
  "endTime": "12:00",
  "location": "Centre Hall",
  "status": "PLANNED"
}
```

### Validation

```text
endTime > startTime
```

The activity's centre must match the program's centre.

The backend should derive `createdBy` from the authenticated user.

---

## 23.4 Update Activity

```http
PATCH /activities/:activityId
```

### Access

- PROGRAM_LEAD: Authorized
- VOLUNTEER: Limited/assigned activity only
- EXECUTIVE_DIRECTOR: Read only

---

## 23.5 Complete Activity

```http
PATCH /activities/:activityId/status
```

### Request

```json
{
  "status": "COMPLETED"
}
```

Completing an activity may trigger timeline events and related audit logging.

---

## 23.6 Activity Participants

```http
GET /activities/:activityId/participants
```

### Access

Authorized users within scope.

---

# 24. Attendance APIs

## 24.1 Get Activity Attendance

```http
GET /activities/:activityId/attendance
```

### Access

- PROGRAM_LEAD: Full
- VOLUNTEER: Assigned activity
- EXECUTIVE_DIRECTOR: Read

---

## 24.2 Record Attendance

```http
POST /activities/:activityId/attendance
```

### Access

- PROGRAM_LEAD
- Authorized VOLUNTEER for the assigned activity

### Request

```json
{
  "beneficiaryId": "uuid",
  "status": "PRESENT",
  "remarks": "Attended session"
}
```

The backend must set `recordedBy` from the authenticated user.

### Rules

- Activity must exist.
- Beneficiary must exist.
- Beneficiary must be participating in the relevant activity/program.
- Only one attendance record may exist for an activity + beneficiary pair.

### Success

```http
201 Created
```

### Duplicate

```http
409 Conflict
```

---

## 24.3 Update Attendance

```http
PATCH /attendance/:attendanceId
```

### Access

Authorized users.

Volunteer changes must remain within their assigned scope.

---

# 25. Volunteer Assignment APIs

## 25.1 List Assignments

```http
GET /volunteer-assignments
```

### Query Parameters

```text
page
limit
volunteerId
programId
activityId
status
```

---

## 25.2 Assign Volunteer to Program

```http
POST /volunteer-assignments
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "volunteerId": "uuid",
  "programId": "uuid",
  "activityId": null,
  "assignmentDate": "2026-08-18",
  "status": "ASSIGNED",
  "notes": null
}
```

The backend must set `assignedBy` from the authenticated user.

### Validation

```text
volunteerId → user with role VOLUNTEER
programId → existing program
activityId → existing activity when provided
```

If `activityId` is provided:

```text
activity.programId = assignment.programId
```

---

## 25.3 Get Assignment

```http
GET /volunteer-assignments/:assignmentId
```

---

## 25.4 Update Assignment

```http
PATCH /volunteer-assignments/:assignmentId
```

### Access

PROGRAM_LEAD.

---

# 26. Task APIs

## 26.1 List Tasks

```http
GET /tasks
```

### Query Parameters

```text
page
limit
volunteerId
programId
activityId
status
priority
dueDate
```

Volunteers can only receive their own tasks.

---

## 26.2 Create Task

```http
POST /tasks
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "title": "Conduct follow-up session",
  "description": "Complete assigned follow-up",
  "volunteerId": "uuid",
  "programId": "uuid",
  "activityId": null,
  "dueDate": "2026-08-25",
  "priority": "HIGH",
  "status": "ASSIGNED"
}
```

The backend must set `createdBy` from the authenticated user.

### Validation

The volunteer must have the `VOLUNTEER` role.

If `activityId` is provided:

```text
activity.programId = task.programId
```

---

## 26.3 Get Task

```http
GET /tasks/:taskId
```

---

## 26.4 Update Task

```http
PATCH /tasks/:taskId
```

### Access

- PROGRAM_LEAD: Full within scope
- VOLUNTEER: Own task status/allowed fields
- EXECUTIVE_DIRECTOR: Read

---

## 26.5 Complete Task

```http
PATCH /tasks/:taskId/status
```

### Request

```json
{
  "status": "COMPLETED"
}
```

When completed, the backend should set `completedAt`.

---

# 27. Progress APIs

## 27.1 List Progress Records

```http
GET /progress-records
```

### Query Parameters

```text
page
limit
beneficiaryId
programId
activityId
category
startDate
endDate
```

---

## 27.2 Create Progress Record

```http
POST /progress-records
```

### Access

- PROGRAM_LEAD
- Volunteer for activity/assignment-related progress where authorized

### Request

```json
{
  "beneficiaryId": "uuid",
  "programId": "uuid",
  "activityId": null,
  "category": "VOCATIONAL_SKILL",
  "title": "Completed basic training",
  "description": "Beneficiary completed the training milestone",
  "score": 75
}
```

The backend must set `recordedBy` from the authenticated user.

### Validation

```text
score >= 0
score <= 100
```

The beneficiary and program must exist.

The record must respect assignment/scope rules.

### Success

```http
201 Created
```

A corresponding `PROGRESS_MILESTONE` timeline event may be generated automatically according to the timeline rules.

---

## 27.3 Get Progress Record

```http
GET /progress-records/:progressRecordId
```

---

## 27.4 Update Progress Record

```http
PATCH /progress-records/:progressRecordId
```

### Access

Scope-dependent.

---

# 28. Timeline APIs

## 28.1 List Timeline Events

```http
GET /timeline-events
```

### Query Parameters

```text
page
limit
beneficiaryId
eventType
startDate
endDate
```

---

## 28.2 Get Timeline Event

```http
GET /timeline-events/:eventId
```

---

## 28.3 Create Timeline Event

```http
POST /timeline-events
```

### Access

PROGRAM_LEAD and permitted activity-related users according to authorization rules.

### Request

```json
{
  "beneficiaryId": "uuid",
  "eventType": "CASE_UPDATE",
  "title": "Case updated",
  "description": "Case information updated",
  "eventDate": "2026-08-18",
  "programId": null,
  "activityId": null
}
```

The backend must set `createdBy` from the authenticated user.

System-generated timeline events should be preferred for events already represented by system actions.

---

# 29. Volunteer Skills APIs

## 29.1 List Skills

```http
GET /skills
```

---

## 29.2 Get Volunteer Skills

```http
GET /volunteers/:userId/skills
```

---

## 29.3 Add Volunteer Skill

```http
POST /volunteers/:userId/skills
```

### Access

PROGRAM_LEAD.

### Request

```json
{
  "skillId": "uuid",
  "proficiencyLevel": "INTERMEDIATE"
}
```

The same volunteer + skill combination must not be duplicated.

---

## 29.4 Update Volunteer Skill

```http
PATCH /volunteers/:userId/skills/:skillId
```

### Access

PROGRAM_LEAD.

---

# 30. Dashboard APIs

Dashboard endpoints should return aggregated information required by the role-specific dashboard.

---

## 30.1 Program Lead Dashboard

```http
GET /dashboard/program-lead
```

### Access

PROGRAM_LEAD.

Possible data:

```text
totalPrograms
activePrograms
totalBeneficiaries
activeBeneficiaries
totalVolunteers
upcomingActivities
recentActivities
programProgress
beneficiaryProgress
relevantTasks
```

---

## 30.2 Volunteer Dashboard

```http
GET /dashboard/volunteer
```

### Access

VOLUNTEER.

Possible data:

```text
assignedPrograms
assignedBeneficiaries
upcomingActivities
assignedTasks
pendingTasks
recentActivities
```

---

## 30.3 Executive Dashboard

```http
GET /dashboard/executive
```

### Access

EXECUTIVE_DIRECTOR.

Possible data:

```text
totalBeneficiaries
activeBeneficiaries
totalPrograms
activePrograms
totalCentres
totalVolunteers
activities
attendance
progress
```

---

# 31. Analytics APIs

## 31.1 Organization Analytics

```http
GET /analytics/organization
```

### Access

EXECUTIVE_DIRECTOR only.

Possible metrics:

```text
totalBeneficiaries
activeBeneficiaries
totalPrograms
activePrograms
totalCentres
totalVolunteers
programParticipation
activityStatistics
attendance
progress
```

---

## 31.2 Centre Analytics

```http
GET /analytics/centres/:centreId
```

### Access

- PROGRAM_LEAD: Relevant centre
- EXECUTIVE_DIRECTOR: Full
- VOLUNTEER: Not permitted

---

## 31.3 Program Analytics

```http
GET /analytics/programs/:programId
```

### Access

- PROGRAM_LEAD: Full within scope
- VOLUNTEER: Limited/relevant
- EXECUTIVE_DIRECTOR: Full

---

## 31.4 Beneficiary Analytics

```http
GET /analytics/beneficiaries/:beneficiaryId
```

### Access

Authorized users.

Possible information:

```text
program participation
attendance
progress
timeline milestones
```

Sensitive information must follow field-level authorization.

---

## 31.5 Volunteer Performance

```http
GET /analytics/volunteers/:userId/performance
```

### Access

- PROGRAM_LEAD: Authorized
- VOLUNTEER: Own performance
- EXECUTIVE_DIRECTOR: Read

Possible metrics:

```text
programsSupported
activitiesCompleted
tasksCompleted
beneficiariesSupported
participation
taskCompletionRate
```

Performance should be calculated from actual recorded data rather than manually entered scores unless an approved scoring mechanism exists.

---

# 32. Reporting APIs

## 32.1 List Report Types

```http
GET /reports/types
```

Possible reports:

```text
Beneficiary Report
Program Report
Centre Report
Volunteer Report
Attendance Report
Progress Report
Impact Report
```

---

## 32.2 Generate Report

```http
POST /reports
```

### Access

According to reporting permissions.

### Request

```json
{
  "type": "PROGRAM",
  "programId": "uuid",
  "centreId": null,
  "startDate": "2026-08-01",
  "endDate": "2026-08-31"
}
```

The exact output format can be implemented later.

---

## 32.3 Export Report

```http
GET /reports/:reportId/export
```

### Access

Only users authorized to access the underlying report.

Export formats can be finalized in the reporting implementation.

---

# 33. Audit Log APIs

Audit logs contain sensitive operational information and should not be exposed as a normal unrestricted CRUD resource.

---

## 33.1 List Audit Logs

```http
GET /audit-logs
```

### Access

Authorized users only.

### Query Parameters

```text
page
limit
userId
action
entityType
entityId
startDate
endDate
```

---

## 33.2 Get Audit Log

```http
GET /audit-logs/:auditLogId
```

### Access

Authorized users.

---

# 34. API-to-Database Mapping

| API Resource | PostgreSQL Table |
|---|---|
| users | users |
| centres | centres |
| beneficiaries | beneficiaries |
| programs | programs |
| program-enrollments | program_enrollments |
| activities | activities |
| attendance | attendances |
| volunteer profiles | volunteer_profiles |
| skills | skills |
| volunteer skills | volunteer_skills |
| volunteer assignments | volunteer_assignments |
| tasks | tasks |
| progress records | progress_records |
| timeline events | timeline_events |
| audit logs | audit_logs |

The API must not create duplicate tables for concepts already represented in the database schema.

---

# 35. Transaction Requirements

The backend must use PostgreSQL transactions through `pg` for multi-table operations.

---

## 35.1 Register Beneficiary

Conceptually:

```text
BEGIN
  ↓
Create Beneficiary
  ↓
Create Timeline Event
  ↓
Create Audit Log
  ↓
COMMIT
```

If any operation fails:

```text
ROLLBACK
```

---

## 35.2 Program Enrollment

```text
BEGIN
  ↓
Create Enrollment
  ↓
Create Timeline Event
  ↓
Create Audit Log
  ↓
COMMIT
```

---

## 35.3 Complete Activity

```text
BEGIN
  ↓
Update Activity Status
  ↓
Create Timeline Event where applicable
  ↓
Create Audit Log
  ↓
COMMIT
```

---

# 36. Validation Rules

The API must validate both request shape and business rules.

Important rules include:

```text
email must be unique
beneficiaryId must be unique
beneficiaryId must remain unchanged
beneficiary + program enrollment must not duplicate
activity + beneficiary attendance must not duplicate
volunteer + skill must not duplicate
progress score must be 0–100
enrollment progress must be 0–100
activity end time must be after start time
activity centre must match program centre
assignment volunteer must have role VOLUNTEER
assignment creator must be authorized
task volunteer must have role VOLUNTEER
task creator must be authorized
```

Database constraints remain the final integrity layer.

---

# 37. Resource Ownership and Scope Validation

The backend must never trust IDs supplied by the frontend.

For example:

```http
GET /beneficiaries/:beneficiaryId
```

must not simply query the beneficiary by ID.

It must first establish whether the authenticated user can access that beneficiary.

For a volunteer:

```text
Volunteer
   ↓
Assignment
   ↓
Program / Activity
   ↓
Beneficiary
```

If the relationship does not establish authorization:

```http
403 Forbidden
```

---

# 38. Field-Level Authorization

Beneficiary data contains different sensitivity levels.

A response may include:

```text
Basic Information
Program Information
Attendance
Relevant Progress
```

while restricted case information must not be returned to unauthorized volunteers.

The exact sensitive fields must follow the Data Dictionary and Access Control Matrix.

---

# 39. Delete Policy

Permanent deletion is restricted.

Preferred behavior:

```text
ACTIVE
  ↓
INACTIVE / CLOSED / CANCELLED
```

rather than:

```text
ACTIVE
  ↓
DELETE
```

Beneficiary history must be preserved.

Programs and activities with historical dependent records should normally use controlled status changes.

---

# 40. Automatic Timeline Events

Important system actions should generate timeline events where defined.

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

This reduces duplicate manual timeline entry.

---

# 41. Audit Logging

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
Sensitive Record Accessed
```

Audit records should capture:

```text
user
action
entityType
entityId
timestamp
description
metadata
```

---

# 42. Security Requirements

The backend must:

- Never return `passwordHash`.
- Never expose database credentials.
- Never expose PostgreSQL directly to the frontend.
- Validate all request bodies.
- Validate path/query parameters.
- Enforce authorization on every protected endpoint.
- Apply assignment-based scope checks.
- Avoid SQL injection through parameterized queries.
- Use parameterized PostgreSQL queries through `pg`.
- Avoid trusting client-provided ownership fields.
- Log sensitive access where required.
- Avoid returning sensitive information in error messages.

---

# 43. PostgreSQL Query Requirements

The backend uses `pg` (node-postgres) directly.

Queries must be parameterized.

Example:

```js
const result = await pool.query(
  'SELECT * FROM beneficiaries WHERE id = $1',
  [beneficiaryId]
);
```

Do not build SQL using direct string interpolation with user input.

For multi-step writes:

```js
const client = await pool.connect();

try {
  await client.query('BEGIN');

  // related SQL operations

  await client.query('COMMIT');
} catch (error) {
  await client.query('ROLLBACK');
  throw error;
} finally {
  client.release();
}
```

---

# 44. API Route Organization

Recommended Express route structure:

```text
routes/
├── auth.routes.js
├── users.routes.js
├── centres.routes.js
├── beneficiaries.routes.js
├── programs.routes.js
├── enrollments.routes.js
├── activities.routes.js
├── attendance.routes.js
├── volunteers.routes.js
├── volunteerAssignments.routes.js
├── skills.routes.js
├── tasks.routes.js
├── progress.routes.js
├── timeline.routes.js
├── analytics.routes.js
├── reports.routes.js
└── auditLogs.routes.js
```

The exact source-code structure may be refined in the backend architecture document without changing the API contract.

---

# 45. Middleware Responsibilities

Recommended middleware responsibilities:

```text
request
  ↓
authentication middleware
  ↓
authorization middleware
  ↓
validation middleware
  ↓
controller
  ↓
service/business logic
  ↓
PostgreSQL (`pg`)
```

Authorization middleware must not replace resource-level scope checks where an endpoint requires checking relationships.

---

# 46. API Error Codes

Recommended application error codes:

```text
VALIDATION_ERROR
AUTHENTICATION_REQUIRED
INVALID_CREDENTIALS
FORBIDDEN
RESOURCE_NOT_FOUND
DUPLICATE_RESOURCE
DUPLICATE_ENROLLMENT
DUPLICATE_ATTENDANCE
INVALID_STATUS
INVALID_TRANSITION
INVALID_SCOPE
CENTRE_MISMATCH
PROGRAM_MISMATCH
INVALID_ROLE
DATABASE_ERROR
INTERNAL_ERROR
```

The exact set may be extended as implementation requires.

---

# 47. Not Found Behavior

If a requested resource does not exist:

```http
404 Not Found
```

Example:

```json
{
  "success": false,
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Beneficiary not found"
  }
}
```

For unauthorized access, the backend must not expose unnecessary information about restricted resources.

---

# 48. Conflict Behavior

Use:

```http
409 Conflict
```

when the requested operation violates a uniqueness rule.

Examples:

```text
Duplicate beneficiaryId
Duplicate program enrollment
Duplicate attendance
Duplicate volunteer skill
```

---

# 49. End-to-End Core Workflow

The API must support this complete journey:

```text
PROGRAM LEAD
     ↓
Create Program
     ↓
Create Activity
     ↓
Register Beneficiary
     ↓
Generate Unique Beneficiary ID
     ↓
Enroll Beneficiary
     ↓
Assign Volunteer
     ↓
Assign Task
     ↓
Conduct Activity
     ↓
Record Attendance
     ↓
Record Progress
     ↓
Update Timeline
     ↓
Analytics
     ↓
Program / Organization Dashboard
```

This matches the core workflow defined in the User Flows document.

---

# 50. API Development Rules

AI coding agents and developers must:

1. Follow this API specification.
2. Follow `ACCESS_CONTROL_MATRIX.md` for authorization.
3. Follow `DATA_DICTIONARY.md` for API field names and enum values.
4. Follow `DATABASE_SCHEMA.md` for database relationships and constraints.
5. Follow `USER_FLOWS.md` for workflow behavior.
6. Use PostgreSQL through `pg` (node-postgres).
7. Use parameterized SQL queries.
8. Use PostgreSQL transactions for multi-table operations.
9. Never expose `passwordHash`.
10. Never trust client-provided ownership fields.
11. Never bypass role and scope checks.
12. Never create duplicate database concepts.
13. Preserve the persistent beneficiary ID.
14. Preserve auditability.
15. Keep API responses independent from direct database access.

---

# 51. API Contract Summary

```text
Authentication
├── POST   /auth/login
├── POST   /auth/logout
└── GET    /auth/me

Centres
├── GET    /centres
├── GET    /centres/:centreId
└── GET    /centres/:centreId/analytics

Beneficiaries
├── GET    /beneficiaries
├── POST   /beneficiaries
├── GET    /beneficiaries/:beneficiaryId
├── PATCH  /beneficiaries/:beneficiaryId
└── GET    /beneficiaries/:beneficiaryId/timeline

Programs
├── GET    /programs
├── POST   /programs
├── GET    /programs/:programId
├── PATCH  /programs/:programId
├── PATCH  /programs/:programId/status
├── GET    /programs/:programId/beneficiaries
├── GET    /programs/:programId/activities
├── GET    /programs/:programId/volunteers
└── GET    /programs/:programId/analytics

Program Enrollments
├── GET    /program-enrollments
├── POST   /program-enrollments
├── GET    /program-enrollments/:enrollmentId
└── PATCH  /program-enrollments/:enrollmentId

Activities
├── GET    /activities
├── POST   /activities
├── GET    /activities/:activityId
├── PATCH  /activities/:activityId
├── PATCH  /activities/:activityId/status
├── GET    /activities/:activityId/participants
└── GET    /activities/:activityId/attendance

Attendance
├── POST   /activities/:activityId/attendance
└── PATCH  /attendance/:attendanceId

Volunteers
├── GET    /volunteers
├── GET    /volunteers/:userId
├── PATCH  /volunteers/me
├── GET    /volunteers/:userId/skills
└── POST   /volunteers/:userId/skills

Volunteer Assignments
├── GET    /volunteer-assignments
├── POST   /volunteer-assignments
├── GET    /volunteer-assignments/:assignmentId
└── PATCH  /volunteer-assignments/:assignmentId

Skills
└── GET    /skills

Tasks
├── GET    /tasks
├── POST   /tasks
├── GET    /tasks/:taskId
├── PATCH  /tasks/:taskId
└── PATCH  /tasks/:taskId/status

Progress
├── GET    /progress-records
├── POST   /progress-records
├── GET    /progress-records/:progressRecordId
└── PATCH  /progress-records/:progressRecordId

Timeline
├── GET    /timeline-events
├── POST   /timeline-events
└── GET    /timeline-events/:eventId

Dashboards
├── GET    /dashboard/program-lead
├── GET    /dashboard/volunteer
└── GET    /dashboard/executive

Analytics
├── GET    /analytics/organization
├── GET    /analytics/centres/:centreId
├── GET    /analytics/programs/:programId
├── GET    /analytics/beneficiaries/:beneficiaryId
└── GET    /analytics/volunteers/:userId/performance

Reports
├── GET    /reports/types
├── POST   /reports
└── GET    /reports/:reportId/export

Audit Logs
├── GET    /audit-logs
└── GET    /audit-logs/:auditLogId
```

---

# 52. Final API Architecture

```text
┌──────────────────────────┐
│      React Frontend      │
└────────────┬─────────────┘
             │
             │ REST / JSON
             ▼
┌──────────────────────────┐
│    Node.js + Express     │
├──────────────────────────┤
│ Authentication           │
│ Authorization            │
│ Validation               │
│ Controllers              │
│ Services                 │
└────────────┬─────────────┘
             │
             │ Parameterized SQL
             │ + Transactions
             ▼
┌──────────────────────────┐
│      pg / node-postgres  │
└────────────┬─────────────┘
             │
             ▼
┌──────────────────────────┐
│       PostgreSQL         │
├──────────────────────────┤
│ Referential Integrity    │
│ Constraints              │
│ Transactions             │
│ Indexes                  │
│ Analytics Queries        │
└──────────────────────────┘
```

This document defines the API layer without introducing an ORM and keeps the API contract aligned with the PostgreSQL database, existing user workflows, data dictionary, and access-control rules.
