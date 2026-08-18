# ANALYTICS_SPECIFICATION.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Specification  
**Parent Documents:** `PRD.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`, `ACCESS_CONTROL_MATRIX.md`, `TECHNICAL_ARCHITECTURE.md`, `VALIDATION_RULES.md`

---

# 1. Purpose

This document defines the analytics and dashboard requirements for Purnata.

The analytics layer must help users:

- Monitor operational performance.
- Understand beneficiary participation and progress.
- Monitor programs and activities.
- Understand volunteer involvement.
- Compare centres and programs.
- Support organizational decision-making.
- Support reporting and impact communication.

The analytics system must use the centralized PostgreSQL operational data as its source of truth.

The PRD explicitly requires program-level, centre-level, organization-wide, and beneficiary progress analytics. fileciteturn4file0L19-L37

---

# 2. Analytics Principles

The analytics system must follow these principles:

1. Use PostgreSQL operational data as the source of truth.
2. Respect role-based and scope-based authorization.
3. Never expose analytics derived from records the user cannot access.
4. Do not invent metrics that are not supported by collected data.
5. Prefer meaningful trends over raw data.
6. Keep metric definitions consistent across dashboards and reports.
7. Use server-side aggregation for organizational metrics.
8. Support filtering where useful.
9. Clearly distinguish zero from unavailable data.
10. Preserve historical consistency.
11. Avoid predictive/AI analytics in the MVP unless explicitly approved.
12. Keep analytics definitions synchronized with the Data Dictionary and Database Schema.

The PRD states that visualizations should help users understand trends rather than simply display raw data. fileciteturn4file2L429-L444

---

# 3. Analytics Architecture

```text
                 PostgreSQL
                     │
                     ▼
             Operational Tables
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   Beneficiaries   Programs    Activities
        │            │            │
        ▼            ▼            ▼
    Attendance     Enrollments  Volunteers
        │            │            │
        └────────────┼────────────┘
                     ▼
             Analytics Queries
                     │
                     ▼
              Analytics Service
                     │
                     ▼
                REST API
                     │
                     ▼
              React Dashboards
```

The analytics service should query PostgreSQL directly through the backend's existing `pg`/node-postgres layer.

---

# 4. Analytics Access Model

Analytics access follows:

```text
USER
  ↓
ROLE
  ↓
PERMISSION
  ↓
SCOPE
  ↓
ANALYTICS RESOURCE
  ↓
ALLOW / DENY
```

The Access Control Matrix defines:

| Analytics | Program Lead | Volunteer | Executive Director |
|---|---|---|---|
| Program Analytics | Full | Limited/Own | Full |
| Centre Analytics | Relevant | No | Full |
| Organization Analytics | No/Operational | No | Full |

These permissions must be enforced by the backend. fileciteturn4file6L1195-L1212

---

# 5. Analytics Endpoints

The API specification defines the following analytics endpoints:

```text
GET /analytics/organization

GET /analytics/centres/:centreId

GET /analytics/programs/:programId

GET /analytics/beneficiaries/:beneficiaryId

GET /analytics/volunteers/:userId/performance
```

Dashboard endpoints:

```text
GET /dashboard/program-lead

GET /dashboard/volunteer

GET /dashboard/executive
```

Analytics endpoints return data for specific analytical resources.

Dashboard endpoints combine relevant metrics into role-specific views.

---

# 6. Metric Classification

Metrics are classified into:

```text
COUNT
RATE
PERCENTAGE
AVERAGE
TREND
STATUS DISTRIBUTION
COMPARISON
TIMELINE
```

Every metric implemented in the application should have:

```text
Metric Name
Definition
Data Source
Calculation
Scope
Access
Empty State
```

---

# 7. Source of Truth

Analytics must be derived from operational records.

Primary data sources include:

```text
users
centres
beneficiaries
programs
program_enrollments
activities
attendances
volunteer_profiles
volunteer_assignments
tasks
progress_records
timeline_events
```

Audit logs should not normally be used as the primary source for operational metrics.

Audit logs exist for traceability.

---

# 8. Program Lead Dashboard

The Program Lead dashboard should provide operational information.

The PRD specifies:

```text
Total programs
Active programs
Total beneficiaries
Active beneficiaries
Total volunteers
Upcoming activities
Recent activities
Program progress
Beneficiary progress
Relevant alerts/tasks
```

These requirements come directly from the Program Lead dashboard definition. fileciteturn4file4L895-L912

---

# 9. Program Lead KPI Cards

Recommended KPI cards:

```text
Total Programs
Active Programs
Total Beneficiaries
Active Beneficiaries
Total Volunteers
Upcoming Activities
```

Each KPI must be calculated only from records within the Program Lead's authorized scope.

---

# 10. Total Programs

## Definition

Number of programs accessible to the authenticated Program Lead.

## Data Source

```text
programs
```

## Calculation

```sql
COUNT(program.id)
```

subject to the user's authorized centre/program scope.

## Display

```text
Total Programs
```

---

# 11. Active Programs

## Definition

Number of accessible programs whose status is:

```text
ACTIVE
```

## Calculation

```text
COUNT(programs WHERE status = 'ACTIVE')
```

---

# 12. Total Beneficiaries

## Definition

Number of unique beneficiaries accessible to the Program Lead.

Important:

A beneficiary must be counted once even if they participate in multiple programs.

The persistent beneficiary record is the counting entity.

---

# 13. Active Beneficiaries

## Definition

Number of accessible beneficiaries considered active according to the approved beneficiary/case status definition.

The exact set of statuses representing an "active beneficiary" must remain synchronized with the Data Dictionary.

If the Data Dictionary does not explicitly define this mapping, the implementation must not invent one silently.

---

# 14. Total Volunteers

## Definition

Number of volunteers relevant to the Program Lead's authorized operational scope.

Possible source:

```text
users
volunteer_profiles
volunteer_assignments
```

The implementation must avoid counting the same volunteer multiple times because of multiple assignments.

Use:

```text
COUNT(DISTINCT volunteer/user)
```

where appropriate.

---

# 15. Upcoming Activities

## Definition

Activities scheduled for the future within the user's authorized scope.

Possible fields:

```text
activityDate
startTime
status
```

The dashboard should prioritize upcoming operational work.

---

# 16. Recent Activities

## Definition

Recently recorded activities within the user's authorized scope.

The exact display window should be configurable rather than hard-coded into the metric definition.

Example UI:

```text
Recent Activities
├── Activity A
├── Activity B
└── Activity C
```

---

# 17. Relevant Tasks / Alerts

The Program Lead dashboard should surface relevant operational tasks and alerts.

Possible task data:

```text
assigned tasks
overdue tasks
upcoming due dates
in-progress tasks
```

The exact alert rules are not fully defined by the PRD and should be finalized before introducing additional alert types.

---

# 18. Program Analytics

Program Leads should be able to monitor program performance.

The PRD identifies these possible program metrics:

```text
Total beneficiaries
Active beneficiaries
Program enrollments
Activity count
Attendance
Volunteer participation
Progress milestones
Completion statistics
Program timeline
Other defined program KPIs
```

These metrics are explicitly identified in the PRD. fileciteturn4file3L690-L705

---

# 19. Program Analytics Endpoint

```http
GET /analytics/programs/:programId
```

## Access

```text
PROGRAM_LEAD → Full within authorized scope
VOLUNTEER → Limited / relevant
EXECUTIVE_DIRECTOR → Full
```

The API must enforce scope before returning analytics.

---

# 20. Program Beneficiary Count

## Definition

Number of unique beneficiaries enrolled in the program.

## Source

```text
program_enrollments
beneficiaries
```

## Calculation

```text
COUNT(DISTINCT beneficiary_id)
```

---

# 21. Program Active Beneficiary Count

## Definition

Number of unique beneficiaries in the program whose enrollment/case state qualifies as active according to approved status definitions.

The exact status mapping must be defined centrally.

---

# 22. Program Enrollment Count

## Definition

Number of enrollment records associated with the program.

```text
COUNT(program_enrollments)
```

This differs from beneficiary count.

Example:

```text
100 enrollment records
95 unique beneficiaries
```

Both values may be useful and must not be confused.

---

# 23. Program Activity Count

## Definition

Number of activities associated with the program.

Possible breakdown:

```text
Total
Planned
Ongoing
Completed
Cancelled
```

Only approved activity statuses should be used.

---

# 24. Program Attendance

Attendance analytics may include:

```text
Present
Absent
Excused
Total attendance records
```

The current attendance statuses are:

```text
PRESENT
ABSENT
EXCUSED
```

The PRD defines these statuses. fileciteturn4file3L627-L649

---

# 25. Attendance Rate

If attendance rate is implemented:

```text
Attendance Rate =
Present Attendance Records
--------------------------------
Eligible Attendance Records
× 100
```

The exact definition of "eligible attendance records" must be finalized.

Do not silently include or exclude `EXCUSED` records without an approved definition.

---

# 26. Program Volunteer Participation

## Definition

Volunteer involvement in the program.

Possible measures:

```text
unique volunteers assigned
total assignments
activities supported
tasks completed
```

These are different metrics and should not be collapsed into one number without a clear label.

---

# 27. Program Progress Milestones

Progress analytics should use recorded progress data.

Possible source:

```text
progress_records
timeline_events
```

Possible display:

```text
Progress milestones achieved
Progress by category
Progress over time
```

The PRD explicitly says measurable beneficiary progress indicators still need stakeholder finalization. fileciteturn4file3L653-L668

Therefore, the system must not invent a universal "impact score" or "success score."

---

# 28. Program Completion Statistics

Possible program completion measures:

```text
completed enrollments
active enrollments
withdrawn enrollments
completed activities
```

The dashboard should clearly label which completion concept is being displayed.

For example:

```text
Enrollment Completion Rate
```

must not be presented as:

```text
Program Success Rate
```

unless stakeholders define that metric.

---

# 29. Program Timeline

Program analytics may include a timeline showing:

```text
Program Start
Activities
Milestones
Completion
```

Timeline events should be retrieved from authorized records.

---

# 30. Centre Analytics

The platform should provide centre-level analytics.

The PRD identifies:

```text
Beneficiaries per centre
Active programs
Program participation
Activity count
Attendance
Volunteer involvement
Progress indicators
Centre-level outcomes
```

These metrics are explicitly listed in the PRD. fileciteturn4file2L353-L366

---

# 31. Centre Analytics Endpoint

```http
GET /analytics/centres/:centreId
```

## Access

```text
PROGRAM_LEAD → Relevant centre
VOLUNTEER → No
EXECUTIVE_DIRECTOR → Full
```

---

# 32. Beneficiaries Per Centre

## Definition

Number of unique beneficiaries associated with the centre.

Use:

```text
COUNT(DISTINCT beneficiary.id)
```

to prevent duplicate counting.

---

# 33. Active Programs Per Centre

## Definition

Number of programs associated with the centre with:

```text
status = ACTIVE
```

---

# 34. Centre Program Participation

Possible measures:

```text
unique enrolled beneficiaries
total enrollments
programs with participation
```

The dashboard should label each measure precisely.

---

# 35. Centre Activity Count

Number of activities associated with the centre.

Possible status breakdown:

```text
PLANNED
ONGOING
COMPLETED
CANCELLED
```

---

# 36. Centre Attendance

Possible metrics:

```text
attendance records
present
absent
excused
attendance rate
```

Any rate must use the approved attendance-rate definition.

---

# 37. Centre Volunteer Involvement

Possible metrics:

```text
unique volunteers
assignments
activities supported
tasks completed
```

Avoid double counting volunteers with multiple assignments.

---

# 38. Centre Progress Indicators

Progress indicators must be based on actual recorded progress.

Potential breakdown:

```text
progress records
milestones
progress categories
trend over time
```

The exact measurable indicators remain subject to stakeholder definition.

---

# 39. Centre Outcome Metrics

The PRD mentions centre-level outcomes but does not define an exact outcome formula.

Therefore:

```text
Centre Outcomes
```

must remain a defined metric category rather than an invented calculation.

Before implementation of a formal outcome score, stakeholders must define:

```text
What counts as an outcome?
What data represents it?
How is it calculated?
What time period is used?
```

---

# 40. Organization Analytics

Organization analytics are primarily for the Executive Director.

The PRD specifies:

```text
Total beneficiaries
Total active beneficiaries
Total programs
Active programs
Total centres
Total volunteers
Program participation
Activity statistics
Centre comparisons
Program comparisons
Beneficiary journey overview
Impact visualization
```

fileciteturn4file2L370-L401

---

# 41. Organization Analytics Endpoint

```http
GET /analytics/organization
```

## Access

```text
EXECUTIVE_DIRECTOR → Full
PROGRAM_LEAD → No / operational only
VOLUNTEER → No
```

---

# 42. Total Organization Beneficiaries

## Definition

Number of unique beneficiary records in the organization's authorized organizational dataset.

```text
COUNT(DISTINCT beneficiaries.id)
```

---

# 43. Total Active Beneficiaries

Number of unique beneficiaries whose approved status qualifies as active.

The status mapping must come from the approved business/data definition.

---

# 44. Total Programs

Number of organization programs.

Possible breakdown:

```text
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

---

# 45. Active Programs

```text
COUNT(programs WHERE status = ACTIVE)
```

---

# 46. Total Centres

Number of centres available in the organization's dataset.

---

# 47. Total Volunteers

Number of unique users/profiles whose role is:

```text
VOLUNTEER
```

and who satisfy the approved status definition.

---

# 48. Organization Program Participation

Possible organization-wide measures:

```text
total enrollments
unique enrolled beneficiaries
programs with active participation
```

The dashboard must distinguish enrollment records from unique beneficiaries.

---

# 49. Organization Activity Statistics

Possible metrics:

```text
total activities
completed activities
ongoing activities
planned activities
cancelled activities
```

Only statuses defined by the Activity enum should be used.

---

# 50. Centre Comparison

The Executive Director should be able to compare centres.

Possible comparison dimensions:

```text
beneficiaries
active programs
activities
attendance
volunteer involvement
progress indicators
```

The PRD explicitly requires centre-wise comparison. fileciteturn4file2L387-L401

---

# 51. Program Comparison

The Executive Director should be able to compare programs.

Possible comparison dimensions:

```text
beneficiaries
enrollments
activities
attendance
volunteers
progress
completion
```

Comparisons must use consistent metric definitions across programs.

---

# 52. Beneficiary Journey Analytics

Endpoint:

```http
GET /analytics/beneficiaries/:beneficiaryId
```

The analytics should provide an authorized high-level representation of the beneficiary journey.

Possible information:

```text
registration
program participation
activities
attendance
progress milestones
timeline events
```

The Executive Director's PRD requirements include beneficiary timeline/journey overview. fileciteturn4file2L395-L401

---

# 53. Beneficiary Progress Visualization

Progress may be visualized through:

```text
timeline
progress indicators
category breakdown
program progression
milestone history
```

The exact measurable progress indicators must be finalized with stakeholders.

---

# 54. Volunteer Performance Analytics

Endpoint:

```http
GET /analytics/volunteers/:userId/performance
```

The PRD identifies possible volunteer metrics:

```text
Number of assigned programs
Number of activities
Number of completed tasks
Attendance/participation
Beneficiaries supported
Activity contribution
Task completion rate
```

fileciteturn4file3L672-L686

---

# 55. Assigned Programs

## Definition

Number of unique programs assigned to the volunteer.

Use:

```text
COUNT(DISTINCT program_id)
```

---

# 56. Volunteer Activities

Possible metrics:

```text
assigned activities
completed activities
activities supported
```

The dashboard must distinguish assignment from completion.

---

# 57. Completed Tasks

## Definition

Number of tasks assigned to the volunteer with:

```text
status = COMPLETED
```

---

# 58. Task Completion Rate

If implemented:

```text
Task Completion Rate =
Completed Tasks
-------------------------------
Tasks Eligible for Completion
× 100
```

The exact definition of "eligible" must be finalized.

A simple MVP definition may use assigned tasks excluding cancelled tasks, but this should be explicitly approved before being treated as an official KPI.

---

# 59. Beneficiaries Supported

## Definition

Number of unique beneficiaries associated with the volunteer through authorized assignments/activities.

Use:

```text
COUNT(DISTINCT beneficiary_id)
```

Avoid counting the same beneficiary multiple times.

---

# 60. Volunteer Participation

Possible measures:

```text
activities conducted
attendance records submitted
tasks completed
assignments
```

The system should present each metric separately where meaningful.

---

# 61. Volunteer Analytics Access

The Access Control Matrix states:

```text
Program Analytics:
PROGRAM_LEAD → Full
VOLUNTEER → Limited/Own
EXECUTIVE_DIRECTOR → Full
```

Therefore, a volunteer should not automatically receive another volunteer's performance information.

A volunteer's own performance can be shown where permitted. fileciteturn4file6L1204-L1210

---

# 62. Volunteer Dashboard

The Volunteer dashboard should focus on assigned operational work.

Possible information:

```text
Assigned Programs
Assigned Beneficiaries
Upcoming Activities
Assigned Tasks
Pending Tasks
Recent Activities
Relevant Progress
```

These are consistent with the volunteer responsibilities and user flow defined in the PRD. fileciteturn4file9L1705-L1727

---

# 63. Dashboard vs Analytics

The distinction is:

```text
Dashboard
    ↓
Role-specific summary
```

while:

```text
Analytics
    ↓
Detailed metrics / comparisons / trends
```

Example:

```text
Volunteer Dashboard
→ 5 pending tasks

Volunteer Performance Analytics
→ 18 assigned tasks
→ 14 completed
→ completion rate
```

---

# 64. Time-Based Analytics

Where trends are needed, analytics may be grouped by:

```text
day
week
month
```

The grouping should be selected based on the metric and available data.

Do not introduce unnecessary time granularity for small datasets.

---

# 65. Date Filters

Analytics endpoints may support:

```text
startDate
endDate
```

Rules:

```text
valid date format
endDate >= startDate
```

The date range must be applied consistently to the metric's relevant event/date field.

---

# 66. Analytics Scope Filters

Where appropriate:

```text
centreId
programId
status
category
startDate
endDate
```

All filters must pass validation and authorization checks.

---

# 67. Empty Data Behavior

When no records exist:

```text
counts → 0
rates → "N/A" when denominator is zero
lists → []
charts → empty state
```

Do not display:

```text
0%
```

when a rate has no eligible denominator unless the metric definition explicitly says so.

---

# 68. Missing vs Zero

The system must distinguish:

```text
Zero
```

from:

```text
No Data
```

Example:

```text
0 completed tasks
```

means the dataset contains relevant tasks but none are completed.

```text
N/A
```

may mean there are no eligible records from which to calculate the metric.

---

# 69. Percentage Rounding

Where percentages are displayed, the UI should use a consistent rounding rule.

Recommended:

```text
one decimal place
```

unless the product design specifies otherwise.

The underlying API should avoid unnecessary loss of precision.

---

# 70. Metric Consistency

The same metric must use the same definition everywhere.

Example:

```text
Total Beneficiaries
```

must not mean:

```text
dashboard → enrollment rows
analytics → unique beneficiary records
```

unless the labels explicitly distinguish them.

Preferred labels:

```text
Unique Beneficiaries
Total Enrollments
```

---

# 71. Unique Counting

Whenever the business question is about people:

```text
COUNT(DISTINCT beneficiary_id)
```

or:

```text
COUNT(DISTINCT volunteer_id)
```

should be considered to prevent duplicate counting caused by multiple relationships.

---

# 72. Analytics Query Safety

Analytics queries must:

- Use parameterized values.
- Apply authorization scope.
- Avoid unrestricted table scans where possible.
- Use indexes defined by the database schema.
- Use aggregation in PostgreSQL rather than transferring huge datasets to React.
- Return only fields required by the dashboard.

---

# 73. Analytics Repository

Recommended backend structure:

```text
repositories/
└── analyticsRepository.js
```

Possible methods:

```text
getProgramMetrics()
getCentreMetrics()
getOrganizationMetrics()
getBeneficiaryMetrics()
getVolunteerPerformance()
getDashboardMetrics()
```

The exact code organization may vary.

---

# 74. Analytics Service

Recommended service:

```text
analyticsService
```

Responsibilities:

```text
authorization-aware metric retrieval
metric aggregation
date/filter handling
metric formatting
comparison preparation
```

The service should not bypass repository/database boundaries.

---

# 75. Analytics API Response

Example:

```json
{
  "success": true,
  "data": {
    "totalBeneficiaries": 120,
    "activeBeneficiaries": 95,
    "totalPrograms": 8,
    "activePrograms": 5
  }
}
```

---

# 76. Program Analytics Response Example

```json
{
  "success": true,
  "data": {
    "programId": "uuid",
    "totalBeneficiaries": 40,
    "activeBeneficiaries": 32,
    "totalEnrollments": 45,
    "activityCount": 18,
    "attendance": {
      "present": 120,
      "absent": 20,
      "excused": 5
    },
    "volunteerParticipation": {
      "uniqueVolunteers": 8
    },
    "progress": {
      "milestones": 27
    }
  }
}
```

These are response shapes, not a declaration that every metric is already finalized.

---

# 77. Organization Analytics Response Example

```json
{
  "success": true,
  "data": {
    "totalBeneficiaries": 500,
    "activeBeneficiaries": 380,
    "totalPrograms": 20,
    "activePrograms": 12,
    "totalCentres": 4,
    "totalVolunteers": 75,
    "programParticipation": {},
    "activityStatistics": {}
  }
}
```

---

# 78. Dashboard Performance

Dashboard endpoints should avoid making many independent database requests where a consolidated query or service operation is more efficient.

Possible approach:

```text
GET /dashboard/executive
        ↓
Analytics Service
        ↓
Multiple optimized aggregate queries
        ↓
Single API response
```

The exact query optimization should be based on actual database performance.

---

# 79. Analytics Caching

Caching is not required for the MVP.

Start with:

```text
PostgreSQL
   ↓
Optimized aggregate queries
   ↓
API
```

Caching may be introduced later if actual usage demonstrates a need.

---

# 80. Analytics and Privacy

Analytics must not become a mechanism for exposing sensitive beneficiary information.

Examples:

```text
Aggregate counts → generally safer
Individual case details → restricted
Beneficiary journey → authorized only
```

The backend must apply the same authorization rules to analytics endpoints as to operational endpoints.

The PRD explicitly requires sensitive data protection and authorized API access. fileciteturn4file9L1638-L1665

---

# 81. Analytics Auditability

Access to sensitive individual-level analytics may require audit logging according to the final audit policy.

Examples:

```text
Beneficiary journey accessed
Sensitive beneficiary analytics accessed
Organization report generated
```

The exact audit-event list belongs in `AUDIT_LOGGING.md`.

---

# 82. Data Visualization

The PRD identifies these visualization types:

```text
Bar charts
Line charts
Pie/donut charts
KPI cards
Progress indicators
Timeline visualizations
Centre comparisons
Program comparisons
```

fileciteturn4file2L429-L444

Visualization choice should follow the question being answered.

---

# 83. Recommended Visualization Mapping

| Information | Recommended Visualization |
|---|---|
| Total count | KPI card |
| Status distribution | Donut/bar |
| Trend over time | Line chart |
| Centre comparison | Bar chart |
| Program comparison | Bar chart |
| Beneficiary progress | Progress indicator/timeline |
| Journey history | Timeline |
| Attendance distribution | Bar/donut |
| Program activity trend | Line/bar |

These are implementation recommendations, not additional product requirements.

---

# 84. Do Not Misrepresent Analytics

The platform must not convert incomplete operational data into claims of impact.

For example:

```text
10 completed activities
```

does not automatically mean:

```text
10 successful interventions
```

Likewise:

```text
80% attendance
```

does not automatically mean:

```text
80% beneficiary success
```

Analytics labels must accurately describe what is measured.

---

# 85. Impact Analytics

The PRD requires impact visualization and impact communication.

However, it does not define a final impact formula.

Therefore, MVP impact analytics should use directly observable, clearly labeled measures such as:

```text
beneficiaries served
program participation
activities conducted
attendance
progress milestones
completion statistics
```

A composite organizational impact score should not be invented without stakeholder approval.

---

# 86. Predictive Analytics

The following are explicitly future scope and must not be treated as MVP analytics:

```text
predictive analytics
automated beneficiary risk prediction
advanced AI recommendations
advanced GIS analytics
AI-generated impact storytelling
```

fileciteturn4file9L1800-L1816

---

# 87. Financial Analytics

The PRD mentions financial/status information "where available" for the Executive Director.

No detailed financial entity/model is currently defined in the core data model.

Therefore:

```text
Financial Analytics
```

must not be implemented as a core MVP metric without an approved financial data model.

---

# 88. Reporting Relationship

Reports should reuse analytics definitions rather than implementing separate formulas.

```text
Operational Data
      ↓
Analytics Definitions
      ↓
Reports
```

This prevents:

```text
Dashboard metric ≠ Report metric
```

for the same named KPI.

The PRD requires reporting for beneficiary, program, centre, volunteer, attendance, progress, outcome, and impact information, while exact report formats remain open. fileciteturn4file3L761-L781

---

# 89. Analytics Testing

Analytics tests must verify:

```text
metric calculation
unique counting
status filtering
date filtering
scope filtering
authorization
empty states
zero denominators
cross-centre isolation
cross-program isolation
```

---

# 90. Analytics Test Examples

## Example 1 — Unique Beneficiaries

Given:

```text
Beneficiary A → Program X
Beneficiary A → Program Y
```

Expected:

```text
Total Beneficiaries = 1
Total Enrollments = 2
```

---

## Example 2 — Program Activities

Given:

```text
5 activities
2 completed
1 ongoing
2 planned
```

Expected:

```text
Activity Count = 5
Completed = 2
Ongoing = 1
Planned = 2
```

---

## Example 3 — Volunteer Tasks

Given:

```text
10 assigned
7 completed
2 in progress
1 cancelled
```

The dashboard must not present `7/10` as an official completion rate unless the metric definition explicitly says cancelled tasks are included in the denominator.

---

# 91. Authorization Analytics Test

Example:

```text
Volunteer A
   ↓
Program X
```

Expected:

```text
GET /analytics/programs/X
→ permitted according to limited volunteer analytics permission
```

For:

```text
Program Y
```

where Volunteer A has no assignment:

```text
→ deny or restrict according to authorization policy
```

---

# 92. Centre Authorization Test

Program Lead authorized for Centre A:

```text
GET /analytics/centres/A
→ allowed
```

Centre B outside their scope:

```text
GET /analytics/centres/B
→ denied
```

The exact Program Lead centre scope remains an open authorization question in the Access Control Matrix. fileciteturn4file8L1546-L1566

---

# 93. Analytics Documentation Rule

Every finalized KPI should eventually have:

```text
Name
Definition
Formula
Data Source
Filters
Role Access
Time Period
Empty State
Display Format
```

Example:

```text
KPI:
Active Programs

Definition:
Programs whose status is ACTIVE.

Source:
programs

Formula:
COUNT(programs WHERE status = ACTIVE)

Access:
Program Lead within scope
Executive Director organization-wide

Empty:
0
```

---

# 94. Analytics Implementation Priority

## MVP — Required

```text
Program Lead Dashboard
├── Total programs
├── Active programs
├── Total beneficiaries
├── Active beneficiaries
├── Total volunteers
├── Upcoming activities
├── Recent activities
└── Basic program/beneficiary progress

Program Analytics
├── Beneficiaries
├── Enrollments
├── Activities
├── Attendance
├── Volunteer participation
└── Progress

Centre Analytics
├── Beneficiaries
├── Programs
├── Activities
├── Attendance
└── Volunteer involvement

Executive Analytics
├── Organization totals
├── Centre comparison
├── Program comparison
└── Beneficiary journey overview
```

The PRD explicitly includes these analytics capabilities in MVP scope. fileciteturn4file9L1755-L1797

---

# 95. Future Analytics

Do not assume the following for MVP:

```text
Predictive analytics
AI recommendations
Risk prediction
Advanced GIS
Automated impact storytelling
Advanced donor analytics
```

These are future-scope items in the PRD. fileciteturn4file9L1800-L1816

---

# 96. Open Analytics Decisions

The source documents do not fully define:

1. Exact "active beneficiary" status mapping.
2. Exact measurable beneficiary progress indicators.
3. Formal outcome definitions.
4. Formal impact KPI definitions.
5. Exact attendance-rate denominator.
6. Exact task-completion-rate denominator.
7. Exact time windows for dashboard "recent" and "upcoming" sections.
8. Exact Program Lead centre scope.
9. Exact volunteer access to performance analytics.
10. Exact Executive Director access to individual beneficiary information.
11. Financial analytics data model.
12. Final report/export formats.
13. Final dashboard chart designs.

These must be confirmed before treating the corresponding metrics as final business KPIs.

---

# 97. AI Coding Agent Rules

AI coding agents implementing analytics must:

1. Read the source documents before changing metrics.
2. Use only data that actually exists in the approved schema.
3. Follow the API specification.
4. Follow the Access Control Matrix.
5. Apply authorization before returning analytics.
6. Use unique counting where the metric represents people.
7. Avoid inventing impact formulas.
8. Avoid inventing progress indicators.
9. Avoid inventing financial metrics.
10. Keep dashboard and report definitions consistent.
11. Use parameterized PostgreSQL queries.
12. Prefer PostgreSQL aggregation for server-side analytics.
13. Do not introduce predictive analytics into MVP.
14. Update this document when an approved KPI definition changes.

---

# 98. Analytics Architecture Summary

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
              DASHBOARD
                  │
                  ▼
           ANALYTICS SERVICE
                  │
                  ▼
         PARAMETERIZED SQL
                  │
                  ▼
             PostgreSQL
                  │
       ┌──────────┼───────────┐
       ▼          ▼           ▼
 Beneficiaries  Programs   Activities
       │          │           │
       ▼          ▼           ▼
 Attendance   Enrollments  Volunteers
       │          │           │
       └──────────┼───────────┘
                  ▼
              METRICS
                  │
                  ▼
             VISUALIZATION
```

---

# 99. Final Analytics Principle

Purnata analytics must answer:

```text
What is happening?
        ↓
Where is it happening?
        ↓
Who is being served?
        ↓
How are programs performing?
        ↓
How are beneficiaries progressing?
        ↓
How are volunteers contributing?
        ↓
What trends can leadership observe?
```

without claiming more than the underlying data can support.

The analytics layer therefore remains:

```text
Operational Data
      ↓
Reliable Metrics
      ↓
Meaningful Visualization
      ↓
Better Operational Decisions
      ↓
Better Organizational Decisions
```

The purpose is not to produce the maximum number of charts.

The purpose is to provide trustworthy, authorized, decision-useful information from Purnata's centralized operational records.
