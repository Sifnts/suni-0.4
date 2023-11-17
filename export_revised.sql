BEGIN TRANSACTION;

CREATE TABLE degrees (
    DegreeID SERIAL PRIMARY KEY,
    DegreeName TEXT NOT NULL
);

INSERT INTO degrees (DegreeID, DegreeName) VALUES
(1,'ISCE');

CREATE TABLE groups (
    GroupID SERIAL PRIMARY KEY,
    GroupName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    Period TEXT NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID)
);

INSERT INTO groups (GroupID, GroupName, DegreeID, Period) VALUES
(1,'L1',1,'4° cuatrimestre'),
(2,'L2',1,'4° cuatrimestre');

CREATE TABLE students (
    StudentID TEXT PRIMARY KEY,
    FullName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);

INSERT INTO students (StudentID, FullName, DegreeID, GroupID) VALUES
('183976','Argandoña Bernal Ivan Emanuel',1,1),
('174310','Campos Anaya Christopher Giovanni',1,2),
-- More student records...

CREATE TABLE subjects (
    SubjectID SERIAL PRIMARY KEY,
    SubjectName TEXT NOT NULL
);

INSERT INTO subjects (SubjectID, SubjectName) VALUES
(1,'Calculo Integral'),
(2,'Administracion de Base de Datos'),
-- More subject records...

CREATE TABLE teachers (
    TeacherID SERIAL PRIMARY KEY,
    FullName TEXT NOT NULL
);

INSERT INTO teachers (TeacherID, FullName) VALUES
(1,'Garcia Morales Miguel Angel'),
(2,'Rodriguez Martinez Myriam Janeth'),
-- More teacher records...

CREATE TABLE classrooms (
    ClassroomID SERIAL PRIMARY KEY,
    ClassroomNumber TEXT NOT NULL
);

INSERT INTO classrooms (ClassroomID, ClassroomNumber) VALUES
(1,'Salón 5.1'),
(2,'Salón 5.2'),
-- More classroom records...

CREATE TABLE schedules (
    ScheduleID SERIAL PRIMARY KEY,
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

-- Insert schedules data...

CREATE TABLE reservations (
    ReservationID SERIAL PRIMARY KEY,
    ClassroomID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    StartTime TEXT NOT NULL,
    EndTime TEXT NOT NULL,
    Date TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);

-- Insert reservations data...

CREATE TABLE incident_reports (
    IncidentReportID SERIAL PRIMARY KEY,
    ClassroomID INTEGER NOT NULL,
    ReportedBy TEXT NOT NULL,
    IncidentDate TEXT NOT NULL,
    Description TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID)
);

-- Insert incident reports data...

CREATE TABLE admins (
    admin_id TEXT PRIMARY KEY,
    password_hash TEXT NOT NULL
);

-- Insert admin data...

COMMIT;
