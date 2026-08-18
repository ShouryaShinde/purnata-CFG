# Product Requirements Document (PRD)

## Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Draft  
**Organization:** Purnata  
**Project:** Code for <good> — A Tech for Social Good Program

---

# 1. Product Overview

Purnata currently manages beneficiary case information, activities, programs, volunteer involvement, and progress tracking through disconnected tools such as WhatsApp, Google Forms, registers, and spreadsheets.

This project aims to build a **centralized digital platform** for managing the complete journey of beneficiaries—from initial outreach/risk identification and rescue through rehabilitation, reintegration, and long-term follow-up.

The platform will connect:

- Beneficiaries
- Programs
- Activities
- Centres
- Volunteers
- Program Leads/Managers
- Executive Leadership

The system will provide a single source of truth for beneficiary records, program participation, activity attendance, progress, volunteer assignments, timelines, and organizational analytics.

---

# 2. Problem Statement

Purnata works with women and children who have been rescued from trafficking or are vulnerable to exploitation.

Their journey may span several years and involve multiple interventions such as:

- Education
- Vocational training
- Counselling
- Legal support
- Medical support
- Skills training
- Economic empowerment
- Day-care services
- Motivation sessions
- Rehabilitation and reintegration activities

Currently, much of this information is recorded manually and across disconnected systems.

This creates problems such as:

- Fragmented beneficiary information
- Difficulty maintaining long-term case history
- Duplicate beneficiary records
- Difficulty tracking program participation
- Difficulty monitoring attendance
- Limited visibility into beneficiary progress
- Inconsistent volunteer deployment
- Difficulty monitoring program effectiveness
- Manual reporting
- Limited organizational-level analytics

The platform should replace these disconnected processes with a centralized, survivor-focused digital ecosystem.

---

# 3. Product Vision

Build a secure and easy-to-use platform that enables Purnata to:

> **Track every beneficiary journey, manage every intervention, coordinate every volunteer, and measure the impact of every program from one centralized system.**

The platform should preserve continuity of care while making operational and organizational decision-making data-driven.

---

# 4. Product Goals

## 4.1 Primary Goals

1. Create a centralized beneficiary record.
2. Generate a unique identifier for every beneficiary.
3. Maintain the complete beneficiary journey over time.
4. Track programs assigned to beneficiaries.
5. Track activities conducted under programs.
6. Record beneficiary attendance and participation.
7. Assign and manage volunteers based on program requirements.
8. Track volunteer performance and involvement.
9. Provide program-level analytics.
10. Provide centre-level analytics.
11. Provide organization-wide analytics.
12. Provide beneficiary progress visualization.
13. Reduce manual data entry and fragmented record keeping.
14. Enable leadership to make data-driven decisions.
15. Support reporting and impact communication.

---

# 5. Target Users

The initial system will support the following user roles.

## 5.1 Program Lead / Program Manager

Responsible for operational management of programs and beneficiaries.

### Main responsibilities

- Create programs
- Manage program activities
- Register beneficiaries
- Generate/manage beneficiary unique IDs
- Manage beneficiaries
- Assign volunteers
- Assign tasks
- Track program timelines
- Monitor beneficiary participation
- Monitor program analytics
- Review beneficiary progress
- Maintain program records

---

## 5.2 Volunteer

Volunteers support beneficiaries through assigned programs and activities.

### Main responsibilities

- View assigned programs
- View assigned beneficiaries
- View assigned tasks
- View program/activity information
- Conduct assigned activities
- Record attendance
- Update activity-related information
- View beneficiary progress relevant to assigned programs
- View beneficiary timelines where permitted
- Review their own performance/involvement

---

## 5.3 Executive Director

Provides organizational-level oversight and decision-making.

### Main responsibilities

- View organization-wide analytics
- View centre-wise analytics
- View program-wise analytics
- View beneficiary timelines
- Monitor overall program performance
- Monitor financial/status information where available
- Review organizational impact
- Generate/view reports
- Support donor and stakeholder communication
- Make strategic decisions based on platform data

---

# 6. Core Entities

The system will primarily revolve around the following entities:

```text
User
 ├── Program Lead / Manager
 ├── Volunteer
 └── Executive Director

Centre
Program
Activity
Beneficiary
Beneficiary Timeline
Program Enrollment
Attendance
Volunteer Assignment
Task
Performance Record
Analytics / Reports
```

Relationships between these entities will be formally defined in the database design document.

---

# 7. Functional Requirements

# 7.1 Authentication & Authorization

The system must provide secure authentication.

Users must only access functionality permitted by their role.

### Requirements

- Login
- Logout
- Role-based access control
- Protected routes
- Session/token management
- Password security
- Unauthorized-access handling

### Roles

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

The exact authentication mechanism will be defined in the Technical Architecture document.

---

# 8. Program Lead / Manager Features

## 8.1 Program Dashboard

The Program Lead should have a dashboard showing operational information.

### Dashboard should provide

- Total programs
- Active programs
- Total beneficiaries
- Active beneficiaries
- Total volunteers
- Upcoming activities
- Recent activities
- Program progress
- Beneficiary progress
- Relevant alerts/tasks

---

## 8.2 Create Program

The Program Lead can create a new program.

### Program information may include

- Program name
- Program description
- Centre
- Program type/category
- Start date
- End date
- Target beneficiaries
- Program status
- Program objectives

Possible statuses:

```text
PLANNED
ACTIVE
COMPLETED
CANCELLED
```

---

## 8.3 Manage Program

The Program Lead can:

- View programs
- Edit programs
- Update program status
- View enrolled beneficiaries
- View assigned volunteers
- View activities
- View program timeline
- View program analytics

---

# 9. Activity Management

Programs may contain multiple activities.

## 9.1 Create Activity

The Program Lead can create activities associated with a program.

### Activity information

- Activity name
- Activity description
- Program
- Centre
- Date
- Start time
- End time
- Location
- Assigned volunteers
- Target beneficiaries
- Activity status

Possible statuses:

```text
PLANNED
ONGOING
COMPLETED
CANCELLED
```

---

## 9.2 Activity Tracking

The system should maintain a history of activities.

The Program Lead should be able to:

- View upcoming activities
- View completed activities
- View activity participants
- View attendance
- View assigned volunteers
- View activity outcomes

---

# 10. Beneficiary Management

Beneficiary management is a core feature of the platform.

## 10.1 Register Beneficiary

The Program Lead can register a beneficiary.

The system should generate a **unique beneficiary ID**.

The system must prevent duplicate records as far as practical.

### Beneficiary profile

The exact fields will be finalized in the Data Dictionary, but the profile may include:

- Unique beneficiary ID
- Basic demographic information
- Centre
- Case status
- Risk indicators
- Registration date
- Program participation
- Intervention history
- Progress information

Sensitive information must only be accessible to authorized users.

---

# 11. Beneficiary Unique ID

Every beneficiary must have one persistent unique identifier.

Example:

```text
BEN-000001
BEN-000002
BEN-000003
```

The identifier must remain associated with the beneficiary throughout their journey.

If the beneficiary participates in multiple programs, the same beneficiary ID must be used rather than creating another beneficiary record.

---

# 12. Beneficiary Timeline

The platform should maintain a chronological timeline of the beneficiary's journey.

Example:

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

The timeline should allow authorized users to understand the history of interventions and progress over time.

---

# 13. Program Enrollment

A beneficiary may participate in multiple programs.

The system must therefore separate:

```text
Beneficiary
      ↓
Program Enrollment
      ↓
Program
```

This prevents duplication of beneficiary records.

The system should track:

- Beneficiary
- Program
- Enrollment date
- Status
- Participation
- Progress
- Completion date where applicable

---

# 14. Volunteer Management

Program Leads should be able to manage volunteers.

## 14.1 Volunteer Assignment

Program Leads can:

- View volunteers
- Assign volunteers to programs
- Assign volunteers to activities
- Assign tasks
- View volunteer availability where available
- View volunteer skills
- View volunteer involvement

Assignments should consider the requirements of the program/activity and the volunteer's relevant skills.

---

# 15. Task Assignment

Program Leads can assign tasks to volunteers.

### Task information

- Task title
- Description
- Volunteer
- Program
- Activity
- Beneficiary/group where applicable
- Priority
- Due date
- Status

Possible statuses:

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

---

# 16. Volunteer Features

After login, volunteers should be able to access their operational workspace.

## 16.1 Assigned Programs

Volunteer can view:

- Assigned programs
- Program details
- Program timeline
- Assigned beneficiaries
- Assigned activities

---

## 16.2 Assigned Beneficiaries

Volunteer can view beneficiaries associated with their assigned programs/activities, subject to authorization.

The volunteer should only see information required to perform their responsibilities.

---

## 16.3 Conduct Activities

Volunteer can view and update activities assigned to them.

Possible actions:

- View activity
- Start/complete activity where applicable
- Record participation
- Record attendance
- Add activity notes
- Submit activity outcome

---

# 17. Attendance Management

The system should allow attendance to be recorded for activities/program sessions.

### Attendance information

- Beneficiary
- Activity
- Program
- Date
- Attendance status
- Recorded by
- Timestamp

Possible attendance statuses:

```text
PRESENT
ABSENT
EXCUSED
```

Attendance history should be available for authorized users.

---

# 18. Beneficiary Progress Tracking

The platform should support tracking of beneficiary progress over time.

Progress may be associated with:

- Programs
- Activities
- Skills
- Training
- Interventions
- Milestones
- Attendance
- Other defined indicators

The exact measurable indicators should be finalized with Purnata stakeholders.

---

# 19. Volunteer Performance Analytics

The platform should provide analytics related to volunteer participation.

Possible metrics include:

- Number of assigned programs
- Number of activities
- Number of completed tasks
- Attendance/participation
- Beneficiaries supported
- Activity contribution
- Task completion rate

Only metrics supported by reliable collected data should be displayed.

---

# 20. Program Analytics

Program Leads should be able to monitor program performance.

Possible metrics:

- Total beneficiaries
- Active beneficiaries
- Program enrollments
- Activity count
- Attendance
- Volunteer participation
- Progress milestones
- Completion statistics
- Program timeline
- Other defined program KPIs

---

# 21. Centre Analytics

The platform should provide centre-level analytics.

Possible metrics:

- Beneficiaries per centre
- Active programs
- Program participation
- Activity count
- Attendance
- Volunteer involvement
- Progress indicators
- Centre-level outcomes

---

# 22. Executive Director Dashboard

The Executive Director requires a high-level organizational view.

## Dashboard should provide

### Overall Analytics

- Total beneficiaries
- Total active beneficiaries
- Total programs
- Active programs
- Total centres
- Total volunteers
- Program participation
- Activity statistics

### Centre-wise Analytics

Compare performance across centres.

### Program-wise Analytics

Compare programs and their outcomes.

### Beneficiary Timeline

View high-level beneficiary journey information.

### Impact Visualization

Visualize organizational impact through meaningful metrics and charts.

---

# 23. Reporting

The system should support reporting for:

- Program managers
- Senior leadership
- Executive leadership
- Donor/stakeholder communication

Reports may include:

- Beneficiary statistics
- Program statistics
- Centre statistics
- Volunteer statistics
- Attendance
- Progress
- Outcome metrics
- Impact summaries

The exact report formats will be defined later.

---

# 24. Data Visualization

The system should provide visual representations where useful.

Examples:

- Bar charts
- Line charts
- Pie/donut charts
- KPI cards
- Progress indicators
- Timeline visualizations
- Centre comparisons
- Program comparisons

Visualization should help users understand trends rather than simply display raw data.

---

# 25. Search & Filtering

The platform should support efficient retrieval of records.

Users should be able to search/filter based on authorized fields.

Examples:

### Beneficiary

- Unique ID
- Centre
- Program
- Status

### Program

- Centre
- Status
- Date
- Program type

### Volunteer

- Skill
- Program
- Assignment
- Status

---

# 26. Role-Based Access Control

Access must be restricted according to user responsibilities.

## Program Lead / Manager

Can access:

```text
Programs
Activities
Beneficiaries
Volunteers
Tasks
Attendance
Program Analytics
```

## Volunteer

Can access:

```text
Assigned Programs
Assigned Activities
Assigned Beneficiaries
Assigned Tasks
Attendance
Relevant Progress Information
```

## Executive Director

Can access:

```text
Organization Analytics
Centre Analytics
Program Analytics
Beneficiary Journey Overview
Reports
Impact Metrics
```

The exact permissions matrix will be maintained separately in:

```text
docs/ACCESS_CONTROL_MATRIX.md
```

---

# 27. Non-Functional Requirements

## 27.1 Usability

The system should be simple enough for frontline staff and volunteers with limited technical expertise.

Interfaces should minimize unnecessary complexity.

---

## 27.2 Mobile Friendliness

Frontline users may use mobile devices.

Therefore:

- Forms should be mobile-friendly.
- Important workflows should require minimal steps.
- Buttons and input fields should be touch-friendly.
- The system should work on common mobile browsers.

---

## 27.3 Security

The system must protect sensitive beneficiary information.

Requirements include:

- Authentication
- Authorization
- Secure password handling
- Role-based access
- Input validation
- Secure API communication
- Protection against unauthorized access
- Appropriate audit logging

---

## 27.4 Data Integrity

The system must maintain consistent and reliable records.

Important requirements:

- Unique beneficiary IDs
- Referential integrity
- Validation
- Duplicate prevention
- Consistent timestamps
- Controlled status transitions

---

## 27.5 Scalability

The architecture should allow the platform to grow as:

- Number of beneficiaries increases
- Number of programs increases
- Number of centres increases
- Number of volunteers increases
- Historical records increase

---

# 28. Auditability

Important actions should be traceable.

The system should record, where appropriate:

- Who created a record
- Who modified a record
- When it was modified
- What type of action occurred

This is especially important for beneficiary and program records.

---

# 29. Data Privacy

Beneficiary information may contain sensitive personal information.

Therefore:

- Users must only access information required for their role.
- Sensitive data must not be unnecessarily exposed.
- APIs must enforce authorization.
- Frontend-only access restrictions must not be considered sufficient.
- Data access should be auditable.

Detailed privacy rules will be defined after stakeholder discussion.

---

# 30. Core User Flows

## 30.1 Program Lead Flow

```text
Login
  ↓
Program Lead Dashboard
  ↓
Manage Centre / Programs
  ↓
Create Program
  ↓
Create Activities
  ↓
Register Beneficiary
  ↓
Generate Unique Beneficiary ID
  ↓
Enroll Beneficiary into Program
  ↓
Assign Volunteers
  ↓
Assign Tasks
  ↓
Conduct Activities
  ↓
Record Attendance
  ↓
Track Beneficiary Progress
  ↓
View Program Analytics
```

---

## 30.2 Volunteer Flow

```text
Login
  ↓
Volunteer Dashboard
  ↓
View Assigned Programs
  ↓
View Assigned Beneficiaries
  ↓
View Assigned Activities / Tasks
  ↓
Conduct Activity
  ↓
Record Attendance
  ↓
Submit Activity Information
  ↓
View Relevant Beneficiary Progress
  ↓
Task Completed
```

---

## 30.3 Executive Director Flow

```text
Login
  ↓
Executive Dashboard
  ↓
View Organization Analytics
  ↓
View Centre Analytics
  ↓
View Program Analytics
  ↓
View Beneficiary Journey Overview
  ↓
Analyze Impact
  ↓
Generate / Review Reports
  ↓
Strategic Decision Making
```

---

# 31. MVP Scope

The first version should prioritize the functionality necessary to demonstrate the complete core workflow.

## MVP Features

### Authentication

- Login
- Role-based authorization

### Program Lead

- Dashboard
- Program CRUD
- Activity CRUD
- Beneficiary registration
- Unique beneficiary ID
- Program enrollment
- Volunteer assignment
- Task assignment
- Attendance monitoring
- Beneficiary timeline
- Basic analytics

### Volunteer

- Dashboard
- Assigned programs
- Assigned beneficiaries
- Assigned activities
- Assigned tasks
- Attendance
- Activity updates

### Executive Director

- Dashboard
- Organization analytics
- Centre analytics
- Program analytics
- Beneficiary journey overview

---

# 32. Future Scope

The following features should not be assumed as MVP unless explicitly approved:

- Advanced AI-based recommendations
- Predictive analytics
- Automated donor reports
- Advanced notification systems
- Offline-first functionality
- Automated beneficiary risk prediction
- Advanced GIS/location analytics
- External system integrations
- Automated communication
- Advanced curriculum recommendation
- AI-generated impact storytelling

These can be considered after the core platform is stable.

---

# 33. Success Metrics

The project should measure success using indicators such as:

### Operational

- Reduction in manual data entry
- Reduction in duplicate beneficiary records
- Percentage of activities digitally recorded
- Percentage of beneficiary records with complete histories

### Program

- Program participation tracking coverage
- Attendance tracking coverage
- Progress tracking coverage

### Volunteer

- Volunteer assignment efficiency
- Task completion rate
- Volunteer participation

### Leadership

- Time required to obtain reports
- Availability of centre/program analytics
- Availability of beneficiary journey information

---

# 34. Out of Scope for Initial Version

Unless explicitly added later, the following are outside the initial scope:

- Public-facing beneficiary portal
- Public registration
- Payment processing
- Donor payment management
- Social media management
- Full HR management
- Payroll
- Accounting system
- Medical diagnosis system
- Legal case management system
- Automated decision-making regarding beneficiaries

---

# 35. Product Principles

The development team and AI agents must follow these principles.

## Principle 1 — Beneficiary First

The system should be designed around continuity of the beneficiary journey rather than isolated activities.

## Principle 2 — One Beneficiary, One Identity

A beneficiary participating in multiple programs must not be represented as multiple people.

## Principle 3 — Minimum Necessary Access

Users should only access information required for their role.

## Principle 4 — Simple Frontline Experience

The people entering data should not have to navigate unnecessarily complicated interfaces.

## Principle 5 — Data Before Analytics

Analytics must be derived from reliable underlying records.

## Principle 6 — Every Important Action Should Be Traceable

Important changes should have an identifiable user and timestamp.

## Principle 7 — Don't Build Unapproved Features

AI agents and developers must not invent business requirements that are not defined in this PRD or subsequently approved documents.

---

# 36. Source of Truth Hierarchy

When requirements conflict, AI agents and developers should follow this order:

```text
1. Explicit stakeholder decision
        ↓
2. Approved PRD
        ↓
3. Approved API / Data / Architecture documents
        ↓
4. Approved UI specifications
        ↓
5. Existing implementation
        ↓
6. Developer assumptions
```

If an important requirement is ambiguous, the agent should **ask for clarification instead of silently inventing behavior**.

---

# 37. Requirement Traceability

Every major feature should eventually have a unique requirement ID.

Example:

```text
AUTH-001   User login
AUTH-002   Role-based access

BEN-001    Register beneficiary
BEN-002    Generate unique beneficiary ID
BEN-003    View beneficiary timeline

PROG-001   Create program
PROG-002   Manage program
PROG-003   Enroll beneficiary

ACT-001    Create activity
ACT-002    Record activity

VOL-001    Assign volunteer
VOL-002    Assign task
VOL-003    View volunteer performance

ATT-001    Record attendance

ANL-001    Program analytics
ANL-002    Centre analytics
ANL-003    Organization analytics
```

The complete requirements catalogue will be maintained in:

```text
docs/REQUIREMENTS.md
```

---

# 38. Open Questions

The following decisions must be finalized with stakeholders before implementation of the affected functionality:

1. What exact beneficiary fields must be collected?
2. Which beneficiary information is considered sensitive?
3. What exact permissions should volunteers have?
4. Can volunteers see beneficiary timelines?
5. What information can an Executive Director see about individual beneficiaries?
6. What are the exact program categories?
7. What are the exact activity categories?
8. What are the required beneficiary progress indicators?
9. What constitutes successful program completion?
10. What volunteer skills should be stored?
11. How should volunteer availability be represented?
12. What exact analytics/KPIs does Purnata currently use?
13. What reports are required for donors?
14. Are notifications required?
15. Is offline data entry required?
16. What is the required retention period for beneficiary records?
17. What data export formats are required?
18. What centres will be included in the initial deployment?

---

# 39. Definition of Done — Product Level

The MVP can be considered functionally complete when:

- All three user roles can authenticate.
- Role-based access is enforced.
- Program Leads can create and manage programs.
- Activities can be created and managed.
- Beneficiaries can be registered.
- Each beneficiary receives a unique ID.
- Beneficiaries can be enrolled in multiple programs without duplication.
- Volunteers can be assigned to programs/activities.
- Tasks can be assigned to volunteers.
- Volunteers can view their assignments.
- Attendance can be recorded.
- Beneficiary timelines can be maintained.
- Program analytics are available.
- Centre analytics are available.
- Executive-level analytics are available.
- Core workflows are usable on mobile devices.
- Sensitive data is protected through authorization.
- Important records are auditable.

---

# 40. Development Rule for AI Agents

Any AI coding agent working on this project must first read:

```text
PRD.md
```

before implementing a feature.

For every task, the agent should determine:

```text
What user role is involved?
        ↓
What business requirement does this implement?
        ↓
What entities/data are involved?
        ↓
What API is required?
        ↓
What authorization is required?
        ↓
What UI is required?
        ↓
What validation is required?
        ↓
What happens on success?
        ↓
What happens on failure?
```

Agents must not independently change:

- Database relationships
- API contracts
- Authentication rules
- Role permissions
- Core business logic
- Beneficiary identity rules

without updating the appropriate specification or asking for approval.

---

# 41. Document Ecosystem

PRD.md is the root document for the project.

Recommended documentation structure:

```text
docs/
│
├── PRD.md
├── REQUIREMENTS.md
├── USER_FLOWS.md
├── ACCESS_CONTROL_MATRIX.md
├── DATA_DICTIONARY.md
├── DATABASE_SCHEMA.md
├── API_SPECIFICATION.md
├── FRONTEND_SPECIFICATION.md
├── BACKEND_SPECIFICATION.md
├── SYSTEM_ARCHITECTURE.md
├── VALIDATION_RULES.md
├── ANALYTICS_SPECIFICATION.md
├── AUDIT_LOGGING.md
└── AI_AGENT_CONTEXT.md
```

All development documents should reference the PRD and must not contradict it.

---

# 42. Final Product Definition

The Purnata platform is a **role-based digital case and program management system** that connects beneficiary case histories, programs, activities, volunteers, attendance, progress tracking, and organizational analytics.

The system's central concept is:

```text
                    PURNATA PLATFORM
                           │
          ┌────────────────┼────────────────┐
          │                │                │
      Beneficiary       Programs        Volunteers
          │                │                │
          │             Activities       Tasks
          │                │                │
          └───────────────┼────────────────┘
                          │
                   Progress & Data
                          │
             ┌────────────┴────────────┐
             │                         │
       Operational Analytics      Leadership Analytics
             │                         │
       Program Lead/Manager       Executive Director
```

The platform should ultimately provide a continuous digital representation of the beneficiary journey while simultaneously enabling Purnata to manage programs, volunteers, centres, activities, and organizational impact.