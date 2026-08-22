--
-- PostgreSQL database dump
--

\restrict VnyEl10xGqcsyqZFNek6jhglrRNOD5I2SYN2s7UlxSOK7Jmca900RpOr0aGLuSW

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-08-22 22:22:21

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
-- TOC entry 2 (class 3079 OID 24577)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5290 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 937 (class 1247 OID 24756)
-- Name: activity_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.activity_status AS ENUM (
    'PLANNED',
    'ONGOING',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.activity_status OWNER TO postgres;

--
-- TOC entry 934 (class 1247 OID 24734)
-- Name: activity_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.activity_type AS ENUM (
    'TRAINING',
    'COUNSELLING_SESSION',
    'EDUCATION_SESSION',
    'SKILL_DEVELOPMENT',
    'AWARENESS_SESSION',
    'HEALTH_SESSION',
    'LEGAL_SESSION',
    'LIFE_SKILLS_SESSION',
    'GROUP_ACTIVITY',
    'OTHER'
);


ALTER TYPE public.activity_type OWNER TO postgres;

--
-- TOC entry 952 (class 1247 OID 24802)
-- Name: assignment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.assignment_status AS ENUM (
    'ASSIGNED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.assignment_status OWNER TO postgres;

--
-- TOC entry 940 (class 1247 OID 24766)
-- Name: attendance_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendance_status AS ENUM (
    'PRESENT',
    'ABSENT',
    'EXCUSED'
);


ALTER TYPE public.attendance_status OWNER TO postgres;

--
-- TOC entry 967 (class 1247 OID 24878)
-- Name: audit_action; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.audit_action AS ENUM (
    'CREATE',
    'UPDATE',
    'DELETE',
    'LOGIN',
    'LOGOUT',
    'ASSIGN',
    'COMPLETE',
    'VIEW_SENSITIVE'
);


ALTER TYPE public.audit_action OWNER TO postgres;

--
-- TOC entry 916 (class 1247 OID 24648)
-- Name: case_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.case_status AS ENUM (
    'OUTREACH',
    'RESCUED',
    'REHABILITATION',
    'REINTEGRATION',
    'FOLLOW_UP',
    'CLOSED'
);


ALTER TYPE public.case_status OWNER TO postgres;

--
-- TOC entry 910 (class 1247 OID 24632)
-- Name: centre_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.centre_status AS ENUM (
    'ACTIVE',
    'INACTIVE'
);


ALTER TYPE public.centre_status OWNER TO postgres;

--
-- TOC entry 922 (class 1247 OID 24672)
-- Name: education_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.education_level AS ENUM (
    'NO_FORMAL_EDUCATION',
    'PRIMARY',
    'SECONDARY',
    'HIGHER_SECONDARY',
    'UNDERGRADUATE',
    'POSTGRADUATE',
    'VOCATIONAL',
    'OTHER'
);


ALTER TYPE public.education_level OWNER TO postgres;

--
-- TOC entry 931 (class 1247 OID 24724)
-- Name: enrollment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.enrollment_status AS ENUM (
    'ACTIVE',
    'COMPLETED',
    'WITHDRAWN',
    'PAUSED'
);


ALTER TYPE public.enrollment_status OWNER TO postgres;

--
-- TOC entry 913 (class 1247 OID 24638)
-- Name: gender; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gender AS ENUM (
    'FEMALE',
    'MALE',
    'OTHER',
    'PREFER_NOT_TO_SAY'
);


ALTER TYPE public.gender OWNER TO postgres;

--
-- TOC entry 925 (class 1247 OID 24690)
-- Name: program_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.program_category AS ENUM (
    'EDUCATION',
    'VOCATIONAL_TRAINING',
    'COUNSELLING',
    'LEGAL_SUPPORT',
    'HEALTHCARE',
    'SKILL_DEVELOPMENT',
    'ECONOMIC_EMPOWERMENT',
    'CHILDCARE',
    'LIFE_SKILLS',
    'REINTEGRATION',
    'OTHER'
);


ALTER TYPE public.program_category OWNER TO postgres;

--
-- TOC entry 928 (class 1247 OID 24714)
-- Name: program_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.program_status AS ENUM (
    'PLANNED',
    'ACTIVE',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.program_status OWNER TO postgres;

--
-- TOC entry 961 (class 1247 OID 24832)
-- Name: progress_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.progress_category AS ENUM (
    'EDUCATION',
    'VOCATIONAL_SKILL',
    'LIFE_SKILL',
    'HEALTH',
    'COUNSELLING',
    'EMPLOYMENT',
    'ECONOMIC_INDEPENDENCE',
    'SOCIAL_REINTEGRATION',
    'OTHER'
);


ALTER TYPE public.progress_category OWNER TO postgres;

--
-- TOC entry 919 (class 1247 OID 24662)
-- Name: risk_level; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.risk_level AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'CRITICAL'
);


ALTER TYPE public.risk_level OWNER TO postgres;

--
-- TOC entry 949 (class 1247 OID 24792)
-- Name: skill_proficiency; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.skill_proficiency AS ENUM (
    'BEGINNER',
    'INTERMEDIATE',
    'ADVANCED',
    'EXPERT'
);


ALTER TYPE public.skill_proficiency OWNER TO postgres;

--
-- TOC entry 955 (class 1247 OID 24812)
-- Name: task_priority; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_priority AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH',
    'URGENT'
);


ALTER TYPE public.task_priority OWNER TO postgres;

--
-- TOC entry 958 (class 1247 OID 24822)
-- Name: task_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.task_status AS ENUM (
    'ASSIGNED',
    'IN_PROGRESS',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.task_status OWNER TO postgres;

--
-- TOC entry 964 (class 1247 OID 24852)
-- Name: timeline_event_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.timeline_event_type AS ENUM (
    'OUTREACH',
    'RISK_IDENTIFICATION',
    'REGISTRATION',
    'RESCUE',
    'REHABILITATION',
    'PROGRAM_ENROLLMENT',
    'ACTIVITY',
    'PROGRESS_MILESTONE',
    'REINTEGRATION',
    'FOLLOW_UP',
    'CASE_UPDATE',
    'OTHER'
);


ALTER TYPE public.timeline_event_type OWNER TO postgres;

--
-- TOC entry 904 (class 1247 OID 24616)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'PROGRAM_LEAD',
    'VOLUNTEER',
    'EXECUTIVE_DIRECTOR'
);


ALTER TYPE public.user_role OWNER TO postgres;

--
-- TOC entry 907 (class 1247 OID 24624)
-- Name: user_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED'
);


ALTER TYPE public.user_status OWNER TO postgres;

--
-- TOC entry 943 (class 1247 OID 24774)
-- Name: volunteer_availability; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.volunteer_availability AS ENUM (
    'WEEKDAYS',
    'WEEKENDS',
    'BOTH',
    'FLEXIBLE'
);


ALTER TYPE public.volunteer_availability OWNER TO postgres;

--
-- TOC entry 946 (class 1247 OID 24784)
-- Name: volunteer_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.volunteer_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'ON_LEAVE'
);


ALTER TYPE public.volunteer_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 225 (class 1259 OID 25034)
-- Name: activities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    program_id uuid NOT NULL,
    centre_id uuid NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    activity_type public.activity_type NOT NULL,
    activity_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    location character varying(200) NOT NULL,
    status public.activity_status NOT NULL,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT activities_check CHECK ((end_time > start_time))
);


ALTER TABLE public.activities OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 25074)
-- Name: attendances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    activity_id uuid NOT NULL,
    beneficiary_id uuid NOT NULL,
    status public.attendance_status NOT NULL,
    remarks text,
    recorded_by uuid NOT NULL,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.attendances OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 25329)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    action public.audit_action NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id uuid NOT NULL,
    description text NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    metadata jsonb
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24941)
-- Name: beneficiaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.beneficiaries (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beneficiary_id character varying(20) NOT NULL,
    full_name character varying(150) NOT NULL,
    date_of_birth date NOT NULL,
    gender public.gender NOT NULL,
    phone character varying(20),
    address text NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    centre_id uuid NOT NULL,
    registration_date date NOT NULL,
    case_status public.case_status NOT NULL,
    risk_level public.risk_level NOT NULL,
    education_level public.education_level,
    occupation character varying(150),
    emergency_contact_name character varying(150),
    emergency_contact_phone character varying(20),
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.beneficiaries OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24895)
-- Name: centres; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.centres (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(150) NOT NULL,
    address text NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    contact_number character varying(20),
    status public.centre_status NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.centres OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 25003)
-- Name: program_enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_enrollments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beneficiary_id uuid NOT NULL,
    program_id uuid NOT NULL,
    enrollment_date date NOT NULL,
    status public.enrollment_status NOT NULL,
    completion_date date,
    progress_percentage integer NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT program_enrollments_progress_percentage_check CHECK (((progress_percentage >= 0) AND (progress_percentage <= 100)))
);


ALTER TABLE public.program_enrollments OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24972)
-- Name: programs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.programs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(200) NOT NULL,
    description text NOT NULL,
    category public.program_category NOT NULL,
    centre_id uuid NOT NULL,
    start_date date NOT NULL,
    end_date date,
    objectives text NOT NULL,
    status public.program_status NOT NULL,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.programs OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 25249)
-- Name: progress_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progress_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beneficiary_id uuid NOT NULL,
    program_id uuid NOT NULL,
    activity_id uuid,
    category public.progress_category NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    score integer NOT NULL,
    recorded_by uuid NOT NULL,
    recorded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT progress_records_score_check CHECK (((score >= 0) AND (score <= 100)))
);


ALTER TABLE public.progress_records OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 25130)
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 25208)
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    volunteer_id uuid NOT NULL,
    program_id uuid NOT NULL,
    activity_id uuid,
    due_date date NOT NULL,
    priority public.task_priority NOT NULL,
    status public.task_status NOT NULL,
    created_by uuid NOT NULL,
    completed_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 25292)
-- Name: timeline_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timeline_events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    beneficiary_id uuid NOT NULL,
    event_type public.timeline_event_type NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL,
    event_date date NOT NULL,
    program_id uuid,
    activity_id uuid,
    created_by uuid NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.timeline_events OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 24915)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    full_name character varying(150) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash text NOT NULL,
    role public.user_role NOT NULL,
    phone character varying(20) NOT NULL,
    centre_id uuid,
    status public.user_status NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 25170)
-- Name: volunteer_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    volunteer_id uuid NOT NULL,
    program_id uuid NOT NULL,
    activity_id uuid,
    assigned_by uuid NOT NULL,
    assignment_date date NOT NULL,
    status public.assignment_status NOT NULL,
    notes text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.volunteer_assignments OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 25106)
-- Name: volunteer_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    bio text,
    availability public.volunteer_availability NOT NULL,
    experience text,
    status public.volunteer_status NOT NULL,
    joined_date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.volunteer_profiles OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 25146)
-- Name: volunteer_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.volunteer_skills (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    volunteer_id uuid NOT NULL,
    skill_id uuid NOT NULL,
    proficiency_level public.skill_proficiency NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.volunteer_skills OWNER TO postgres;

--
-- TOC entry 5079 (class 2606 OID 25058)
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- TOC entry 5081 (class 2606 OID 25090)
-- Name: attendances attendances_activity_id_beneficiary_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_activity_id_beneficiary_id_key UNIQUE (activity_id, beneficiary_id);


--
-- TOC entry 5083 (class 2606 OID 25088)
-- Name: attendances attendances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_pkey PRIMARY KEY (id);


--
-- TOC entry 5105 (class 2606 OID 25344)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 5069 (class 2606 OID 24966)
-- Name: beneficiaries beneficiaries_beneficiary_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_beneficiary_id_key UNIQUE (beneficiary_id);


--
-- TOC entry 5071 (class 2606 OID 24964)
-- Name: beneficiaries beneficiaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_pkey PRIMARY KEY (id);


--
-- TOC entry 5061 (class 2606 OID 24914)
-- Name: centres centres_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centres
    ADD CONSTRAINT centres_name_key UNIQUE (name);


--
-- TOC entry 5063 (class 2606 OID 24912)
-- Name: centres centres_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.centres
    ADD CONSTRAINT centres_pkey PRIMARY KEY (id);


--
-- TOC entry 5075 (class 2606 OID 25023)
-- Name: program_enrollments program_enrollments_beneficiary_id_program_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_enrollments
    ADD CONSTRAINT program_enrollments_beneficiary_id_program_id_key UNIQUE (beneficiary_id, program_id);


--
-- TOC entry 5077 (class 2606 OID 25021)
-- Name: program_enrollments program_enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_enrollments
    ADD CONSTRAINT program_enrollments_pkey PRIMARY KEY (id);


--
-- TOC entry 5073 (class 2606 OID 24992)
-- Name: programs programs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- TOC entry 5101 (class 2606 OID 25271)
-- Name: progress_records progress_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_records
    ADD CONSTRAINT progress_records_pkey PRIMARY KEY (id);


--
-- TOC entry 5089 (class 2606 OID 25145)
-- Name: skills skills_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_name_key UNIQUE (name);


--
-- TOC entry 5091 (class 2606 OID 25143)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- TOC entry 5099 (class 2606 OID 25228)
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 5103 (class 2606 OID 25308)
-- Name: timeline_events timeline_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_pkey PRIMARY KEY (id);


--
-- TOC entry 5065 (class 2606 OID 24935)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 5067 (class 2606 OID 24933)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 5097 (class 2606 OID 25187)
-- Name: volunteer_assignments volunteer_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_assignments
    ADD CONSTRAINT volunteer_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 5085 (class 2606 OID 25122)
-- Name: volunteer_profiles volunteer_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_profiles
    ADD CONSTRAINT volunteer_profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 5087 (class 2606 OID 25124)
-- Name: volunteer_profiles volunteer_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_profiles
    ADD CONSTRAINT volunteer_profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 5093 (class 2606 OID 25157)
-- Name: volunteer_skills volunteer_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skills
    ADD CONSTRAINT volunteer_skills_pkey PRIMARY KEY (id);


--
-- TOC entry 5095 (class 2606 OID 25159)
-- Name: volunteer_skills volunteer_skills_volunteer_id_skill_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skills
    ADD CONSTRAINT volunteer_skills_volunteer_id_skill_id_key UNIQUE (volunteer_id, skill_id);


--
-- TOC entry 5112 (class 2606 OID 25064)
-- Name: activities activities_centre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_centre_id_fkey FOREIGN KEY (centre_id) REFERENCES public.centres(id);


--
-- TOC entry 5113 (class 2606 OID 25069)
-- Name: activities activities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5114 (class 2606 OID 25059)
-- Name: activities activities_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5115 (class 2606 OID 25091)
-- Name: attendances attendances_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 5116 (class 2606 OID 25096)
-- Name: attendances attendances_beneficiary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_beneficiary_id_fkey FOREIGN KEY (beneficiary_id) REFERENCES public.beneficiaries(id);


--
-- TOC entry 5117 (class 2606 OID 25101)
-- Name: attendances attendances_recorded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendances
    ADD CONSTRAINT attendances_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5137 (class 2606 OID 25345)
-- Name: audit_logs audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5107 (class 2606 OID 24967)
-- Name: beneficiaries beneficiaries_centre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.beneficiaries
    ADD CONSTRAINT beneficiaries_centre_id_fkey FOREIGN KEY (centre_id) REFERENCES public.centres(id);


--
-- TOC entry 5110 (class 2606 OID 25024)
-- Name: program_enrollments program_enrollments_beneficiary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_enrollments
    ADD CONSTRAINT program_enrollments_beneficiary_id_fkey FOREIGN KEY (beneficiary_id) REFERENCES public.beneficiaries(id);


--
-- TOC entry 5111 (class 2606 OID 25029)
-- Name: program_enrollments program_enrollments_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_enrollments
    ADD CONSTRAINT program_enrollments_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5108 (class 2606 OID 24993)
-- Name: programs programs_centre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_centre_id_fkey FOREIGN KEY (centre_id) REFERENCES public.centres(id);


--
-- TOC entry 5109 (class 2606 OID 24998)
-- Name: programs programs_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programs
    ADD CONSTRAINT programs_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5129 (class 2606 OID 25282)
-- Name: progress_records progress_records_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_records
    ADD CONSTRAINT progress_records_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 5130 (class 2606 OID 25272)
-- Name: progress_records progress_records_beneficiary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_records
    ADD CONSTRAINT progress_records_beneficiary_id_fkey FOREIGN KEY (beneficiary_id) REFERENCES public.beneficiaries(id);


--
-- TOC entry 5131 (class 2606 OID 25277)
-- Name: progress_records progress_records_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_records
    ADD CONSTRAINT progress_records_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5132 (class 2606 OID 25287)
-- Name: progress_records progress_records_recorded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress_records
    ADD CONSTRAINT progress_records_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES public.users(id);


--
-- TOC entry 5125 (class 2606 OID 25239)
-- Name: tasks tasks_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 5126 (class 2606 OID 25244)
-- Name: tasks tasks_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5127 (class 2606 OID 25234)
-- Name: tasks tasks_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5128 (class 2606 OID 25229)
-- Name: tasks tasks_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.users(id);


--
-- TOC entry 5133 (class 2606 OID 25319)
-- Name: timeline_events timeline_events_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 5134 (class 2606 OID 25309)
-- Name: timeline_events timeline_events_beneficiary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_beneficiary_id_fkey FOREIGN KEY (beneficiary_id) REFERENCES public.beneficiaries(id);


--
-- TOC entry 5135 (class 2606 OID 25324)
-- Name: timeline_events timeline_events_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id);


--
-- TOC entry 5136 (class 2606 OID 25314)
-- Name: timeline_events timeline_events_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timeline_events
    ADD CONSTRAINT timeline_events_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5106 (class 2606 OID 24936)
-- Name: users users_centre_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_centre_id_fkey FOREIGN KEY (centre_id) REFERENCES public.centres(id);


--
-- TOC entry 5121 (class 2606 OID 25198)
-- Name: volunteer_assignments volunteer_assignments_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_assignments
    ADD CONSTRAINT volunteer_assignments_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- TOC entry 5122 (class 2606 OID 25203)
-- Name: volunteer_assignments volunteer_assignments_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_assignments
    ADD CONSTRAINT volunteer_assignments_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id);


--
-- TOC entry 5123 (class 2606 OID 25193)
-- Name: volunteer_assignments volunteer_assignments_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_assignments
    ADD CONSTRAINT volunteer_assignments_program_id_fkey FOREIGN KEY (program_id) REFERENCES public.programs(id);


--
-- TOC entry 5124 (class 2606 OID 25188)
-- Name: volunteer_assignments volunteer_assignments_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_assignments
    ADD CONSTRAINT volunteer_assignments_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.users(id);


--
-- TOC entry 5118 (class 2606 OID 25125)
-- Name: volunteer_profiles volunteer_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_profiles
    ADD CONSTRAINT volunteer_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 5119 (class 2606 OID 25165)
-- Name: volunteer_skills volunteer_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skills
    ADD CONSTRAINT volunteer_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- TOC entry 5120 (class 2606 OID 25160)
-- Name: volunteer_skills volunteer_skills_volunteer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.volunteer_skills
    ADD CONSTRAINT volunteer_skills_volunteer_id_fkey FOREIGN KEY (volunteer_id) REFERENCES public.volunteer_profiles(id);


-- Completed on 2026-08-22 22:22:21

--
-- PostgreSQL database dump complete
--

\unrestrict VnyEl10xGqcsyqZFNek6jhglrRNOD5I2SYN2s7UlxSOK7Jmca900RpOr0aGLuSW

