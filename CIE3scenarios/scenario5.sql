create database scenario5;
use scenario5;
create table doctor (
    doctorid int primary key,
    doctorname varchar(100)
);

create table patient (
    patientid int primary key,
    patientname varchar(100),
    doctorid int,
    billamount decimal(10,2),
    foreign key (doctorid) references doctor(doctorid)
);

insert into doctor values
(1, 'dr. smith'),
(2, 'dr. johnson'),
(3, 'dr. williams'),
(4, 'dr. brown');  

insert into patient values
(1, 'raj', 1, 1200.00),
(2, 'bob', 2, 900.00),
(3, 'charlie', 1, 1500.00),
(4, 'david', 3, 800.00);

select 
    p.patientname,
    d.doctorname
from patient p
inner join doctor d on p.doctorid = d.doctorid;
/*raj	dr. smith
bob	dr. johnson
charlie	dr. smith
david	dr. williams*/
select 
    d.doctorname,
    p.patientname
from patient p
right outer join doctor d on p.doctorid = d.doctorid;
/*dr. smith	raj
dr. smith	charlie
dr. johnson	bob
dr. williams	david
dr. brown*/	
select 
    d.doctorname,
    count(p.patientid) as total_patients
from doctor d
left join patient p on d.doctorid = p.doctorid
group by d.doctorname;
/*dr. smith	2
dr. johnson	1
dr. williams	1
dr. brown	0*/
select sum(billamount) as total_bill_collected from patient;
/*4400.00*/
select avg(billamount) as average_bill_per_patient from patient;
/*1100.000000*/

