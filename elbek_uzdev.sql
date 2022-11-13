--
-- PostgreSQL database dump
--

-- Dumped from database version 14.5 (Ubuntu 14.5-1.pgdg20.04+1)
-- Dumped by pg_dump version 14.5 (Ubuntu 14.5-1.pgdg20.04+1)

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
-- Name: add_action(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.add_action() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    row record;
begin
    for row in select * from book where class_number = new.number and is_active = true
        loop
            insert into actions (class_id, book_id) values (new.id, row.id);
        end loop;

    return new;
end;

$$;


ALTER FUNCTION public.add_action() OWNER TO postgres;

--
-- Name: addbook(integer, integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.addbook(IN classid integer, IN bookcount integer, IN commentin character varying)
    LANGUAGE plpgsql
    AS $$
declare
    bookId int;
begin
    for bookId in select book_id from actions where class_id = classId group by book_id loop
            insert into actions (class_id, book_id, comment, count) VALUES (classId, bookId, commentIn, bookCount);
        end loop;
end; $$;


ALTER PROCEDURE public.addbook(IN classid integer, IN bookcount integer, IN commentin character varying) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actions (
    id integer NOT NULL,
    class_id integer NOT NULL,
    book_id integer NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    comment character varying,
    action_date timestamp with time zone DEFAULT now()
);


ALTER TABLE public.actions OWNER TO postgres;

--
-- Name: actions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.actions_id_seq OWNER TO postgres;

--
-- Name: actions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actions_id_seq OWNED BY public.actions.id;


--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    id integer NOT NULL,
    name character varying NOT NULL,
    class_number integer NOT NULL,
    production_year integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: book_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.book_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.book_id_seq OWNER TO postgres;

--
-- Name: book_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.book_id_seq OWNED BY public.book.id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    id integer NOT NULL,
    number integer NOT NULL,
    "character" character varying(1) NOT NULL,
    teacher character varying NOT NULL,
    student_count integer NOT NULL,
    school_id integer NOT NULL,
    education_year integer,
    is_active boolean DEFAULT true,
    CONSTRAINT classes_number_check CHECK (((number > 0) AND (number < 12))),
    CONSTRAINT classes_student_count_check CHECK ((student_count > 0))
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.classes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_id_seq OWNER TO postgres;

--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- Name: district; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.district (
    id integer NOT NULL,
    name character varying NOT NULL,
    region_id integer NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.district OWNER TO postgres;

--
-- Name: district_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.district_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.district_id_seq OWNER TO postgres;

--
-- Name: district_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.district_id_seq OWNED BY public.district.id;


--
-- Name: phonenumbers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.phonenumbers (
    id integer NOT NULL,
    phonenumber character varying(12) NOT NULL,
    sms_code integer,
    is_active boolean DEFAULT false NOT NULL,
    action_time bigint
);


ALTER TABLE public.phonenumbers OWNER TO postgres;

--
-- Name: phonenumbers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.phonenumbers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phonenumbers_id_seq OWNER TO postgres;

--
-- Name: phonenumbers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.phonenumbers_id_seq OWNED BY public.phonenumbers.id;


--
-- Name: region; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.region (
    id integer NOT NULL,
    name character varying NOT NULL,
    is_active boolean DEFAULT true
);


ALTER TABLE public.region OWNER TO postgres;

--
-- Name: region_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.region_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.region_id_seq OWNER TO postgres;

--
-- Name: region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.region_id_seq OWNED BY public.region.id;


--
-- Name: school_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.school_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.school_id_seq OWNER TO postgres;

--
-- Name: school; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.school (
    id integer DEFAULT nextval('public.school_id_seq'::regclass) NOT NULL,
    region_id integer NOT NULL,
    district_id integer NOT NULL,
    school_number integer NOT NULL,
    phone_number character varying NOT NULL,
    password character varying NOT NULL,
    is_active boolean DEFAULT true,
    CONSTRAINT school_phone_number_check CHECK ((((phone_number)::text ~ '^9{2}8\d{9}'::text) AND (length((phone_number)::text) = 12)))
);


ALTER TABLE public.school OWNER TO postgres;

--
-- Name: actions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions ALTER COLUMN id SET DEFAULT nextval('public.actions_id_seq'::regclass);


--
-- Name: book id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book ALTER COLUMN id SET DEFAULT nextval('public.book_id_seq'::regclass);


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- Name: district id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district ALTER COLUMN id SET DEFAULT nextval('public.district_id_seq'::regclass);


--
-- Name: phonenumbers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phonenumbers ALTER COLUMN id SET DEFAULT nextval('public.phonenumbers_id_seq'::regclass);


--
-- Name: region id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region ALTER COLUMN id SET DEFAULT nextval('public.region_id_seq'::regclass);


--
-- Data for Name: actions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actions (id, class_id, book_id, count, comment, action_date) FROM stdin;
\.


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.book (id, name, class_number, production_year, is_active) FROM stdin;
1	Ona tili	2	2021	t
2	Oʻqish kitobi	2	2021	t
3	Russkiy yazik  	2	2021	t
4	Matematika 	2	2021	t
5	Atrofimizdagi olam	2	2021	t
6	Tarbiya	2	2020	t
7	Tasviriy sanʼat	2	2021	t
8	Musiqa 	2	2021	t
9	“Kidsʻ English”	2	2021	t
10	“Workbook”	2	2021	t
11	“Deutsch mit spaβ”	2	2021	t
12	“Arbeitsheft”	2	2021	t
13	“Hirondelle”	2	2021	t
14	“Cahier dʻexercices”	2	2021	t
15	Texnologiya 	2	2021	t
16	Ona tili	3	2019	t
17	Oʻqish kitobi	3	2019	t
18	Russkiy yazыk 	3	2019	t
19	Matematika 	3	2019	t
20	Tabiatshunoslik 	3	2019	t
21	Tarbiya	3	2020	t
22	Tasviriy sanʼat	3	2019	t
23	Musiqa 	3	2019	t
24	 “Kidsʻ English”	3	2021	t
25	 “Workbook”	3	2020	t
26	“Deutsch mit Spaβ”	3	2021	t
27	 “Arbeitsheft”	3	2020	t
28	 “Hirondelle”	3	2020	t
29	 “Cahier dʻexercices”	3	2021	t
30	Texnologiya	3	2019	t
31	Ona tili	4	2020	t
32	Oʻqish kitobi	4	2020	t
33	Russkiy yazыk	4	2020	t
34	Matematika	4	2020	t
35	Tabiatshunoslik	4	2020	t
36	Tarbiya	4	2020	t
37	Musiqa	4	2020	t
38	Texnologiya	4	2020	t
39	Tasviriy sanʼat 	4	2020	t
40	 “Kidsʻ English”	4	2020	t
41	 “Workbook”	4	2021	t
42	“Deutsch mit Spaβ”	4	2020	t
43	 “Arbeitsheft”	4	2021	t
44	 “Hirondelle”	4	2020	t
45	 “Cahier dʻexercices”	4	2021	t
46	Ona tili	5	2020	t
47	Adabiyot 	5	2020	t
48	Russkiy yazыk	5	2020	t
49	 “New Fly High English”	5	2017	t
50	“Deutsch”	5	2017	t
51	“Je parle français”	5	2017	t
52	Tarixdan hikoyalar	5	2020	t
54	Biologiya	5	2020	t
55	Geografiya (Tabiiy geografiya boshlangʻich kursi)	5	2020	t
56	Informatika va axborot texnologiyalari	5	2020	t
57	Tarbiya	5	2020	t
58	Musiqa	5	2020	t
59	Texnologiya 	5	2020	t
60	Tasviriy sanʼat 	5	2020	t
61	Matematika (ixtisoslashtirilgan  maktablar uchun)	5	2021	t
62	Ona tili	6	2017	t
63	Adabiyot 	6	2017	t
64	Russkiy yazыk	6	2017	t
65	“Teensʻ English”	6	2018	t
66	“Assalom, Deutsch!”	6	2018	t
67	“Voyage en France”	6	2018	t
68	Tarix	6	2017	t
69	Matematika	6	2017	t
70	Fizika	6	2017	t
71	Biologiya (Botanika)	6	2017	t
72	Informatika va axborot texnologiyalari	6	2017	t
73	Geografiya (Materiklar va okeanlar tabiiy geografiyasi)	6	2017	t
74	Tarbiya	6	2020	t
75	Musiqa	6	2017	t
76	Texnologiya	6	2017	t
77	Tasviriy sanʼat	6	2017	t
78	Matematika (ixtisoslashtirilgan  maktablar uchun)	6	2021	t
79	Fizika (ixtisoslashtirilgan  maktablar uchun)	6	2019	t
80	Ona tili	7	2017	t
81	Adabiyot	7	2017	t
82	Russkiy yazыk	7	2017	t
83	“Teensʻ English”	7	2019	t
84	“Assalom, Deutsch!”	7	2019	t
85	“Bon voyage”	7	2019	t
86	Oʻzbekiston tarixi	7	2017	t
87	Jahon tarixi	7	2017	t
88	Algebra	7	2017	t
89	Geometriya	7	2017	t
90	Fizika	7	2017	t
91	Kimyo	7	2017	t
92	Biologiya (Zoologiya) 	7	2017	t
93	Geografiya (Oʻrta Osiyo va Oʻzbekiston tabiiy geografiyasi)	7	2017	t
94	Texnologiya	7	2017	t
95	Tasviriy sanʼat	7	2017	t
96	Musiqa	7	2017	t
97	Tarbiya	7	2020	t
98	Informatika va axborot texnologiyalari	7	2017	t
99	Algebra (ixtisoslashtirilgan  maktablar uchun)	7	2019	t
100	Fizika (ixtisoslashtirilgan  maktablar uchun)	7	2021	t
101	Ona tili 	8	2019	t
102	Adabiyot	8	2019	t
103	Russkiy yazыk	8	2019	t
104	“Fly High English”	8	2020	t
105	“Assalom, Deutsch!”	8	2020	t
106	“Le nouveau voyage en France”	8	2020	t
107	Oʻzbekiston tarixi 	8	2019	t
108	Jahon tarixi	8	2019	t
109	Oʻzbekiston davlati va huquqi asoslari	8	2019	t
110	Iqtisodiy bilim asoslari	8	2019	t
111	Algebra	8	2019	t
112	Geometriya	8	2019	t
113	Fizika	8	2019	t
114	Kimyo 	8	2019	t
115	Biologiya (Odam va uning salomatligi)	8	2019	t
116	Geografiya (Oʻzbekiston iqtisodiy- ijtimoiy geografiyasi) 	8	2019	t
117	Tarbiya	8	2020	t
118	Informatika va axborot texnologiyalari	8	2020	t
119	Chizmachilik	8	2019	t
120	Algebra (ixtisoslashtirilgan  maktablar uchun)	8	2019	t
121	Texnologiya	8	2019	t
122	Fizika (ixtisoslashtirilgan  maktablar uchun)	8	2021	t
123	Ona tili	9	2019	t
124	Adabiyot	9	2019	t
125	Russkiy yazыk	9	2019	t
126	“Fly High English” 	9	2021	t
127	“Deutsch” 	9	2021	t
128	Dʻun Etat à lʻautre"	9	2021	t
129	Oʻzbekiston tarixi	9	2019	t
130	Jahon tarixi	9	2019	t
131	Konstitutsiyaviy huquq asoslari	9	2019	t
132	Iqtisodiy bilim asoslari	9	2019	t
133	Algebra	9	2019	t
134	Geometriya	9	2019	t
135	Informatika va axborot texnologiyalari	9	2020	t
136	Fizika	9	2019	t
137	Kimyo 	9	2019	t
138	Biologiya sitologiya va genetika asoslari	9	2019	t
139	Geografiya (Jahon iqtisodiy - ijtimoiy geografiyasi) 	9	2019	t
140	Tarbiya	9	2020	t
141	Chizmachilik	9	2019	t
142	Algebra (ixtisoslashtirilgan  maktablar uchun)	9	2021	t
143	Texnologiya	9	2019	t
144	Fizika (ixtisoslashtirilgan  maktablar uchun)	9	2021	t
145	Ona tili	10	2017	t
146	Ona tili (oʻquv qoʻllama)	10	2020	t
147	Adabiyot	10	2017	t
148	Russkiy yazыk	10	2017	t
149	“English” 	10	2017	t
150	“Deutsch” 	10	2017	t
151	“France”	10	2017	t
152	Oʻzbekiston tarixi	10	2017	t
153	Jahon tarixi	10	2017	t
154	Tarbiya	10	2021	t
155	Davlat va huquq asoslari	10	2017	t
156	Maʼnaviyat asoslari	10	2017	t
157	Matematika (algebra va analiz asoslari, geometriya) 	10	2017	t
158	Informatika va axborot texnologiyalari	10	2017	t
159	Fizika	10	2017	t
160	Organik kimyo	10	2017	t
161	Biologiya	10	2017	t
162	Geografiya (Amaliy geografiya)	10	2017	t
163	Chaqiruvga  qadar boshlangʻich tayyorgarlik	10	2017	t
164	Ona tili	11	2018	t
165	Ona tili (oʻquv qoʻllama)	11	2020	t
166	Adabiyot	11	2018	t
167	Russkiy yazыk	11	2018	t
168	Oʻzbekiston tarixi	11	2018	t
169	Jaxon tarixi	11	2018	t
170	Tarbiya	11	2021	t
171	Davlat va huquq asoslari	11	2018	t
172	Maʼnaviyat asoslari	11	2018	t
173	Tadbirkorlik asoslari	11	2018	t
174	Matematika (algebra va analiz asoslari, geometriya)	11	2018	t
175	Informatika va axborot texnologiyalari	11	2018	t
176	Biologiya	11	2018	t
177	Astronomiya	11	2018	t
178	Fizika	11	2018	t
179	Umumiy kimyo	11	2018	t
180	“English” 	11	2018	t
181	“Deutsch” 	11	2018	t
182	“Libre opinion”	11	2018	t
183	Chaqiruvga  qadar boshlangʻich tayyorgarlik	11	2018	t
53	Matematika 1	5	2020	t
184	Matematika 2	5	2020	t
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id, number, "character", teacher, student_count, school_id, education_year, is_active) FROM stdin;
\.


--
-- Data for Name: district; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.district (id, name, region_id, is_active) FROM stdin;
2	Chortoq	1	t
3	Chust	1	t
4	Kosonsoy	1	t
5	Mingbuloq	1	t
6	Namangan	1	t
7	Norin	1	t
8	Pop	1	t
9	To`raqo`rg`on	1	t
10	Uchqo`rg`on	1	t
11	Uychi	1	t
12	Yangiqo`rg`on	1	t
13	Amudaryo	2	t
14	Beruniy	2	t
15	Chimboy	2	t
16	Ellikqal`a	2	t
17	Kegeyli	2	t
19	Mo`ynoq	2	t
20	Shumanay	2	t
21	Nukus	2	t
22	Qonliko`l	2	t
23	Qo`ng`irot	2	t
24	Qorao`zak	2	t
25	Taxtako`pir	2	t
26	To`rtko`l	2	t
27	Xo`jayli	2	t
28	Bogot	3	t
29	Gurlen	3	t
30	Xonqa	3	t
31	Hazorasp	3	t
32	Xiva	3	t
33	Qo`shko`pir	3	t
34	Shovot	3	t
35	Urganch	3	t
36	Yangiariq	3	t
37	Yangibozor	3	t
38	Kanimex	4	t
39	Navoiy	4	t
40	Qiziltepa	4	t
41	Xatirchi	4	t
42	Navbahor	4	t
43	Nurota	4	t
44	Tamdi	4	t
45	Uchquduq	4	t
46	Olot	5	t
47	Buxoro	5	t
48	G`ijduvon	5	t
49	Jondor	5	t
50	Kogon	5	t
51	Qorako`l	5	t
52	Qorovulbozor	5	t
53	Peshku	5	t
54	Romitan	5	t
55	Shofirkon	5	t
56	Vabkent	5	t
57	Bulung`ur	6	t
58	Ishtixon	6	t
59	Jomboy	6	t
60	Kattaqo`rg`on	6	t
61	Qo`shrabot	6	t
62	Narpay	6	t
63	Nurobod	6	t
64	Oqdaryo	6	t
65	Paxtachi	6	t
66	Payariq	6	t
67	Pastdarg`om	6	t
68	Samarqand	6	t
69	Toyloq	6	t
70	Urgut	6	t
71	Chiroqchi	7	t
72	Dehqonobod	7	t
73	G`uzor	7	t
74	Qamashi	7	t
75	Qarshi	7	t
76	Koson	7	t
77	Kasbi	7	t
78	Kitob	7	t
79	Mirishkor	7	t
80	Muborak	7	t
81	Nishon	7	t
82	Shahrisabz	7	t
83	Yakkabog`	7	t
84	Angor	8	t
85	Bandixon	8	t
86	Boysun	8	t
87	Denov	8	t
88	Jarqo`rg`on	8	t
89	Kizirik	8	t
90	Qumqo`rg`on	8	t
91	Muzrabot	8	t
92	Oltinsoy	8	t
93	Sariosiyo	8	t
94	Sherobod	8	t
95	Sho`rchi	8	t
96	Termiz	8	t
97	Uzun	8	t
98	Arnasoy	9	t
99	Baxmal	9	t
100	Do`stlik	9	t
101	Forish	9	t
102	G`allaorol	9	t
103	Jizzax	9	t
104	Mirzacho`l	9	t
105	Paxtakor	9	t
106	Yangiobod	9	t
107	Zomin	9	t
108	Zafarobod	9	t
109	Zarbdar	9	t
110	Akaltin	10	t
111	Bayaut	10	t
112	Guliston	10	t
113	Xovast	10	t
114	Mirzaobod	10	t
115	Sayxunobod	10	t
116	Sardoba	10	t
117	Sirdayo	10	t
118	Bekobod	11	t
119	Bo`stonliq	11	t
120	Buka	11	t
121	Chinoz	11	t
122	Qibray	11	t
123	Ohangaron	11	t
124	Oqqo`rg`on	11	t
125	Parkent	11	t
126	Piskent	11	t
127	Quyi Chirchiq	11	t
128	O`rta Chirchiq	11	t
129	Yangi yo`l	11	t
130	Yuqori Chirchiq	11	t
131	Zangiata	11	t
132	Oltiariq	12	t
133	Bag`dod	12	t
134	Beshariq	12	t
135	Buvayda	12	t
136	Dang`ara	12	t
137	Farg`ona	12	t
138	Furqat	12	t
139	Qo`shtepa	12	t
140	Quva	12	t
141	Rishton	12	t
142	So`x	12	t
143	Toshloq	12	t
144	Uchko`prik	12	t
145	O`zbekiston	12	t
146	Yozyovon	12	t
147	Andijon	13	t
148	Asaka	13	t
149	Baliqchi	13	t
150	Boz	13	t
151	Buloqboshi	13	t
152	Jalolquduq	13	t
153	Xo`jaobod	13	t
154	Kurgontepa	13	t
155	Marhamat	13	t
156	Oltinko`l	13	t
157	Paxtaobod	13	t
158	Shahrixon	13	t
159	Ulugnor	13	t
160	Bektemir	15	t
161	Chilonzor	15	t
163	Hamza	15	t
164	Mirobod	15	t
165	Mirzo Ulug`bek	15	t
166	Sergeli	15	t
167	Shayxontohur	15	t
168	Olmazar	15	t
169	Uchtepa	15	t
170	Yakkasaroy	15	t
171	Yunusobod	15	t
\.


--
-- Data for Name: phonenumbers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.phonenumbers (id, phonenumber, sms_code, is_active, action_time) FROM stdin;
1	998931732003	6048	t	1666430848981
2	998990616218	1011	t	\N
\.


--
-- Data for Name: region; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.region (id, name, is_active) FROM stdin;
1	Namangan	t
2	Qoraqalpog`iston	t
3	Xorazm	t
4	Navoiy	t
5	Buxoro	t
6	Samarqand	t
7	Qashqadaryo	t
8	Surxondaryo	t
9	Jizzax	t
10	Sirdaryo	t
11	Toshkent	t
12	Farg`ona	t
13	Andijon	t
15	Toshkent sh	t
\.


--
-- Data for Name: school; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.school (id, region_id, district_id, school_number, phone_number, password, is_active) FROM stdin;
1	1	9	42	998931732003	$2a$10$qKRrGN2nB6laDeeObIhNoOGH7JT.HSqGLTGGJpvEII2joN0WvkbJu	t
3	5	10	78	998990616218	$2a$10$i3/Ik2yq4cW1Hct4jTHg3O5vxSbYrnZ2YE9t28kFaYtLphk9EYUfS	t
\.


--
-- Name: actions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actions_id_seq', 1, false);


--
-- Name: book_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.book_id_seq', 184, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.classes_id_seq', 1, false);


--
-- Name: district_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.district_id_seq', 171, true);


--
-- Name: phonenumbers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.phonenumbers_id_seq', 2, true);


--
-- Name: region_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.region_id_seq', 15, true);


--
-- Name: school_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.school_id_seq', 3, true);


--
-- Name: actions actions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (id);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (id);


--
-- Name: classes classes_education_year_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.classes
    ADD CONSTRAINT classes_education_year_check CHECK ((education_year >= 2022)) NOT VALID;


--
-- Name: classes classes_number_character_education_year_school_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_number_character_education_year_school_id_key UNIQUE (number, "character", education_year, school_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: district district_name_region_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district
    ADD CONSTRAINT district_name_region_id_key UNIQUE (name, region_id);


--
-- Name: district district_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district
    ADD CONSTRAINT district_pkey PRIMARY KEY (id);


--
-- Name: phonenumbers phonenumbers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.phonenumbers
    ADD CONSTRAINT phonenumbers_pkey PRIMARY KEY (id);


--
-- Name: region region_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_name_key UNIQUE (name);


--
-- Name: region region_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.region
    ADD CONSTRAINT region_pkey PRIMARY KEY (id);


--
-- Name: school school_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_phone_number_key UNIQUE (phone_number);


--
-- Name: school school_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_pkey PRIMARY KEY (id);


--
-- Name: school school_region_id_district_id_school_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT school_region_id_district_id_school_number_key UNIQUE (region_id, district_id, school_number);


--
-- Name: phonenumbers_phonenumber_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX phonenumbers_phonenumber_uindex ON public.phonenumbers USING btree (phonenumber);


--
-- Name: classes add_action_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_action_trigger AFTER INSERT ON public.classes FOR EACH ROW EXECUTE FUNCTION public.add_action();


--
-- Name: actions actions_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(id);


--
-- Name: actions actions_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actions
    ADD CONSTRAINT actions_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: classes classes_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);


--
-- Name: district district_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.district
    ADD CONSTRAINT district_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.region(id);


--
-- Name: school fk_district_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT fk_district_id FOREIGN KEY (district_id) REFERENCES public.district(id);


--
-- Name: school fk_region_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.school
    ADD CONSTRAINT fk_region_id FOREIGN KEY (region_id) REFERENCES public.region(id);


--
-- PostgreSQL database dump complete
--

