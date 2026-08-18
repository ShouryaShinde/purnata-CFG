# TESTING_STRATEGY.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Testing & Quality Specification  
**Parent Documents:** `PRD.md`, `USER_FLOWS.md`, `ACCESS_CONTROL_MATRIX.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`, `TECHNICAL_ARCHITECTURE.md`, `VALIDATION_RULES.md`, `ANALYTICS_SPECIFICATION.md`, `AUDIT_LOGGING.md`, `AUTHENTICATION_AUTHORIZATION.md`, `FRONTEND_SPECIFICATION.md`

---

# 1. Purpose

This document defines the testing strategy for Purnata.

The objective is to verify that the platform correctly implements the approved requirements for:

- Authentication
- Role-based authorization
- Beneficiary management
- Programs
- Activities
- Enrollments
- Volunteers
- Tasks
- Attendance
- Progress
- Timelines
- Analytics
- Reports
- Auditability
- Data integrity
- Sensitive-data protection
- Mobile usability

The PRD's product-level Definition of Done requires all three roles to authenticate, role-based access to be enforced, core workflows to function, analytics to be available, sensitive data to be protected, and important records to be auditable. fileciteturn8file1L166-L187

---

# 2. Testing Objectives

Testing must verify:

1. Requirements are implemented correctly.
2. Core user flows work end-to-end.
3. API contracts behave as specified.
4. PostgreSQL data remains consistent.
5. Authorization cannot be bypassed.
6. Sensitive beneficiary information is protected.
7. Validation rules reject invalid data.
8. Duplicate records are prevented where required.
9. Analytics calculations are correct.
10. Important actions are auditable.
11. Frontend states are usable.
12. Core workflows work on mobile devices.
13. Regressions are detected before release.

---

# 3. Testing Principles

The project follows these principles:

```text
Test the requirement
        ↓
Test the business rule
        ↓
Test the API
        ↓
Test the database effect
        ↓
Test the UI
        ↓
Test the complete workflow
```

Additional principles:

- Test authorization on the backend.
- Do not treat hidden frontend controls as security.
- Test both valid and invalid inputs.
- Test role and resource scope.
- Test data integrity at the database boundary.
- Use realistic but non-sensitive test data.
- Do not invent requirements that are marked open.
- Every major requirement should eventually map to test cases.

---

# 4. Source of Truth

Testing must follow the approved documentation hierarchy.

Primary sources:

```text
PRD.md
USER_FLOWS.md
ACCESS_CONTROL_MATRIX.md
DATA_DICTIONARY.md
DATABASE_SCHEMA.md
API_SPECIFICATION.md
TECHNICAL_ARCHITECTURE.md
VALIDATION_RULES.md
ANALYTICS_SPECIFICATION.md
AUDIT_LOGGING.md
AUTHENTICATION_AUTHORIZATION.md
FRONTEND_SPECIFICATION.md
```

The Data Dictionary is explicitly the shared data contract for the frontend, backend, database, API, analytics, AI coding agents, and testing. fileciteturn8file6L1016-L1030

---

# 5. Testing Pyramid

The recommended testing structure is:

```text
                 E2E Tests
              ─────────────
            Integration Tests
          ─────────────────────
        API / Service / DB Tests
      ────────────────────────────
             Unit Tests
    ───────────────────────────────
```

Use many fast unit tests, a substantial set of API/integration tests, and a smaller set of critical end-to-end workflows.

---

# 6. Test Levels

The project should use:

```text
1. Unit Testing
2. Component Testing
3. API Testing
4. Integration Testing
5. Database Testing
6. Authorization/Security Testing
7. Analytics Testing
8. End-to-End Testing
9. Accessibility Testing
10. Performance Testing
11. Regression Testing
```

Not every feature requires identical coverage at every level.

---

# 7. Unit Testing

Unit tests should verify isolated logic such as:

```text
validation functions
permission helpers
status-transition logic
data transformations
analytics calculations
formatters
utility functions
```

Examples:

```text
valid email → accepted
invalid email → rejected

score 0 → valid
score 100 → valid
score 101 → rejected

PROGRAM_LEAD + PROGRAM_CREATE → allowed
VOLUNTEER + PROGRAM_CREATE → denied
```

---

# 8. Frontend Component Testing

Frontend component tests should verify:

```text
rendering
user interaction
form behavior
validation messages
loading states
empty states
error states
role-based UI
table behavior
pagination
accessible labels
```

Examples:

```text
Program Lead sees Create Program
Volunteer does not see Create Program
Empty beneficiary list shows empty state
Invalid form displays validation error
```

Frontend behavior must remain consistent with `FRONTEND_SPECIFICATION.md`.

---

# 9. API Testing

API tests should verify:

```text
request validation
authentication
authorization
scope
success response
error response
database effect
audit effect
```

For every important endpoint, test:

```text
valid request
invalid request
unauthenticated request
unauthorized role
unauthorized scope
missing resource
duplicate/conflicting request
```

---

# 10. API Contract Testing

API responses must remain consistent with the approved API specification.

Test:

```text
HTTP status
response structure
field names
field types
error structure
pagination structure
enum values
```

Frontend/API fields must use the approved `camelCase` convention such as `beneficiaryId`, `programId`, `activityDate`, `createdAt`, and `updatedAt`. fileciteturn8file6L1132-L1150

---

# 11. Authentication Testing

Authentication tests must cover all three roles:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

The PRD requires all three roles to authenticate in the MVP. fileciteturn8file1L168-L187

Minimum cases:

```text
valid login
invalid password
invalid email
missing credentials
invalid credential format
logout
protected route without authentication
expired/invalid session or token
```

---

# 12. Login Test Cases

## Valid Login

Given:

```text
valid email
valid password
active user
```

Expected:

```text
authentication succeeds
user identity is established
role is available
dashboard is accessible
```

## Invalid Login

Given invalid credentials:

```text
authentication fails
no protected data is returned
safe error is displayed
```

Passwords must never appear in responses or logs.

---

# 13. Logout Testing

Verify:

```text
user logs in
        ↓
user logs out
        ↓
authenticated state is cleared
        ↓
protected resource is no longer accessible
```

The exact invalidation behavior depends on the final session/token mechanism.

---

# 14. Authorization Testing

Authorization must follow:

```text
USER
 ↓
ROLE
 ↓
PERMISSION
 ↓
SCOPE
 ↓
RESOURCE
 ↓
ACTION
 ↓
ALLOW / DENY
```

The Access Control Matrix defines this as the platform's authorization principle. fileciteturn8file5L966-L992

---

# 15. Role-Based Authorization Matrix Testing

Minimum role tests:

| Resource | Program Lead | Volunteer | Executive Director |
|---|---|---|---|
| Programs | Full | Assigned Read | Read |
| Activities | Full | Assigned Read/Update | Read |
| Beneficiaries | Full | Assigned Read | Authorized Read |
| Tasks | Full | Own Tasks | Read |
| Attendance | Full | Assigned Activity | Read |
| Progress | Full | Relevant/Assigned | Read |
| Program Analytics | Full | Limited/Own | Full |
| Centre Analytics | Relevant | No | Full |
| Organization Analytics | No/Operational | No | Full |
| Reports | Program-level | No | Full |
| Audit Logs | Relevant | Own Actions | Authorized |

This reflects the approved access matrix. fileciteturn8file3L570-L590

---

# 16. Unauthorized API Test

Example:

```text
Volunteer
    ↓
POST /programs
```

Expected:

```text
403 Forbidden
```

No program is created.

The Access Control Matrix specifies `403 Forbidden` for unauthorized operations and requires that sensitive information not be revealed through the error. fileciteturn8file5L808-L830

---

# 17. Unauthenticated API Test

Example:

```text
No authentication
    ↓
GET /beneficiaries
```

Expected:

```text
401 / approved authentication error
```

No beneficiary data is returned.

The exact status/error contract must follow `API_SPECIFICATION.md`.

---

# 18. Scope Authorization Testing

Scope must be tested independently from role.

Example:

```text
Volunteer A → Program X
Volunteer B → Program Y
```

Volunteer A must not access resources available only through Program Y.

Test:

```text
Program Y
Beneficiaries in Program Y
Activities in Program Y
Tasks in Program Y
```

Expected:

```text
Access denied
```

---

# 19. Permission Inheritance Test

Given:

```text
Volunteer can view Program X
```

Do not assume:

```text
Volunteer can view every beneficiary in Program X
```

Beneficiary access must be checked separately according to approved rules. fileciteturn8file5L834-L854

---

# 20. Privilege Escalation Testing

Attempt to manipulate:

```text
role
userId
permissions
centreId
createdBy
assignedBy
```

through request bodies, query parameters, or frontend state.

Expected:

```text
server ignores untrusted authority fields
authenticated identity remains authoritative
unauthorized changes are rejected
```

---

# 21. Sensitive Data Testing

Beneficiary information may contain sensitive personal information.

Tests must verify:

```text
unauthorized fields are not returned
unauthorized users cannot access sensitive records
search does not bypass authorization
analytics does not expose restricted data
reports do not expose unauthorized data
errors do not reveal sensitive information
```

The PRD explicitly requires minimum-necessary access, API authorization, and auditable data access. fileciteturn8file7L1241-L1268

---

# 22. Beneficiary Testing

Beneficiary tests should cover:

```text
registration
unique ID generation
profile retrieval
profile update
program enrollment
multiple-program enrollment
timeline
progress
attendance
duplicate prevention
authorization
```

The beneficiary is a central entity in the platform and must retain a continuous identity across program participation.

---

# 23. Unique Beneficiary ID Test

Create a beneficiary.

Expected:

```text
unique beneficiary ID generated
```

Create another beneficiary.

Expected:

```text
different unique ID
```

Enroll the first beneficiary in multiple programs.

Expected:

```text
same beneficiary identity
no duplicate beneficiary record
```

The PRD requires unique IDs and multiple program enrollment without duplication. fileciteturn8file1L170-L187

---

# 24. Beneficiary Enrollment Testing

Test:

```text
valid enrollment
duplicate active enrollment
invalid beneficiary
invalid program
unauthorized enrollment
```

Expected duplicate behavior must follow `VALIDATION_RULES.md` and database constraints.

---

# 25. Program Testing

Program tests:

```text
create
read
update
status changes
beneficiary management
activity management
volunteer assignment
task assignment
analytics
authorization
```

Program Lead is responsible for creating and managing programs. fileciteturn8file2L336-L353

---

# 26. Activity Testing

Test:

```text
activity creation
activity update
activity retrieval
program association
volunteer assignment
participant association
attendance
status changes
activity completion
```

Volunteer activity access must remain limited to approved assigned scope.

---

# 27. Volunteer Assignment Testing

Test:

```text
valid assignment
invalid volunteer
invalid program
invalid activity
duplicate assignment
unauthorized assignment
assignment visibility
```

After assignment:

```text
Volunteer can see assigned work
Volunteer cannot see unrelated work
```

---

# 28. Task Testing

Test:

```text
task creation
task assignment
task retrieval
priority
due date
status
completion
authorization
```

Approved task statuses:

```text
ASSIGNED
IN_PROGRESS
COMPLETED
CANCELLED
```

Task priorities:

```text
LOW
MEDIUM
HIGH
URGENT
```

---

# 29. Attendance Testing

Attendance must test:

```text
valid attendance
missing beneficiary
missing activity
invalid status
duplicate attendance
unauthorized activity
attendance history
```

Approved statuses:

```text
PRESENT
ABSENT
EXCUSED
```

The PRD defines these attendance statuses and requires attendance history for authorized users. fileciteturn8file8L1479-L1501

---

# 30. Progress Testing

Progress tests should cover:

```text
create progress record
update progress record
valid score
invalid score
category
program association
activity association
authorization
timeline integration where applicable
```

The exact measurable progress indicators remain a stakeholder decision, so tests must not invent additional indicators. fileciteturn8file8L1505-L1520

---

# 31. Timeline Testing

Test:

```text
registration event
enrollment event
activity event
progress milestone
reintegration event
follow-up event
timeline ordering
authorization
```

Timeline tests must ensure historical events are not silently lost or incorrectly associated.

---

# 32. Data Integrity Testing

The PRD explicitly requires:

```text
unique beneficiary IDs
referential integrity
validation
duplicate prevention
consistent timestamps
controlled status transitions
```

These must be tested at the application and database boundaries. fileciteturn8file7L1214-L1226

---

# 33. PostgreSQL Testing

Because Purnata uses PostgreSQL directly rather than Prisma, database integration tests must exercise the actual PostgreSQL data-access layer.

Test:

```text
INSERT
UPDATE
SELECT
DELETE where approved
FOREIGN KEY constraints
UNIQUE constraints
NOT NULL constraints
CHECK constraints
transactions
rollback
indexes where relevant
```

Do not substitute ORM behavior because Prisma is not part of the implementation.

---

# 34. Referential Integrity Testing

Attempt invalid relationships such as:

```text
attendance → nonexistent activity
enrollment → nonexistent beneficiary
enrollment → nonexistent program
assignment → nonexistent volunteer
task → nonexistent program
```

Expected:

```text
operation rejected
database remains consistent
```

---

# 35. Transaction Testing

For multi-step operations:

```text
BEGIN
 ↓
Operation A
 ↓
Operation B
 ↓
Operation C
 ↓
COMMIT
```

If one operation fails:

```text
ROLLBACK
```

Verify that partial records are not left behind.

---

# 36. Audit Logging Testing

Important successful actions should create appropriate audit events.

Test:

```text
beneficiary create
beneficiary update
program create
program update
activity changes
assignment
attendance
progress
important security events
```

The exact final audit-event list must follow `AUDIT_LOGGING.md`.

---

# 37. Audit Actor Test

Attempt to submit:

```json
{
  "userId": "another-user"
}
```

Expected:

```text
audit actor = authenticated user
```

not the client-supplied value.

---

# 38. Audit Rollback Test

Perform:

```text
business operation
+
audit creation
```

Then force a transaction failure.

Expected:

```text
business operation rolled back
success audit event not committed
```

---

# 39. Audit Immutability Test

Normal application users must not be able to:

```text
UPDATE audit log
DELETE audit log
```

unless a specifically approved administrative process exists.

---

# 40. Validation Testing

Every validation rule in `VALIDATION_RULES.md` should have:

```text
valid input test
invalid input test
boundary test
missing-value test
wrong-type test
```

Examples:

```text
score = 0 → valid
score = 100 → valid
score = 101 → invalid

required name missing → invalid

invalid email → invalid
```

---

# 41. Boundary Testing

For numeric/range fields, test:

```text
minimum - 1
minimum
minimum + 1
maximum - 1
maximum
maximum + 1
```

This is especially important for:

```text
progress score
pagination limit
dates
string lengths
```

Only apply ranges explicitly defined by the validation specification.

---

# 42. Enum Testing

Every enum should test:

```text
each approved value
invalid value
missing value where required
case variation where applicable
```

Examples:

```text
PRESENT
ABSENT
EXCUSED
```

Invalid:

```text
PRESENTED
```

---

# 43. Duplicate Prevention Testing

Test duplicate scenarios for entities where uniqueness is required.

Examples:

```text
duplicate beneficiary identity
duplicate active enrollment
duplicate attendance
duplicate assignment
duplicate email
```

The exact uniqueness rules must follow the database schema and validation rules.

---

# 44. Analytics Testing

Analytics tests must verify:

```text
metric definition
filter behavior
date range
role access
scope
aggregation
unique beneficiary counting
zero-data behavior
N/A behavior
```

Do not test against invented KPIs.

The PRD identifies program, centre, organization, volunteer, attendance, progress, and impact-related analytics as platform capabilities. fileciteturn8file8L1524-L1609

---

# 45. Analytics Calculation Testing

For every metric:

```text
Known input dataset
        ↓
Expected calculation
        ↓
API response
        ↓
Compare expected vs actual
```

Use small deterministic datasets for calculation tests.

---

# 46. Analytics Scope Testing

Example:

```text
Program Lead A
    ↓
Program X
```

Analytics for Program X must not include unauthorized Program Y records.

For Executive Director:

```text
Organization analytics
```

should aggregate the authorized organizational dataset.

---

# 47. Analytics Empty-State Testing

Test:

```text
no records
zero denominator
no activities
no attendance
no progress
no programs
```

Expected behavior must follow `ANALYTICS_SPECIFICATION.md`.

For undefined rates, use:

```text
N/A
```

where the analytics specification requires it, rather than presenting a misleading percentage.

---

# 48. Report Testing

Reports should be tested for:

```text
correct dataset
correct filters
correct authorization
correct totals
correct date range
correct empty state
```

The PRD states that exact report formats are to be defined later. fileciteturn8file8L1613-L1633

Therefore report-format tests must only be written after the report specification is finalized.

---

# 49. Search Testing

Test:

```text
valid search
no-result search
partial search
case behavior
filters
pagination
scope
authorization
```

Most importantly:

```text
search must not bypass authorization.
```

---

# 50. Pagination Testing

Test:

```text
first page
middle page
last page
empty page
limit boundary
invalid page
invalid limit
large dataset
```

Verify:

```text
total count
current page
page size
returned records
```

according to the API contract.

---

# 51. Frontend Loading-State Testing

Verify that data-dependent pages correctly show:

```text
loading
success
empty
error
```

Do not show an empty state while data is still loading.

---

# 52. Frontend Form Testing

Test:

```text
required fields
invalid fields
valid submission
server validation error
duplicate submission prevention
success state
cancel behavior
```

---

# 53. Frontend Role Testing

Test that:

```text
Program Lead
→ sees Program Lead navigation

Volunteer
→ sees Volunteer navigation

Executive Director
→ sees Executive navigation
```

Do not use UI visibility tests as the only authorization tests.

Backend authorization tests are mandatory.

---

# 54. Frontend Protected Route Testing

Test:

```text
unauthenticated → /login
authenticated Program Lead → permitted routes
authenticated Volunteer → permitted routes
authenticated Executive Director → permitted routes
```

Attempt direct navigation to restricted routes and verify safe handling.

---

# 55. Mobile Testing

The PRD requires core workflows to be usable on mobile devices. fileciteturn8file1L168-L187

Test at minimum:

```text
login
dashboard
program list
beneficiary list
beneficiary registration
activity view
attendance
task completion
progress
```

Check:

```text
layout
forms
buttons
tables
navigation
scrolling
charts
touch targets
```

---

# 56. Accessibility Testing

Test:

```text
keyboard navigation
focus order
visible focus
form labels
validation messages
button names
table semantics
chart alternatives
color-independent status
responsive layout
```

Accessibility testing should be performed for core workflows.

---

# 57. Security Testing

Security tests should cover:

```text
authentication bypass
authorization bypass
scope bypass
privilege escalation
client-side role forgery
resource-ID manipulation
sensitive-field exposure
secret exposure
SQL injection protection
malicious input
```

The exact security controls must remain consistent with the authentication, authorization, API, and technical architecture specifications.

---

# 58. SQL Injection Testing

All user-controlled SQL parameters must be safely parameterized.

Test malicious values in:

```text
search
filters
IDs
names
descriptions
query parameters
```

Expected:

```text
no SQL execution injection
safe error/validation behavior
```

Because the project uses PostgreSQL directly, SQL injection testing is especially important at the database access layer.

---

# 59. API Input Security

Test:

```text
unexpected fields
extra JSON properties
wrong types
very long strings
malformed UUIDs
invalid dates
invalid enum values
nested unexpected objects
```

The backend must validate and safely reject unsupported inputs.

---

# 60. Sensitive Logging Test

Verify that application and audit logs do not contain:

```text
plain passwords
password hashes
authentication tokens
refresh tokens
database credentials
API keys
unnecessary beneficiary sensitive data
```

---

# 61. Performance Testing

Performance testing should focus on:

```text
dashboard load
beneficiary list
program list
search
analytics
reports
large historical datasets
```

The PRD expects the architecture to grow as beneficiaries, programs, centres, volunteers, and historical records increase. fileciteturn8file7L1229-L1237

---

# 62. Performance Test Strategy

Start with realistic datasets representing:

```text
multiple centres
multiple programs
multiple activities
many beneficiaries
many attendance records
historical progress
volunteer assignments
```

Measure:

```text
response time
database query time
API throughput where relevant
frontend rendering time
memory usage where relevant
```

Do not invent a hard production SLA unless one is approved.

---

# 63. Regression Testing

Every significant change should run regression tests for affected areas.

Examples:

```text
Database schema change
→ API + validation + integration tests

Authorization change
→ all role/scope security tests

Beneficiary change
→ beneficiary + enrollment + timeline + analytics tests

Analytics change
→ metric + API + dashboard tests
```

---

# 64. End-to-End Testing

E2E tests should focus on the most important business workflows rather than every possible UI path.

---

# 65. E2E — Program Lead Workflow

Test:

```text
Login
 ↓
Dashboard
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
Assign Task
 ↓
Record Attendance
 ↓
Track Progress
 ↓
View Analytics
```

This follows the core Program Lead flow defined by the PRD. fileciteturn8file7L1272-L1304

---

# 66. E2E — Volunteer Workflow

Test:

```text
Login
 ↓
Volunteer Dashboard
 ↓
View Assigned Program
 ↓
View Assigned Beneficiary
 ↓
View Activity / Task
 ↓
Conduct Activity
 ↓
Record Attendance
 ↓
Submit Activity Information
 ↓
View Relevant Progress
 ↓
Complete Task
```

This follows the defined Volunteer flow. fileciteturn8file7L1308-L1330

---

# 67. E2E — Executive Director Workflow

Test:

```text
Login
 ↓
Executive Dashboard
 ↓
Organization Analytics
 ↓
Centre Analytics
 ↓
Program Analytics
 ↓
Beneficiary Journey Overview
 ↓
Impact Analysis
 ↓
Reports
```

This follows the defined Executive Director flow. fileciteturn8file7L1334-L1353

---

# 68. Critical Path Tests

The following should be considered release-blocking:

```text
Login
Role authorization
Beneficiary registration
Unique beneficiary ID
Program creation
Activity creation
Program enrollment
Volunteer assignment
Task assignment
Attendance
Timeline
Basic analytics
Sensitive-data authorization
Auditability
```

These correspond closely to the MVP Definition of Done. fileciteturn8file1L168-L187

---

# 69. Test Data Strategy

Test data should be:

```text
synthetic
deterministic
non-sensitive
repeatable
isolated from production
```

Never copy real beneficiary records into development or automated tests without explicit approved handling.

---

# 70. Test Users

Create deterministic users for:

```text
Program Lead
Volunteer A
Volunteer B
Executive Director
```

Where scope testing is required:

```text
Centre A
Centre B
Program A
Program B
```

Example:

```text
Volunteer A → Program A
Volunteer B → Program B
```

This enables reliable scope-isolation tests.

---

# 71. Test Dataset

A representative dataset should include:

```text
2+ centres
2+ programs
multiple activities
multiple beneficiaries
multiple enrollments
attendance records
progress records
timeline events
volunteer assignments
tasks
audit logs
```

Do not create unnecessary test data that is unrelated to the scenario.

---

# 72. Database Test Isolation

Each integration test should ideally run against an isolated test database or isolated transaction/schema strategy.

Tests must not depend on execution order.

After tests:

```text
cleanup/reset
```

must leave a deterministic environment.

---

# 73. Environment Separation

At minimum distinguish:

```text
Development
Test
Production
```

Never run automated tests against the production database.

---

# 74. Test Database

The test environment should use PostgreSQL because PostgreSQL-specific behavior is part of the actual application architecture.

Do not replace PostgreSQL with an unrelated database for tests where database behavior matters.

---

# 75. Mocking Strategy

Mock external boundaries when necessary.

Good candidates:

```text
external services
email provider
third-party APIs
```

Do not unnecessarily mock:

```text
authorization logic
PostgreSQL constraints
core business logic
```

when integration behavior is what needs to be verified.

---

# 76. Test Naming

Tests should clearly express:

```text
given condition
when action
then expected result
```

Example:

```text
should reject beneficiary enrollment when an active enrollment already exists
```

Prefer behavior-oriented test names over implementation details.

---

# 77. Requirement Traceability

Major requirements should map to test cases.

Example:

```text
AUTH-001
User login
    ↓
AUTH-001-TEST

BEN-001
Register beneficiary
    ↓
BEN-001-TEST

BEN-002
Generate unique beneficiary ID
    ↓
BEN-002-TEST

PROG-001
Create program
    ↓
PROG-001-TEST

ATT-001
Record attendance
    ↓
ATT-001-TEST

ANL-001
Program analytics
    ↓
ANL-001-TEST
```

The PRD explicitly recommends unique requirement IDs and provides these example categories. fileciteturn8file4L654-L689

---

# 78. Definition of Done for a Feature

A feature should not be considered complete until applicable tests cover:

```text
Requirement
Business rule
Validation
Authorization
API
Database effect
Frontend behavior
Error handling
Audit
```

Not every item applies identically to every feature.

---

# 79. Pull Request Testing

Before opening a pull request, run the project's documented:

```text
tests
lint
build
```

The repository contribution guidance explicitly requires tests to pass, the project to build, and no secrets/credentials to be committed. fileciteturn8file9L1689-L1724

---

# 80. Pull Request Checklist

```text
[ ] Relevant tests added
[ ] Existing tests pass
[ ] Authorization tests pass
[ ] Validation tests pass
[ ] Database integration tests pass where applicable
[ ] Frontend tests pass where applicable
[ ] Build passes
[ ] Lint passes
[ ] No secrets committed
[ ] Documentation updated
```

---

# 81. Continuous Integration

The CI pipeline should eventually run:

```text
Install dependencies
        ↓
Lint
        ↓
Unit tests
        ↓
API/integration tests
        ↓
Frontend tests
        ↓
Build
```

Additional security/E2E jobs can be added according to project maturity.

The exact CI provider and commands are not defined by the current product documents.

---

# 82. Test Coverage

Coverage should be treated as a quality indicator, not the only measure of correctness.

Prioritize high coverage for:

```text
authorization
validation
core business logic
database integrity
analytics calculations
critical workflows
```

Avoid writing meaningless tests merely to increase a percentage.

No universal percentage target is defined by the current source documents.

---

# 83. Failure Triage

When a test fails:

```text
Identify failing requirement
        ↓
Identify affected layer
        ↓
Reproduce
        ↓
Determine root cause
        ↓
Fix implementation
        ↓
Add/update regression test
        ↓
Run affected suite
        ↓
Run broader regression
```

---

# 84. Regression Priority

Highest priority regression areas:

```text
Authentication
Authorization
Beneficiary identity
Enrollment
Attendance
Progress
Audit
Analytics
Database integrity
```

These areas affect multiple workflows and can create serious data/security problems if broken.

---

# 85. Test Reports

Test results should make it possible to identify:

```text
passed
failed
skipped
duration
failure reason
affected test
```

The exact reporting tool is not specified.

---

# 86. Test Environment Security

Test environments must not contain production secrets or real sensitive beneficiary data.

Use:

```text
test credentials
test database
synthetic beneficiaries
synthetic users
```

---

# 87. Open Testing Decisions

The current source documents do not define:

1. Exact test framework.
2. Exact frontend test library.
3. Exact API test library.
4. Exact E2E framework.
5. Exact CI provider.
6. Exact coverage threshold.
7. Exact performance SLA.
8. Exact browser/device support matrix.
9. Exact accessibility conformance target.
10. Exact report-format tests.
11. Exact production dataset size for load testing.

These should be finalized as implementation decisions rather than invented as product requirements.

---

# 88. MVP Testing Scope

The MVP testing effort must prioritize:

```text
Authentication
Role authorization
Core Program Lead workflow
Core Volunteer workflow
Executive Director analytics
Beneficiary identity
Program enrollment
Volunteer assignment
Tasks
Attendance
Timeline
Basic analytics
Sensitive-data protection
Auditability
Mobile usability
```

This matches the MVP Definition of Done in the PRD. fileciteturn8file1L168-L187

---

# 89. AI Coding Agent Testing Rules

Any AI coding agent working on Purnata must:

1. Read `PRD.md` before implementing a feature.
2. Read the relevant specification documents.
3. Identify the user role involved.
4. Identify the business requirement.
5. Identify affected entities/data.
6. Identify the API.
7. Identify authorization requirements.
8. Identify UI requirements.
9. Identify validation requirements.
10. Define success behavior.
11. Define failure behavior.
12. Add tests for new business logic.
13. Add authorization tests for new protected functionality.
14. Add validation tests for new validation rules.
15. Add integration tests when database behavior changes.
16. Add frontend tests when UI behavior changes.
17. Never change database relationships without approval.
18. Never change API contracts without updating the specification.
19. Never change authentication rules without approval.
20. Never broaden role permissions silently.
21. Never change beneficiary identity rules silently.

These rules follow the PRD's AI-agent development requirements. fileciteturn8file1L191-L232

---

# 90. Final Testing Model

```text
                  REQUIREMENTS
                       │
                       ▼
                  TEST CASES
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Frontend       API        Database
          │            │            │
          └────────────┼────────────┘
                       ▼
                 Integration
                       │
                       ▼
                     E2E
                       │
                       ▼
                 RELEASE CHECK
```

The purpose is not simply to prove that individual functions work.

The goal is to prove:

```text
Correct User
    +
Correct Permission
    +
Correct Scope
    +
Correct Data
    +
Correct Business Rule
    +
Correct UI
    +
Correct Audit Trail
    =
Correct Purnata Workflow
```

---

# 91. Final Quality Principle

Purnata testing must protect three things above all:

```text
1. Data Integrity
2. Sensitive-Data Security
3. Correct Beneficiary/Program Workflows
```

The platform is intended to become the single source of truth for beneficiary records, program participation, attendance, progress, volunteer assignments, timelines, and analytics. fileciteturn8file0L22-L38

Therefore, a feature is not considered reliable merely because its UI works.

It must also:

```text
validate correctly
authorize correctly
persist correctly
calculate correctly
audit correctly
fail safely
```

Any requirement that remains explicitly open in the source documents must remain open in the test strategy until stakeholders finalize it.
