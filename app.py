from flask import Flask, render_template, request, redirect, session, url_for
from werkzeug.security import generate_password_hash, check_password_hash
import psycopg2 
import os

app = Flask(__name__)
app.secret_key = "super-secret-key" 

USER_EMAIL = "user@gmail.com"
USER_PASSWORD_HASH = generate_password_hash(
    "user123",
    method="pbkdf2:sha256",
    salt_length=16
)

@app.route("/")
def login():
    return render_template("login.html")

@app.route("/admin_login", methods=["GET","POST"])
def admin_login():
    if request.method == "POST":
        email = request.form.get("email")
        password = request.form.get("password")

        if email == "admin@gmail.com" and password == "admin123":
            return redirect("/admin/dashboard")
        else:
            return render_template("admin_login.html", error="Invalid admin credentials")

    return render_template("admin_login.html")

@app.route("/dashboard")
def dashboard():
    if "user_logged_in" in session:
        return f"Welcome User ({session['user_email']})"
    return redirect(url_for("login"))

@app.route("/home")
def home():
    return render_template("home.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

@app.route("/already")
def already():
    return render_template("already.html")



if __name__ == "__main__":
    app.run(debug=True)
