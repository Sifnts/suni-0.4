import sqlite3
import pandas as pd

def insert_data_from_csv(csv_filepath, database_filepath, table_name):
    try:
        # Load the CSV file into a pandas DataFrame
        table_df = pd.read_csv(csv_filepath)

        # Connect to your SQLite database using 'with' to ensure it closes properly
        with sqlite3.connect(database_filepath) as conn:
            # Insert the data from the DataFrame into the specified 'table_name' table
            table_df.to_sql(table_name, conn, if_exists='append', index=False)
            print(f"Data inserted into {table_name} from {csv_filepath} successfully.")

    except sqlite3.Error as e:
        print(f"An error occurred while inserting data: {e}")

    except pd.errors.EmptyDataError as e:
        print(f"Empty data from file {csv_filepath}: {e}")

    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Function call example
insert_data_from_csv('./csv_files/schedules.csv', './university_schedule.db', 'schedules')

