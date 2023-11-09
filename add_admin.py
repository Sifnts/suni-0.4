# add_admin.py

import sqlite3
from werkzeug.security import generate_password_hash

def add_admin_to_database(admin_id, admin_password, database_path='university_schedule.db'):
    # Connect to the database
    conn = sqlite3.connect(database_path)
    cur = conn.cursor()

    # Hash the provided password
    hashed_password = generate_password_hash(admin_password)

    # Insert the new admin record into the admins table
    try:
        cur.execute("INSERT INTO admins (admin_id, password_hash) VALUES (?, ?)", (admin_id, hashed_password))
        conn.commit()
        print(f"Admin {admin_id} added successfully.")
    except sqlite3.IntegrityError as e:  # This will catch any issues such as duplicate admin IDs
        print(f"Error adding admin: {e}")
    finally:
        conn.close()

if __name__ == '__main__':
    # Input admin details
    admin_id = input("Enter new admin ID: ")
    # Securely input the password without echoing it, requires 'getpass' module
    from getpass import getpass
    admin_password = getpass("Enter new admin password: ")

    # Add the admin to the database
    add_admin_to_database(admin_id, admin_password)
