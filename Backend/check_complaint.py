import sqlite3

# Connect to your database
conn = sqlite3.connect("civic_db.sqlite")
cursor = conn.cursor()

# Query all complaints
cursor.execute("SELECT id, name, address, description, category, tax_paid, status FROM complaints")
rows = cursor.fetchall()

if not rows:
    print("No complaints found.")
else:
    print(f"{'ID':<3} {'Name':<15} {'Address':<20} {'Category':<15} {'Tax Paid':<10} {'Status':<10} Description")
    print("-" * 100)
    for row in rows:
        id_, name, address, description, category, tax_paid, status = row
        print(f"{id_:<3} {name:<15} {address:<20} {category:<15} {tax_paid:<10} {status:<10} {description}")

# Close connection
conn.close()