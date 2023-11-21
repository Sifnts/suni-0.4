-- Create Degrees Table
CREATE TABLE IF NOT EXISTS degrees (
    degreeId INTEGER PRIMARY KEY AUTOINCREMENT,
    degreeName TEXT NOT NULL
);

-- Create Groups Table
CREATE TABLE IF NOT EXISTS groups (
    groupId INTEGER PRIMARY KEY AUTOINCREMENT,
    groupName TEXT NOT NULL,
    degreeId INTEGER NOT NULL,
    period TEXT NOT NULL,
    FOREIGN KEY(degreeId) REFERENCES degrees(degreeId)
);

-- Create Students Table
CREATE TABLE IF NOT EXISTS students (
    studentId TEXT PRIMARY KEY,
    fullName TEXT NOT NULL,
    degreeId INTEGER NOT NULL,
    groupId INTEGER NOT NULL,
    FOREIGN KEY(degreeId) REFERENCES degrees(degreeId),
    FOREIGN KEY(groupId) REFERENCES groups(groupId)
);

-- Create Subjects Table
CREATE TABLE IF NOT EXISTS subjects (
    subjectId INTEGER PRIMARY KEY AUTOINCREMENT,
    subjectName TEXT NOT NULL
);

-- Create Teachers Table
CREATE TABLE IF NOT EXISTS teachers (
    teacherId INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT NOT NULL
);

-- Create Classrooms Table
CREATE TABLE IF NOT EXISTS classrooms (
    classroomId INTEGER PRIMARY KEY AUTOINCREMENT,
    classroomNumber TEXT NOT NULL
);

-- Create Schedules Table
CREATE TABLE IF NOT EXISTS schedules (
    scheduleId INTEGER PRIMARY KEY AUTOINCREMENT,
    groupId INTEGER NOT NULL,
    subjectId INTEGER NOT NULL,
    teacherId INTEGER NOT NULL,
    classroomId INTEGER NOT NULL,
    startTime TEXT NOT NULL,
    endTime TEXT NOT NULL,
    dayOfWeek TEXT NOT NULL,
    FOREIGN KEY(groupId) REFERENCES groups(groupId),
    FOREIGN KEY(subjectId) REFERENCES subjects(subjectId),
    FOREIGN KEY(teacherId) REFERENCES teachers(teacherId),
    FOREIGN KEY(classroomId) REFERENCES classrooms(classroomId)
);

-- Create Reservations Table
CREATE TABLE IF NOT EXISTS reservations (
    reservationId INTEGER PRIMARY KEY AUTOINCREMENT,
    classroomId INTEGER NOT NULL,
    startTime TEXT NOT NULL,
    endTime TEXT NOT NULL,
    date TEXT NOT NULL,
    requestedBy TEXT NOT NULL,
    description TEXT NOT NULL,
    FOREIGN KEY(classroomId) REFERENCES classrooms(classroomId),
    FOREIGN KEY(requestedBy) REFERENCES students(studentId)
);

-- Create Incident Reports Table
CREATE TABLE IF NOT EXISTS incident_reports (
    incidentReportId INTEGER PRIMARY KEY AUTOINCREMENT,
    classroomId INTEGER NOT NULL,
    reportedBy TEXT NOT NULL,
    incidentDate TEXT NOT NULL,
    description TEXT NOT NULL,
    FOREIGN KEY(classroomId) REFERENCES classrooms(classroomId),
    FOREIGN KEY(reportedBy) REFERENCES students(studentId)
);

CREATE TABLE IF NOT EXISTS admins (
    admin_id TEXT PRIMARY KEY,
    password_hash TEXT NOT NULL
);