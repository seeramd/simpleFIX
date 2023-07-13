#!/usr/bin/env python3
import sqlite3
import csv

# used once to generate sqlite db of fix tags from csv file

conn = sqlite3.connect("./fix_dictionary.db")
cursor = conn.cursor()
with open('fix_tags.csv') as csv_file:
    reader = csv.reader(csv_file, delimiter=',')
    for row in reader:
        print(f"Tag: {row[0]}, Name: {row[1]}")
        cursor.execute(f'INSERT INTO fix_tags (tag, name) VALUES ({int(row[0])}, "{row[1]}")')
conn.commit()
conn.close()


