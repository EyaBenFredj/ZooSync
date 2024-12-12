from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text

app = Flask(__name__)
app.secret_key = 'supersecretkey'  # For flashing messages

# MySQL Database Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:bogamenthe88@localhost/ZooManagement'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Models
class Employe(db.Model):
    __tablename__ = 'Employes'
    employee_id = db.Column(db.Integer, primary_key=True)
    code_mnemo = db.Column(db.String(3), nullable=False)
    nom = db.Column(db.String(50), nullable=False)
    prenom = db.Column(db.String(50), nullable=False)

class Service(db.Model):
    __tablename__ = 'Services'
    service_id = db.Column(db.Integer, primary_key=True)
    nom_service = db.Column(db.String(100), nullable=False)

class Parcelle(db.Model):
    __tablename__ = 'Parcelles'
    parcelle_id = db.Column(db.Integer, primary_key=True)
    nom_parcelle = db.Column(db.String(100), nullable=False)

# Predefined SQL Queries
PREDEFINED_QUERIES = {
    '1': "SELECT * FROM Employes;",
    '2': "SELECT * FROM Services;",
    '3': "SELECT * FROM Parcelles;",
    '4': "SELECT nom, prenom FROM Employes WHERE code_mnemo = 'JEA';",
    '5': "SELECT * FROM Parcelles WHERE nom_parcelle LIKE 'Parcelle%';"
}

# Home Route with SQL Query Execution
@app.route('/', methods=['GET', 'POST'])
def index():
    query_result = None
    headers = []
    error = None
    selected_query = None

    if request.method == 'POST':
        sql_query = request.form.get('sql_query')
        selected_query = request.form.get('predefined_query')

        # Use predefined query if selected
        if selected_query and selected_query in PREDEFINED_QUERIES:
            sql_query = PREDEFINED_QUERIES[selected_query]

        try:
            result = db.session.execute(text(sql_query))
            headers = result.keys()
            query_result = result.fetchall()
            flash('Query executed successfully!', 'success')
        except Exception as e:
            error = str(e)
            flash(f'Error: {error}', 'danger')

    employes = Employe.query.all()
    services = Service.query.all()
    parcelles = Parcelle.query.all()

    return render_template(
        'index.html',
        employes=employes,
        services=services,
        parcelles=parcelles,
        query_result=query_result,
        headers=headers,
        error=error,
        predefined_queries=PREDEFINED_QUERIES,
        selected_query=selected_query
    )

# CRUD for Employees
@app.route('/add_employee', methods=['POST'])
def add_employee():
    code_mnemo = request.form['code_mnemo']
    nom = request.form['nom']
    prenom = request.form['prenom']
    new_employee = Employe(code_mnemo=code_mnemo, nom=nom, prenom=prenom)
    db.session.add(new_employee)
    db.session.commit()
    flash('Employee added successfully!', 'success')
    return redirect(url_for('index'))

@app.route('/delete_employee/<int:employee_id>', methods=['POST'])
def delete_employee(employee_id):
    employee = Employe.query.get_or_404(employee_id)
    db.session.delete(employee)
    db.session.commit()
    flash('Employee deleted successfully!', 'danger')
    return redirect(url_for('index'))

# CRUD for Services
@app.route('/add_service', methods=['POST'])
def add_service():
    nom_service = request.form['nom_service']
    new_service = Service(nom_service=nom_service)
    db.session.add(new_service)
    db.session.commit()
    flash('Service added successfully!', 'success')
    return redirect(url_for('index'))

@app.route('/delete_service/<int:service_id>', methods=['POST'])
def delete_service(service_id):
    service = Service.query.get_or_404(service_id)
    db.session.delete(service)
    db.session.commit()
    flash('Service deleted successfully!', 'danger')
    return redirect(url_for('index'))

# CRUD for Parcelles
@app.route('/add_parcelle', methods=['POST'])
def add_parcelle():
    nom_parcelle = request.form['nom_parcelle']
    new_parcelle = Parcelle(nom_parcelle=nom_parcelle)
    db.session.add(new_parcelle)
    db.session.commit()
    flash('Parcelle added successfully!', 'success')
    return redirect(url_for('index'))

@app.route('/delete_parcelle/<int:parcelle_id>', methods=['POST'])
def delete_parcelle(parcelle_id):
    parcelle = Parcelle.query.get_or_404(parcelle_id)
    db.session.delete(parcelle)
    db.session.commit()
    flash('Parcelle deleted successfully!', 'danger')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)
