# USER_FLOWS.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Draft  
**Parent Document:** `PRD.md`

---

# 1. Purpose

This document defines the step-by-step workflows for every major user role in the Purnata platform.

It acts as the bridge between:

```text
Business Requirements
        ↓
User Actions
        ↓
Frontend Screens
        ↓
API Operations
        ↓
Database Operations
```

Both frontend and backend developers/AI agents must use this document when implementing workflows.

---

# 2. User Roles

The platform initially contains three primary roles:

```text
1. PROGRAM_LEAD
2. VOLUNTEER
3. EXECUTIVE_DIRECTOR
```

---

# 3. High-Level System Flow

```text
                         ┌──────────────────┐
                         │      LOGIN       │
                         └────────┬─────────┘
                                  │
                         Authenticate User
                                  │
                    ┌─────────────┼─────────────┐
                    │             │             │
                    ▼             ▼             ▼
             PROGRAM LEAD     VOLUNTEER    EXECUTIVE DIRECTOR
                    │             │             │
                    ▼             ▼             ▼
              Operations      Assigned Work   Analytics
                    │             │             │
                    └─────────────┼─────────────┘
                                  ▼
                         Centralized Platform
```

---

# 4. Authentication Flow

## 4.1 Login

```text
User
 ↓
Open Login Page
 ↓
Enter Email/Username
 ↓
Enter Password
 ↓
Submit
 ↓
Backend validates credentials
 ↓
Credentials valid?
 ├── NO → Return authentication error
 │         ↓
 │       Stay on Login Page
 │
 └── YES
       ↓
     Identify User Role
       ↓
     Create authenticated session/token
       ↓
     Redirect according to role
```

---

# 5. Program Lead / Manager Flow

The Program Lead is the primary operational user.

The Program Lead manages programs, beneficiaries, activities, volunteers, assignments, and operational analytics.

---

# 6. Program Lead Dashboard Flow

```text
Login
 ↓
Authentication
 ↓
Role = PROGRAM_LEAD
 ↓
Program Lead Dashboard
```

The dashboard should provide access to:

```text
Programs
Beneficiaries
Activities
Volunteers
Tasks
Attendance
Timelines
Analytics
```

The dashboard may also display:

- Active programs
- Total beneficiaries
- Upcoming activities
- Volunteer assignments
- Pending tasks
- Recent activity
- Program progress

---

# 7. Create Program Flow

```text
Program Lead Dashboard
 ↓
Programs
 ↓
Create Program
 ↓
Enter Program Details
 ↓
Validate Input
 ↓
Submit
 ↓
Backend creates Program
 ↓
Program ID generated
 ↓
Program appears in Program List
 ↓
Program Lead can manage the program
```

## Required conceptual information

```text
Program
├── Name
├── Description
├── Centre
├── Category
├── Start Date
├── End Date
├── Status
└── Objectives
```

---

# 8. Manage Program Flow

```text
Program Lead
 ↓
Programs
 ↓
Select Program
 ↓
Program Details
```

From the program details page:

```text
 ├── Edit Program
 ├── View Beneficiaries
 ├── Enroll Beneficiary
 ├── View Activities
 ├── Create Activity
 ├── Assign Volunteers
 ├── Manage Tasks
 ├── View Attendance
 ├── View Timeline
 └── View Analytics
```

---

# 9. Register Beneficiary Flow

This is one of the most important workflows.

```text
Program Lead
 ↓
Beneficiaries
 ↓
Register Beneficiary
 ↓
Enter Beneficiary Information
 ↓
Validate Information
 ↓
Check for Existing Beneficiary
```

### If existing beneficiary is found

```text
Existing Beneficiary
 ↓
Display existing record
 ↓
Use existing Beneficiary ID
 ↓
Do NOT create duplicate beneficiary
```

### If no existing beneficiary is found

```text
No Existing Beneficiary
 ↓
Create Beneficiary
 ↓
Generate Unique Beneficiary ID
 ↓
Create Beneficiary Profile
 ↓
Display Beneficiary ID
```

---

# 10. Beneficiary Unique ID Flow

Every beneficiary must have one persistent unique ID.

```text
Register Beneficiary
        ↓
Create Beneficiary Record
        ↓
Generate Unique ID
        ↓
Store ID
        ↓
Return ID to Frontend
        ↓
Display ID
```

Example:

```text
BEN-000001
```

The same ID must be used if the beneficiary participates in multiple programs.

---

# 11. Enroll Beneficiary Into Program

A beneficiary and a program must not be treated as the same entity.

The relationship should conceptually be:

```text
Beneficiary
      │
      │
      ▼
Program Enrollment
      │
      ▼
Program
```

Flow:

```text
Program Lead
 ↓
Open Program
 ↓
Enroll Beneficiary
 ↓
Search Beneficiary
 ↓
Select Beneficiary
 ↓
Enter Enrollment Information
 ↓
Submit
 ↓
Create Program Enrollment
 ↓
Beneficiary becomes associated with Program
```

If the beneficiary is already enrolled:

```text
Already Enrolled
 ↓
Show existing enrollment
 ↓
Do not create duplicate enrollment
```

---

# 12. Create Activity Flow

```text
Program Lead
 ↓
Open Program
 ↓
Activities
 ↓
Create Activity
 ↓
Enter Activity Details
 ↓
Select Date/Time
 ↓
Select Participants
 ↓
Assign Volunteers
 ↓
Validate
 ↓
Create Activity
 ↓
Activity appears in Program Timeline
```

---

# 13. Activity Management Flow

```text
Program
 ↓
Activity
 ↓
Activity Details
```

Possible actions:

```text
 ├── View Activity
 ├── Edit Activity
 ├── Assign Volunteers
 ├── View Participants
 ├── Record Attendance
 ├── Add Outcome/Notes
 └── Mark Activity Complete
```

---

# 14. Volunteer Management Flow

```text
Program Lead
 ↓
Volunteers
 ↓
View Volunteers
 ↓
Select Volunteer
```

Program Lead can:

```text
 ├── View Volunteer Profile
 ├── View Skills
 ├── View Availability
 ├── Assign Program
 ├── Assign Activity
 ├── Assign Task
 └── View Performance
```

---

# 15. Assign Volunteer To Program

```text
Program Lead
 ↓
Open Program
 ↓
Volunteers
 ↓
Assign Volunteer
 ↓
Search/Select Volunteer
 ↓
Review Volunteer Information
 ↓
Confirm Assignment
 ↓
Create Volunteer Assignment
 ↓
Volunteer sees Program in Dashboard
```

---

# 16. Assign Volunteer To Activity

```text
Program Lead
 ↓
Open Activity
 ↓
Assign Volunteer
 ↓
Select Volunteer
 ↓
Confirm
 ↓
Create Activity Assignment
 ↓
Volunteer sees Activity
```

---

# 17. Assign Task To Volunteer

```text
Program Lead
 ↓
Tasks
 ↓
Create Task
 ↓
Select Volunteer
 ↓
Select Program/Activity
 ↓
Enter Task Details
 ↓
Set Due Date/Priority
 ↓
Create Task
 ↓
Volunteer receives task
```

Task lifecycle:

```text
ASSIGNED
   ↓
IN_PROGRESS
   ↓
COMPLETED
```

Alternative:

```text
ASSIGNED
   ↓
CANCELLED
```

---

# 18. Beneficiary Timeline Flow

The beneficiary timeline represents the long-term journey of the beneficiary.

```text
Program Lead
 ↓
Beneficiaries
 ↓
Search Beneficiary
 ↓
Open Beneficiary Profile
 ↓
View Timeline
```

Timeline may contain:

```text
Initial Outreach
       ↓
Risk Identification
       ↓
Rescue / Registration
       ↓
Rehabilitation
       ↓
Program Enrollment
       ↓
Activities
       ↓
Attendance
       ↓
Interventions
       ↓
Progress Milestones
       ↓
Reintegration
       ↓
Long-Term Follow-up
```

Every timeline event should contain, where applicable:

```text
Event
Date
Program
Activity
Recorded By
Description
```

---

# 19. Attendance Flow

Attendance is generally recorded against an activity/session.

```text
Program Lead / Authorized Volunteer
 ↓
Open Activity
 ↓
View Participants
 ↓
Record Attendance
 ↓
Select Status
 ↓
Submit
 ↓
Attendance Saved
```

Possible statuses:

```text
PRESENT
ABSENT
EXCUSED
```

---

# 20. Program Lead Analytics Flow

```text
Program Lead
 ↓
Analytics
 ↓
Select Scope
```

Possible scopes:

```text
Program
Centre
Beneficiary
Volunteer
Activity
```

Example:

```text
Program Analytics
 ↓
Total Beneficiaries
 ↓
Active Beneficiaries
 ↓
Activities
 ↓
Attendance
 ↓
Volunteer Participation
 ↓
Progress
```

---

# 21. Volunteer Flow

# 21.1 Volunteer Dashboard

```text
Login
 ↓
Authentication
 ↓
Role = VOLUNTEER
 ↓
Volunteer Dashboard
```

Dashboard should show:

```text
Assigned Programs
Assigned Beneficiaries
Upcoming Activities
Assigned Tasks
Pending Tasks
Recent Activities
```

---

# 22. View Assigned Programs

```text
Volunteer Dashboard
 ↓
My Programs
 ↓
Select Program
 ↓
Program Details
```

Volunteer can see information necessary for their assigned work.

---

# 23. View Assigned Beneficiaries

```text
Volunteer Dashboard
 ↓
My Beneficiaries
 ↓
Select Program
 ↓
View Assigned Beneficiaries
 ↓
Select Beneficiary
 ↓
Beneficiary Information
```

The volunteer should only receive beneficiary information permitted by the access-control rules.

---

# 24. View Beneficiary Timeline — Volunteer

```text
Volunteer
 ↓
Assigned Beneficiary
 ↓
View Timeline
```

The timeline displayed to a volunteer must be filtered according to their permissions.

Sensitive or unrelated information must not be exposed.

---

# 25. Volunteer Activity Flow

```text
Volunteer Dashboard
 ↓
My Activities
 ↓
Select Activity
 ↓
View Activity Details
 ↓
Conduct Activity
 ↓
Record Required Information
 ↓
Record Attendance
 ↓
Add Activity Notes/Outcome
 ↓
Submit
 ↓
Activity Information Saved
```

---

# 26. Volunteer Task Flow

```text
Volunteer Dashboard
 ↓
My Tasks
 ↓
Select Task
 ↓
View Task Details
 ↓
Start Task
 ↓
Status = IN_PROGRESS
 ↓
Perform Task
 ↓
Submit Completion
 ↓
Status = COMPLETED
```

---

# 27. Volunteer Performance Flow

```text
Volunteer
 ↓
My Performance
 ↓
View Performance Analytics
```

Possible information:

```text
Programs Supported
Activities Completed
Tasks Completed
Beneficiaries Supported
Participation
```

The system should calculate performance from actual recorded activity/task data rather than manually entered scores unless a scoring mechanism is explicitly approved.

---

# 28. Executive Director Flow

# 28.1 Executive Dashboard

```text
Login
 ↓
Authentication
 ↓
Role = EXECUTIVE_DIRECTOR
 ↓
Executive Dashboard
```

The Executive Director primarily consumes aggregated organizational information rather than performing frontline operational tasks.

---

# 29. Organization-Wide Analytics Flow

```text
Executive Dashboard
 ↓
Overall Analytics
```

Display relevant KPIs such as:

```text
Total Beneficiaries
Active Beneficiaries
Total Programs
Active Programs
Total Centres
Total Volunteers
Activities
Attendance
Progress
```

---

# 30. Centre-Wise Analytics Flow

```text
Executive Dashboard
 ↓
Centre Analytics
 ↓
Select Centre
 ↓
View Centre Performance
```

Possible metrics:

```text
Beneficiaries
Programs
Activities
Attendance
Volunteer Participation
Progress
```

The Executive Director should be able to compare centres where appropriate.

---

# 31. Program-Wise Analytics Flow

```text
Executive Dashboard
 ↓
Program Analytics
 ↓
Select Program
 ↓
View Program Performance
```

Possible metrics:

```text
Beneficiaries
Enrollments
Activities
Attendance
Volunteers
Progress
Completion
```

---

# 32. Beneficiary Journey Overview — Executive Director

```text
Executive Dashboard
 ↓
Beneficiary Journey
 ↓
Search Beneficiary / Select Beneficiary
 ↓
View Authorized Journey Overview
```

The Executive Director should receive a suitable high-level view of the beneficiary journey.

Sensitive information should follow the access-control matrix.

---

# 33. Reporting Flow

```text
Executive Director / Authorized User
 ↓
Reports
 ↓
Select Report Type
 ↓
Select Date / Centre / Program Filters
 ↓
Generate Report
 ↓
System aggregates data
 ↓
Display Report
 ↓
Optional Export
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

# 34. Complete End-to-End Business Flow

The core system should support the following complete journey:

```text
                    PROGRAM LEAD
                         │
                         ▼
                  Create Program
                         │
                         ▼
                  Create Activity
                         │
                         ▼
                Register Beneficiary
                         │
                         ▼
               Generate Unique ID
                         │
                         ▼
             Enroll Beneficiary
                         │
                         ▼
                Assign Volunteer
                         │
                         ▼
                  Assign Tasks
                         │
                         ▼
                  Conduct Activity
                         │
                         ▼
                Record Attendance
                         │
                         ▼
              Record Progress
                         │
                         ▼
               Update Timeline
                         │
                         ▼
                  Analytics
                         │
            ┌────────────┴────────────┐
            ▼                         ▼
     Program Manager          Executive Director
       Analytics              Organization Analytics
```

---

# 35. Data Flow Principle

The same underlying data must power all dashboards.

For example:

```text
Activity
   │
   ├── Attendance
   │
   ├── Volunteers
   │
   └── Beneficiaries
          │
          ▼
      Progress
          │
          ▼
      Analytics
```

The frontend must not maintain independent copies of business data merely for visualization.

---

# 36. Error Handling Principles

Every workflow must define:

```text
Success
Validation Error
Authentication Error
Authorization Error
Not Found
Conflict / Duplicate
Server Error
```

Example:

```text
Register Beneficiary
       ↓
Validation
       │
       ├── Invalid → Show field errors
       │
       ├── Duplicate → Show existing beneficiary
       │
       └── Valid
             ↓
         Create Record
             │
             ├── Failure → Show server error
             │
             └── Success → Show Beneficiary ID
```

---

# 37. Authorization Principle

Authorization must be enforced on the backend.

The frontend may hide unavailable actions, but this must never be considered sufficient security.

Example:

```text
Volunteer requests another program's beneficiary
                 ↓
Backend checks authorization
                 ↓
Not authorized
                 ↓
403 Forbidden
```

---

# 38. Frontend Implementation Rule

Every major flow should correspond to identifiable UI screens/components.

Example:

```text
USER FLOW
    ↓
SCREEN
    ↓
COMPONENT
    ↓
API CALL
```

Example:

```text
Register Beneficiary
        ↓
RegisterBeneficiaryPage
        ↓
BeneficiaryForm
        ↓
POST /beneficiaries
```

The exact endpoint names must be defined later in `API_SPECIFICATION.md`.

---

# 39. Backend Implementation Rule

Every workflow must have clearly defined:

```text
Route
 ↓
Authentication
 ↓
Authorization
 ↓
Validation
 ↓
Business Logic
 ↓
Database Operation
 ↓
Response
```

Example:

```text
POST /beneficiaries
        ↓
Authenticate
        ↓
Check PROGRAM_LEAD permission
        ↓
Validate fields
        ↓
Check duplicate
        ↓
Generate unique ID
        ↓
Create beneficiary
        ↓
Return created beneficiary
```

---

# 40. AI Agent Rules

Before implementing any workflow, AI agents must identify:

1. User role
2. Starting screen
3. User action
4. Required data
5. Validation rules
6. API operation
7. Authorization requirement
8. Database operation
9. Success response
10. Error responses
11. Next screen/state

Agents must not invent missing business rules.

If a workflow requires an undefined decision, the agent should flag it as an **Open Question** rather than silently choosing a behavior.

---

# 41. Workflow-to-Document Dependencies

This document should be used together with:

```text
PRD.md
      ↓
USER_FLOWS.md
      ↓
ACCESS_CONTROL_MATRIX.md
      ↓
DATA_DICTIONARY.md
      ↓
DATABASE_SCHEMA.md
      ↓
API_SPECIFICATION.md
      ↓
FRONTEND_SPECIFICATION.md
      ↓
BACKEND_SPECIFICATION.md
```

---

# 42. Current Workflow Priority

The following workflows are considered highest priority for MVP:

```text
P0 — Critical

1. Login
2. Role-based redirection
3. Create Program
4. Register Beneficiary
5. Generate Beneficiary ID
6. Enroll Beneficiary
7. Create Activity
8. Assign Volunteer
9. Assign Task
10. Record Attendance
11. View Beneficiary Timeline
12. Program Analytics
13. Executive Analytics
```

```text
P1 — Important

14. Volunteer Performance
15. Centre Analytics
16. Reports
17. Advanced filtering
18. Activity outcomes
```

---

# 43. Key Business Rule

The most important relationship in the platform is:

```text
ONE BENEFICIARY
      │
      ├──────── Program A
      │
      ├──────── Program B
      │
      ├──────── Program C
      │
      └──────── Program D
```

NOT:

```text
Program A → Beneficiary Copy 1
Program B → Beneficiary Copy 2
Program C → Beneficiary Copy 3
```

All programs must reference the same beneficiary identity.

This ensures continuity of the beneficiary's multi-year journey and prevents fragmented case histories.

---

# 44. Definition of Complete Workflow

A workflow is considered implementation-ready only when the following are defined:

```text
✓ User Role
✓ User Goal
✓ Starting Screen
✓ User Actions
✓ Required Inputs
✓ Validation
✓ Authorization
✓ API Operation
✓ Database Operation
✓ Success State
✓ Error States
✓ Next State
```

If any of these are missing for a critical workflow, the workflow should be considered incomplete until clarified.