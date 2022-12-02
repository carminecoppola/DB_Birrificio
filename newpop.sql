/*FORNITORI
MASTRI BIRRAI
CONTENITORI
PUB*/

--FORNITORE
insert into Fornitore values (00000000011,'AURIAN SAS','Condom','32100','5 Avenue de la Gare');
insert into Fornitore values (00000000012,'ASIA EUROPE TRADE','Liege','4000','25 rue de Rotterdam');
insert into Fornitore values (00000000013,'E-SARDINIA ','Oristano','09170','Via Santa Petronilla 15');
insert into Fornitore values (00000000014,'NOSTRALE','Milano','20157','Via G. Ungaretti 23');
insert into Fornitore values (00000000015,'PRATOROSSO','Milano','20107','Cascina Gaita 5');
insert into Fornitore values (00000000016,'MARCONI','Novara','30040','5 Avenue de la Gare');
insert into Fornitore values (00000000017,'BRASSERIE DE BRUNEHAUT SA','Brunehaut','7623','17 rue des Panneries');
insert into Fornitore values (00000000018,'SWISS CHIPS GMBH','Schneisingen','5425','4 Schulstrasse');
insert into Fornitore values (00000000019,'RESONE','Paris','75008','1 Rue De Stockholm');
insert into Fornitore values (00000000020,'VETRARIA','Savignano Sul Rubicone','47039','Via Emilia Est 23');
insert into Fornitore values (00000000021,'BROUWERIJ DE FENIKS CVBA','Heule','8501','138 Mellestraat');
insert into Fornitore values (00000000022,'FLECKS BRAUHAUS TECHNIK GMBH ','Frohnleiten','8130','Rothleiten 64');
insert into Fornitore values (00000000023,'KURSK BREWERY, LLC','Kursk','30502','Magistralny 18');
insert into Fornitore values (00000000024,'BEERINBA DI BARBORA','Vigevano','27029','Via Carrobbio 18');
insert into Fornitore values (00000000025,'DE-GUSTAMI','Milano','20131','Via Vallazze 95');

--MASTRO BIRRAIO

insert into MastroBirraio values ('IT0011220','Maurizio','Scarponi',TO_DATE('15/01/1992','DD/MM/YYYY'),TO_DATE('25/01/2006','DD/MM/YYYY'),1600.00);
insert into MastroBirraio values ('IT0011221','Gemma','Moretti',TO_DATE('23/09/1982','DD/MM/YYYY'),TO_DATE('07/01/2007','DD/MM/YYYY'),1600.00);
insert into MastroBirraio values ('IT0011222','Giampiero','Barzini',TO_DATE('12/06/1993','DD/MM/YYYY'),TO_DATE('08/02/2008','DD/MM/YYYY'),1100.00);
insert into MastroBirraio values ('IT0011223','Francesca','Ferrara',TO_DATE('13/07/1994','DD/MM/YYYY'),TO_DATE('04/03/2005','DD/MM/YYYY'),1200.00);
insert into MastroBirraio values ('IT0011224','Sante','Armani',TO_DATE('01/02/1987','DD/MM/YYYY'),TO_DATE('20/02/2009','DD/MM/YYYY'),1150.00);
insert into MastroBirraio values ('IT0011225','Luigi','Fallaci',TO_DATE('18/03/1982','DD/MM/YYYY'),TO_DATE('15/06/2008','DD/MM/YYYY'),1450.00);
insert into MastroBirraio values ('IT0011226','Renata','Torricelli',TO_DATE('24/03/1992','DD/MM/YYYY'),TO_DATE('12/06/2005','DD/MM/YYYY'),1600.00);
insert into MastroBirraio values ('IT0011227','Veronica','Jovinelli',TO_DATE('21/11/1996','DD/MM/YYYY'),TO_DATE('11/06/2009','DD/MM/YYYY'),1150.00);
insert into MastroBirraio values ('IT0011228','Lorenzo','Caccianemico',TO_DATE('14/12/1999','DD/MM/YYYY'),TO_DATE('18/05/2007','DD/MM/YYYY'),1150.00);
insert into MastroBirraio values ('IT0011229','Federico','Iannelli',TO_DATE('16/09/1986','DD/MM/YYYY'),TO_DATE('16/05/2010','DD/MM/YYYY'),1450.00);
insert into MastroBirraio values ('IT0011230','Luisa ','Santoro',TO_DATE('11/03/1982','DD/MM/YYYY'),TO_DATE('19/04/2008','DD/MM/YYYY'),1600.00);
insert into MastroBirraio values ('IT0011231','Adelmo','Tafuri',TO_DATE('04/05/1980','DD/MM/YYYY'),TO_DATE('20/04/2006','DD/MM/YYYY'),1450.00);
insert into MastroBirraio values ('IT0011232','Piero','Malacarne',TO_DATE('03/06/1990','DD/MM/YYYY'),TO_DATE('21/07/2005','DD/MM/YYYY'),1200.00);
insert into MastroBirraio values ('IT0011233','Ciro','Bellini',TO_DATE('11/12/1988','DD/MM/YYYY'),TO_DATE('30/08/2000','DD/MM/YYYY'),1600.00);
insert into MastroBirraio values ('IT0011234','Franco','Mastroianni',TO_DATE('17/10/1981','DD/MM/YYYY'),TO_DATE('29/11/2004','DD/MM/YYYY'),1150.00);


--CONTENITORI

insert into Contenitore values (1,'IT0011220','Bollitore',400,500,2000);
insert into Contenitore values ('IT0011221','Fermentatore',200,300,1500);
insert into Contenitore values ('IT0011222','Bollitore',500,600,2500);
insert into Contenitore values ('IT0011223','Fermentatore',200,300,1500);
insert into Contenitore values ('IT0011224','Bollitore',400,500,2000);
insert into Contenitore values ('IT0011225','Bollitore',450,600,2500);
insert into Contenitore values ('IT0011226','Bollitore',250,300,1500);
insert into Contenitore values ('IT0011227','Fermentatore',350,500,2000);
insert into Contenitore values ('IT0011228','Fermentatore',250,300,1500);
insert into Contenitore values ('IT0011229','Bollitore',400,500,2000);
insert into Contenitore values ('IT0011230','Bollitore',575,600,2500);
insert into Contenitore values ('IT0011231','Fermentatore',400,500,2000);
insert into Contenitore values ('IT0011232','Bollitore',500,600,2500);
insert into Contenitore values ('IT0011233','Fermentatore',400,500,2000);
insert into Contenitore values ('IT0011234','Fermentatore',200,300,1500);
