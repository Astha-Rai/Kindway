# app/routes.py
from flask import render_template, request, redirect, url_for, session, flash
from app import app, mysql
from werkzeug.security import generate_password_hash, check_password_hash

@app.route('/')
def home():
    return render_template('home.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = generate_password_hash(request.form['password'])
        phone = request.form['phone']
        role = request.form['role']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO Users (name, email, password, phone, role) VALUES (%s, %s, %s, %s, %s)",
                    (name, email, password, phone, role))
        mysql.connection.commit()
        cur.close()

        flash('Registration successful! Please log in.')
        return redirect(url_for('login'))

    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM Users WHERE email = %s", (email,))
        user = cur.fetchone()
        cur.close()

        if user and check_password_hash(user[3], password):
            session['user_id'] = user[0]
            session['user_name'] = user[1]
            session['role'] = user[5]

            if user[5] == 'Admin':
                return redirect(url_for('admin_dashboard'))
            elif user[5] == 'NGO':
                return redirect(url_for('ngo_dashboard'))
            else:
                return redirect(url_for('user_dashboard'))
        else:
            flash('Invalid credentials. Please try again.')

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('home'))

@app.route('/user/dashboard')
def user_dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM DonationItem WHERE user_id = %s", (session['user_id'],))
    donations = cur.fetchall()
    cur.close()
    return render_template('user_dashboard.html', user_name=session['user_name'], donations=donations)

@app.route('/ngo/dashboard')
def ngo_dashboard():
    if 'user_id' not in session or session['role'] != 'NGO':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM DonationRequest WHERE ngo_id = %s", (session['user_id'],))
    requests = cur.fetchall()
    cur.close()
    return render_template('ngo_dashboard.html', user_name=session['user_name'], requests=requests)

@app.route('/admin/dashboard')
def admin_dashboard():
    if 'role' not in session or session['role'] != 'Admin':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()

    cur.execute("""
        SELECT u.user_id, u.name, u.email, COUNT(DISTINCT dr.request_id) AS total_donations
        FROM Users u
        LEFT JOIN DonationItem di ON u.user_id = di.user_id
        LEFT JOIN DonationRequest dr ON di.item_id = dr.item_id
        WHERE u.role = 'Donor'
        GROUP BY u.user_id, u.name, u.email
    """)
    users = cur.fetchall()

    cur.execute("""
        SELECT u.user_id, u.name, u.email, l.city, l.state, u.phone
        FROM Users u
        LEFT JOIN Location l ON u.user_id = l.user_id
        WHERE u.role = 'NGO'
    """)
    ngos = cur.fetchall()

    cur.execute("""
        SELECT u.name, COUNT(dr.request_id)
        FROM Users u
        LEFT JOIN DonationRequest dr ON u.user_id = dr.ngo_id
        WHERE u.role = 'NGO'
        GROUP BY u.name
    """)
    donations_per_ngo = cur.fetchall()

    cur.close()
    return render_template('admin_panel.html', users=users, ngos=ngos, donations_per_ngo=donations_per_ngo)

@app.route('/donate/<category>', methods=['GET', 'POST'])
def donate(category):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        item_name = request.form['item_name']
        description = request.form['description']
        image_url = request.form['image_url']

        cur = mysql.connection.cursor()
        cur.execute("SELECT category_id FROM Category WHERE name = %s", (category,))
        category_row = cur.fetchone()
        if not category_row:
            flash('Invalid category selected.')
            return redirect(url_for('donate', category=category))
        category_id = category_row[0]

        cur.execute("INSERT INTO DonationItem (user_id, category_id, item_name, description, image_path) VALUES (%s, %s, %s, %s, %s)",
                    (session['user_id'], category_id, item_name, description, image_url))
        mysql.connection.commit()
        cur.close()
        return redirect(url_for('search_ngos', category=category))

    return render_template('donate.html', category=category)

@app.route('/search_ngos/<category>', methods=['GET', 'POST'])
def search_ngos(category):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT category_id FROM Category WHERE name = %s", (category,))
    category_row = cur.fetchone()
    if not category_row:
        flash('Invalid category.')
        return redirect(url_for('home'))
    category_id = category_row[0]

    cur.execute("""
    SELECT user_id, name, email, phone FROM Users
    WHERE role = 'NGO' AND user_id IN (
        SELECT user_id FROM Location WHERE city IS NOT NULL
    ) LIMIT 10
    """)

    ngos = cur.fetchall()
    cur.close()
    return render_template('search_results.html', ngos=ngos, category=category)

@app.route('/request_pickup/<int:ngo_id>/<category>', methods=['POST'])
def request_pickup(ngo_id, category):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    pickup_address = request.form['pickup_address']
    preferred_date = request.form['preferred_date']
    donation_type = request.form['donation_type']

    cur = mysql.connection.cursor()
    cur.execute("SELECT category_id FROM Category WHERE name = %s", (category,))
    category_row = cur.fetchone()
    if not category_row:
        flash('Invalid category.')
        return redirect(url_for('user_dashboard'))
    category_id = category_row[0]

    cur.execute("SELECT item_id FROM DonationItem WHERE user_id = %s AND category_id = %s ORDER BY item_id DESC LIMIT 1",
                (session['user_id'], category_id))
    item = cur.fetchone()
    if item:
        item_id = item[0]
        cur.execute("INSERT INTO DonationRequest (item_id, ngo_id, donation_type) VALUES (%s, %s, %s)", (item_id, ngo_id, donation_type))
        donation_request_id = cur.lastrowid
        cur.execute("INSERT INTO PickupRequest (request_id, pickup_address, preferred_date) VALUES (%s, %s, %s)",
                    (donation_request_id, pickup_address, preferred_date))
        mysql.connection.commit()
        flash('Pickup request submitted!')
    else:
        flash('No donation item found.')

    cur.close()
    return redirect(url_for('user_dashboard'))
