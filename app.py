from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2
from psycopg2.extras import DictCursor

app = Flask(__name__)
app.secret_key = "super-secret-key"


def get_db_connection():
    return psycopg2.connect(
        host="localhost",
        database="intern",
        user="postgres",
        password="postgres",
        port=5432,
        cursor_factory=DictCursor
    )


@app.route("/")
def login():
    return render_template("login.html")


@app.route("/admin_login", methods=["GET", "POST"])
def admin_login():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute(
            "SELECT password FROM admins WHERE email = %s",
            (email,)
        )
        admin = cur.fetchone()

        cur.close()
        conn.close()

        if admin and check_password_hash(admin["password"], password):
            session["admin_logged_in"] = True
            session["admin_email"] = email
            return redirect(url_for("admin_dashboard"))

        return render_template("admin_login.html", error="Invalid admin credentials")

    return render_template("admin_login.html")


@app.route("/admin/dashboard")
def admin_dashboard():
    if not session.get("admin_logged_in"):
        return redirect(url_for("admin_login"))

    return f"Welcome Admin ({session['admin_email']})"

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
            "SELECT password FROM interns WHERE email = %s",
            (email,)
        )
        intern = cur.fetchone()

        cur.close()
        conn.close()

        if intern and check_password_hash(intern["password"], password):
            session["intern_logged_in"] = True
            session["intern_email"] = email
            return redirect(url_for("home"))

        return render_template("already.html", error="Invalid intern credentials")

    return render_template("already.html")


@app.route("/home")
def home():
    return render_template("home.html")


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run(debug=True)
