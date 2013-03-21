The file courses_details.txt contains detailed information about the courses.
The fields are tab delimited. The fields are as follows:
COURSE FID course item id, used in courses_num.txt
COURSE SHORT NAME course short name, used in last week's data 
YEAR (1995 to 2012)
TERM (K: spring, V:summer, S:fall)
LEVEL (A:basic studies,	C:intermediate studies,	J:PhD,	K:communication,	L:advanced studies,	M:other studies,	T:introduction	)
COMPULSORY (P:yes, V:no, ?:undefined)
COURSE CODE
SUBPROGRAM (Algoritmit,	Bioinformatiikka,	Ei suuntautumisvaihtoehtoa,	Hajaut.järj. ja tietoliikenne,	Muuntokoulutus,	Ohjelmistojärjestelmät,	Opettaja,	Perusopetus,	Selvitettävä,	Sovellettu tietojenkäsittely,	Yleinen)

One COURSE FID can correspond to one COURSE CODE but may have been taught several years, hence the multiple lines for some COURSE FID 

The file courses_num.txt contains detailed information about enrollment.
Each line corresponds to one student and contains the COURSE FID of the courses the student enrolled to.
Some students may have taken a same course several times, therefore a COURSE FID can appear several time on a given line. The items are sorted by ids, hence the order of the courses inside the transactions is irrelevant.
