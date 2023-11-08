from flask import Flask, render_template, request, redirect, url_for, session
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

    today = datetime.now().strftime("%B %d, %A").title()   # e.g., "November 08, Wednesday"    
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
    conn.close()
    return render_template('index.html', index=schedule_items, today=today)

# Account Page
@app.route('/account')
def account():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    # Here you would fetch account details based on the student_id in the session
    # ... (fetch account details logic) ...
    return render_template('account.html')  # Replace with actual data fetched

# Reports Page
@app.route('/reports', methods=['GET', 'POST'])
def reports():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    # Handle form submission
    if request.method == 'POST':
        # Here you would process the submitted report
        # ... (process submitted report logic) ...
        return redirect(url_for('reports_success'))  # Redirect to a success page or back to form with a success message
    return render_template('reports.html')  # Show the reports form

# Reservation Page
@app.route('/reservation', methods=['GET', 'POST'])
def reservation():
    if 'student_id' not in session:
        return redirect(url_for('login'))
    if request.method == 'POST':
        # Process reservation here
        # ... (reservation handling logic) ...
        return redirect(url_for('reservation_success'))  # Redirect after handling reservation
    return render_template('reservation.html')  # Show reservation form

# Main block to run the app
if __name__ == '__main__':
    app.run(debug=True)
