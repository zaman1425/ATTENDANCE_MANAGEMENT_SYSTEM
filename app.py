from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2

app = Flask(__name__)
app.secret_key = "super-secret-key"
ADMIN_EMAIL = "admin@gmail.com"
ADMIN_PASSWORD_HASH = generate_password_hash("admin123", method="pbkdf2:sha256")
@app.route("/")
def login():
    return render_template("login.html")
@app.route("/admin_login", methods=["GET", "POST"])
def admin_login():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")
        if email == ADMIN_EMAIL and check_password_hash(ADMIN_PASSWORD_HASH, password):
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

@app.route("/already", methods=["GET", "POST"])
def already():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        INTERN_EMAIL = "intern@gmail.com"
        INTERN_PASSWORD_HASH = generate_password_hash("intern123")
        if email == INTERN_EMAIL and check_password_hash(INTERN_PASSWORD_HASH, password):
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
