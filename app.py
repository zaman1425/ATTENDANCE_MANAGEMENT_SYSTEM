from flask import Flask, render_template, request, redirect, session, url_for, flash
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2
from psycopg2.extras import DictCursor

app = Flask(__name__)
app.secret_key = "super-secret-key"


def get_db_connection():
    return psycopg2.connect(
        host="localhost",
        database="postgres",
        user="postgres",
        password="postgres",
        port=5432,
        cursor_factory=DictCursor
    )

@app.route("/")
def login():
    return render_template("login.html")

@app.route("/admin_signup", methods=["GET", "POST"])
def admin_signup():
    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute("SELECT COUNT(*) FROM admins")
    admin_count = cur.fetchone()[0]

    if admin_count > 0:
        cur.close()
        conn.close()
        return redirect(url_for("admin_login"))

    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        confirm = request.form["confirm_password"]

        if password != confirm:
            return render_template("admin_signup.html", error="Passwords do not match")

        hashed = generate_password_hash(password)

        cur.execute(
            "INSERT INTO admins (email, password) VALUES (%s, %s)",
            (email, hashed)
        )
        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for("admin_login"))

    cur.close()
    conn.close()
    return render_template("admin_signup.html")


@app.route("/admin_login", methods=["GET", "POST"])
def admin_login():
    if session.get("admin_logged_in"):
        return redirect(url_for("intern_attendance"))

    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute("SELECT password FROM admins WHERE email=%s", (email,))
        admin = cur.fetchone()
        cur.close()
        conn.close()

        if not admin:
            return render_template("admin_login.html", error="Admin not found")

        if not check_password_hash(admin[0], password):
            return render_template("admin_login.html", error="Invalid password")

        session["admin_logged_in"] = True
        session["admin_email"] = email
        return redirect(url_for("intern_attendance"))

    return render_template("admin_login.html")



@app.route("/admin_dashboard", methods=["GET", "POST"])
def admin_dashboard():
    if not session.get("admin_logged_in"):
        return redirect(url_for("admin_login"))

    interns = []
    count = 0

    if request.method == "POST":
        reg_no = request.form.get("reg_no", "").strip()
        intern_name = request.form.get("intern_name", "").strip()
        email = request.form.get("email", "").strip()

        conn = get_db_connection()
        cur = conn.cursor()

        query = """
            SELECT reg_no, intern_name, email
            FROM interns
            WHERE
                (%s = '' OR reg_no ILIKE %s)
                AND (%s = '' OR intern_name ILIKE %s)
                AND (%s = '' OR email ILIKE %s)
            ORDER BY reg_no
        """

        cur.execute(
            query,
            (
                reg_no, f"%{reg_no}%",
                intern_name, f"%{intern_name}%",
                email, f"%{email}%"
            )
        )

        interns = cur.fetchall()
        count = len(interns)

        cur.close()
        conn.close()

    return render_template(
        "admin_dashboard.html",
        interns=interns,
        count=count
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
