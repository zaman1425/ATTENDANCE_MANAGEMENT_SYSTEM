--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_requests (
    id integer NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.admin_requests OWNER TO postgres;

--
-- Name: admin_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_requests_id_seq OWNER TO postgres;

--
-- Name: admin_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_requests_id_seq OWNED BY public.admin_requests.id;


--
-- Name: admins; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admins (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admins OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admins_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admins_id_seq OWNER TO postgres;

--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admins_id_seq OWNED BY public.admins.id;


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id integer NOT NULL,
    intern_email character varying(255) NOT NULL,
    date date NOT NULL,
    status character(1) NOT NULL,
    marked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT attendance_status_check CHECK ((status = ANY (ARRAY['P'::bpchar, 'A'::bpchar])))
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;


--
-- Name: block; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.block (
    student_id integer,
    student_name character varying(30),
    student_birth integer,
    student_marks integer,
    student_count integer
);


ALTER TABLE public.block OWNER TO postgres;

--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    name character varying,
    price integer,
    title character varying,
    author character varying
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: cars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cars (
    year integer,
    name character varying(250),
    colour character varying(250),
    owner character varying(250),
    symbol character varying(250)
);


ALTER TABLE public.cars OWNER TO postgres;

--
-- Name: class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class (
    student_id integer,
    student_name character varying(30),
    student_birth integer,
    student_marks integer
);


ALTER TABLE public.class OWNER TO postgres;

--
-- Name: course; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course (
    course_id integer NOT NULL,
    course_name character varying(50) NOT NULL,
    course_duration integer
);


ALTER TABLE public.course OWNER TO postgres;

--
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    cus_id integer NOT NULL,
    cus_name character varying(50),
    cus_age integer,
    cus_phone character varying(15),
    cus_adr character varying(100)
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- Name: department; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.department (
    dep_no integer,
    dep_name character varying(100),
    dep_loc character varying(100)
);


ALTER TABLE public.department OWNER TO postgres;

--
-- Name: dept; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dept (
    deptno integer,
    deptname character varying(20),
    loc character varying(20)
);


ALTER TABLE public.dept OWNER TO postgres;

--
-- Name: emp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emp (
    empno integer,
    ename character varying(20),
    job character varying(20),
    mgr integer,
    hiredate date,
    sal numeric,
    comm numeric,
    deptno integer
);


ALTER TABLE public.emp OWNER TO postgres;

--
-- Name: employee; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee (
    emp_no integer NOT NULL,
    emp_name character varying(100),
    emp_job character varying(100),
    emp_hiredate date,
    emp_salary numeric,
    emp_commision numeric,
    emp_deptno integer,
    emp_ numeric,
    emp_forward integer,
    emp_age integer
);


ALTER TABLE public.employee OWNER TO postgres;

--
-- Name: emptb; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emptb (
    emp_name character varying(20),
    emp_email character varying(50),
    emp_no integer,
    emp_dob integer
);


ALTER TABLE public.emptb OWNER TO postgres;

--
-- Name: interns; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interns (
    reg_no character varying(100) NOT NULL,
    intern_name character varying(100),
    age integer,
    contact character varying(100),
    college character varying(100),
    course character varying(100),
    duration integer,
    reference_by character varying(100),
    project character varying(100),
    email character varying(255),
    password_hash text NOT NULL,
    CONSTRAINT interns_age_check CHECK ((age >= 18)),
    CONSTRAINT interns_duration_check CHECK ((duration = ANY (ARRAY[1, 2, 3, 6])))
);


ALTER TABLE public.interns OWNER TO postgres;

--
-- Name: mobiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mobiles (
    name character varying(250),
    model integer,
    ram integer,
    processor character varying(250),
    rom integer
);


ALTER TABLE public.mobiles OWNER TO postgres;

--
-- Name: parts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parts (
    pno character varying(30) NOT NULL,
    pname character varying(30),
    colour character varying(20),
    weight numeric,
    city character varying(20)
);


ALTER TABLE public.parts OWNER TO postgres;

--
-- Name: project; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.project (
    jno character varying(5) NOT NULL,
    jname character varying(30),
    city character varying(40)
);


ALTER TABLE public.project OWNER TO postgres;

--
-- Name: salamanca; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salamanca (
    sal_name character varying(50),
    sal_no integer,
    sal_place character varying(50),
    sal_add character varying(50),
    sal_email character varying(50)
);


ALTER TABLE public.salamanca OWNER TO postgres;

--
-- Name: salesman; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.salesman (
    salesman_id integer,
    sales_date date,
    sales_amount numeric
);


ALTER TABLE public.salesman OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    stu_name character varying(30),
    stu_age integer,
    stu_dob date,
    stu_grade character varying(30)
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.suppliers (
    sno character varying(5) NOT NULL,
    sname character varying(50),
    status integer,
    city character varying(40)
);


ALTER TABLE public.suppliers OWNER TO postgres;

--
-- Name: workers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workers (
    wrk_no integer,
    wrk_name character varying(50),
    wrk_age integer,
    wrk_job character varying(50),
    wrk_salary numeric,
    wrk_adr character varying(100)
);


ALTER TABLE public.workers OWNER TO postgres;

--
-- Name: admin_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_requests ALTER COLUMN id SET DEFAULT nextval('public.admin_requests_id_seq'::regclass);


--
-- Name: admins id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins ALTER COLUMN id SET DEFAULT nextval('public.admins_id_seq'::regclass);


--
-- Name: attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);


--
-- Data for Name: admin_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_requests (id, email, password_hash, created_at) FROM stdin;
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admins (id, email, password, created_at) FROM stdin;
234	admin@gmail.com	hokey	2026-01-04 17:53:14.563264
1	admins@gmail.com	scrypt:32768:8:1$i25RxAEtwnSjFLST$e46f6275545a213feeafc97bd5349cb4bd4761c2b185418120dd92db401373f02b498adfd808a5839d8a404c5d5943e7297572a23fa305ef7c63f0b5cacc843c	2026-01-04 18:06:38.55217
2	here@gmail.com	scrypt:32768:8:1$pW9jPNx2y5t5BGea$b95b7c06df2316f6e4c87e091e677305433427967a23ec1eb0083458d1783a3c663e8d4fa94c8ca9ac9b57ba018f870a21df5829c3adcf4aa83cab264ea57ab6	2026-01-04 22:56:13.823447
3	nothing@gmail.com	scrypt:32768:8:1$Dd8mPgp2BzXQBr8Z$661f8a226b6bb744fba2977b237684bf09fe087d2decfba01f623e130a6bb55a3d84a5c199ac23606f970d0d1a068adc36f7c96169b14a20ce7bb0e40f7c9ac3	2026-01-10 23:52:00.186806
4	timeless@gmail.com	scrypt:32768:8:1$gxBj9XpsvjFapLcs$3cc12fe8cec704b7108ddceceeb6dc6a94659914314e591ad88ca3d6b73f63a28dbab1d12c74b169073290aa8f785b44ddc502a721c6455d60f1b8ac2e0134be	2026-01-13 19:27:59.973809
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, intern_email, date, status, marked_at) FROM stdin;
1	user@gmail.com	2025-01-10	P	2025-12-28 00:14:08.648387
2	john@example.com	2025-01-11	A	2025-12-28 00:14:08.648387
3	john@example.com	2025-01-12	P	2025-12-28 00:14:08.648387
4	sam@gmail.com	2026-01-08	P	2026-01-08 19:51:05.822706
5	fury@gmail.com	2026-01-09	P	2026-01-09 22:12:51.02831
6	fury@gmail.com	2026-01-10	P	2026-01-10 22:49:56.832386
7	second@gmail.com	2026-01-10	A	2026-01-10 23:00:28.500925
8	second@gmail.com	2026-01-11	A	2026-01-11 15:50:03.810663
9	second@gmail.com	2026-01-12	A	2026-01-12 23:36:11.040217
10	second@gmail.com	2026-01-13	P	2026-01-13 19:28:23.123199
11	fury@gmail.com	2026-01-13	A	2026-01-13 20:24:36.343959
12	fury@gmail.com	2026-01-15	P	2026-01-15 12:30:20.115716
13	second@gmail.com	2026-01-15	A	2026-01-15 19:47:32.486243
14	second@gmail.com	2026-01-17	A	2026-01-17 13:30:44.301224
15	fury@gmail.com	2026-01-17	A	2026-01-17 17:58:10.009711
16	fury@gmail.com	2026-01-18	P	2026-01-18 07:52:23.160632
17	dhruv@gmail.com	2026-01-18	P	2026-01-18 10:00:07.102553
18	dhruv@gmail.com	2026-01-19	A	2026-01-19 04:36:08.987063
\.


--
-- Data for Name: block; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.block (student_id, student_name, student_birth, student_marks, student_count) FROM stdin;
5453	freedom	1947	69	\N
\.


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (name, price, title, author) FROM stdin;
ncert	499	inheritance	author
\.


--
-- Data for Name: cars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cars (year, name, colour, owner, symbol) FROM stdin;
2018	volkswagen	white	\N	\N
2020	bwm	white	\N	\N
\N	\N	\N	\N	ecstacy
\.


--
-- Data for Name: class; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.class (student_id, student_name, student_birth, student_marks) FROM stdin;
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course (course_id, course_name, course_duration) FROM stdin;
1001	BE MECHANICAL	4
1002	BE CS	4
1004	MBBS	5
1003	BE CIVIL ENGINEERING	5
\.


--
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer (cus_id, cus_name, cus_age, cus_phone, cus_adr) FROM stdin;
1001	Michael	20	9876543210	George avenue, America
1002	Philip	35	9123456780	William avenue, Washington
1003	Andrew	28	9012345678	Trevor avenue, Edinburg
1004	Jhon	40	9988776655	St. Thomas avenue, America
1005	Russel	25	9345678901	EL Agto avenue, Chicago
1006	Tom	18	9456123789	Nosferatu avenue, Philadelphia
1007	Adrian	45	9567891234	Lya avenue, Moscow
1008	Max	50	9789012346	Wisdom avenue, New York
1009	Luke	36	9890123457	Antony avenue, America
1102	ygb	356	56543	nbgkznjb
2900	Numan	18	123498303484	u 102, cosmos, magarpatta
2901	Numan Alathur	19	7837377383	jfkshklgf 48333
3000	arthur	32	1234556788	wilson garden, laksandra
3001	jknvjf	42	3256789	b,ndk
2002	graditude	4	8379582832	43.cross validation
2000	fsbdf	32	877374897389	dbffkjfkl
783	neel	32	83829693	no.3 hfgsjhijaf
\.


--
-- Data for Name: department; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.department (dep_no, dep_name, dep_loc) FROM stdin;
1	web devep	infosys
2	sales	chicago
3	sales	dallas
3	research	new york
4	sales	moscow
5	research	south africa
6	sales	edinburgh
8	sales	syria
9	sales	london
10	organization	sweden
\.


--
-- Data for Name: dept; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dept (deptno, deptname, loc) FROM stdin;
10	Accounting	New york
20	Research	Dallas
30	Sales	Chicago
40	Operations	Boston
\.


--
-- Data for Name: emp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emp (empno, ename, job, mgr, hiredate, sal, comm, deptno) FROM stdin;
7839	King	President	\N	1981-11-17	5000	\N	10
7566	Jones	Manager	7839	1981-04-02	2975	\N	20
7788	Scott	Analyst	7566	1982-12-09	3000	\N	20
7876	Adams	Clerk	7788	1983-01-12	1100	\N	20
7844	Turner	Salesman	7698	1981-09-08	1500	0	30
7698	Blake	Manager	7839	1981-05-01	2850	\N	30
7934	Miller	Clerk	7782	1982-01-23	1300	\N	10
7782	Clark	Manager	7839	1981-06-09	2450	\N	10
7654	Martin	Salesman	7698	1981-09-28	1250	1400	30
7521	Ward	Salesman	7698	1981-02-22	1250	500	30
7900	James	Clerk	7698	1981-12-03	950	\N	30
7902	Ford	Analyst	7566	1981-12-04	3000	\N	20
7369	Smith	Clerk	7902	1980-12-17	800	\N	20
7499	Allen	Salesman	7698	1981-02-20	1600	300	30
\.


--
-- Data for Name: employee; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee (emp_no, emp_name, emp_job, emp_hiredate, emp_salary, emp_commision, emp_deptno, emp_, emp_forward, emp_age) FROM stdin;
7562	scott	president	2023-02-10	77463	36474	4	\N	\N	\N
5632	king	salesman	2023-08-08	45433	567532	5	\N	\N	\N
6576	jones	analyst	2023-09-03	89732	345532	6	\N	\N	\N
7687	ford	manager	2023-01-04	87342	42232	8	\N	\N	\N
4532	captain	clerk	2023-03-08	58673	86782	9	\N	\N	\N
74633	New Employee	\N	\N	\N	\N	\N	\N	5000	\N
74632	adams	clerk	2023-04-20	78963	54334	3	\N	6888	\N
8732	indiana jones	clerk	\N	\N	\N	\N	\N	4369	\N
9789	miller	trainer	2023-04-04	34732	65532	7	\N	\N	\N
456	philip	\N	\N	4567878	\N	\N	\N	\N	\N
867	dwayne	\N	\N	9800	\N	\N	\N	\N	\N
1	John Doe	\N	\N	65000	\N	\N	\N	\N	\N
\.


--
-- Data for Name: emptb; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emptb (emp_name, emp_email, emp_no, emp_dob) FROM stdin;
jane doe	janedoe@gmail.com	12345	-2002
\.


--
-- Data for Name: interns; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interns (reg_no, intern_name, age, contact, college, course, duration, reference_by, project, email, password_hash) FROM stdin;
24356753	\N	21	2893291	saveetha school of engineering	cseai	2	\N	attendance management system	zaman@gmail.com	pbkdf2:sha256:1000000$GULRakbm3nxrI2iw$4fb046b006c91a81ccdcabd9d5f242d7d6bf503aa57c8afeb1c323c0cd16c92d
2435675349	\N	21	2893291	saveetha school of engineering	cseai	2	\N	gdhfgzhv	zaman@gmail.com	pbkdf2:sha256:1000000$tkMfNZzRTPUmoMOL$3a671dc60ba991001b546536bbda24aca622f6332d4f904f2994df0f727f413b
192372333	\N	20	24328932	nothing	cse-it	6	\N	jkfajkgn	vardha@gmail.com	pbkdf2:sha256:1000000$6aAFNW6Lf35QohKO$e2d6b8a41fe7b11624bbc467d0615e035ce3ea8184ba54db0329d1ee0983ff3e
75676467	\N	23	3457846334	xxx	aids	2	\N	sfjkdfhjkg	zabxsd@gmail.com	pbkdf2:sha256:1000000$u7N66wbRBabpScmC$5a1704fd0e7b7e9d0c46e5cfd673da7471fefaa2926d15a262492acb648ae80f
34567899	\N	25	98498323258	SRM institute of technology	AIML	2	\N	Alarm system	neil@gmail.com	pbkdf2:sha256:1000000$R8Ez9j0ZJ1o3EzLb$5d61896243f0eea08a61938a3d410a32167ee7fb0f1f0dae258c69eb6da30478
565644	\N	26	7656656	Kings engineering college	CSE-ML	3	\N	Implementation of Z-transform	gilman@gmail.com	pbkdf2:sha256:1000000$RBg72McCOqWAWE62$ed8380d4d1fff6482c75e57f2082f24e2c59265919bbe9b301bd5a369813d354
123456789	\N	20	7894561230	Vellore institute of technology	EEE	2	\N	Is there someone else or not	someone@gmail.com	pbkdf2:sha256:1000000$pprVifWj12qQQ7M0$1fdda3659aed9e04ef958d0409c2c835b6a0a297854d5a18ed29cd5f33a76a55
31356663	\N	25	667484545	Reva University	B.E. CSE	2	\N	Hellman's mayo	Lois@gmail.com	pbkdf2:sha256:1000000$bpTqwgBHERz5lio7$438e1e3fd0c3bba25afb1e02562c59a3a211d977c87b92f23a8fa4c036da32b7
98372493	ZYAN	22	93724834222	xxxx	xyxyyx	2	unknown	everything	user@gmail.com	pbkdf2:sha256:1000000$VwtyLzzAn89zanRt$4056d0c6087c6814d47192a55de80c37b0c77cce195497a15051b8f9f96926b7
598739	Euler	22	23789754989	MIT	CSE	3	someone	jhzjkb nznbjnbkjn	Euler@gmail.com	pbkdf2:sha256:1000000$CouDDsHBfsuoHa4s$7fce24ca8ec119a44a1b59ae32603e1d2a418c588f9f700f4ec91f89b8e61948
7865487	jacob	20	64238791	SRM college	CSE-AIML	2	xxxx	Alarm managment system	jacob@gmail.com	pbkdf2:sha256:1000000$FjjlOUrpDb5Q5Ti0$fc5014ff63c87a90298033c0d088494088a8b696a608e526c05b20e35a85a994
6583427	julie	22	628798432	REVA college	CSE	2	xxxx	sjkghiaro	julie@gmail.com	pbkdf2:sha256:1000000$2Xwfo2NhWba4JQWM$b36c3e9578ab0c1745dd897bd1a205c68d976323ad7b99fe005d2de832b127cb
237478	Golang	23	32432335323	saveetha school of engineering	CSE	3	\N	something	golang@gmail.com	pbkdf2:sha256:1000000$M1GbVxsv0RBBCHfj$9627e540e4691f1e6ebbd790d233925d816c7ec3f994d947fa5f23af362e2d62
8485743	Keith blanko	21	3293232332	saveetha school of engineering	CSE	2	\N	something gigs	keith@gmail.com	pbkdf2:sha256:1000000$VAllB1NrIkcBbHFq$6e695b76bf7395653dfaa04ecae235f5c011f316a574583af3606f70ce76fa1d
483975	jdgj	34	4325425	hsdjgnh	nfg	3	fhgcre	dhjghjhsdghsuer	yep@gmail.com	pbkdf2:sha256:1000000$PJDr4hk5ZHVsy2Yp$2352337899b546d5767a9af391ff5fb84af0b463b4b382fd1398828d59f54630
78345798	let it happen	23	438597289634	saveetha school of engineering	CSE-AIML	3	xxx	hjkhfurge	let@gmail.com	pbkdf2:sha256:1000000$g9La9AmGBzxomJQx$7bac3244d33c7171e7a22aed413a823aff27348b24cea73d2452d77cfda88de3
12345	keith sam	23	2342354243243	ghjdfg	jhsgur	2	dfsjgirinejjf	fjksdjgiegs	keithsam@gmail.com	pbkdf2:sha256:1000000$d7bKrd4tbtt9i1wn$eebf7d84264cda2b0d981b1038b4d0fb3b26f5f7fd05a8aa351c4fbf6e08cf33
09876	samsmith	23	23456425	saveetha school of engineering	CSE	6	digiking	nothing but simple	sam@gmail.com	pbkdf2:sha256:1000000$jmlLmRN1pfZvkyCp$211e022ae8745b50a532a1c0117fe2116e220dfbc81738457e4e06b430992c63
0000	xo_tatted	23	0349309403	bdfdjskf	fjgdfjg	2	nfjdkgn	hjhgjd	xotatted@gmail.com	pbkdf2:sha256:1000000$DdQYUdMkJmpnEkg0$21f1294a4c8c726b2a97859a8e0243056f58baa78ac096a1566ae27027baf890
2211	dhruv	24	236478235	xxx	xx	1	xxxxxxxx	forbidden from the beginningk	dhruv@gmail.com	pbkdf2:sha256:600000$UHYo7mQM1n3wUR9I$19714b089a2e9d108c46370d5185aee2dc52fdc405c2e5de71ff255a72ad4757
2345	second	25	34545	cvdsgf	alarm system interrupted	2	dfsvgdfvgb	you can't change the past but the present	second@gmail.com	pbkdf2:sha256:1000000$FNaMYRpuRzlxR7gI$8cf37722d2324957aa23c29060ba1f995e1d56b2d9b74c34f0783d108f0d1453
1122	fury	26	8673565	sjcda	snd	2	dsfsv	here iam	fury@gmail.com	pbkdf2:sha256:1000000$1ICASrJGYjZdHyTZ$56e46a3d53634a4d2c8700cb4cd6b9c243a47ba53d3f3bd64b23724a619fde46
19233	fury	23	173274239	destina	c cn	1	 cvjcs	bsfhvbjf	furynigga@gmail.com	pbkdf2:sha256:1000000$oWTHCFdyA2Cagk62$ddfc6a2cf3fe00e349f0b1f4175510d8d11f766c6f2185f34e5893d55a020c01
1921	second	22	348754839	SRM university	trippin	3	jingles	keothlin	secondlin@gmail.com	pbkdf2:sha256:600000$Bw6xhUORxycqvsWT$032b9e98889ac6f9cb4b6b7720200282a1bcbb847c2afeb65354e51aa46b1eaa
\.


--
-- Data for Name: mobiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mobiles (name, model, ram, processor, rom) FROM stdin;
vivo	100	8	snapdragon	\N
\.


--
-- Data for Name: parts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parts (pno, pname, colour, weight, city) FROM stdin;
pkP1	Nut	Red	12.0	London
pkP2	Bolt	Green	17.0	Paris
pkP3	Screw	Blue	17.0	Rome
pkP4	Screw	Red	14.0	London
pkP5	Cam	Blue	12.0	Paris
pkP6	Cog	Red	19.0	London
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.project (jno, jname, city) FROM stdin;
J1	Montago	London
J2	Cat	Paris
J3	Box	London
J4	Montago	Rome
J5	Eagles	Athens
\.


--
-- Data for Name: salamanca; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salamanca (sal_name, sal_no, sal_place, sal_add, sal_email) FROM stdin;
tuco	28834	spain	stephenson_avenue	tucosalamanca@gmail.com
\.


--
-- Data for Name: salesman; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.salesman (salesman_id, sales_date, sales_amount) FROM stdin;
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (stu_name, stu_age, stu_dob, stu_grade) FROM stdin;
george	24	2020-04-02	s
\.


--
-- Data for Name: suppliers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.suppliers (sno, sname, status, city) FROM stdin;
S1	Smith	20	London
S2	Jones	10	Paris
S3	Blake	30	Paris
S4	Clarke	20	London
S5	Adams	30	Athens
\.


--
-- Data for Name: workers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workers (wrk_no, wrk_name, wrk_age, wrk_job, wrk_salary, wrk_adr) FROM stdin;
5001	Jhon	40	Analyst	40000	no.3 washington Avenue
5003	Parker	50	Web developer	69900	London SW1A 1AA, United Kingdom
5004	Steven	45	Salesman	70000	Pennsylvania Ave NW, Washington
5006	Poseidon	38	Electrician	67800	Taj Mahal, Agra, Uttar Pradesh 282001, India 
5008	Miller	55	Accountant	45660	Champ de Mars, 5 Av. Anatole France, France 
5010	kate	57	Analyst	88890	gjhkjhgh
5011	grumpy	29	web developer	93854	neon avenue, cairo
5005	\N	\N	\N	\N	\N
5007	flippo	42	doms	42354	dkjgoihh
5002	deiter	34	Activist	65000	no.6 redsquare moscow
2000	jasmin	42	Employee	34234	noefhvijbf
4001	peter	28	Analysts	98772	xyz avenue washington
1245	abc	56	Analysts	478	fgz hfg j
\.


--
-- Name: admin_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_requests_id_seq', 7, true);


--
-- Name: admins_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admins_id_seq', 4, true);


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_id_seq', 18, true);


--
-- Name: admin_requests admin_requests_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_requests
    ADD CONSTRAINT admin_requests_email_key UNIQUE (email);


--
-- Name: admin_requests admin_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_requests
    ADD CONSTRAINT admin_requests_pkey PRIMARY KEY (id);


--
-- Name: admins admins_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_key UNIQUE (email);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (course_id);


--
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (cus_id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (emp_no);


--
-- Name: interns interns_reg_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interns
    ADD CONSTRAINT interns_reg_no_key UNIQUE (reg_no);


--
-- Name: parts parts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parts
    ADD CONSTRAINT parts_pkey PRIMARY KEY (pno);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (jno);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (sno);


--
-- PostgreSQL database dump complete
--

