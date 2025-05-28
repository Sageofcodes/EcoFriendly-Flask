from flask import Flask, render_template, redirect, request, jsonify, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, login_user, login_required, logout_user, UserMixin, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
from functools import wraps
import json

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or not current_user.is_admin:
            return redirect(url_for('home'))  # or login page
        return f(*args, **kwargs)
    return decorated_function

app = Flask(__name__)
app.secret_key = 'supersecret123'

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:fahad125dbconnect@localhost/info_db'
db = SQLAlchemy(app)

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

import json

# Register 'loads' filter for decoding JSON in Jinja2
@app.template_filter('loads')
def from_json_filter(s):
    return json.loads(s)

class NewsletterSubscription(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)

class ContactMessages(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=True)
    email = db.Column(db.String(255), nullable=False)
    message = db.Column(db.Text, nullable=False)

class Orders(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    items = db.Column(db.Text, nullable=False)  # Stored as JSON string
    total = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)
    status = db.Column(db.String(50), default='Pending')

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text, nullable=False)
    price = db.Column(db.Float, nullable=False)
    image_url = db.Column(db.String(255))

class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(100), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)
    is_admin = db.Column(db.Boolean, default=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

#@app.route('/create_admin')
#def create_admin():
#    user = User(username='admin', email='fahad@admin.com')
#    user.set_password('admin125') 
#    db.session.add(user)
#    db.session.commit()
#    return "Admin user created!"

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        user = User.query.filter_by(email=email).first()
        if user and user.check_password(password) and user.is_admin:
            login_user(user)
            return redirect('/admin')
        return "Invalid credentials", 401
    return render_template('login.html')  # This line opens the page

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect('/')

@app.route('/admin')
@admin_required
def admin_dashboard():
    page = request.args.get('page', 1, type=int)

    products = Product.query.all()
    messages = ContactMessages.query.all()
    subs = NewsletterSubscription.query.all()
    orders = Orders.query.order_by(Orders.timestamp.desc()).paginate(page=page, per_page=5)

    # Parse order items (as before)
    for order in orders.items:
        try:
            loaded_items = json.loads(order.items)
            order.items = list(loaded_items.values()) if isinstance(loaded_items, dict) else loaded_items
        except:
            order.items = []

    return render_template('admin/dashboard.html',
        products=products, messages=messages, subs=subs, orders=orders)


@app.route('/')
def home():
    products = Product.query.all()
    return render_template('index.html', products=products)

@app.route('/subscribe', methods=['POST'])
def subscribe():
    email = request.form.get('email')
    if email:
        subscription = NewsletterSubscription(email=email)
        db.session.add(subscription)
        db.session.commit()
        return jsonify({'message': 'Subscription successful!'})
    return jsonify({'message': 'Email is required!'}), 400

@app.route('/contact', methods=['POST'])
def contact():
    name = request.form.get('name')
    email = request.form.get('email')
    message = request.form.get('message')
    if email and message:
        contact_msg = ContactMessages(name=name, email=email, message=message)
        db.session.add(contact_msg)
        db.session.commit()
        return jsonify({'message': 'Message sent successfully!'})
    return jsonify({'message': 'Email and Message are required!'}), 400

@app.route('/checkout', methods=['POST'])
def checkout():
    try:
        items_json = request.form.get('items')
        total = request.form.get('total')

        if not items_json or not total:
            return jsonify({'message': 'Missing data'}), 400

        order = Orders(items=items_json, total=float(total))
        db.session.add(order)
        db.session.commit()

        return jsonify({'message': 'Order successfully saved!'})
    except Exception as e:
        return jsonify({'message': 'Error saving order', 'error': str(e)}), 500
    
@app.route('/add_product', methods=['POST'])
@admin_required
def add_product():
    if not current_user.is_admin:
        return redirect('/')
    name = request.form.get('name')
    description = request.form.get('description')
    price = float(request.form.get('price'))
    image_url = request.form.get('image_url')
    new_product = Product(name=name, description=description, price=price, image_url=image_url)
    db.session.add(new_product)
    db.session.commit()
    return redirect('/admin')

@app.route('/edit_product/<int:product_id>', methods=['GET', 'POST'])
@admin_required
def edit_product(product_id):
    if not current_user.is_admin:
        return redirect('/')
    product = Product.query.get_or_404(product_id)

    if request.method == 'POST':
        product.name = request.form.get('name')
        product.description = request.form.get('description')
        product.price = float(request.form.get('price'))
        product.image_url = request.form.get('image_url')
        db.session.commit()
        return redirect('/admin')

    return render_template('admin/edit_product.html', product=product)

@app.route('/delete_product/<int:product_id>')
@admin_required
def delete_product(product_id):
    if not current_user.is_admin:
        return redirect('/')
    product = Product.query.get_or_404(product_id)
    db.session.delete(product)
    db.session.commit()
    return redirect('/admin')

@app.route('/update_status/<int:order_id>', methods=['POST'])
@admin_required
def update_status(order_id):
    if not current_user.is_admin:
        return redirect('/')
    
    order = Orders.query.get_or_404(order_id)
    new_status = request.form.get('status')

    if new_status in ['Pending', 'On the Way', 'Fulfilled']:
        order.status = new_status
        db.session.commit()

    return redirect('/admin')


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)

