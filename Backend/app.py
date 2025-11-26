from flask import Flask, request, jsonify
import sqlite3
import os

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# ----------------------
# Create DB + Table
# ----------------------
def init_db():
    conn = sqlite3.connect("civic.db")
    c = conn.cursor()
    c.execute("""
        CREATE TABLE IF NOT EXISTS complaints (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            address TEXT,
            description TEXT,
            category TEXT,
            image_path TEXT,
            latitude REAL,
            longitude REAL,
            tax_paid TEXT,
            city TEXT,
            status TEXT DEFAULT 'pending'
        )
    """)
    c.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT UNIQUE,
            password TEXT
        )
    """)
    conn.commit()
    conn.close()

init_db()   # Call once on server start


def get_db():
    conn = sqlite3.connect("civic.db")
    conn.row_factory = sqlite3.Row
    return conn


# ----------------------
# Submit Complaint API
# ----------------------
@app.route("/submit_complaint", methods=["POST"])
def submit_complaint():
    name = request.form.get("name")
    address = request.form.get("address")
    description = request.form.get("description")
    category = request.form.get("category")
    latitude = request.form.get("latitude")
    longitude = request.form.get("longitude")
    tax_paid = request.form.get("tax_paid")
    city = request.form.get("city", "Satara")

    # Handle Image Upload
    image = request.files.get("image")
    if image:
        image_path = os.path.join(UPLOAD_FOLDER, image.filename)
        image.save(image_path)
    else:
        image_path = None

    conn = get_db()
    cur = conn.cursor()

    cur.execute("""
        INSERT INTO complaints
        (name, address, description, category, image_path, latitude, longitude, tax_paid, city)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (name, address, description, category, image_path, latitude, longitude, tax_paid, city))

    conn.commit()
    conn.close()

    return jsonify({"message": "Complaint submitted successfully"})


# ----------------------
# Register API
# ----------------------
@app.route("/register", methods=["POST"])
def register():
    username = request.form.get("username")
    email = request.form.get("email")
    password = request.form.get("password")

    conn = get_db()
    cur = conn.cursor()

    try:
        cur.execute("""
            INSERT INTO users (username, email, password)
            VALUES (?, ?, ?)
        """, (username, email, password))
        conn.commit()
        conn.close()
        return jsonify({"success": True, "message": "Registered successfully"})

    except sqlite3.IntegrityError:
        return jsonify({"success": False, "message": "Email already exists"})


# ----------------------
# Login API
# ----------------------
@app.route("/login", methods=["POST"])
def login():
    email = request.form.get("email")
    password = request.form.get("password")

    conn = get_db()
    cur = conn.cursor()

    cur.execute("SELECT * FROM users WHERE email=? AND password=?", (email, password))
    user = cur.fetchone()

    if user:
        user_dict = {
            "id": user["id"],
            "username": user["username"],
            "email": user["email"]
        }
        return jsonify({"success": True, "user": user_dict})

    return jsonify({"success": False, "message": "Invalid credentials"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)





