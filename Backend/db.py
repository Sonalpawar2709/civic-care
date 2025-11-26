import mysql.connector

try:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root123",  # replace with your MySQL password
        database="civic_db",
        port=3306 
    )
    print("MySQL connected successfully!")
except mysql.connector.Error as err:
    print("MySQL connection error:", err)
    conn = None


