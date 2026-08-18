# FRONTEND_SPECIFICATION.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Specification  
**Parent Documents:** `PRD.md`, `USER_FLOWS.md`, `ACCESS_CONTROL_MATRIX.md`, `DATA_DICTIONARY.md`, `API_SPECIFICATION.md`, `TECHNICAL_ARCHITECTURE.md`, `VALIDATION_RULES.md`, `ANALYTICS_SPECIFICATION.md`, `AUTHENTICATION_AUTHORIZATION.md`

---

# 1. Purpose

This document defines the frontend requirements for the Purnata web application.

The frontend must provide a secure, accessible, role-aware interface for:

- Beneficiary management
- Program management
- Activity management
- Attendance
- Volunteer coordination
- Tasks
- Progress tracking
- Beneficiary timelines
- Analytics
- Reports
- Authentication

The PRD describes Purnata as a centralized platform for beneficiary records, program participation, attendance, progress, volunteer assignments, timelines, and organizational analytics. fileciteturn7file1L186-L202

---

# 2. Frontend Goals

The frontend should:

1. Make operational workflows simple.
2. Reduce manual data entry.
3. Present role-appropriate information.
4. Protect sensitive information through appropriate UI restrictions.
5. Provide clear feedback for loading, success, validation, and errors.
6. Provide dashboards that summarize operational information.
7. Provide accessible forms and navigation.
8. Consume the backend API rather than accessing PostgreSQL directly.
9. Keep API field names consistent with the Data Dictionary.
10. Avoid implementing business rules independently from the backend.

---

# 3. Frontend Architecture

Recommended architecture:

```text
React Application
       │
       ├── Routing
       ├── Authentication State
       ├── Role / Permission UI
       ├── Pages
       ├── Reusable Components
       ├── Forms
       ├── API Client
       └── UI State
              │
              ▼
         Express REST API
              │
              ▼
          PostgreSQL
```

The frontend must never connect directly to PostgreSQL.

---

# 4. Technology Boundary

The frontend is responsible for:

```text
UI
Routing
Form interaction
Client-side validation
Presentation
Loading/error states
Authenticated UI state
API consumption
```

The backend is responsible for:

```text
Authentication
Authorization
Business rules
Data validation
Scope enforcement
Sensitive-data protection
Database access
Audit logging
Analytics calculation
```

Frontend restrictions are not a security boundary. The Access Control Matrix explicitly states that backend permissions must be enforced and frontend restrictions are only for user experience. fileciteturn7file0L21-L29

---

# 5. Frontend Data Contract

The Data Dictionary is the shared data contract for:

```text
Frontend
Backend
Database
API
Analytics
Testing
AI coding agents
```

All frontend code must use its field names, types, relationships, and enum values. fileciteturn7file9L1552-L1566

API/frontend field names use:

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

fileciteturn7file9L1668-L1686

---

# 6. Supported Roles

The MVP contains:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

These are the only roles that should be assumed by the frontend unless an approved requirement introduces another role. fileciteturn7file0L33-L41

---

# 7. Application Entry Flow

```text
Application
    ↓
Check Authentication State
    │
    ├── Not Authenticated
    │       ↓
    │      Login
    │
    └── Authenticated
            ↓
          Load User
            ↓
          Identify Role
            ↓
       Role Dashboard
```

---

# 8. Route Structure

A conceptual route structure is:

```text
/
├── login
├── dashboard
│
├── programs
│   ├── list
│   ├── create
│   ├── details
│   └── edit
│
├── beneficiaries
│   ├── list
│   ├── register
│   ├── details
│   └── edit
│
├── activities
│   ├── list
│   ├── create
│   ├── details
│   └── edit
│
├── volunteers
│   ├── list
│   └── details
│
├── tasks
│   ├── list
│   └── details
│
├── analytics
│   ├── program
│   ├── centre
│   └── organization
│
├── reports
│
└── audit-logs
```

These routes are a frontend organization proposal. Exact URLs should remain synchronized with the final API/UI routing design.

---

# 9. Protected Routes

Protected application routes require authentication.

Conceptually:

```text
ProtectedRoute
      ↓
Authenticated?
   ├── NO → /login
   └── YES
          ↓
       Continue
```

Role restrictions must also be applied where required.

Example:

```text
Organization Analytics
        ↓
EXECUTIVE_DIRECTOR
```

A route guard improves UX but does not replace backend authorization.

---

# 10. Role-Based Navigation

The frontend should show navigation appropriate to the authenticated role.

The Access Control Matrix provides these role-oriented navigation examples. fileciteturn7file2L514-L551

## Program Lead

```text
Dashboard
Programs
Beneficiaries
Activities
Volunteers
Tasks
Analytics
Reports
```

## Volunteer

```text
Dashboard
My Programs
My Beneficiaries
My Activities
My Tasks
My Performance
```

## Executive Director

```text
Dashboard
Organization Analytics
Centre Analytics
Program Analytics
Beneficiary Journey
Reports
```

---

# 11. Navigation Rule

Navigation visibility should follow:

```text
Authenticated User
       ↓
Role
       ↓
Permitted UI
```

Hidden navigation does not mean the backend should trust the client.

If a user manually navigates to an unauthorized URL:

```text
Frontend route guard
        ↓
Unauthorized page/message
```

and the backend must independently reject unauthorized API calls.

---

# 12. Common Application Layout

Recommended authenticated layout:

```text
┌─────────────────────────────────────────────┐
│ Header / User Menu                          │
├───────────────┬─────────────────────────────┤
│ Sidebar       │ Main Content                │
│               │                             │
│ Navigation    │ Page                        │
│               │                             │
│               │                             │
└───────────────┴─────────────────────────────┘
```

The layout should remain consistent across role dashboards.

---

# 13. Header

The authenticated header may contain:

```text
Purnata
Current page/context
Authenticated user's name
Role
Logout
```

Do not display sensitive account information unnecessarily.

---

# 14. Sidebar

The sidebar should:

- Show role-appropriate navigation.
- Highlight the current section.
- Support keyboard navigation.
- Remain usable on smaller screens.
- Avoid showing unavailable administrative functionality.

---

# 15. Login Page

The login page should contain:

```text
Email
Password
Login button
Authentication error area
Loading state
```

Conceptual flow:

```text
Enter credentials
       ↓
Submit
       ↓
Loading
       ↓
API authentication
       ↓
Success → Dashboard
Failure → Error message
```

The PRD requires Login and Logout as authentication functionality. fileciteturn7file4L886-L912

---

# 16. Login Validation

Frontend validation should check:

```text
email required
email format
password required
```

The backend must perform the authoritative validation.

The frontend must not expose whether an account exists through custom client-side behavior.

---

# 17. Logout

Logout should:

```text
Clear authenticated UI state
Call server logout if required by auth mechanism
Remove/expire client auth state according to the selected strategy
Redirect to /login
```

The exact token/session handling follows `AUTHENTICATION_AUTHORIZATION.md`.

---

# 18. Dashboard Design

Dashboards should summarize information rather than require users to manually compile reports.

The Access Control Matrix explicitly describes dashboards as aggregating information for operational users. fileciteturn7file2L325-L343

Dashboard structure:

```text
Page Header
    ↓
KPI Cards
    ↓
Charts / Progress
    ↓
Recent / Upcoming Items
    ↓
Tasks / Alerts
```

---

# 19. Program Lead Dashboard

The Program Lead dashboard should provide:

```text
Total Programs
Active Programs
Total Beneficiaries
Active Beneficiaries
Total Volunteers
Upcoming Activities
Recent Activities
Program Progress
Beneficiary Progress
Relevant Alerts/Tasks
```

These dashboard requirements are defined in the PRD. fileciteturn7file4L918-L933

---

# 20. Program Lead Dashboard Components

Recommended:

```text
ProgramKpiCards
BeneficiaryKpiCards
VolunteerKpiCard
UpcomingActivities
RecentActivities
ProgramProgress
BeneficiaryProgress
TaskAlerts
```

Each component should consume data from the approved dashboard/analytics API.

---

# 21. Volunteer Dashboard

The Volunteer dashboard should focus on assigned work.

Possible sections:

```text
My Programs
My Beneficiaries
My Activities
My Tasks
Upcoming Activities
Recent Activity
My Performance
Relevant Progress
```

These correspond to the Volunteer responsibilities defined by the PRD. fileciteturn7file1L299-L314

---

# 22. Executive Director Dashboard

The Executive Director dashboard should focus on organizational oversight.

Possible sections:

```text
Organization KPIs
Centre Comparison
Program Comparison
Beneficiary Journey Overview
Program Performance
Impact/Progress Visualization
Reports
```

The Executive Director's responsibilities include organization, centre, and program analytics, beneficiary timelines, reports, and organizational impact review. fileciteturn7file4L840-L855

---

# 23. KPI Cards

KPI cards should contain:

```text
Metric Name
Current Value
Optional comparison/trend
```

Example:

```text
┌────────────────────┐
│ Active Programs    │
│ 12                 │
└────────────────────┘
```

Metrics must use the definitions from `ANALYTICS_SPECIFICATION.md`.

---

# 24. Loading States

Every data-dependent page should define a loading state.

Recommended:

```text
Skeleton
Spinner
Loading text
```

Avoid rendering misleading empty values while data is still loading.

---

# 25. Empty States

If no records exist:

```text
No programs found.
No assigned beneficiaries.
No upcoming activities.
No tasks found.
```

Empty states should provide an appropriate next action where the user has permission.

Example:

```text
No programs yet.
[Create Program]
```

Only show creation actions when permitted.

---

# 26. Error States

API errors should be presented clearly.

Examples:

```text
Unable to load programs.
Unable to save beneficiary.
You do not have permission to perform this action.
Your session has expired. Please log in again.
```

Do not expose:

```text
SQL errors
stack traces
database credentials
internal server details
sensitive record information
```

---

# 27. Unauthorized UI

For a `403 Forbidden` response, the UI should show a clear authorization message.

Example:

```text
You do not have permission to perform this action.
```

The Access Control Matrix explicitly recommends this behavior and requires that sensitive information not be revealed. fileciteturn7file3L571-L593

---

# 28. Beneficiary List

The beneficiary list should support authorized users with:

```text
Search
Filters
Pagination
Beneficiary ID
Name/display identity fields
Program/context
Status where permitted
Actions
```

Search must respect authorization scope.

Program Leads can search beneficiaries within their authorized operational scope, while Volunteers must not receive unrestricted global beneficiary search. fileciteturn7file2L361-L403

---

# 29. Beneficiary Registration

The Program Lead should be able to register a beneficiary.

Conceptual flow:

```text
Beneficiary List
      ↓
Register Beneficiary
      ↓
Form
      ↓
Validation
      ↓
Submit
      ↓
API
      ↓
Success
      ↓
Beneficiary Profile
```

The PRD identifies beneficiary registration and unique-ID generation as Program Lead responsibilities. fileciteturn7file1L278-L295

---

# 30. Beneficiary Unique ID

The frontend should display the persistent unique beneficiary ID where the role is authorized to view it.

Rules:

```text
Program Lead → Generate/View
Volunteer → View assigned
Executive Director → View
```

The ID must not be regenerated when the beneficiary joins another program. fileciteturn7file6L1209-L1240

The frontend should treat the ID as read-only after creation.

---

# 31. Beneficiary Profile

The profile should organize authorized information into logical sections:

```text
Identity
Contact / Basic Information
Program Enrollment
Attendance
Progress
Timeline
Intervention History
```

Sensitive fields must only be rendered when returned by the authorized API.

Do not hard-code sensitive-field access solely in the UI.

---

# 32. Beneficiary Edit

Program Lead:

```text
Edit permitted beneficiary information
```

Volunteer:

```text
Limited update only
```

Executive Director:

```text
Read/analytics-oriented access
```

The exact Volunteer editable fields remain an open authorization decision and must not be invented. fileciteturn7file6L1172-L1189

---

# 33. Beneficiary Timeline UI

Recommended layout:

```text
Beneficiary Journey
│
├── Registration
├── Program Enrollment
├── Activity
├── Progress Milestone
├── Rehabilitation
├── Reintegration
└── Follow-up
```

Timeline events should be presented chronologically.

The Data Dictionary defines timeline event types including `OUTREACH`, `REGISTRATION`, `PROGRAM_ENROLLMENT`, `ACTIVITY`, `PROGRESS_MILESTONE`, `REINTEGRATION`, and `FOLLOW_UP`. fileciteturn7file7L1399-L1437

---

# 34. Progress UI

Progress can be displayed using:

```text
Progress cards
Progress bars
Category breakdown
Milestone timeline
Trend chart
```

Progress categories include:

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

The Data Dictionary defines a progress score range of `0–100` and its interpretation bands. fileciteturn7file7L1338-L1395

---

# 35. Progress Form

A progress record form should contain the fields defined by the data contract:

```text
Program
Activity (when applicable)
Category
Title
Description
Score
```

The backend supplies:

```text
beneficiaryId
recordedBy
recordedAt
```

where appropriate.

The frontend must not allow the user to impersonate another recorder.

---

# 36. Program List

Program Lead view:

```text
Programs
├── Search
├── Filters
├── Status
├── Create Program
└── Program rows/cards
```

Volunteer view:

```text
My Programs
└── Assigned programs only
```

Executive Director:

```text
Programs
└── Authorized organizational view
```

This follows the role permissions defined in the Access Control Matrix. fileciteturn7file5L973-L1030

---

# 37. Program Form

Program creation/edit UI should only contain fields defined in the approved data contract.

The Program Lead is responsible for creating and managing programs.

Volunteer and Executive Director interfaces should not display create/edit controls unless explicitly authorized.

---

# 38. Program Details

Recommended sections:

```text
Program Overview
Beneficiaries
Activities
Volunteers
Tasks
Progress
Timeline
Analytics
```

The sections displayed must be role-appropriate.

---

# 39. Activity List

Activity screens should provide authorized users with:

```text
Activity title
Date
Program
Status
Assigned volunteers
Participants
Actions
```

The Activity permission matrix gives Program Leads full activity access, Volunteers assigned access, and Executive Directors read access. fileciteturn7file5L1034-L1049

---

# 40. Activity Form

Program Lead can create activities.

The activity form should collect only approved activity fields.

Volunteer activity editing is limited and marked as subject to final business rules in the Access Control Matrix. fileciteturn7file5L1034-L1049

Therefore the frontend must not invent editable fields for Volunteers.

---

# 41. Activity Details

Recommended sections:

```text
Activity Overview
Program
Participants
Assigned Volunteers
Attendance
Notes
Outcome
Status
```

Role-specific actions:

```text
Program Lead → Full operational controls
Volunteer → Assigned activity controls
Executive Director → Read
```

---

# 42. Attendance UI

Attendance should be available within an authorized activity.

Conceptual layout:

```text
Activity
   ↓
Participants
   ↓
Attendance
   ├── PRESENT
   ├── ABSENT
   └── EXCUSED
```

The frontend must use the approved attendance enum values.

The Program Lead can record attendance, and Volunteers can record attendance for assigned activities according to the access matrix. fileciteturn7file5L1034-L1049

---

# 43. Attendance Validation

Frontend should prevent obvious invalid submissions such as:

```text
missing participant
missing status
invalid status
duplicate UI submission
```

The backend remains authoritative for:

```text
participant eligibility
activity scope
duplicate attendance
authorization
```

---

# 44. Volunteer List

Program Leads can manage volunteers within authorized operational scope.

The UI may show:

```text
Volunteer name
Contact information where authorized
Assigned programs
Assigned activities
Assignments
Performance
```

Volunteer users should primarily see their own profile and assigned work.

---

# 45. Volunteer Assignment UI

Program Lead flow:

```text
Program
   ↓
Assign Volunteer
   ↓
Select Volunteer
   ↓
Select/Confirm Scope
   ↓
Submit
```

The frontend should only display volunteers and resources permitted by the backend.

---

# 46. Task List

Program Lead:

```text
All authorized tasks
```

Volunteer:

```text
My Tasks
```

Executive Director:

```text
Read-only authorized task information
```

The Task data contract includes:

```text
title
description
volunteerId
programId
activityId
dueDate
priority
status
createdBy
completedAt
createdAt
updatedAt
```

fileciteturn7file7L1294-L1312

---

# 47. Task Status UI

Use the approved values:

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

fileciteturn7file7L1327-L1334

---

# 48. Task Priority UI

Use:

```text
LOW
MEDIUM
HIGH
URGENT
```

fileciteturn7file7L1316-L1323

Display priority consistently using text and accessible visual indicators.

---

# 49. Analytics Pages

Analytics pages should consume the definitions in:

```text
ANALYTICS_SPECIFICATION.md
```

They should not implement independent metric formulas in React.

Recommended pages:

```text
Program Analytics
Centre Analytics
Organization Analytics
Beneficiary Progress
Volunteer Performance
```

Only authorized roles should access each page.

---

# 50. Analytics Visualizations

Recommended mapping:

| Data | UI |
|---|---|
| KPI | KPI card |
| Trend | Line chart |
| Centre comparison | Bar chart |
| Program comparison | Bar chart |
| Status distribution | Bar/donut |
| Progress | Progress indicator |
| Beneficiary journey | Timeline |

The PRD identifies KPI cards, bar charts, line charts, pie/donut charts, progress indicators, and timeline visualizations as suitable visualization types. fileciteturn7file1L252-L270

---

# 51. Analytics Empty State

When there is insufficient data:

```text
No data available for the selected filters.
```

For rates with zero denominator:

```text
N/A
```

rather than misleading `0%`, following the analytics specification.

---

# 52. Reports UI

The reporting flow is:

```text
Reports
   ↓
Select Report Type
   ↓
Select Date / Centre / Program Filters
   ↓
Generate
   ↓
Display Report
   ↓
Optional Export
```

This flow is defined in `USER_FLOWS.md`. fileciteturn7file8L1462-L1492

Possible report types:

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

# 53. Report Permissions

According to the Access Control Matrix:

| Report | Program Lead | Volunteer | Executive Director |
|---|---|---|---|
| Program Report | ✓ | ✗ | ✓ |
| Beneficiary Report | Authorized | ✗ | Authorized |
| Attendance Report | ✓ | Own/Assigned | ✓ |
| Volunteer Report | ✓ | ✗ | ✓ |
| Centre Report | Relevant | ✗ | ✓ |
| Organization Report | ✗ | ✗ | ✓ |
| Impact Report | Limited | ✗ | ✓ |

fileciteturn7file2L347-L357

Exact export permissions remain open where the source document marks them unresolved.

---

# 54. Search UI

Search must be scope-aware.

## Program Lead

Can search authorized:

```text
Programs
Beneficiaries
Activities
Volunteers
Tasks
```

## Volunteer

Search only within assigned scope:

```text
My Programs
My Beneficiaries
My Activities
```

## Executive Director

Search authorized organizational records.

fileciteturn7file2L361-L403

---

# 55. Search Component

Recommended:

```text
SearchInput
FilterButton
FilterPanel
SearchResults
Pagination
EmptyState
```

Search requests should be debounced where appropriate.

The backend remains responsible for authorization and filtering.

---

# 56. Forms

Forms should use a consistent pattern:

```text
Label
Input
Helper text
Validation message
```

Example:

```text
Program Name *
[________________]

Description *
[________________]

[Cancel] [Save]
```

Required fields must be visually identifiable and programmatically associated with inputs.

---

# 57. Client-Side Validation

Frontend validation should provide immediate feedback.

Examples:

```text
required fields
email format
date format
numeric range
enum selection
string length
```

The exact validation rules come from:

```text
VALIDATION_RULES.md
```

The backend must still perform all authoritative validation.

---

# 58. Form Submission State

During submission:

```text
Disable duplicate submission
Show loading state
Preserve entered values
Display API errors
```

After success:

```text
Show success feedback
Refresh/invalidate relevant data
Navigate appropriately
```

---

# 59. Unsaved Changes

For complex forms, the frontend may warn users before navigating away when there are unsaved changes.

This is a UX enhancement, not a data-integrity mechanism.

---

# 60. Confirmation Dialogs

Use confirmation dialogs for potentially destructive or irreversible actions.

Examples:

```text
Delete/Archive Program
Delete/Archive Beneficiary
Cancel Activity
Cancel Task
```

The exact deletion/archive permissions are not fully finalized.

Do not expose destructive controls unless the backend/API and access matrix authorize them.

---

# 61. Status Changes

Status controls should:

```text
show current status
show only valid transitions
require confirmation when appropriate
```

The frontend must not independently invent status-transition rules.

Backend validation remains authoritative.

---

# 62. Notifications / Toasts

Use consistent notifications for:

```text
Success
Warning
Error
Info
```

Examples:

```text
Program created successfully.
Attendance recorded.
Task completed.
Unable to save changes.
You do not have permission to perform this action.
```

Avoid using notifications for critical information that must remain visible on the page.

---

# 63. API Client

Recommended frontend boundary:

```text
src/
└── services/
    └── api/
```

Possible modules:

```text
authApi
programApi
beneficiaryApi
activityApi
volunteerApi
taskApi
attendanceApi
progressApi
analyticsApi
reportApi
auditApi
```

The exact folder structure may vary.

---

# 64. API Client Responsibilities

The API client should handle:

```text
HTTP requests
authentication credentials/session
query parameters
request serialization
response parsing
common error handling
```

It should not contain business authorization decisions that belong to the backend.

---

# 65. Data Fetching

Data-dependent pages should follow:

```text
Page
 ↓
Data Hook / API Service
 ↓
API
 ↓
Loading
 ↓
Success / Error
```

The implementation may use the project's chosen React data-fetching approach.

No specific library is mandated by the current source documents.

---

# 66. State Management

Frontend state should be separated conceptually into:

```text
Authentication State
Server/API State
Form State
UI State
```

Avoid storing duplicate server data in many unrelated components.

The exact state-management library is not specified by the current source documents.

---

# 67. Authentication State

Minimum information needed by the UI:

```text
isAuthenticated
user
role
```

Where required:

```text
permissions
scope
```

Sensitive credentials must follow the selected authentication strategy and security specification.

---

# 68. Role-Based UI Helper

A reusable authorization helper can conceptually support:

```text
can("PROGRAM_CREATE")
can("BENEFICIARY_UPDATE")
can("ANALYTICS_ORGANIZATION_READ")
```

However, this helper only controls UI visibility.

The backend remains authoritative.

Permission names should follow the `RESOURCE_ACTION` convention. fileciteturn7file3L664-L701

---

# 69. Field-Level UI Rendering

If the API omits a restricted field:

```text
Frontend should not assume it exists.
```

Components should gracefully handle:

```text
field unavailable
field not authorized
field has no value
```

Do not render placeholder values that imply the user has access to restricted information.

---

# 70. Responsive Design

The application should remain usable across:

```text
Desktop
Laptop
Tablet
Mobile
```

Priority:

```text
Core operational workflows
Forms
Tables
Dashboards
Navigation
```

Complex analytics may require responsive chart/table behavior.

The exact responsive breakpoints are a design implementation decision.

---

# 71. Tables

Tables should support where appropriate:

```text
Readable headers
Pagination
Sorting
Filtering
Responsive behavior
Row actions
Empty states
Loading states
```

Do not render unauthorized row actions.

---

# 72. Accessibility

The frontend should target accessible interaction patterns.

Minimum expectations:

```text
Keyboard navigation
Visible focus
Semantic HTML
Associated labels
Accessible form errors
Meaningful button names
Sufficient text alternatives
Readable contrast
```

Do not communicate important state through color alone.

---

# 73. Accessibility for Forms

Every input should have:

```text
label
name/id
validation state
accessible error association
```

Required fields should be programmatically identifiable.

Example:

```text
<label for="programName">Program Name</label>
<input id="programName" ... />
```

---

# 74. Accessibility for Tables

Tables should use:

```text
thead
th
scope where appropriate
```

Column headers must communicate the meaning of values.

For mobile layouts, avoid replacing important tabular information with inaccessible visual-only cards.

---

# 75. Accessibility for Charts

Charts must have a text-accessible representation.

Example:

```text
Attendance Trend
[Chart]

Summary:
Attendance increased from 62% in June to 71% in July.
```

The exact chart library is not specified.

---

# 76. Date and Time Display

The Data Dictionary states that backend timestamps are stored in UTC. fileciteturn7file9L1642-L1664

Frontend responsibilities:

```text
Receive API timestamp
Convert/display appropriately for the UI context
```

Do not mutate stored timestamps.

Date-only fields should not accidentally shift due to timezone conversion.

---

# 77. IDs

The database uses UUIDs internally. fileciteturn7file9L1622-L1638

The frontend should:

```text
Use UUIDs for API resource identification
Treat UUIDs as opaque identifiers
```

The user-facing beneficiary unique ID is a separate business identity attribute and must not be confused with the internal UUID.

---

# 78. Error Boundary

The React application should include an application-level error boundary for unexpected rendering failures.

It should:

```text
Prevent blank/crashed UI
Display safe fallback
Allow recovery/reload
Avoid exposing stack traces to users
```

Technical errors should be captured through the application's approved logging/monitoring mechanism.

---

# 79. Security Rules

The frontend must never:

```text
connect directly to PostgreSQL
store passwords
display password hashes
trust client role for backend authorization
expose API secrets
hard-code database credentials
log authentication secrets
```

The frontend must not assume hidden UI elements provide security.

---

# 80. Sensitive Beneficiary UI

Beneficiary screens should follow:

```text
Minimum Necessary Access
```

A Volunteer must not receive:

```text
unrelated beneficiaries
unrelated sensitive case information
global beneficiary search
```

The Access Control Matrix explicitly defines these restrictions. fileciteturn7file6L1172-L1189

---

# 81. Authorization Failure Handling

If an API returns:

```text
403
```

the UI should:

```text
stop the unauthorized action
show safe message
refresh/reload authorized state if necessary
```

Do not expose backend authorization logic or sensitive resource information.

---

# 82. Session Expiration Handling

If the authentication mechanism reports an expired/invalid session:

```text
API response
    ↓
Authentication state invalid
    ↓
Clear UI auth state
    ↓
Redirect to Login
```

The exact token/session mechanism is defined by the authentication specification.

---

# 83. Duplicate Submission Prevention

For create/update actions:

```text
Submit
 ↓
Loading
 ↓
Disable repeated submit
```

This improves UX, but the backend must also protect against duplicate business records where required.

For example, duplicate active program enrollments must be prevented according to business rules. fileciteturn7file6L1244-L1253

---

# 84. Frontend Architecture Example

Recommended conceptual structure:

```text
src/
├── app/
│   ├── router
│   ├── providers
│   └── auth
│
├── components/
│   ├── common
│   ├── forms
│   ├── tables
│   ├── charts
│   └── layout
│
├── pages/
│   ├── auth
│   ├── dashboard
│   ├── programs
│   ├── beneficiaries
│   ├── activities
│   ├── volunteers
│   ├── tasks
│   ├── analytics
│   ├── reports
│   └── audit
│
├── services/
│   └── api
│
├── hooks/
│
├── utils/
│
└── styles/
```

This is a recommended structure, not a requirement to use a specific folder naming scheme.

---

# 85. Component Principles

Reusable components should be preferred for repeated UI patterns.

Examples:

```text
Button
Input
Select
Modal
Table
Pagination
StatusBadge
KpiCard
EmptyState
LoadingState
ErrorState
FormField
PageHeader
```

Domain-specific components should remain understandable and focused.

---

# 86. Page Principles

Each page should generally own:

```text
Page-level data requirements
Page layout
Page actions
Page states
```

Business rules should remain in backend services.

---

# 87. Program Page Example

```text
ProgramsPage
    │
    ├── PageHeader
    ├── Search / Filters
    ├── ProgramTable
    ├── Pagination
    └── Empty/Error/Loading State
```

Create action:

```text
CreateProgramPage
    │
    └── ProgramForm
```

---

# 88. Beneficiary Page Example

```text
BeneficiariesPage
    │
    ├── Search
    ├── Filters
    ├── BeneficiaryTable
    └── Pagination

BeneficiaryDetailsPage
    │
    ├── Profile
    ├── Enrollments
    ├── Attendance
    ├── Progress
    └── Timeline
```

Only authorized sections should be displayed.

---

# 89. Activity Page Example

```text
ActivityDetailsPage
    │
    ├── Overview
    ├── Participants
    ├── Volunteers
    ├── Attendance
    ├── Notes
    └── Outcome
```

Actions should depend on the authenticated role and API authorization.

---

# 90. Dashboard Performance

Dashboards should avoid unnecessary API calls.

Prefer:

```text
Dashboard API
    ↓
Aggregated response
    ↓
Dashboard components
```

rather than every KPI component independently requesting the same data.

This aligns with the analytics architecture.

---

# 91. Pagination

Large lists should use server-side pagination.

Examples:

```text
Beneficiaries
Programs
Activities
Volunteers
Tasks
Audit Logs
```

The frontend should pass pagination parameters defined by the API.

---

# 92. Filtering

Filters should use backend-supported query parameters.

Examples:

```text
status
centreId
programId
startDate
endDate
```

The frontend must not claim a filter is supported unless the API supports it.

---

# 93. Sorting

Sorting should be server-side for large datasets where supported.

The frontend should only expose approved sortable fields.

---

# 94. Optimistic Updates

Optimistic updates should be used cautiously for sensitive workflows.

For:

```text
Attendance
Progress
Beneficiary updates
Program changes
```

prefer confirmed server responses unless the operation is simple and rollback behavior is reliable.

---

# 95. Data Refresh

After successful mutation:

```text
Create Program
    ↓
Refresh Program List
```

```text
Record Attendance
    ↓
Refresh Attendance
```

```text
Create Progress
    ↓
Refresh Progress + Timeline where applicable
```

The exact data invalidation strategy depends on the selected frontend data layer.

---

# 96. API Error Mapping

Frontend should map known API errors into user-friendly messages.

Example:

```text
401 → Please log in again.
403 → You do not have permission.
400/422 → Check the highlighted fields.
404 → Resource not found.
409 → Record already exists/conflict.
500 → Something went wrong. Please try again.
```

Exact status codes and error structure must remain synchronized with `API_SPECIFICATION.md`.

---

# 97. Frontend Testing

Frontend tests should cover:

```text
routing
authentication state
role-based navigation
protected routes
forms
validation
loading states
empty states
error states
table rendering
analytics rendering
authorization-aware actions
responsive behavior
accessibility
```

---

# 98. Role-Based UI Testing

Minimum examples:

```text
Program Lead
→ sees Programs
→ sees Beneficiaries
→ sees Activities
→ sees Analytics

Volunteer
→ sees My Programs
→ sees My Beneficiaries
→ sees My Tasks
→ does not see global beneficiary search

Executive Director
→ sees Organization Analytics
→ sees Centre Analytics
→ sees Reports
```

These navigation expectations follow the Access Control Matrix. fileciteturn7file2L514-L551

---

# 99. Scope UI Testing

Given:

```text
Volunteer A → Program X
```

the UI should show:

```text
Program X
Beneficiaries within permitted scope
Activities within permitted scope
Tasks within permitted scope
```

It should not provide global navigation/search into unrelated records.

The backend must still enforce the same scope.

---

# 100. Sensitive Field Testing

Verify that restricted fields are not rendered for unauthorized users.

Test:

```text
API response omits restricted field
        ↓
Frontend renders safely
```

Also test that a user cannot access the restricted information by manipulating:

```text
URL
query parameter
frontend state
browser developer tools
```

Backend authorization must reject unauthorized API requests.

---

# 101. Accessibility Testing

Test:

```text
keyboard-only navigation
screen reader labels
focus order
form errors
button names
table semantics
chart alternatives
responsive layout
```

---

# 102. Performance Testing

Measure:

```text
initial application load
dashboard load
large list rendering
search response handling
analytics rendering
form submission
```

Use pagination and server-side aggregation rather than loading unnecessary datasets.

---

# 103. Frontend Environment Variables

Only public/non-secret configuration may be exposed to the browser.

Examples:

```text
API base URL
public application configuration
```

Never expose:

```text
database password
JWT signing secret
private API keys
server credentials
```

---

# 104. API Base URL

The frontend should use an environment/configuration value for the backend API base URL.

Conceptually:

```text
VITE_API_BASE_URL
```

or the equivalent configuration mechanism used by the selected React setup.

The exact variable name is an implementation decision.

---

# 105. Production Build

The production frontend should:

```text
Build optimized assets
Use production API configuration
Avoid development debugging output
Avoid source-level secrets
Serve over HTTPS
```

The exact hosting/deployment configuration belongs in `DEPLOYMENT.md`.

---

# 106. Frontend and Audit Logging

Frontend should not create authoritative audit records.

Correct:

```text
User Action
   ↓
API
   ↓
Backend Business Operation
   ↓
Audit Service
```

Incorrect:

```text
React
   ↓
Insert audit record
```

The backend remains the source of truth for audit events.

---

# 107. Frontend and Analytics

React should render metrics returned by the analytics API.

Avoid implementing business formulas such as:

```text
attendanceRate = ...
```

inside multiple unrelated components.

Metric definitions belong in `ANALYTICS_SPECIFICATION.md`.

---

# 108. Frontend and Validation

Frontend validation:

```text
fast feedback
```

Backend validation:

```text
authoritative correctness
```

Both should follow `VALIDATION_RULES.md`.

---

# 109. Frontend and Database

The dependency chain must remain:

```text
React
  ↓
REST API
  ↓
Backend Services
  ↓
PostgreSQL
```

The frontend must never import PostgreSQL/node-postgres code.

---

# 110. AI Coding Agent Rules

Any AI coding agent implementing the frontend must:

1. Read `PRD.md`.
2. Read `USER_FLOWS.md`.
3. Read `ACCESS_CONTROL_MATRIX.md`.
4. Read `DATA_DICTIONARY.md`.
5. Read `API_SPECIFICATION.md`.
6. Read `TECHNICAL_ARCHITECTURE.md`.
7. Read `VALIDATION_RULES.md`.
8. Read `ANALYTICS_SPECIFICATION.md`.
9. Read `AUTHENTICATION_AUTHORIZATION.md`.
10. Never invent a role.
11. Never broaden frontend permissions.
12. Never treat frontend authorization as security.
13. Never invent API endpoints.
14. Never invent fields that are not in the approved data/API contract.
15. Use camelCase API fields.
16. Use approved enum values.
17. Respect role and scope restrictions.
18. Do not expose sensitive beneficiary information.
19. Do not connect directly to PostgreSQL.
20. Do not invent analytics formulas.
21. Do not invent validation rules.
22. Ask for clarification when requirements are explicitly marked open.
23. Keep frontend behavior synchronized with backend contracts.

The Access Control Matrix explicitly requires AI agents not to invent roles, silently broaden permissions, or implement authorization only in the frontend. fileciteturn7file3L647-L660

---

# 111. Open Frontend Decisions

The current source documents do not fully specify:

1. Exact React state-management library.
2. Exact data-fetching library.
3. Exact UI component library.
4. Exact charting library.
5. Exact responsive breakpoints.
6. Exact visual design system/colors/typography.
7. Exact route URL naming.
8. Exact pagination defaults.
9. Exact sorting behavior for every list.
10. Exact Volunteer editable beneficiary fields.
11. Exact Volunteer timeline visibility.
12. Exact Volunteer activity-note editing behavior.
13. Exact attendance correction behavior.
14. Exact Program Lead centre scope.
15. Exact Executive Director beneficiary-field visibility.
16. Exact report export behavior.

These should be finalized through the relevant product/design/technical decisions rather than invented by implementation agents.

---

# 112. MVP Frontend Scope

The frontend MVP should support:

```text
Authentication
    ├── Login
    └── Logout

Program Lead
    ├── Dashboard
    ├── Programs
    ├── Beneficiaries
    ├── Activities
    ├── Volunteers
    ├── Tasks
    ├── Analytics
    └── Reports

Volunteer
    ├── Dashboard
    ├── My Programs
    ├── My Beneficiaries
    ├── My Activities
    ├── My Tasks
    └── My Performance

Executive Director
    ├── Dashboard
    ├── Organization Analytics
    ├── Centre Analytics
    ├── Program Analytics
    ├── Beneficiary Journey
    └── Reports
```

The PRD's primary goals include centralized beneficiary records, program/activity tracking, attendance, volunteer coordination, analytics, progress visualization, reporting, and impact communication. fileciteturn7file4L774-L792

---

# 113. Frontend Out of Scope

Do not assume MVP includes:

```text
Public beneficiary portal
Public registration
Advanced AI recommendations
Predictive analytics
Advanced GIS
Offline-first workflows
Additional administrative roles
Full user-management console
```

These capabilities are not established as core frontend MVP requirements in the supplied source material.

---

# 114. End-to-End Frontend Flow

The main operational journey should be represented in the UI as:

```text
Program Lead
    ↓
Create Program
    ↓
Create Activity
    ↓
Register Beneficiary
    ↓
Generate Unique ID
    ↓
Enroll Beneficiary
    ↓
Assign Volunteer
    ↓
Assign Tasks
    ↓
Conduct Activity
    ↓
Record Attendance
    ↓
Record Progress
    ↓
Update Timeline
    ↓
View Analytics
    ↓
Generate Reports
```

This follows the end-to-end business flow defined in `USER_FLOWS.md`. fileciteturn7file8L1496-L1528

---

# 115. Final Frontend Architecture

```text
                         React Application
                                │
              ┌─────────────────┼─────────────────┐
              │                 │                 │
              ▼                 ▼                 ▼
        Authentication       Routing          Layout
              │                 │                 │
              └─────────────────┼─────────────────┘
                                ▼
                       Role-Aware Navigation
                                │
              ┌─────────────────┼─────────────────┐
              ▼                 ▼                 ▼
        Program Lead        Volunteer       Executive Director
              │                 │                 │
              └─────────────────┼─────────────────┘
                                ▼
                              Pages
                                │
                                ▼
                           Components
                                │
                                ▼
                           API Client
                                │
                                ▼
                         Express REST API
                                │
                                ▼
                           PostgreSQL
```

---

# 116. Final Frontend Principle

The Purnata frontend should follow:

```text
Simple UI
    +
Role-aware Experience
    +
Scope-aware Data
    +
Accessible Interaction
    +
Consistent API Contract
    +
Backend-Enforced Security
    =
Reliable Frontend
```

The frontend should make the system easier to operate without becoming a second source of business rules.

The most important boundary is:

```text
Frontend
   ↓
Presentation + User Experience

Backend
   ↓
Security + Business Rules + Data Integrity

PostgreSQL
   ↓
Persistent Source of Truth
```

The implementation must remain consistent with the project's approved documentation and must not silently invent behavior where the source documents mark a requirement as open.
