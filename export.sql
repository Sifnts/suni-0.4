PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE degrees (
    DegreeID INTEGER PRIMARY KEY AUTOINCREMENT,
    DegreeName TEXT NOT NULL
);
INSERT INTO degrees VALUES(1,'ISCE');
CREATE TABLE groups (
    GroupID INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    Period TEXT NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID)
);
INSERT INTO "groups" VALUES(1,'L1',1,'4┬░cuatrimestre');
INSERT INTO "groups" VALUES(2,'L2',1,'4┬░cuatrimestre');
CREATE TABLE students (
    StudentID TEXT PRIMARY KEY,
    FullName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);
INSERT INTO students VALUES('183976','Argando├▒a Bernal Ivan Emanuel',1,1);
INSERT INTO students VALUES('174310','Campos Anaya Christopher Giovanni',1,2);
INSERT INTO students VALUES('174025','Campos Garcia Carla Alicia',1,1);
INSERT INTO students VALUES('184007','Canales Garcia Manuel Valentin',1,1);
INSERT INTO students VALUES('184644','Charur Balderas Jose Antonio',1,1);
INSERT INTO students VALUES('184256','Gamez Gamez Lizbeth Alejandra',1,1);
INSERT INTO students VALUES('183631','Garcia Moreno Isai Brandon',1,1);
INSERT INTO students VALUES('183863','Garcia Tenorio Luis David',1,1);
INSERT INTO students VALUES('184264','Gomez Sifuentes Alfredo Carlos',1,1);
INSERT INTO students VALUES('183680','Gonzalez Lopez Sergio Ivan',1,1);
INSERT INTO students VALUES('183286','Guzman De La Cruz Ana Sofia',1,1);
INSERT INTO students VALUES('183965','Herrera Becerril Diego',1,1);
INSERT INTO students VALUES('183878','Jimenez Vazquez Eduardo',1,1);
INSERT INTO students VALUES('184272','Moreno Cruz Alma Nayobi',1,1);
INSERT INTO students VALUES('180313','Nava Velazquez Esteban Eduardo',1,1);
INSERT INTO students VALUES('173459','Olguin Madrigal Alan Jesus',1,1);
INSERT INTO students VALUES('183822','Olguin Morales Javier Emmanuel',1,2);
INSERT INTO students VALUES('183683','Osorio Caudillo Jose Gerardo',1,2);
INSERT INTO students VALUES('183728','Perez Angel Jesus Elias',1,2);
INSERT INTO students VALUES('183748','Puente Hernandez Xavier Antonio',1,2);
INSERT INTO students VALUES('183714','Ramos Bernal Isaias Arturo',1,2);
INSERT INTO students VALUES('183858','Rivera Gonzalez Tayde Maria',1,2);
INSERT INTO students VALUES('183633','Sierra Ruiz Joaquin Enrique',1,2);
INSERT INTO students VALUES('184226','Valdez Martinez Bryan Axl',1,2);
INSERT INTO students VALUES('184492','Zulaica Rodriguez Josue',1,2);
CREATE TABLE subjects (
    SubjectID INTEGER PRIMARY KEY AUTOINCREMENT,
    SubjectName TEXT NOT NULL
);
INSERT INTO subjects VALUES(1,'Calculo Integral');
INSERT INTO subjects VALUES(2,'Administracion de Base de Datos');
INSERT INTO subjects VALUES(3,'Analisis y Dise├▒o de Sistemas');
INSERT INTO subjects VALUES(4,'Sustentabilidad en la Practica');
INSERT INTO subjects VALUES(5,'Circuitos Logicos Secuenciales');
INSERT INTO subjects VALUES(6,'Costos y Presupuestos');
INSERT INTO subjects VALUES(7,'Herramientas Estadisticas');
CREATE TABLE teachers (
    TeacherID INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName TEXT NOT NULL
);
INSERT INTO teachers VALUES(1,'Garcia Morales Miguel Angel');
INSERT INTO teachers VALUES(2,'Rodriguez Martinez Myriam Janeth');
INSERT INTO teachers VALUES(3,'Coo Pedraza Juan Jose');
INSERT INTO teachers VALUES(4,'Vazquez Casta├▒o Sergio');
INSERT INTO teachers VALUES(5,'Castilla Flores Ivone');
INSERT INTO teachers VALUES(6,'Huerta Lopez Mardonio');
INSERT INTO teachers VALUES(7,'Mojica Guerrero Isabel Xareni');
INSERT INTO teachers VALUES(8,'Guillen Rodriguez Joaquin');
CREATE TABLE classrooms (
    ClassroomID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomNumber TEXT NOT NULL
);
INSERT INTO classrooms VALUES(1,'Sal├│n 5.1');
INSERT INTO classrooms VALUES(2,'Sal├│n 5.2');
INSERT INTO classrooms VALUES(3,'Sal├│n 5.3');
INSERT INTO classrooms VALUES(4,'Sal├│n 5.4');
INSERT INTO classrooms VALUES(5,'Laboratorio de Ingener├¡a');
CREATE TABLE schedules (
    ScheduleID INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupID INTEGER NOT NULL,
    SubjectID INTEGER NOT NULL,
    TeacherID INTEGER NOT NULL,
    ClassroomID INTEGER NOT NULL,
    StartTime TEXT NOT NULL,
    EndTime TEXT NOT NULL,
    DayOfWeek TEXT NOT NULL,
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID),
    FOREIGN KEY(SubjectID) REFERENCES subjects(SubjectID),
    FOREIGN KEY(TeacherID) REFERENCES teachers(TeacherID),
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID)
);
INSERT INTO schedules VALUES(1,1,2,1,1,'7','8','Lunes');
INSERT INTO schedules VALUES(2,1,2,1,1,'8','9','Lunes');
INSERT INTO schedules VALUES(3,1,3,2,2,'9','10','Lunes');
INSERT INTO schedules VALUES(4,1,4,3,3,'12','13','Lunes');
INSERT INTO schedules VALUES(5,1,5,4,2,'7','8','Martes');
INSERT INTO schedules VALUES(6,1,5,4,2,'8','9','Martes');
INSERT INTO schedules VALUES(7,1,6,5,2,'10','11','Martes');
INSERT INTO schedules VALUES(8,1,6,5,2,'11','12','Martes');
INSERT INTO schedules VALUES(9,1,1,6,2,'12','13','Martes');
INSERT INTO schedules VALUES(10,1,1,6,2,'13','14','Martes');
INSERT INTO schedules VALUES(11,1,3,2,2,'8','9','Mi├®rcoles');
INSERT INTO schedules VALUES(12,1,3,2,2,'9','10','Mi├®rcoles');
INSERT INTO schedules VALUES(13,1,7,7,3,'12','13','Mi├®rcoles');
INSERT INTO schedules VALUES(14,1,7,7,3,'13','14','Mi├®rcoles');
INSERT INTO schedules VALUES(15,1,6,5,2,'10','11','Jueves');
INSERT INTO schedules VALUES(16,1,6,5,2,'11','12','Jueves');
INSERT INTO schedules VALUES(17,1,1,6,2,'12','13','Jueves');
INSERT INTO schedules VALUES(18,1,1,6,2,'13','14','Jueves');
INSERT INTO schedules VALUES(19,1,2,1,1,'7','8','Viernes');
INSERT INTO schedules VALUES(20,1,2,1,1,'8','9','Viernes');
INSERT INTO schedules VALUES(21,1,5,4,2,'10','11','Viernes');
INSERT INTO schedules VALUES(22,1,5,4,2,'11','12','Viernes');
INSERT INTO schedules VALUES(23,1,7,7,3,'12','13','Viernes');
INSERT INTO schedules VALUES(24,1,7,7,3,'13','14','Viernes');
INSERT INTO schedules VALUES(25,2,2,1,1,'7','8','Lunes');
INSERT INTO schedules VALUES(26,2,2,1,1,'8','9','Lunes');
INSERT INTO schedules VALUES(27,2,3,2,2,'9','10','Lunes');
INSERT INTO schedules VALUES(28,2,4,3,3,'12','13','Lunes');
INSERT INTO schedules VALUES(29,2,5,8,5,'8','9','Martes');
INSERT INTO schedules VALUES(30,2,5,8,5,'9','10','Martes');
INSERT INTO schedules VALUES(31,2,6,5,2,'10','11','Martes');
INSERT INTO schedules VALUES(32,2,6,5,2,'11','12','Martes');
INSERT INTO schedules VALUES(33,2,1,6,2,'12','13','Martes');
INSERT INTO schedules VALUES(34,2,1,6,2,'13','14','Martes');
INSERT INTO schedules VALUES(35,2,3,2,2,'8','9','Mi├®rcoles');
INSERT INTO schedules VALUES(36,2,3,2,2,'9','10','Mi├®rcoles');
INSERT INTO schedules VALUES(37,2,7,7,3,'12','13','Mi├®rcoles');
INSERT INTO schedules VALUES(38,2,7,7,3,'13','14','Mi├®rcoles');
INSERT INTO schedules VALUES(39,2,6,5,2,'10','11','Jueves');
INSERT INTO schedules VALUES(40,2,6,5,2,'11','12','Jueves');
INSERT INTO schedules VALUES(41,2,1,6,2,'12','13','Jueves');
INSERT INTO schedules VALUES(42,2,1,6,2,'13','14','Jueves');
INSERT INTO schedules VALUES(43,2,2,1,1,'7','8','Viernes');
INSERT INTO schedules VALUES(44,2,2,1,1,'8','9','Viernes');
INSERT INTO schedules VALUES(45,2,5,8,4,'10','11','Viernes');
INSERT INTO schedules VALUES(46,2,5,8,4,'11','12','Viernes');
INSERT INTO schedules VALUES(47,2,7,7,3,'12','13','Viernes');
INSERT INTO schedules VALUES(48,2,7,7,3,'13','14','Viernes');
CREATE TABLE reservations (
    ReservationID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    StartTime TEXT NOT NULL,
    EndTime TEXT NOT NULL,
    Date TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);
INSERT INTO reservations VALUES(1,2,1,'15:20','17:20','2023-11-10');
INSERT INTO reservations VALUES(2,4,1,'13:14','13:16','2023-11-16');
INSERT INTO reservations VALUES(3,3,1,'15:00','17:00','2023-11-21');
INSERT INTO reservations VALUES(4,3,1,'14:33','02:23','2004-01-02');
CREATE TABLE incident_reports (
    IncidentReportID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomID INTEGER NOT NULL,
    ReportedBy TEXT NOT NULL,
    IncidentDate TEXT NOT NULL,
    Description TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID)
);
INSERT INTO incident_reports VALUES(1,5.099999999999999645,'A184264','2023-11-08','Alfredo se rompi├│ el cerebro');
INSERT INTO incident_reports VALUES(2,4.200000000000000177,'A184264','2023-11-08','Isa├¡as se peg├│ con pegamento, jaja');
INSERT INTO incident_reports VALUES(3,5.099999999999999645,'A184264','2023-11-14','Prueba de flash');
INSERT INTO incident_reports VALUES(4,4.200000000000000177,'A184264','2023-11-14','Prueba tercera de flash');
INSERT INTO incident_reports VALUES(5,4.200000000000000177,'184264','2023-11-14','Una computadora no enciende');
INSERT INTO incident_reports VALUES(6,2,'184264','2023-11-09','algo sucedi├│ que acontece');
CREATE TABLE admins (
    admin_id TEXT PRIMARY KEY,
    password_hash TEXT NOT NULL
);
INSERT INTO admins VALUES('777','scrypt:32768:8:1$n2ZHZPFUxlwngguq$f1d98aa6765f4f7e0b0908d9c6553a079731f4e10435108e086155d0854e9cf661d726fee13f931699d0032dc0e881d36b459dc4fda1cfb9453cef9a0fa2025b');
DELETE FROM sqlite_sequence;
INSERT INTO sqlite_sequence VALUES('teachers',8);
INSERT INTO sqlite_sequence VALUES('subjects',7);
INSERT INTO sqlite_sequence VALUES('classrooms',5);
INSERT INTO sqlite_sequence VALUES('schedules',48);
INSERT INTO sqlite_sequence VALUES('groups',2);
INSERT INTO sqlite_sequence VALUES('degrees',1);
INSERT INTO sqlite_sequence VALUES('incident_reports',6);
INSERT INTO sqlite_sequence VALUES('reservations',4);
COMMIT;
