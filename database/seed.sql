--
-- PostgreSQL database dump
--

\restrict SGQlPfbHtoOgf48cdQkscqv2is96k3gU3N1QUtGOPdOoikPTaoSx4LZ1jFhhTSg

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-08-22 22:22:49

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5240 (class 0 OID 24895)
-- Dependencies: 220
-- Data for Name: centres; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.centres (id, name, address, city, state, contact_number, status, created_at, updated_at) FROM stdin;
86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	Purnata Pune Centre	Shivajinagar	Pune	Maharashtra	9876543201	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
83c42a87-bdfc-40a3-9290-4b3878aff98c	Purnata Mumbai Centre	Andheri East	Mumbai	Maharashtra	9876543202	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
f7aa77b0-e584-43f0-85c5-0dc88c643725	Purnata Nashik Centre	College Road	Nashik	Maharashtra	9876543203	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
8106ff55-c7c2-43b3-9afc-b272c2752ff4	Purnata Nagpur Centre	Dharampeth	Nagpur	Maharashtra	9876543204	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
a41ccdd8-a448-45b4-85de-3053a3f4fd91	Purnata Aurangabad Centre	CIDCO	Aurangabad	Maharashtra	9876543205	INACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5241 (class 0 OID 24915)
-- Dependencies: 221
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, full_name, email, password_hash, role, phone, centre_id, status, created_at, updated_at) FROM stdin;
513c824a-d636-4e6a-9efa-335b9e765ea9	Anita Sharma	anita@purnata.org	$2b$10$dummyhash001	PROGRAM_LEAD	9000000001	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
c7283e28-af26-451a-ac2c-cc2ab89d83d8	Rahul Patil	rahul@purnata.org	$2b$10$dummyhash002	PROGRAM_LEAD	9000000002	83c42a87-bdfc-40a3-9290-4b3878aff98c	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
6513c3a6-e813-4f44-b3b5-30714afce17d	Sneha Joshi	sneha@purnata.org	$2b$10$dummyhash003	PROGRAM_LEAD	9000000003	f7aa77b0-e584-43f0-85c5-0dc88c643725	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
868b7aff-7f02-49a0-9baf-4fbb761ab499	Amit Kulkarni	amit@purnata.org	$2b$10$dummyhash004	VOLUNTEER	9000000004	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
cd8891ea-318a-48ed-9cca-d683deb11c88	Meera Deshmukh	meera@purnata.org	$2b$10$dummyhash005	EXECUTIVE_DIRECTOR	9000000005	\N	ACTIVE	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5243 (class 0 OID 24972)
-- Dependencies: 223
-- Data for Name: programs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.programs (id, name, description, category, centre_id, start_date, end_date, objectives, status, created_by, created_at, updated_at) FROM stdin;
fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	Digital Literacy Program	Basic computer and digital literacy training.	EDUCATION	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	2026-01-15	2026-06-30	Improve digital literacy and confidence.	ACTIVE	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	Tailoring Skills Program	Vocational training in tailoring.	VOCATIONAL_TRAINING	83c42a87-bdfc-40a3-9290-4b3878aff98c	2026-02-10	2026-08-30	Develop employable tailoring skills.	ACTIVE	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
ae5e9011-a942-44ca-8a38-5c5f06c776f4	Counselling Support	Individual and group counselling sessions.	COUNSELLING	f7aa77b0-e584-43f0-85c5-0dc88c643725	2026-03-15	\N	Provide continuous counselling support.	ACTIVE	6513c3a6-e813-4f44-b3b5-30714afce17d	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
83b38cf9-02d7-403d-8017-930f1b32f61d	Life Skills Development	Training focused on communication and life skills.	LIFE_SKILLS	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	2026-04-01	2026-09-30	Improve communication and independent living skills.	PLANNED	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
3fa50692-3d85-4b05-ba0a-2919b257d4e0	Economic Empowerment	Employment and financial independence support.	ECONOMIC_EMPOWERMENT	8106ff55-c7c2-43b3-9afc-b272c2752ff4	2026-01-20	2026-12-31	Improve economic independence.	ACTIVE	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5245 (class 0 OID 25034)
-- Dependencies: 225
-- Data for Name: activities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activities (id, program_id, centre_id, name, description, activity_type, activity_date, start_time, end_time, location, status, created_by, created_at, updated_at) FROM stdin;
fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	Computer Basics	Introduction to computers and internet.	TRAINING	2026-05-10	10:00:00	12:00:00	Pune Training Hall	COMPLETED	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
22fd4426-9a66-4755-8700-05610da383e8	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	83c42a87-bdfc-40a3-9290-4b3878aff98c	Tailoring Workshop	Practical tailoring workshop.	SKILL_DEVELOPMENT	2026-05-15	11:00:00	13:00:00	Mumbai Skill Centre	COMPLETED	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
38bd2db8-9399-4fc4-b30c-830b3ebadb7c	ae5e9011-a942-44ca-8a38-5c5f06c776f4	f7aa77b0-e584-43f0-85c5-0dc88c643725	Group Counselling	Group counselling session.	COUNSELLING_SESSION	2026-05-20	14:00:00	15:30:00	Nashik Counselling Room	COMPLETED	6513c3a6-e813-4f44-b3b5-30714afce17d	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
37711e5a-6de4-4754-8fd1-be006f764898	83b38cf9-02d7-403d-8017-930f1b32f61d	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	Communication Skills	Communication and confidence workshop.	LIFE_SKILLS_SESSION	2026-06-05	10:00:00	12:00:00	Pune Community Hall	COMPLETED	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
7558ba1b-e5c0-4741-b072-1d0c2cf8d650	3fa50692-3d85-4b05-ba0a-2919b257d4e0	8106ff55-c7c2-43b3-9afc-b272c2752ff4	Financial Planning	Basic financial literacy session.	TRAINING	2026-06-10	11:00:00	13:00:00	Nagpur Training Hall	COMPLETED	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5242 (class 0 OID 24941)
-- Dependencies: 222
-- Data for Name: beneficiaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.beneficiaries (id, beneficiary_id, full_name, date_of_birth, gender, phone, address, city, state, centre_id, registration_date, case_status, risk_level, education_level, occupation, emergency_contact_name, emergency_contact_phone, notes, created_at, updated_at) FROM stdin;
de643881-5fa8-4f73-9dcc-f08056d89279	BEN-000001	Priya Patil	2004-05-12	FEMALE	9100000001	Kothrud	Pune	Maharashtra	86bec6f6-f1b1-49fc-8b50-ab5dbd7d818e	2026-01-10	REHABILITATION	HIGH	SECONDARY	\N	Sunita Patil	9111111111	Currently receiving rehabilitation support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
d7a60e15-4a2b-41c3-805a-3db30a2eb42d	BEN-000002	Kavita More	2002-08-21	FEMALE	9100000002	Andheri	Mumbai	Maharashtra	83c42a87-bdfc-40a3-9290-4b3878aff98c	2026-02-05	REINTEGRATION	MEDIUM	HIGHER_SECONDARY	Tailoring	Ramesh More	9222222222	Preparing for independent employment	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
ed7e83df-2c5b-4af9-96fa-c5b29733fbaf	BEN-000003	Neha Shinde	2006-11-03	FEMALE	9100000003	Nashik Road	Nashik	Maharashtra	f7aa77b0-e584-43f0-85c5-0dc88c643725	2026-03-12	RESCUED	CRITICAL	SECONDARY	\N	Vijay Shinde	9333333333	Recently registered	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
93e865e5-4b52-4af2-bad3-979ae16c83ed	BEN-000004	Asha Pawar	2001-02-17	FEMALE	9100000004	Dharampeth	Nagpur	Maharashtra	8106ff55-c7c2-43b3-9afc-b272c2752ff4	2026-01-25	FOLLOW_UP	LOW	UNDERGRADUATE	Teacher Assistant	Maya Pawar	9444444444	Long-term follow-up	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
3c0d8344-45ae-4b86-96dc-35e4bc3298d7	BEN-000005	Riya Jadhav	2005-07-29	FEMALE	9100000005	CIDCO	Aurangabad	Maharashtra	a41ccdd8-a448-45b4-85de-3053a3f4fd91	2026-04-01	OUTREACH	MEDIUM	PRIMARY	\N	Sunil Jadhav	9555555555	Outreach case	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5246 (class 0 OID 25074)
-- Dependencies: 226
-- Data for Name: attendances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendances (id, activity_id, beneficiary_id, status, remarks, recorded_by, recorded_at) FROM stdin;
5daad521-b174-4269-b688-3e6adfa7de23	fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	de643881-5fa8-4f73-9dcc-f08056d89279	PRESENT	Participated actively	868b7aff-7f02-49a0-9baf-4fbb761ab499	2026-08-22 00:14:18.737153
e5699670-c77e-4265-9862-74fdb16f7bc3	22fd4426-9a66-4755-8700-05610da383e8	d7a60e15-4a2b-41c3-805a-3db30a2eb42d	PRESENT	Completed workshop	868b7aff-7f02-49a0-9baf-4fbb761ab499	2026-08-22 00:14:18.737153
a4ab9cdc-88b2-4a7c-aea1-c3fb07700147	38bd2db8-9399-4fc4-b30c-830b3ebadb7c	ed7e83df-2c5b-4af9-96fa-c5b29733fbaf	PRESENT	Participated in counselling	6513c3a6-e813-4f44-b3b5-30714afce17d	2026-08-22 00:14:18.737153
78c0d267-96c3-44b1-9e96-c147bbb868bf	37711e5a-6de4-4754-8fd1-be006f764898	de643881-5fa8-4f73-9dcc-f08056d89279	PRESENT	Good participation	868b7aff-7f02-49a0-9baf-4fbb761ab499	2026-08-22 00:14:18.737153
5519f520-b523-4fb0-a607-8c337da7b23d	7558ba1b-e5c0-4741-b072-1d0c2cf8d650	93e865e5-4b52-4af2-bad3-979ae16c83ed	EXCUSED	Medical appointment	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5254 (class 0 OID 25329)
-- Dependencies: 234
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, user_id, action, entity_type, entity_id, description, "timestamp", metadata) FROM stdin;
20cc56d7-2cd4-4d2a-ad93-67d6ee1291f4	513c824a-d636-4e6a-9efa-335b9e765ea9	CREATE	BENEFICIARY	de643881-5fa8-4f73-9dcc-f08056d89279	Created beneficiary BEN-000001	2026-08-22 00:14:18.737153	{"beneficiaryId": "BEN-000001"}
81877ac6-b119-4134-bdf7-f7e9eb588fba	513c824a-d636-4e6a-9efa-335b9e765ea9	CREATE	PROGRAM	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	Created Digital Literacy Program	2026-08-22 00:14:18.737153	{"category": "EDUCATION"}
0dc86b2f-7129-41c0-819c-ec2ac6621055	868b7aff-7f02-49a0-9baf-4fbb761ab499	CREATE	ATTENDANCE	5daad521-b174-4269-b688-3e6adfa7de23	Recorded beneficiary attendance	2026-08-22 00:14:18.737153	{"status": "PRESENT"}
58b42eb9-ce52-4536-8d4b-6d1abbe344b0	513c824a-d636-4e6a-9efa-335b9e765ea9	ASSIGN	VOLUNTEER_ASSIGNMENT	a3d29ea2-2816-4cf0-ae70-8449f74b85b8	Assigned volunteer to program	2026-08-22 00:14:18.737153	{"volunteer": "Amit Kulkarni"}
0bfa6218-3b48-4f42-b581-595aa8a8ed4b	c7283e28-af26-451a-ac2c-cc2ab89d83d8	COMPLETE	TASK	a7293522-e605-4eca-bb0d-7dd8a93a3ca4	Completed financial literacy support task	2026-08-22 00:14:18.737153	{"status": "COMPLETED"}
\.


--
-- TOC entry 5244 (class 0 OID 25003)
-- Dependencies: 224
-- Data for Name: program_enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_enrollments (id, beneficiary_id, program_id, enrollment_date, status, completion_date, progress_percentage, notes, created_at, updated_at) FROM stdin;
875f96c1-2b63-4f87-9e11-c3ad455e4c25	de643881-5fa8-4f73-9dcc-f08056d89279	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	2026-01-16	ACTIVE	\N	65	Good participation	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
0cce2805-6fb3-478f-a9b6-1001e3bdb9aa	de643881-5fa8-4f73-9dcc-f08056d89279	83b38cf9-02d7-403d-8017-930f1b32f61d	2026-04-02	ACTIVE	\N	40	Life skills training started	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
def0d6ba-3a94-4220-9715-54c59b7d2afa	d7a60e15-4a2b-41c3-805a-3db30a2eb42d	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	2026-02-11	ACTIVE	\N	80	Near completion	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
71ff423f-382b-403b-9214-b8880149f858	ed7e83df-2c5b-4af9-96fa-c5b29733fbaf	ae5e9011-a942-44ca-8a38-5c5f06c776f4	2026-03-16	ACTIVE	\N	30	Counselling ongoing	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
7756e96d-ba86-41d8-95e1-42a30819e505	93e865e5-4b52-4af2-bad3-979ae16c83ed	3fa50692-3d85-4b05-ba0a-2919b257d4e0	2026-01-21	COMPLETED	2026-06-15	100	Successfully completed	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5252 (class 0 OID 25249)
-- Dependencies: 232
-- Data for Name: progress_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progress_records (id, beneficiary_id, program_id, activity_id, category, title, description, score, recorded_by, recorded_at, created_at, updated_at) FROM stdin;
052292ee-feac-45d5-8822-87064cb36c52	de643881-5fa8-4f73-9dcc-f08056d89279	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	EDUCATION	Computer Basics Progress	Improved basic computer skills.	70	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
58587e1d-6d86-4ab6-9b18-32cd71204153	d7a60e15-4a2b-41c3-805a-3db30a2eb42d	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	22fd4426-9a66-4755-8700-05610da383e8	VOCATIONAL_SKILL	Tailoring Progress	Demonstrated improved tailoring ability.	85	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
7a055b6b-7130-4f67-b43f-b37843f89790	ed7e83df-2c5b-4af9-96fa-c5b29733fbaf	ae5e9011-a942-44ca-8a38-5c5f06c776f4	38bd2db8-9399-4fc4-b30c-830b3ebadb7c	COUNSELLING	Counselling Progress	Showing positive engagement in counselling.	45	6513c3a6-e813-4f44-b3b5-30714afce17d	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
a2823b3f-17a5-49a3-ae70-61fa02034fc9	93e865e5-4b52-4af2-bad3-979ae16c83ed	3fa50692-3d85-4b05-ba0a-2919b257d4e0	7558ba1b-e5c0-4741-b072-1d0c2cf8d650	ECONOMIC_INDEPENDENCE	Financial Independence	Completed financial literacy training.	92	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
ebbd9026-7c02-483d-a41f-9836f1e59c3f	de643881-5fa8-4f73-9dcc-f08056d89279	83b38cf9-02d7-403d-8017-930f1b32f61d	37711e5a-6de4-4754-8fd1-be006f764898	LIFE_SKILL	Confidence Building	Improved communication and confidence.	60	868b7aff-7f02-49a0-9baf-4fbb761ab499	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5248 (class 0 OID 25130)
-- Dependencies: 228
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skills (id, name, description, created_at, updated_at) FROM stdin;
71b57978-0d35-433a-b505-e35e6ef8b4cd	Counselling	Basic counselling support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
d418d099-c279-4f45-a7a2-c1293799c2d9	Teaching	Education and teaching skills	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
40404edf-1960-4cbe-b981-886f1543e9a6	Computer Skills	Basic computer knowledge	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
87017673-158b-4c52-a2c4-8314d4c8b0bf	Communication	Communication and interpersonal skills	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
d227fa25-dd4f-460d-bd7e-5d481fbd3d4c	Financial Literacy	Basic financial planning skills	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5251 (class 0 OID 25208)
-- Dependencies: 231
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (id, title, description, volunteer_id, program_id, activity_id, due_date, priority, status, created_by, completed_at, created_at, updated_at) FROM stdin;
383d3fb2-37f7-4686-a833-cdaa93508970	Prepare Training Material	Prepare computer training material.	868b7aff-7f02-49a0-9baf-4fbb761ab499	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	2026-05-08	HIGH	COMPLETED	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-05-07 16:00:00	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
437f76f5-4975-4a71-a0d8-75020e528f59	Support Workshop	Assist beneficiaries during tailoring workshop.	868b7aff-7f02-49a0-9baf-4fbb761ab499	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	22fd4426-9a66-4755-8700-05610da383e8	2026-05-14	MEDIUM	COMPLETED	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-05-14 15:00:00	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
a30960aa-5cfe-429c-a968-351ad4c3b7d1	Counselling Follow-up	Follow up with counselling participants.	868b7aff-7f02-49a0-9baf-4fbb761ab499	ae5e9011-a942-44ca-8a38-5c5f06c776f4	38bd2db8-9399-4fc4-b30c-830b3ebadb7c	2026-05-25	HIGH	IN_PROGRESS	6513c3a6-e813-4f44-b3b5-30714afce17d	\N	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
bb30938c-4c7c-4136-9eb5-e209e3afec6f	Prepare Activity Report	Prepare report for communication skills activity.	868b7aff-7f02-49a0-9baf-4fbb761ab499	83b38cf9-02d7-403d-8017-930f1b32f61d	37711e5a-6de4-4754-8fd1-be006f764898	2026-06-10	LOW	ASSIGNED	513c824a-d636-4e6a-9efa-335b9e765ea9	\N	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
a7293522-e605-4eca-bb0d-7dd8a93a3ca4	Financial Session Support	Support beneficiaries during financial planning.	868b7aff-7f02-49a0-9baf-4fbb761ab499	3fa50692-3d85-4b05-ba0a-2919b257d4e0	7558ba1b-e5c0-4741-b072-1d0c2cf8d650	2026-06-15	URGENT	COMPLETED	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-06-14 17:00:00	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5253 (class 0 OID 25292)
-- Dependencies: 233
-- Data for Name: timeline_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timeline_events (id, beneficiary_id, event_type, title, description, event_date, program_id, activity_id, created_by, created_at) FROM stdin;
d8d86feb-937a-493c-9963-749dfcdef672	de643881-5fa8-4f73-9dcc-f08056d89279	REGISTRATION	Beneficiary Registered	Beneficiary registered with Purnata.	2026-01-10	\N	\N	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153
b05ca2a5-b8ee-4e30-91a2-6235dee49469	de643881-5fa8-4f73-9dcc-f08056d89279	PROGRAM_ENROLLMENT	Digital Literacy Enrollment	Enrolled in Digital Literacy Program.	2026-01-16	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	\N	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153
1c1c04ad-785d-477f-8a14-79484522d2d5	de643881-5fa8-4f73-9dcc-f08056d89279	ACTIVITY	Computer Training Completed	Attended computer basics training.	2026-05-10	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-08-22 00:14:18.737153
241c2ee3-e4eb-400e-9896-6b37ea7344d2	d7a60e15-4a2b-41c3-805a-3db30a2eb42d	PROGRESS_MILESTONE	Vocational Progress	Reached 85 percent progress in tailoring.	2026-05-15	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	22fd4426-9a66-4755-8700-05610da383e8	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153
8e184d45-f205-444c-a3fb-cfb68761d7c8	93e865e5-4b52-4af2-bad3-979ae16c83ed	REINTEGRATION	Economic Reintegration	Completed economic empowerment program.	2026-06-15	3fa50692-3d85-4b05-ba0a-2919b257d4e0	7558ba1b-e5c0-4741-b072-1d0c2cf8d650	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5250 (class 0 OID 25170)
-- Dependencies: 230
-- Data for Name: volunteer_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer_assignments (id, volunteer_id, program_id, activity_id, assigned_by, assignment_date, status, notes, created_at, updated_at) FROM stdin;
a3d29ea2-2816-4cf0-ae70-8449f74b85b8	868b7aff-7f02-49a0-9baf-4fbb761ab499	fb785de4-97cb-4a74-81e1-2fcbe05b8ca1	fbe56de1-15e3-4fd4-95c1-4e4ab358e26b	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-05-01	COMPLETED	Computer training support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
19a94cd8-c359-41ce-a230-f61edbdf7c00	868b7aff-7f02-49a0-9baf-4fbb761ab499	3434aa2b-aa0d-4162-8f7a-0706f7bdd2e5	22fd4426-9a66-4755-8700-05610da383e8	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-05-05	ACTIVE	Workshop support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
7df5cba7-60c3-40d8-86e0-7ad191c8b8e5	868b7aff-7f02-49a0-9baf-4fbb761ab499	ae5e9011-a942-44ca-8a38-5c5f06c776f4	38bd2db8-9399-4fc4-b30c-830b3ebadb7c	6513c3a6-e813-4f44-b3b5-30714afce17d	2026-05-10	ACTIVE	Counselling support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
5a830909-6251-4d7f-bffb-6970a552e5c6	868b7aff-7f02-49a0-9baf-4fbb761ab499	83b38cf9-02d7-403d-8017-930f1b32f61d	37711e5a-6de4-4754-8fd1-be006f764898	513c824a-d636-4e6a-9efa-335b9e765ea9	2026-05-20	ASSIGNED	Life skills support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
1567c044-1cb8-4109-9e8f-cc848681265c	868b7aff-7f02-49a0-9baf-4fbb761ab499	3fa50692-3d85-4b05-ba0a-2919b257d4e0	7558ba1b-e5c0-4741-b072-1d0c2cf8d650	c7283e28-af26-451a-ac2c-cc2ab89d83d8	2026-05-25	COMPLETED	Financial literacy support	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5247 (class 0 OID 25106)
-- Dependencies: 227
-- Data for Name: volunteer_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer_profiles (id, user_id, bio, availability, experience, status, joined_date, created_at, updated_at) FROM stdin;
9d869ded-1a8f-43fb-b817-155ad04ea3af	868b7aff-7f02-49a0-9baf-4fbb761ab499	Community support volunteer	BOTH	2 years of volunteering experience	ACTIVE	2026-01-05	2026-08-22 00:14:18.737153	2026-08-22 00:14:18.737153
\.


--
-- TOC entry 5249 (class 0 OID 25146)
-- Dependencies: 229
-- Data for Name: volunteer_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.volunteer_skills (id, volunteer_id, skill_id, proficiency_level, created_at) FROM stdin;
8cd26b77-c7bd-4a55-8db8-3aed5bb1329d	9d869ded-1a8f-43fb-b817-155ad04ea3af	71b57978-0d35-433a-b505-e35e6ef8b4cd	ADVANCED	2026-08-22 00:14:18.737153
a7f4d9b9-7a95-449c-ab3a-fac69750bd50	9d869ded-1a8f-43fb-b817-155ad04ea3af	d418d099-c279-4f45-a7a2-c1293799c2d9	INTERMEDIATE	2026-08-22 00:14:18.737153
3db34625-ddd2-496a-9028-c95e400c21d5	9d869ded-1a8f-43fb-b817-155ad04ea3af	40404edf-1960-4cbe-b981-886f1543e9a6	ADVANCED	2026-08-22 00:14:18.737153
55ce04e3-25fa-4c15-97ee-fb8c340603cf	9d869ded-1a8f-43fb-b817-155ad04ea3af	87017673-158b-4c52-a2c4-8314d4c8b0bf	EXPERT	2026-08-22 00:14:18.737153
61ddb2cc-7045-47cd-bc1d-2bdfc8ed706e	9d869ded-1a8f-43fb-b817-155ad04ea3af	d227fa25-dd4f-460d-bd7e-5d481fbd3d4c	BEGINNER	2026-08-22 00:14:18.737153
\.


-- Completed on 2026-08-22 22:22:49

--
-- PostgreSQL database dump complete
--

\unrestrict SGQlPfbHtoOgf48cdQkscqv2is96k3gU3N1QUtGOPdOoikPTaoSx4LZ1jFhhTSg

