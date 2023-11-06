import sqlite3
import pandas as pd

# Load the CSV file into a pandas DataFrame
table_df = pd.read_csv('./csv_files/degrees.csv')

# Connect to your SQLite database
conn = sqlite3.connect('./db/university_schedule.db')

# Insert the data from the DataFrame into the 'students' table
table_df.to_sql('degrees', conn, if_exists='append', index=False)

# Close the connection
conn.close()
