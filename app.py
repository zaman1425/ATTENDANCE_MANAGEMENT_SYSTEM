from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2

app = Flask(__name__)
app.secret_key = "super-secret-key" 

ADMIN_EMAIL = "admin@gmail.com"
ADMIN_PASSWORD_HASH = generate_password_hash(
    "admin123",
    method="pbkdf2:sha256",
    salt_length=16
)

@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]

        if email == ADMIN_EMAIL and check_password_hash(ADMIN_PASSWORD_HASH, password):
            session["admin_logged_in"] = True
            session["admin_email"] = email
            return redirect(url_for("dashboard"))

        return "Invalid Credentials"

    return render_template("login.html")


@app.route("/dashboard")
def dashboard():
    if "admin_logged_in" in session:
        return f"Welcome Admin ({session['admin_email']})"
    return redirect(url_for("login"))

@app.route("/home.html")
def home():
    return render_template("home.html")

@app.route("/about.html")
def about():
    return render_template("login.html")

@app.route()

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0")
