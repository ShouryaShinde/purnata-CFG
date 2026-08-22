# AUTHENTICATION_AUTHORIZATION.md

# Purnata Digital Case & Program Management Platform

**Version:** 1.0  
**Status:** Implementation Specification  
**Parent Documents:** `PRD.md`, `USER_FLOWS.md`, `ACCESS_CONTROL_MATRIX.md`, `DATA_DICTIONARY.md`, `DATABASE_SCHEMA.md`, `API_SPECIFICATION.md`, `TECHNICAL_ARCHITECTURE.md`, `VALIDATION_RULES.md`, `AUDIT_LOGGING.md`

---

# 1. Purpose

This document defines the authentication and authorization architecture for Purnata.

The PRD requires:

- Login
- Logout
- Role-based access control
- Protected routes
- Session/token management
- Password security
- Unauthorized-access handling

The three MVP roles are:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

The PRD states that the exact authentication mechanism is to be defined by the technical architecture. fileciteturn6file1L330-L356

This document therefore defines the security behavior and authorization model while keeping any implementation decision that has not been explicitly approved as an open decision.

---

# 2. Security Goals

The authentication and authorization system must:

1. Verify the identity of every protected user.
2. Restrict functionality according to role.
3. Restrict records according to scope.
4. Protect sensitive beneficiary information.
5. Enforce authorization at the backend/API layer.
6. Prevent users from impersonating another user.
7. Prevent privilege escalation.
8. Prevent unauthorized cross-centre or cross-program access.
9. Support secure login and logout.
10. Support protected frontend routes.
11. Support protected backend endpoints.
12. Support field-level restrictions where required.
13. Integrate with audit logging for important/security-sensitive actions.
14. Keep authentication secrets out of normal API responses.
15. Preserve the principle of minimum necessary access.

The PRD explicitly states that users should access only information required for their role and that frontend-only restrictions are insufficient. fileciteturn6file7L1237-L1249

---

# 3. Authentication vs Authorization

These are separate concepts.

## Authentication

Answers:

```text
Who are you?
```

Example:

```text
email + valid credentials
        ↓
authenticated user
```

## Authorization

Answers:

```text
What are you allowed to do?
```

Example:

```text
authenticated user
        ↓
role = VOLUNTEER
        ↓
assigned activity
        ↓
attendance permission
```

The Access Control Matrix explicitly separates these concepts. fileciteturn6file4L861-L897

---

# 4. Core Authorization Model

Purnata follows:

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

A user receives access only when all required conditions are satisfied. fileciteturn6file6L1154-L1182

This can be summarized as:

```text
ROLE + SCOPE = ACCESS
```

Role alone is not sufficient.

---

# 5. MVP Roles

The platform contains three primary roles:

```text
PROGRAM_LEAD
VOLUNTEER
EXECUTIVE_DIRECTOR
```

No additional role should be introduced without an approved product/security decision.

The Access Control Matrix identifies these as the MVP roles. fileciteturn6file3L570-L578

---

# 6. Program Lead

The Program Lead is responsible for operational management.

Main responsibilities include:

```text
Create programs
Manage programs
Manage activities
Register beneficiaries
Manage beneficiaries
Generate/manage beneficiary IDs
Assign volunteers
Assign tasks
Track timelines
Monitor participation
Review progress
View program analytics
```

These responsibilities are defined in the PRD. fileciteturn6file1L240-L261

---

# 7. Volunteer

The Volunteer supports beneficiaries within assigned scope.

Main responsibilities include:

```text
View assigned programs
View assigned beneficiaries
View assigned tasks
View assigned activities
Conduct assigned activities
Record attendance
Update activity-related information
View relevant beneficiary progress
View beneficiary timelines where permitted
Review own performance
```

These responsibilities are defined in the PRD. fileciteturn6file1L265-L280

---

# 8. Executive Director

The Executive Director provides organizational oversight.

Main responsibilities include:

```text
Organization analytics
Centre analytics
Program analytics
Beneficiary journey overview
Program performance
Impact review
Reports
Strategic decision-making
```

These responsibilities are defined in the PRD. fileciteturn6file1L284-L299

---

# 9. Authentication Requirements

The MVP requires:

```text
LOGIN
LOGOUT
PROTECTED ROUTES
SESSION/TOKEN MANAGEMENT
PASSWORD SECURITY
UNAUTHORIZED ACCESS HANDLING
```

All three MVP roles must be able to authenticate before the product can be considered functionally complete. fileciteturn6file2L463-L484

---

# 10. Authentication Flow

The conceptual login flow is:

```text
User
  ↓
Login Form
  ↓
POST /api/auth/login
  ↓
Validate Credentials
  ↓
Authenticate User
  ↓
Create Authenticated Session/Token
  ↓
Return Safe User/Auth Response
  ↓
Frontend Stores Auth State
  ↓
Protected Application
```

The exact session/token implementation remains an implementation decision and must be finalized before coding.

---

# 11. Login Request

Conceptual request:

```http
POST /api/auth/login
Content-Type: application/json
```

```json
{
  "email": "user@example.com",
  "password": "user-password"
}
```

The password must be transmitted only over a secure transport connection in deployed environments.

---

# 12. Login Validation

The backend must validate:

```text
email
password
```

Rules:

- Email must be valid.
- Required fields must be present.
- Credentials must be checked against the stored user account.
- Passwords must never be compared as plain-text stored values.
- The account must satisfy the approved active-account rule.
- Authentication failures must not expose whether unrelated sensitive account information exists beyond the approved behavior.

---

# 13. Password Security

Passwords must be stored using a strong password-hashing mechanism.

The system must never store or return:

```text
plain-text password
```

The exact password hashing library/configuration is an implementation decision to be finalized during backend implementation.

The password hash must remain server-side.

---

# 14. Authentication Response

A successful login response should contain only information necessary for authenticated application operation.

Conceptually:

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "fullName": "User Name",
      "email": "user@example.com",
      "role": "PROGRAM_LEAD"
    }
  }
}
```

The response must never contain:

```text
password
passwordHash
database credentials
internal secrets
```

The exact token/session response shape must be finalized with the chosen authentication mechanism.

---

# 15. Authentication State

After successful authentication, the application needs to know at minimum:

```text
authenticated
userId
role
```

Where required by the implementation, it may also need:

```text
centre scope
session/token state
permissions
```

The backend remains the authoritative source for authorization.

---

# 16. Session / Token Management

The PRD requires session/token management but does not prescribe a specific mechanism. fileciteturn6file1L338-L356

Therefore the implementation must explicitly select one approved approach, such as:

```text
server-side session
```

or:

```text
signed access token
```

The project must not mix incompatible approaches without a clear security design.

---

# 17. Authentication Mechanism Decision

Current status:

```text
EXACT AUTHENTICATION MECHANISM = OPEN IMPLEMENTATION DECISION
```

Before implementation, finalize:

```text
Session vs token strategy
Token/session lifetime
Refresh strategy, if applicable
Storage mechanism
Logout invalidation behavior
Secret/key management
```

This document must not silently treat one option as a finalized product requirement.

---

# 18. Protected Routes

Frontend routes that require authentication must be protected.

Conceptually:

```text
User opens protected route
        ↓
Authenticated?
     ├── NO → Login
     └── YES
            ↓
        Check role/access
            ↓
        Render route
```

Frontend protection is a user-experience mechanism.

It does not replace backend authorization.

---

# 19. Backend Protected Endpoints

Every protected endpoint must specify:

```text
Authentication Required
Role(s)
Scope Rule
Allowed Action
```

The Access Control Matrix explicitly requires this endpoint-level definition. fileciteturn6file9L1744-L1766

Example:

```text
POST /api/programs

Authentication: Required
Allowed Role: PROGRAM_LEAD
Action: CREATE
Scope: Authorized Centre
```

---

# 20. Authentication Middleware

Recommended backend middleware:

```text
authenticate
```

Responsibilities:

1. Read the approved authentication credential/session.
2. Validate it.
3. Identify the user.
4. Load or establish the user's role.
5. Attach trusted user identity to the request context.
6. Reject unauthenticated requests.

Conceptual:

```text
Request
  ↓
Authentication Middleware
  ↓
request.user
  ↓
Authorization Middleware
```

---

# 21. Request Identity

After authentication, the backend should establish a trusted identity object.

Conceptually:

```js
req.user = {
  id: userId,
  role: userRole
}
```

Additional scope information may be included if appropriate.

The client must not be able to overwrite this trusted identity.

---

# 22. Unauthorized vs Unauthenticated

These must be distinguished.

## Unauthenticated

The user has not successfully authenticated.

Conceptually:

```http
401 Unauthorized
```

Use when authentication credentials are missing or invalid, according to the final API contract.

## Unauthorized Action / Forbidden

The user is authenticated but lacks permission or scope.

Conceptually:

```http
403 Forbidden
```

The Access Control Matrix explicitly specifies `403 Forbidden` for unauthorized operations. fileciteturn6file0L15-L37

---

# 23. Authorization Middleware

Recommended backend middleware:

```text
authorize
```

It should verify:

```text
authenticated user
        ↓
role
        ↓
required permission
```

But role-level middleware alone is insufficient for scoped resources.

---

# 24. Resource Scope Authorization

For resource-level authorization:

```text
Authenticate
    ↓
Identify User
    ↓
Identify Role
    ↓
Identify Resource
    ↓
Identify Requested Action
    ↓
Check Scope
    ↓
Allow / Deny
```

This is the authorization decision flow defined by the Access Control Matrix. fileciteturn6file4L832-L857

---

# 25. Scope Principle

Example:

```text
Volunteer A
    ↓
Program X
    ↓
Beneficiary 101
```

If Volunteer A is assigned to Program X and the approved access rules allow the relationship:

```text
Beneficiary 101 → accessible
```

But:

```text
Volunteer A
    ↓
Program Y
    ↓
Beneficiary 205
```

without an appropriate assignment:

```text
Access → denied
```

This is explicitly defined by the Access Control Matrix. fileciteturn6file4L794-L828

---

# 26. Permission Inheritance Rule

Access to a parent resource does not automatically grant access to every child resource.

Example:

```text
Volunteer
    ↓
Can view Program X
```

does not automatically mean:

```text
Can view every beneficiary in Program X
```

Beneficiary access must be checked separately according to the approved rules. fileciteturn6file0L41-L61

---

# 27. Field-Level Authorization

Some records contain different sensitivity levels.

Example:

```text
Beneficiary
├── Basic Information
├── Program Information
├── Attendance
├── Progress
└── Sensitive Case Information
```

A Volunteer may receive:

```text
Basic Information
Program Information
Attendance
Relevant Progress
```

while restricted case information may not be returned.

The exact sensitive fields must be finalized in `DATA_DICTIONARY.md`. fileciteturn6file9L1606-L1634

---

# 28. Program Lead Authorization

The Access Control Matrix gives the Program Lead broad operational permissions.

High-level:

```text
Programs          → Full
Activities        → Full
Beneficiaries     → Full
Enrollments       → Full
Timeline          → Full
Volunteers        → Full
Assignments       → Full
Tasks             → Full
Attendance        → Full
Progress          → Full
Program Analytics → Full
Centre Analytics  → Relevant
Reports           → Program-level
Audit Logs        → Relevant
```

These permissions remain subject to scope and the open questions in the Access Control Matrix. fileciteturn6file3L630-L650

---

# 29. Volunteer Authorization

High-level:

```text
Programs          → Assigned Read
Activities        → Assigned Read/Update
Beneficiaries     → Assigned Read
Enrollments       → Assigned Read
Timeline          → Limited
Volunteers        → Own Profile
Assignments       → Own/Assigned Read
Tasks             → Own Tasks
Attendance        → Assigned Activity
Progress          → Relevant/Assigned
Program Analytics → Limited/Own
Centre Analytics  → No
Organization      → No
Reports           → No
Audit Logs        → Own Actions
```

The exact field and timeline restrictions remain open where the Access Control Matrix marks them for stakeholder confirmation. fileciteturn6file3L630-L650

---

# 30. Executive Director Authorization

High-level:

```text
Programs          → Read
Activities        → Read
Beneficiaries     → Authorized Read
Enrollments       → Read
Timeline          → Authorized Read
Volunteers        → Read
Assignments       → Read
Tasks             → Read
Attendance        → Read
Progress          → Read
Program Analytics → Full
Centre Analytics  → Full
Organization      → Full
Reports           → Full
Audit Logs        → Authorized
```

The exact access to individual beneficiary fields remains an open stakeholder decision.

---

# 31. Permission Naming

The backend should use a consistent permission naming convention:

```text
RESOURCE_ACTION
```

Examples:

```text
PROGRAM_CREATE
PROGRAM_READ
PROGRAM_UPDATE

BENEFICIARY_CREATE
BENEFICIARY_READ
BENEFICIARY_UPDATE

ACTIVITY_CREATE
ACTIVITY_READ
ACTIVITY_UPDATE

VOLUNTEER_ASSIGN

TASK_CREATE
TASK_UPDATE

ATTENDANCE_CREATE
ATTENDANCE_READ

ANALYTICS_PROGRAM_READ
ANALYTICS_CENTRE_READ
ANALYTICS_ORGANIZATION_READ
```

The final permission list should be maintained centrally. fileciteturn6file0L108-L145

---

# 32. Central Permission Definition

Permissions should not be scattered throughout controllers.

Recommended conceptual structure:

```text
permissions/
    permissions.js
```

or:

```text
auth/
    permissions.js
```

The exact folder structure is an implementation choice.

The important requirement is a single maintainable permission definition.

---

# 33. Authorization Middleware Example

Conceptual flow:

```text
requireAuth
      ↓
requirePermission(PROGRAM_CREATE)
      ↓
checkProgramScope
      ↓
Controller
```

For resource-level access:

```text
requireAuth
      ↓
requirePermission(BENEFICIARY_READ)
      ↓
checkBeneficiaryScope
      ↓
selectPermittedFields
      ↓
Controller
```

---

# 34. Database-Level Scope Enforcement

Scope should be enforced in the backend query itself wherever possible.

For example, a Volunteer beneficiary query should conceptually be:

```text
Find beneficiary
+
Verify assignment relationship
+
Return only permitted fields
```

Do not:

```text
SELECT beneficiary
→ then check authorization after returning the full record
```

The query/service boundary should prevent unauthorized data from becoming application-visible.

---

# 35. Example — Volunteer Beneficiary Access

Request:

```http
GET /api/beneficiaries/:beneficiaryId
```

Flow:

```text
Authenticate
    ↓
User = Volunteer A
    ↓
Role = VOLUNTEER
    ↓
Check beneficiary assignment
    ↓
Authorized?
   ├── NO → 403
   └── YES
          ↓
      Select permitted fields
          ↓
      Return response
```

This matches the backend authorization example in the Access Control Matrix. fileciteturn6file9L1574-L1602

---

# 36. Authorization Must Not Trust Request Body

The backend must not trust client fields such as:

```json
{
  "userId": "some-other-user",
  "role": "EXECUTIVE_DIRECTOR",
  "centreId": "unauthorized-centre"
}
```

for determining the caller's authority.

Authority must come from:

```text
authenticated identity
server-side user record
approved authorization rules
resource scope
```

---

# 37. Preventing Role Escalation

A normal user must not be able to:

```text
change own role
change another user's role
assign themselves Executive Director privileges
modify authorization rules
```

unless an explicitly approved administrative capability exists.

User management is currently outside the MVP unless explicitly approved. fileciteturn6file3L648-L652

---

# 38. Centre Scope

Centre scope is currently not completely finalized.

Open questions include:

```text
Can Program Leads access beneficiaries from every centre
or only assigned centres?

Can one Program Lead manage multiple centres?
```

These questions are explicitly listed in the Access Control Matrix. fileciteturn6file6L1130-L1150

Therefore the implementation must not silently assume a multi-centre rule.

---

# 39. Program Scope

For Program Lead:

```text
Program
   ↓
Authorized operational scope
```

For Volunteer:

```text
Program
   ↓
Assignment
   ↓
Accessible program
```

For Executive Director:

```text
Organization scope
```

subject to field-level and beneficiary-specific authorization rules.

---

# 40. Activity Scope

Activity access should consider:

```text
activity
program
centre
volunteer assignment
requested action
```

A Volunteer should only access activities within their approved assigned scope.

---

# 41. Attendance Authorization

Recording attendance requires:

```text
authenticated user
        ↓
role permits attendance recording
        ↓
activity is in user's authorized scope
        ↓
beneficiary is eligible for the activity
        ↓
record attendance
```

The Access Control Matrix permits Program Leads and Volunteers on assigned activities to record attendance. fileciteturn5file3L1624-L1637

---

# 42. Progress Authorization

Progress access follows the same model:

```text
authenticated user
        ↓
role
        ↓
program/activity/beneficiary scope
        ↓
field-level permission
        ↓
read/create/update
```

Volunteers receive relevant/assigned progress, while Program Leads have broader operational access. fileciteturn6file3L630-L650

---

# 43. Timeline Authorization

The current rules are:

```text
Program Lead → Full operational timeline access
Volunteer → Limited access / activity-related entries
Executive Director → Authorized read
```

The Access Control Matrix also identifies whether volunteers can see the full timeline as an open question. fileciteturn5file9L1757-L1779

---

# 44. Analytics Authorization

Analytics endpoints must be protected like operational endpoints.

Example:

```text
GET /analytics/programs/:programId
```

must check:

```text
authentication
role
permission
program scope
```

A user must not access analytics simply by knowing a valid program UUID.

---

# 45. Report Authorization

Reports must also be scoped.

High-level:

```text
Program Lead → Program-level reports
Volunteer → No reports
Executive Director → Organization/centre/program reports
```

The exact export permissions remain open in the Access Control Matrix. fileciteturn6file4L734-L744

---

# 46. Search Authorization

Search must never bypass scope.

Program Lead can search within authorized operational scope.

Volunteer can search only within assigned scope.

Volunteer must not have unrestricted global beneficiary search.

Executive Director can search authorized organizational records.

These rules are explicitly defined in the Access Control Matrix. fileciteturn6file4L748-L790

---

# 47. API Security Boundary

The backend is the authoritative security boundary.

Frontend controls such as:

```text
hidden button
hidden navigation item
disabled form
```

are not authorization.

The Access Control Matrix explicitly requires backend enforcement. fileciteturn6file3L558-L566

---

# 48. Frontend Authorization

The React application should use authenticated role information to:

- Show appropriate navigation.
- Hide unavailable actions.
- Redirect unauthorized users.
- Avoid unnecessary API requests.

These are UX responsibilities.

The frontend must not assume that a visible action is authorized merely because the UI displays it.

---

# 49. Frontend Role Routes

## Program Lead

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

## Volunteer

```text
/dashboard
/my-programs
/my-beneficiaries
/my-activities
/my-tasks
/my-performance
```

## Executive Director

```text
/dashboard
/organization-analytics
/centre-analytics
/program-analytics
/beneficiary-journey
/reports
```

These are conceptual route groups based on the defined role workflows.

---

# 50. Logout

The logout flow should:

```text
User selects Logout
        ↓
Frontend requests logout if required by auth mechanism
        ↓
Server invalidates session/token state where applicable
        ↓
Frontend clears authenticated state
        ↓
Redirect to Login
```

Exact invalidation behavior depends on the selected session/token strategy.

---

# 51. Token/Session Expiration

The implementation must define:

```text
session/token lifetime
expiration behavior
renewal/refresh behavior, if applicable
```

These values are currently not specified by the source documents.

Do not invent production security values in this product specification.

---

# 52. Expired Authentication

If an authenticated request becomes invalid because the session/token expires:

```text
API
   ↓
authentication failure
   ↓
401
```

Frontend behavior:

```text
clear invalid auth state
redirect to login
```

The exact API error contract must remain consistent with `API_SPECIFICATION.md`.

---

# 53. Invalid Credentials

Invalid login credentials should result in an authentication failure.

The response should not reveal unnecessary information about account existence.

Example:

```text
Invalid email or password.
```

The exact error wording is an implementation/security decision.

---

# 54. Unauthorized Resource Access

When an authenticated user lacks authorization:

```http
403 Forbidden
```

Frontend should display a clear message without revealing sensitive resource information.

The Access Control Matrix explicitly requires this behavior. fileciteturn6file0L15-L37

---

# 55. Sensitive Data Protection

Beneficiary information may contain sensitive personal information.

The PRD requires:

```text
minimum necessary access
API authorization
no frontend-only security
auditable data access
```

fileciteturn6file7L1237-L1249

Authorization must therefore apply before returning sensitive fields.

---

# 56. Authentication Secrets

The following must never be exposed through normal API responses:

```text
password
passwordHash
session secret
token signing secret
database password
API keys
```

Secrets must be stored through secure environment/configuration management.

---

# 57. HTTPS

Production authentication credentials and authenticated API traffic must use secure transport.

Conceptually:

```text
Browser
   ↓
HTTPS
   ↓
Node.js / Express API
```

The exact production certificate/hosting configuration is outside this document.

---

# 58. CORS

The backend should restrict allowed frontend origins according to the deployment environment.

Production should not use unrestricted origins unless there is an explicitly approved reason.

The exact frontend origin configuration belongs in deployment/environment configuration.

---

# 59. Authentication Rate Limiting

The source documents do not explicitly specify rate limiting.

Therefore:

```text
Authentication rate limiting = recommended security implementation
```

but not a finalized product requirement in this document.

Before production, the team should decide the exact policy for:

```text
login attempts
lockout/throttling
security monitoring
```

---

# 60. Password Reset

The current PRD requires login/logout/password security but does not define a password-reset workflow.

Therefore:

```text
Password Reset = Open Product/Technical Decision
```

Do not implement an unapproved reset workflow as a required MVP feature.

---

# 61. Account Recovery

Account recovery is not defined in the current source documents.

Any recovery mechanism must be separately specified before implementation.

---

# 62. User Management

User management is outside the current MVP unless explicitly approved.

The Access Control Matrix states:

```text
User Management → No*
```

with the note that it is outside the MVP unless explicitly approved. fileciteturn6file3L630-L652

Therefore authentication implementation should not automatically expand into a full admin user-management system.

---

# 63. Authorization and Database Queries

Authorization must be integrated with PostgreSQL access.

For example:

```text
Volunteer requests beneficiary
        ↓
Check assignment relationship
        ↓
Query permitted beneficiary
```

Do not retrieve unrestricted data first and filter it only in React.

---

# 64. Parameterized Queries

All authorization-related SQL must use parameterized queries.

Conceptually:

```js
await pool.query(
  `
  SELECT b.*
  FROM beneficiaries b
  JOIN program_enrollments pe
    ON pe.beneficiary_id = b.id
  JOIN volunteer_assignments va
    ON va.program_id = pe.program_id
  WHERE b.id = $1
    AND va.volunteer_id = $2
  `,
  [beneficiaryId, authenticatedUserId]
);
```

The exact SQL must match the finalized schema.

---

# 65. Authorization Query Principle

A secure query should answer:

```text
Does this authenticated user have access to this resource?
```

rather than:

```text
Does this resource exist?
```

for sensitive resources where existence itself may be restricted.

---

# 66. Authorization and Resource Existence

The API must avoid leaking sensitive information through different errors where policy requires generic handling.

For example, an unauthorized user should not necessarily learn:

```text
"Beneficiary 101 exists but belongs to another centre."
```

Instead, the API should return the appropriate generic authorization/resource response according to the final security policy.

---

# 67. Authentication Audit Integration

Authentication/security events may be audited according to `AUDIT_LOGGING.md`.

Potential events:

```text
LOGIN_SUCCESS
LOGIN_FAILURE
LOGOUT
UNAUTHORIZED_ACCESS_ATTEMPT
```

The exact final audit event list is still subject to the audit policy.

---

# 68. Authorization Audit Integration

Important authorization/security events may also be audited.

Example:

```text
Sensitive Record Accessed
```

The Access Control Matrix identifies sensitive record access as an auditable action. fileciteturn6file9L1662-L1690

The exact conditions for logging reads remain an open decision.

---

# 69. Authorization Error Format

The API should use the standard error structure from `API_SPECIFICATION.md`.

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

Sensitive resource details must not be included.

---

# 70. Authentication Error Format

Conceptually:

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHENTICATED",
    "message": "Authentication is required."
  }
}
```

The exact API error codes must remain consistent with the final API specification.

---

# 71. Permission Check Sequence

Recommended backend sequence:

```text
1. Authenticate
        ↓
2. Identify user
        ↓
3. Identify role
        ↓
4. Identify permission
        ↓
5. Identify resource
        ↓
6. Check scope
        ↓
7. Check field-level access
        ↓
8. Validate business operation
        ↓
9. Execute
```

This keeps authorization before sensitive data access.

---

# 72. Example — Create Program

```text
POST /api/programs
        ↓
Authenticate
        ↓
Role = PROGRAM_LEAD?
        ↓
Permission = PROGRAM_CREATE?
        ↓
Centre in authorized scope?
        ↓
Validate program
        ↓
Create program
        ↓
Audit
        ↓
Response
```

If role fails:

```text
403
```

---

# 73. Example — Volunteer Attendance

```text
POST /api/activities/:activityId/attendance
        ↓
Authenticate
        ↓
Role = VOLUNTEER or PROGRAM_LEAD?
        ↓
Permission = ATTENDANCE_CREATE?
        ↓
Activity in authorized scope?
        ↓
Beneficiary eligible?
        ↓
Validate attendance
        ↓
Create record
        ↓
Audit
        ↓
Response
```

---

# 74. Example — Executive Analytics

```text
GET /api/analytics/organization
        ↓
Authenticate
        ↓
Role = EXECUTIVE_DIRECTOR?
        ↓
Permission = ANALYTICS_ORGANIZATION_READ?
        ↓
Organization scope
        ↓
Analytics query
        ↓
Response
```

Program Leads and Volunteers must not receive unrestricted organization analytics.

---

# 75. Example — Volunteer Program Access

```text
GET /api/programs/:programId
        ↓
Authenticate
        ↓
Role = VOLUNTEER
        ↓
Permission = PROGRAM_READ
        ↓
Check volunteer assignment
        ↓
Assigned?
  ├── NO → 403
  └── YES → Return permitted fields
```

This follows the Access Control Matrix rule that volunteers can only view assigned programs or programs required for assigned work. fileciteturn6file3L684-L697

---

# 76. Authentication Testing

Authentication tests must include:

```text
valid login
invalid password
invalid email
missing credentials
inactive account
expired session/token
logout
protected endpoint without authentication
```

---

# 77. Authorization Testing

Authorization tests must cover:

```text
correct role
incorrect role
correct scope
incorrect scope
resource ownership
field-level restrictions
cross-centre access
cross-program access
analytics restrictions
report restrictions
audit-log restrictions
```

---

# 78. Role Matrix Test

Minimum test cases:

| Role | Correct Access | Incorrect Access |
|---|---|---|
| Program Lead | Program CRUD | Organization analytics |
| Volunteer | Assigned activities | Unrelated beneficiary |
| Executive Director | Organization analytics | Operational create/update |

The exact expected behavior must follow the Access Control Matrix.

---

# 79. Scope Isolation Test

Given:

```text
Volunteer A → Program X
Volunteer B → Program Y
```

Volunteer A must not access:

```text
Program Y
Beneficiaries only accessible through Program Y
Activities only accessible through Program Y
```

unless another approved assignment grants access.

---

# 80. Field-Level Test

Given a beneficiary with:

```text
Basic Information
Program Information
Attendance
Progress
Sensitive Case Information
```

Volunteer response should include only fields approved for Volunteer access.

Sensitive case information must not leak through:

```text
GET response
search
analytics
reports
error messages
```

---

# 81. Privilege Escalation Test

Attempt:

```text
PATCH /users/me
{
  "role": "EXECUTIVE_DIRECTOR"
}
```

Expected:

```text
Rejected
```

No privilege escalation should occur.

---

# 82. Client Forgery Test

Attempt to submit:

```json
{
  "createdBy": "another-user"
}
```

Expected:

```text
backend uses authenticated user
```

not:

```text
client-supplied user
```

---

# 83. Token/Session Forgery Test

If token-based authentication is selected:

```text
modified token
expired token
invalid signature
missing token
```

must not authenticate the user.

If session-based authentication is selected, equivalent session-integrity tests must be performed.

---

# 84. Logout Test

After logout:

```text
authenticated state cleared
```

and the previous authentication mechanism must no longer provide access according to the selected session/token strategy.

---

# 85. Security Test — Unauthenticated API

Request:

```http
GET /api/beneficiaries
```

without authentication.

Expected:

```http
401 Unauthorized
```

No beneficiary data should be returned.

---

# 86. Security Test — Forbidden API

Authenticated Volunteer attempts:

```http
POST /api/programs
```

Expected:

```http
403 Forbidden
```

No program should be created.

---

# 87. Security Test — Cross-Scope Access

Volunteer assigned to Program A attempts to access Program B.

Expected:

```text
403 Forbidden
```

or another approved authorization response that does not leak sensitive information.

---

# 88. Security Test — Sensitive Fields

Volunteer requests a beneficiary record.

Expected:

```text
permitted fields only
```

No restricted case information should appear.

---

# 89. Security Test — Audit

Important successful changes must produce the expected audit event according to `AUDIT_LOGGING.md`.

Unauthorized operations must not create misleading successful business-action audit events.

---

# 90. AI Coding Agent Rules

Any AI coding agent implementing authentication or authorization must:

1. Read `PRD.md`.
2. Read `USER_FLOWS.md`.
3. Read `ACCESS_CONTROL_MATRIX.md`.
4. Read `DATABASE_SCHEMA.md`.
5. Read `API_SPECIFICATION.md`.
6. Read `TECHNICAL_ARCHITECTURE.md`.
7. Read `VALIDATION_RULES.md`.
8. Read `AUDIT_LOGGING.md`.
9. Never invent new roles.
10. Never silently broaden permissions.
11. Never implement authorization only in the frontend.
12. Enforce authorization at the backend/API layer.
13. Respect resource scope.
14. Respect field-level restrictions.
15. Derive actor identity from authenticated context.
16. Never trust client-supplied role/user identity.
17. Never expose passwords, hashes, tokens, or secrets.
18. Ask for clarification when a permission is undefined.
19. Update the appropriate specification when an approved security rule changes.

These rules align with the explicit AI-agent requirements in the Access Control Matrix. fileciteturn6file0L91-L104

---

# 91. Open Authentication Decisions

The current source documents do not finalize:

1. Session vs token authentication.
2. Token/session lifetime.
3. Refresh-token strategy, if applicable.
4. Client-side credential storage strategy.
5. Logout invalidation mechanism.
6. Password hashing library/configuration.
7. Password reset flow.
8. Account recovery flow.
9. Login rate limiting.
10. Account lockout/throttling policy.
11. Exact active-account definition.
12. Authentication security event list.

These must be finalized before production implementation.

---

# 92. Open Authorization Decisions

The Access Control Matrix explicitly identifies these unresolved questions:

1. Can volunteers see the full beneficiary timeline?
2. Which beneficiary fields can volunteers see?
3. Can volunteers edit activity notes after submission?
4. Can volunteers correct attendance records?
5. Can Program Leads access beneficiaries from every centre or only assigned centres?
6. Can one Program Lead manage multiple centres?
7. Can the Executive Director see all beneficiary-level information?
8. Who can archive beneficiaries?
9. Who can archive programs?
10. Should Program Leads be able to delete activities?
11. Can volunteers see volunteer performance analytics?
12. Can Program Leads export reports?
13. Can volunteers export anything?
14. Which actions require audit logging?
15. Are additional administrative roles planned?

These questions must be resolved before the permission model is marked final. fileciteturn6file6L1130-L1150

---

# 93. MVP Security Scope

The MVP must include:

```text
Login
Logout
Authentication
Role-based authorization
Protected frontend routes
Protected backend APIs
Resource scope checks
Sensitive-data protection
Unauthorized-access handling
Important-action auditability
```

The PRD lists authentication and role-based authorization in MVP scope and requires all three roles to authenticate. fileciteturn6file7L1339-L1381

---

# 94. Security Out of Scope / Future

The PRD does not require the MVP to include:

```text
Public beneficiary portal
Public registration
Automated beneficiary decisions
Advanced AI recommendations
Predictive analytics
Offline-first authentication workflows
External identity integrations
```

These should not be silently introduced into the authentication architecture.

The PRD explicitly places several advanced capabilities in future scope. fileciteturn6file7L1384-L1400

---

# 95. Final Authentication & Authorization Architecture

```text
                         USER
                          │
                          ▼
                    LOGIN / AUTH
                          │
                          ▼
                  AUTHENTICATED USER
                          │
                          ▼
                         ROLE
                          │
             ┌────────────┼────────────┐
             ▼            ▼            ▼
       PROGRAM_LEAD   VOLUNTEER   EXECUTIVE_DIRECTOR
             │            │            │
             └────────────┼────────────┘
                          ▼
                      PERMISSION
                          │
                          ▼
                        SCOPE
                          │
                          ▼
                      RESOURCE
                          │
                          ▼
                        ACTION
                          │
                   ┌──────┴──────┐
                   ▼             ▼
                ALLOW           DENY
                   │             │
                   ▼             ▼
             Business       403 Forbidden
             Operation
                   │
                   ▼
                Audit
```

---

# 96. Final Security Principle

Purnata's security model is:

```text
AUTHENTICATE
      ↓
IDENTIFY USER
      ↓
IDENTIFY ROLE
      ↓
CHECK PERMISSION
      ↓
CHECK SCOPE
      ↓
CHECK RESOURCE
      ↓
CHECK ACTION
      ↓
CHECK FIELD ACCESS
      ↓
EXECUTE
      ↓
AUDIT IMPORTANT ACTION
```

The most important rule is:

```text
Frontend restrictions improve UX.
Backend authorization provides security.
```

The authorization model must therefore be enforced consistently across:

```text
React
   ↓
Express API
   ↓
Authorization Middleware
   ↓
Services
   ↓
PostgreSQL Queries
```

Sensitive beneficiary information must remain protected through minimum-necessary access, resource scope, field-level restrictions where required, and backend enforcement. fileciteturn6file7L1237-L1249

The final implementation must follow the project's source-of-truth hierarchy:

```text
Stakeholder Decision
        ↓
Approved PRD
        ↓
Approved API / Data / Architecture Documents
        ↓
Approved UI Specifications
        ↓
Existing Implementation
        ↓
Developer Assumptions
```

If an important authentication or authorization requirement is ambiguous, the implementation must seek clarification rather than silently inventing behavior. fileciteturn6file8L1479-L1497
