from flask import Flask, render_template, request, redirect, session, url_for, flash
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2
from psycopg2.extras import DictCursor, RealDictCursor
from datetime import date, datetime
import os
from dotenv import load_dotenv

app = Flask(__name__)
app.secret_key = "super-secret-key"

load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST"),
        database=os.getenv("DB_NAME"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        port=os.getenv("DB_PORT"),
        cursor_factory=DictCursor
    )
    
@app.route("/admin_signup_success")
def admin_signup_success():
    return render_template("admin_signup_success.html")


@app.route("/")
def login():
    return render_template("login.html")

@app.route("/admin_signup", methods=["GET", "POST"])
def admin_signup():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        confirm = request.form["confirm_password"]

        if password != confirm:
            return render_template(
                "admin_signup.html",
                error="Passwords do not match"
            )

        hashed = generate_password_hash(password)

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("SELECT id FROM admins WHERE email=%s", (email,))
        if cur.fetchone():
            cur.close()
            conn.close()
            return render_template(
                "admin_signup.html",
                error="Admin already exists. Please login."
            )

        cur.execute(
            "INSERT INTO admins (email, password) VALUES (%s, %s)",
            (email, hashed)
        )
        conn.commit()
        cur.close()
        conn.close()
        return redirect(url_for("admin_signup_success"))

    return render_template("admin_signup.html")


@app.route("/admin_login", methods=["GET", "POST"])
def admin_login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT password FROM admins WHERE email=%s", (email,))
        admin = cur.fetchone()
        cur.close()
        conn.close()

        if not admin or not check_password_hash(admin[0], password):
            return render_template(
                "admin_login.html",
                error="Invalid credentials"
            )

        session["admin_logged_in"] = True
        session["admin_email"] = email

        return redirect(url_for("admin_dashboard"))

    return render_template("admin_login.html")



@app.route("/admin_dashboard", methods=["GET", "POST"])
def admin_dashboard():
    if not session.get("admin_logged_in"):
        return redirect(url_for("admin_login"))
    interns = []
    count = 0
    reg_no = request.values.get("reg_no", "").strip()
    intern_name = request.values.get("intern_name", "").strip()
    if reg_no or intern_name:
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=RealDictCursor)
        try:
            cur.execute("SELECT COUNT(*) AS cnt FROM interns")
            cnt_row = cur.fetchone()
            if isinstance(cnt_row, dict):
                total_interns = cnt_row.get("cnt")
            else:
                total_interns = cnt_row[0]
        except Exception as _e:
            total_interns = f"error: {_e}"
        if reg_no:
            try:
                cur.execute("SELECT reg_no, intern_name, email FROM interns WHERE CAST(reg_no AS TEXT) = %s", (reg_no,))
                exact_reg = cur.fetchall()
            except Exception as _e:
                exact_reg = f"error: {_e}"
        try:
            cur.execute("SELECT reg_no, intern_name, email FROM interns LIMIT 5")
            sample_rows = cur.fetchall()
        except Exception as _e:
            sample_rows = f"error: {_e}"
        where_clauses = []
        params = []

        if reg_no:
            where_clauses.append("CAST(reg_no AS TEXT) ILIKE %s")
            params.append(f"%{reg_no}%")
        if intern_name:
            where_clauses.append("intern_name ILIKE %s")
            params.append(f"%{intern_name}%")

        if where_clauses:
            query = (
                "SELECT reg_no, intern_name, email FROM interns WHERE "
                + " OR ".join(where_clauses)
                + " ORDER BY reg_no"
            )
            cur.execute(query, tuple(params))
        else:
            cur.execute("SELECT reg_no, intern_name, email FROM interns ORDER BY reg_no")

        interns = cur.fetchall()
        count = len(interns)

        cur.close()
        conn.close()    
    return render_template(
        "admin_dashboard.html",
        ints=interns,
        cnt=count,
        reg_no=reg_no,
        intern_name=intern_name
    )

@app.route("/admin_attendance/<reg_no>", methods=["GET", "POST"])
def admin_attendance(reg_no):
    if not session.get("admin_logged_in"):
        return redirect(url_for("admin_login"))

    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=DictCursor)

    # 1️⃣ Fetch intern details
    cur.execute(
        "SELECT reg_no, intern_name, email FROM interns WHERE reg_no = %s",
        (reg_no,)
    )
    intern = cur.fetchone()

    if not intern:
        cur.close()
        conn.close()
        return "Intern not found", 404

    today = date.today()

    # 2️⃣ Check if already marked today
    cur.execute(
        """
        SELECT status
        FROM attendance
        WHERE intern_email = %s AND date = %s
        """,
        (intern["email"], today)
    )
    today_status = cur.fetchone()

    # 3️⃣ Handle attendance submission
    if request.method == "POST":
        status = request.form.get("status")  # 'P' or 'A'

        if status not in ("P", "A"):
            cur.close()
            conn.close()
            return redirect(url_for("admin_attendance", reg_no=reg_no))

        if today_status:
            # Update existing record
            cur.execute(
                """
                UPDATE attendance
                SET status = %s, marked_at = %s
                WHERE intern_email = %s AND date = %s
                """,
                (status, datetime.now(), intern["email"], today)
            )
        else:
            # Insert new record
            cur.execute(
                """
                INSERT INTO attendance (intern_email, date, status, marked_at)
                VALUES (%s, %s, %s, %s)
                """,
                (intern["email"], today, status, datetime.now())
            )

        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for("admin_attendance", reg_no=reg_no))

    # 4️⃣ Fetch attendance history
    cur.execute(
        """
        SELECT date, status, marked_at
        FROM attendance
        WHERE intern_email = %s
        ORDER BY date DESC
        """,
        (intern["email"],)
    )
    history = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "admin_attendance.html",
        intern=intern,
        today_status=today_status["status"] if today_status else None,
        history=history
    )


@app.route("/intern_attendance")
def intern_attendance():
    if not session.get("admin_logged_in"):
        return redirect(url_for("admin_login"))

    return render_template("intern_attendance.html")


@app.route("/success/<reg_no>")
def success(reg_no):
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        "SELECT * FROM interns WHERE reg_no = %s",
        (reg_no,)
    )
    intern = cur.fetchone()

    cur.close()
    conn.close()

    if not intern:
        return "Intern not found", 404

    return render_template("success.html", intern=intern)

@app.route("/already", methods=["GET", "POST"])
def already():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(
            "SELECT password_hash FROM interns WHERE email = %s",
            (email,)
        )
        intern = cur.fetchone()
       
        cur.close()
        conn.close()

        if intern and check_password_hash(intern["password_hash"], password):
            session["intern_logged_in"] = True
            session["intern_email"] = email
            return redirect(url_for("intern_dashboard"))

        return render_template("already.html", error="Invalid intern credentials")

    return render_template("already.html")



@app.route("/home", methods=["GET", "POST"])
def home():
    if request.method == "POST":

        reg_no = request.form.get("reg_no")
        intern_name = request.form.get("name")
        age = request.form.get("age")
        contact = request.form.get("contact")
        college = request.form.get("college")
        course = request.form.get("course")
        duration = int(request.form.get("duration"))
        reference_by = request.form.get("reference")
        project = request.form.get("project")
        email = request.form.get("email")
        password = request.form.get("password")
        confirm_password = request.form.get("confirm_password")

        if password != confirm_password:
            flash("Passwords do not match!", "error")
            return render_template("home.html", reg_no=reg_no, intern_name=intern_name, age=age,
                                   contact=contact, college=college, course=course,
                                   duration=duration, reference_by=reference_by,
                                   project=project, email=email)
        password_hash = generate_password_hash(
            password,
            method="pbkdf2:sha256",
            salt_length=16
        )
        conn = get_db_connection()
        cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

        cur.execute("""
            INSERT INTO interns
            (reg_no, intern_name, age, contact, college, course,
             duration, reference_by, project, email, password_hash)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            RETURNING reg_no
        """, (
            reg_no,
            intern_name,
            age,
            contact,
            college,
            course,
            int(duration),
            reference_by,
            project,
            email,
            password_hash
        ))

        reg_no = cur.fetchone()["reg_no"]

        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for("success", reg_no=reg_no))

    return render_template("home.html")

@app.route("/intern_dashboard")
def intern_dashboard():
    if not session.get("intern_logged_in"):
        return redirect(url_for("already"))

    email = session["intern_email"]

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        "SELECT * FROM interns WHERE email = %s",
        (email,)
    )
    intern = cur.fetchone()

    cur.execute(
        "SELECT date, status FROM attendance WHERE intern_email = %s ORDER BY date DESC",
        (email,)
    )
    attendance = cur.fetchall()

    cur.close()
    conn.close()

    if not intern:
        return "Intern not found", 404

    return render_template(
        "intern_dashboard.html",
        intern=intern,
        attendance=attendance
    )


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run(debug=True)
