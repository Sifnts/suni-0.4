-- Create Degrees Table
CREATE TABLE IF NOT EXISTS degrees (
    DegreeID INTEGER PRIMARY KEY AUTOINCREMENT,
    DegreeName TEXT NOT NULL
);

-- Create Groups Table
CREATE TABLE IF NOT EXISTS groups (
    GroupID INTEGER PRIMARY KEY AUTOINCREMENT,
    GroupName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    Period TEXT NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID)
);

-- Create Students Table
CREATE TABLE IF NOT EXISTS students (
    StudentID TEXT PRIMARY KEY,
    FullName TEXT NOT NULL,
    DegreeID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    FOREIGN KEY(DegreeID) REFERENCES degrees(DegreeID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);

-- Create Subjects Table
CREATE TABLE IF NOT EXISTS subjects (
    SubjectID INTEGER PRIMARY KEY AUTOINCREMENT,
    SubjectName TEXT NOT NULL
);

-- Create Teachers Table
CREATE TABLE IF NOT EXISTS teachers (
    TeacherID INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName TEXT NOT NULL
);

-- Create Classrooms Table
CREATE TABLE IF NOT EXISTS classrooms (
    ClassroomID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomNumber TEXT NOT NULL
);

-- Create Schedules Table
CREATE TABLE IF NOT EXISTS schedules (
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

-- Create Reservations Table
CREATE TABLE IF NOT EXISTS reservations (
    ReservationID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomID INTEGER NOT NULL,
    GroupID INTEGER NOT NULL,
    StartTime TEXT NOT NULL,
    EndTime TEXT NOT NULL,
    Date TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID),
    FOREIGN KEY(GroupID) REFERENCES groups(GroupID)
);

-- Create Incident Reports Table
CREATE TABLE IF NOT EXISTS incident_reports (
    IncidentReportID INTEGER PRIMARY KEY AUTOINCREMENT,
    ClassroomID INTEGER NOT NULL,
    ReportedBy TEXT NOT NULL,
    IncidentDate TEXT NOT NULL,
    Description TEXT NOT NULL,
    FOREIGN KEY(ClassroomID) REFERENCES classrooms(ClassroomID)
);
