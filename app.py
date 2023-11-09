from flask import Flask, render_template, request, redirect, url_for, session
from flask import flash  # Import flash at the top of your app.py
from werkzeug.security import check_password_hash, generate_password_hash
import sqlite3
import locale
from datetime import datetime  # Corrected import statement

locale.setlocale(locale.LC_TIME, 'es_ES')
app = Flask(__name__)
app.secret_key = 'your_very_secure_secret_key'  # You should change this to a random secret key

# Database connection
def get_db_connection():
    conn = sqlite3.connect('university_schedule.db')
    conn.row_factory = sqlite3.Row
    return conn

# Authentication
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        student_id = request.form['student_id']
        # password = request.form['password'] # If implementing password, uncomment this line
        conn = get_db_connection()
        student = conn.execute('SELECT * FROM students WHERE StudentID = ?', (student_id,)).fetchone()
        conn.close()
        # Replace the if condition below with a password check using check_password_hash if using passwords
        if student: # and check_password_hash(student['hashed_password'], password):
            session['student_id'] = student_id
            session['group_id'] = student['GroupID']
            return redirect(url_for('index'))
        else:
            return 'Invalid student ID or password', 401
    return render_template('login.html')

# Homepage displaying the schedule
@app.route('/index')
def index():
    # your existing code to fetch and display schedule can be moved here if this is the homepage.
    # assuming you want to show schedule on the home page, which is index.html in this context.
    student_id = session.get('student_id')
    if not student_id:
        return redirect(url_for('login'))

    today = datetime.now().strftime("%A").title()
    print(f"Today's day in Spanish: {today}")  # Debug print

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('''
        SELECT sch.*, sub.SubjectName, t.FullName AS TeacherName, c.ClassroomNumber
        FROM schedules sch
        JOIN subjects sub ON sch.SubjectID = sub.SubjectID
        JOIN teachers t ON sch.TeacherID = t.TeacherID
        JOIN classrooms c ON sch.ClassroomID = c.ClassroomID
        WHERE sch.GroupID = (SELECT GroupID FROM students WHERE StudentID = ?)
        AND sch.DayOfWeek = ?
    ''', (student_id, today))
    schedule_items = cur.fetchall()
    print(f"Fetched schedule items: {schedule_items}")  # Debug print
    conn.close()

    # Make sure to pass 'schedule_items' with the same name used in the template
    return render_template('index.html', schedule_items=schedule_items, today=today)

# Account Page
@app.route('/account')
def account():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    conn = get_db_connection()
    student_details = conn.execute('SELECT * FROM students WHERE StudentID = ?', (session['student_id'],)).fetchone()
    degree_details = conn.execute('SELECT DegreeName FROM degrees WHERE DegreeID = ?', (student_details['DegreeID'],)).fetchone()
    group_details = conn.execute('SELECT GroupName, Period FROM groups WHERE GroupID = ?', (student_details['GroupID'],)).fetchone()
    conn.close()
    return render_template('account.html', student=student_details, degree=degree_details, group=group_details)


# Reports Page
@app.route('/reports', methods=['GET', 'POST'])
def reports():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    if request.method == 'POST':
        classroom_id = request.form['classroom']
        incident_date = request.form['incidentDate']
        description = request.form['description']
        conn = get_db_connection()
        conn.execute('INSERT INTO incident_reports (ClassroomID, ReportedBy, IncidentDate, Description) VALUES (?, ?, ?, ?)',
                     (classroom_id, session['student_id'], incident_date, description))
        conn.commit()
        conn.close()
        flash('Tu reporte se ha enviado exitosamente.', 'success')  # Add a flash message here
        return redirect(url_for('index'))  # Or redirect to a 'success' page if you have one
    return render_template('reports.html')


# Reservations Page
@app.route('/reservation', methods=['GET', 'POST'])
def reservation():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    if request.method == 'POST':
        classroom_id = request.form['classroom']
        date = request.form['date']
        start_time = request.form['startTime']
        end_time = request.form['endTime']  # You will need to add an input for 'endTime' in the form
        description = request.form['description']  # Make sure 'description' is for reservation purpose
        group_id = session['group_id']
        conn = get_db_connection()
        conn.execute('INSERT INTO reservations (ClassroomID, GroupID, StartTime, EndTime, Date) VALUES (?, ?, ?, ?, ?)',
                     (classroom_id, group_id, start_time, end_time, date))
        conn.commit()
        conn.close()
        flash('Tu reservación se ha enviado exitosamente.', 'success')  # Add a flash message here
        return redirect(url_for('index'))  # Or redirect to a 'success' page if you have one
    # Fetch available classrooms for selection in the form
    conn = get_db_connection()
    classrooms = conn.execute('SELECT * FROM classrooms').fetchall()
    conn.close()
    return render_template('reservation.html', classrooms=classrooms)


# Main block to run the app
if __name__ == '__main__':
    app.run(debug=True)
