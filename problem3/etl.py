 
import json
import sqlite3

# Step 1: Parse the JSON File
with open('/Users/bhavishya/Desktop/data.json', 'r') as json_file:
    data = json.load(json_file)

# Step 2: Identify Entities

# For simplicity, let's assume we're interested in 'orchestra', 'concerts', and 'works' entities.

# Step 3: Define Database Schema
conn = sqlite3.connect('orchestra.db')
cursor = conn.cursor()
cursor.execute('''CREATE TABLE IF NOT EXISTS Orchestra (
                    orchestra_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT,
                    city TEXT
                )''')


cursor.execute('''CREATE TABLE IF NOT EXISTS Concert (
                    concert_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    date TEXT,
                    venue TEXT,
                    orchestra_id INTEGER,
                    FOREIGN KEY (orchestra_id) REFERENCES Orchestra(orchestra_id)
                )''')

cursor.execute('''CREATE TABLE IF NOT EXISTS Work (
                    work_id INTEGER PRIMARY KEY AUTOINCREMENT,
                    title TEXT,
                    composer TEXT,
                    conductor TEXT
                )''')


for program in data['programs']:
    # Insert Orchestra
    orchestra = program['orchestra']
    cursor.execute('INSERT INTO Orchestra (name, city) VALUES (?, ?)', (str(orchestra), 'city'))

    # Get the last inserted orchestra ID
    orchestra_id = cursor.lastrowid

    # Insert Concert
    concert = program['concerts'][0]  # Assuming each program has only one concert
    cursor.execute('INSERT INTO Concert (date, venue, orchestra_id) VALUES (?, ?, ?)', 
                   (str(concert['Date']), str(concert['Venue']), orchestra_id))

    # Insert Works
    for work in program['works']:
        conductor = work.get('conductorName', 'Unknown')
        title = work.get('workTitle', 'Unknown')
        composer = work.get('composerName', 'Unknown')
        cursor.execute('INSERT INTO Work (title, composer, conductor) VALUES (?, ?, ?)', 
                       (str(title), str(composer), str(conductor)))
conn.commit()



# Function to print table contents
def print_table(table_name):
    cursor.execute(f'SELECT * FROM {table_name}')
    rows = cursor.fetchall()
    print(f'--- {table_name} ---')
    for row in rows:
        print(row)
    print()

# Print contents of each table
print_table('Orchestra')
print_table('Concert')
print_table('Work')
# Close connection
conn.close()

