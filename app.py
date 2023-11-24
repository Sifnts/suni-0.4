from flask import Flask, render_template, request, redirect, url_for, session
from flask import flash  # Import flash at the top of your app.py
from werkzeug.security import check_password_hash, generate_password_hash
import sqlite3
import locale
from datetime import datetime  # Corrected import statement
from datetime import timedelta
import pytz

# This is a test comment

locale.setlocale(locale.LC_TIME, 'es_ES')
app = Flask(__name__)
app.secret_key = 'your_very_secure_secret_key'  # You should change this to a random secret key
app.config['SESSION_PERMANENT'] = False
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=1)  # You can define your own duration

@app.before_request
def before_request():
    session.modified = True
    if 'logged_in' in session and session['logged_in']:
        session.permanent = True  # Reset the session lifetime on activity
        app.permanent_session_lifetime = timedelta(minutes=1)  # Or whatever your timeout is
        if 'last_activity' in session:
            if session['last_activity'] < (datetime.now() - app.permanent_session_lifetime):
                session.clear()  # Logout user
                flash('Your session has expired.', 'info')
                return redirect(url_for('login'))
        session['last_activity'] = datetime.now()  # Update last activity time

# Database connection
def get_db_connection():
    conn = sqlite3.connect('university_schedule.db')
    conn.row_factory = sqlite3.Row
    return conn

# Authentication
@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        studentId = request.form['studentId']
        # password = request.form['password'] # If implementing password, uncomment this line
        conn = get_db_connection()
        student = conn.execute('SELECT * FROM students WHERE studentId = ?', (studentId,)).fetchone()
        conn.close()
        # Replace the if condition below with a password check using check_password_hash if using passwords
        if student: # and check_password_hash(student['hashed_password'], password):
            session['studentId'] = studentId
            session['groupId'] = student['groupId']
            return redirect(url_for('index'))
        else:
            flash('Invalid admin ID or password', 'warning')
    return render_template('login.html')

# Homepage displaying the schedule
@app.route('/index')
def index():
    # your existing code to fetch and display schedule can be moved here if this is the homepage.
    # assuming you want to show schedule on the home page, which is index.html in this context.
    studentId = session.get('studentId')
    if not studentId:
        return redirect(url_for('login'))

    # Your time zone (GMT-6)
    timezone = pytz.timezone('Etc/GMT+6')
    # Get current day in English
    today = datetime.now(timezone).strftime("%A").capitalize()    # Translate to Spanish using the mapping

    print(f"Today's day in Spanish: {today}")  # Debug print

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute('''
        SELECT sch.*, sub.subjectName, t.fullName AS teacherName, c.classroomNumber
        FROM schedules sch
        JOIN subjects sub ON sch.subjectId = sub.subjectId
        JOIN teachers t ON sch.teacherId = t.teacherId
        JOIN classrooms c ON sch.classroomId = c.classroomId
        WHERE sch.groupId = (SELECT groupId FROM students WHERE studentId = ?)
        AND sch.dayOfWeek = ?
    ''', (studentId, today))
    schedule_items = cur.fetchall()

     # Fetch the student's full name
    cur.execute('SELECT fullName FROM students WHERE studentId = ?', (studentId,))
    student = cur.fetchone()
    first_name = student['fullName'].split()[2] if student and len(student['fullName'].split()) >= 3 else 'Estudiante'
    print(f"Fetched schedule items: {schedule_items}")  # Debug print
    conn.close()

    # Make sure to pass 'schedule_items' with the same name used in the template
    return render_template('index.html', schedule_items=schedule_items, today=today, first_name=first_name)


# Account Page
@app.route('/account')
def account():
    if 'studentId' not in session:
        return redirect(url_for('login'))
    conn = get_db_connection()
    student_details = conn.execute('SELECT * FROM students WHERE studentId = ?', (session['studentId'],)).fetchone()
    degree_details = conn.execute('SELECT degreeName FROM degrees WHERE degreeId = ?', (student_details['degreeId'],)).fetchone()
    group_details = conn.execute('SELECT groupName, period FROM groups WHERE groupId = ?', (student_details['groupId'],)).fetchone()
    conn.close()
    return render_template('account.html', student=student_details, degree=degree_details, group=group_details)

    # Account Page
@app.route('/map')
def map():
    if 'studentId' not in session:
        return redirect(url_for('login'))
    return render_template('map.html')


@app.route('/reports', methods=['GET', 'POST'])
def reports():
    if 'studentId' not in session:
        return redirect(url_for('login'))
    if request.method == 'POST':
        classroomId = request.form['classroom']
        incidentDate = request.form['incidentDate']
        description = request.form['description']
        conn = get_db_connection()
        conn.execute('INSERT INTO incident_reports (classroomId, reportedBy, incidentDate, description) VALUES (?, ?, ?, ?)',
                     (classroomId, session['studentId'], incidentDate, description))
        conn.commit()
        conn.close()
        flash('Tu reporte se ha enviado exitosamente.', 'success')
        return redirect(url_for('index'))
    
    conn = get_db_connection()
    query = """
        SELECT incident_reports.*, classrooms.classroomNumber
        FROM incident_reports
        JOIN classrooms ON incident_reports.classroomId = classrooms.classroomId
        WHERE reportedBy = ?
    """
    existing_reports = conn.execute(query, (session['studentId'],)).fetchall()
    classrooms = conn.execute('SELECT * FROM classrooms').fetchall()
    
    # Obtener reportes resueltos que aún no han notificado al usuario
    unresolved_reports = conn.execute("""
        SELECT * FROM incident_reports
        WHERE reportedBy = ? AND isAddressed = TRUE AND user_notified = FALSE
    """, (session['studentId'],)).fetchall()

    # Determinar si mostrar la notificación
    show_notification = len(unresolved_reports) > 0

    # Marcar los reportes como notificados
    if show_notification:
        for report in unresolved_reports:
            conn.execute("UPDATE incident_reports SET user_notified = TRUE WHERE incidentReportId = ?", (report['incidentReportId'],))
        conn.commit()

    # Obtener todos los reportes para mostrar en la página
    existing_reports = conn.execute(query, (session['studentId'],)).fetchall()
    
    conn.close()
    return render_template('reports.html', classrooms=classrooms, reports=existing_reports, has_resolved_reports=show_notification)


# Reservations Page
@app.route('/reservation', methods=['GET', 'POST'])
def reservation():
    if 'studentId' not in session:
        return redirect(url_for('login'))
    
    # Fetch past reservations
    conn = get_db_connection()
    past_reservations = conn.execute('''
        SELECT r.*, c.classroomNumber
        FROM reservations r
        JOIN classrooms c ON r.classroomId = c.classroomId
        WHERE r.requestedBy = ?
        ORDER BY r.date DESC
    ''', (session['studentId'],)).fetchall()
    conn.close()

    if request.method == 'POST':
        classroomId = request.form['classroom']
        date = request.form['date']
        startTime = request.form['startTime']
        endTime = request.form['endTime']  # You will need to add an input for 'endTime' in the form
        description = request.form['description']  # Make sure 'description' is for reservation purpose

        conn = get_db_connection()
        conn.execute('INSERT INTO reservations (classroomId, startTime, endTime, date, requestedBy, description) VALUES (?, ?, ?, ?, ?, ?)',
                     (classroomId, startTime, endTime, date, session['studentId'], description))
        conn.commit()
        conn.close()
        flash('Tu reservación se ha enviado exitosamente.', 'success')  # Add a flash message here
        return redirect(url_for('index'))  # Or redirect to a 'success' page if you have one
    
    # Fetch available classrooms for selection in the form
    conn = get_db_connection()
    classrooms = conn.execute('SELECT * FROM classrooms').fetchall()
    conn.close()
    return render_template('reservation.html', classrooms=classrooms, past_reservations=past_reservations)


@app.route('/admin_login', methods=['GET', 'POST'])
def admin_login():
    if request.method == 'POST':
        admin_id = request.form['admin_id']
        password = request.form['password']  # Make sure you are using hashed passwords in production
        conn = get_db_connection()
        admin = conn.execute('SELECT * FROM admins WHERE admin_id = ?', (admin_id,)).fetchone()
        conn.close()
        if admin and check_password_hash(admin['password_hash'], password):
            session['admin_id'] = admin_id
            return redirect(url_for('admin_dashboard'))
        else:
            flash('Invalid admin ID or password', 'warning')
    return render_template('admin_login.html')


@app.route('/admin_dashboard')
def admin_dashboard():
    # Check if 'admin_id' is in session and redirect if not
    if 'admin_id' not in session:
        # Redirect to the admin login page if 'admin_id' not in session
        flash('Please log in to access the admin dashboard.', 'warning')
        return redirect(url_for('admin_login'))
    
    conn = get_db_connection()
    admin_details = conn.execute('SELECT * FROM admins WHERE admin_id = ?', (session['admin_id'],)).fetchone()
    conn.close()
    
    return render_template('admin_dashboard.html', admin=admin_details)

@app.route('/admin_reservation')
def admin_reservation():
    # Check if 'admin_id' is in session and redirect if not
    if 'admin_id' not in session:
        # Redirect to the admin login page if 'admin_id' not in session
        flash('Please log in to access the admin dashboard.', 'warning')
        return redirect(url_for('admin_login'))
    
    # Fetch all reservations and reports to display to the admin
    conn = get_db_connection()
    reservations = conn.execute('''
        SELECT r.*, c.classroomNumber
        FROM reservations r
        JOIN classrooms c ON r.classroomID = c.classroomId
    ''').fetchall()
    conn.close()
    return render_template('admin_reservation.html', reservations=reservations)


@app.route('/update_reservation_status', methods=['POST'])
def update_reservation_status():
    if 'admin_id' not in session:
        return redirect(url_for('admin_login'))

    conn = get_db_connection()
    for key, value in request.form.items():
        if key.startswith('reservation_status_'):
            reservation_id = key.split('_')[-1]
            is_approved = value == 'approved'
            conn.execute('UPDATE reservations SET isApproved = ? WHERE reservationId = ?', (is_approved, reservation_id))
    conn.commit()
    conn.close()

    flash('Estado de las reservaciones actualizado', 'success')
    return redirect(url_for('admin_reservation'))




@app.route('/admin_reports')
def admin_reports():
    # Check if 'admin_id' is in session and redirect if not
    if 'admin_id' not in session:
        # Redirect to the admin login page if 'admin_id' not in session
        flash('Please log in to access the admin dashboard.', 'warning')
        return redirect(url_for('admin_login'))
    
    # Fetch all reservations and reports to display to the admin
    conn = get_db_connection()
    reports = conn.execute('''
        SELECT ir.*, c.classroomNumber, s.fullName as reportedBy
        FROM incident_reports ir
        JOIN classrooms c ON ir.classroomId = c.classroomId
        JOIN students s ON ir.reportedBy = s.studentID
    ''').fetchall()
    conn.close()
    return render_template('admin_reports.html', reports=reports)


@app.route('/add_comment/<int:report_id>', methods=['POST'])
def add_comment(report_id):
    if 'admin_id' not in session:
        return redirect(url_for('admin_login'))

    admin_comment = request.form['admin_comment']
    conn = get_db_connection()
    conn.execute('UPDATE incident_reports SET admin_comment = ? WHERE incidentReportId = ?', (admin_comment, report_id))
    conn.commit()
    conn.close()

    flash('Comentario guardado.', 'success')
    return redirect(url_for('admin_reports'))


@app.route('/update_report_status', methods=['POST'])
def update_report_status():
    if 'admin_id' not in session:
        flash('Acceso no autorizado.', 'warning')
        return redirect(url_for('admin_login'))

    conn = get_db_connection()
    for key, value in request.form.items():
        if key.startswith('report_status_'):
            report_id = key.split('_')[-1]
            is_addressed = value == 'addressed'
            admin_comment = request.form.get(f'admin_comment_{report_id}', '')
            conn.execute('UPDATE incident_reports SET isAddressed = ?, admin_comment = ? WHERE incidentReportId = ?', (is_addressed, admin_comment, report_id))
    conn.commit()
    conn.close()

    flash('Estado de los reportes y comentarios actualizados.', 'success')
    return redirect(url_for('admin_reports'))


@app.route('/logout', methods=['POST'])
def logout():
    # Clear all data in the session
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('login'))  # Redirect to login or home page

@app.route('/admin_logout', methods=['POST'])
def admin_logout():
    # Clear all data in the session
    session.clear()
    flash('You have been logged out.', 'success')
    return redirect(url_for('admin_login'))  # Redirect to login or home page


# Main block to run the app
if __name__ == '__main__':
    app.run(debug=True)
