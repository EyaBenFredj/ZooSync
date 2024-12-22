DROP DATABASE IF EXISTS ZooManagement;
CREATE DATABASE ZooManagement;
USE ZooManagement;


CREATE TABLE Services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_service VARCHAR(100)
);

CREATE TABLE Employes (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    code_mnemo CHAR(3),
    nom VARCHAR(50),
    prenom VARCHAR(50),
    date_naissance DATE,
    lieu_naissance VARCHAR(100),
    nom_marital VARCHAR(50),
    num_avs CHAR(11),
    adresse VARCHAR(255),
    telephone VARCHAR(15),
    service_id INT,
    FOREIGN KEY (service_id) REFERENCES Services(service_id)
);

CREATE TABLE Salaires (
    salaire_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    mois DATE,
    montant DECIMAL(10,2),
    FOREIGN KEY (employee_id) REFERENCES Employes(employee_id)
);

CREATE TABLE Secteurs (
    secteur_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_secteur VARCHAR(100),
    chef_secteur_id INT,
    FOREIGN KEY (chef_secteur_id) REFERENCES Employes(employee_id)
);

CREATE TABLE Parcelles (
    parcelle_id INT AUTO_INCREMENT PRIMARY KEY,
    nom_parcelle VARCHAR(100),
    secteur_id INT,
    FOREIGN KEY (secteur_id) REFERENCES Secteurs(secteur_id)
);

CREATE TABLE Gardiens (
    gardien_id INT PRIMARY KEY,
    taux_occupation DECIMAL(5,2),
    grade VARCHAR(50),
    FOREIGN KEY (gardien_id) REFERENCES Employes(employee_id)
);

CREATE TABLE Horaires (
    horaire_id INT AUTO_INCREMENT PRIMARY KEY,
    gardien_id INT,
    parcelle_id INT,
    date DATE,
    heure_debut TIME,
    heure_fin TIME,
    FOREIGN KEY (gardien_id) REFERENCES Gardiens(gardien_id),
    FOREIGN KEY (parcelle_id) REFERENCES Parcelles(parcelle_id)
);

CREATE TABLE Animaux (
    animal_id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50),
    espece VARCHAR(50),
    date_naissance DATE,
    poids DECIMAL(5,2),
    taille DECIMAL(5,2),
    groupe_sanguin VARCHAR(5),
    parent_id INT,
    date_deces DATE,
    parcelle_id INT,
    FOREIGN KEY (parent_id) REFERENCES Animaux(animal_id),
    FOREIGN KEY (parcelle_id) REFERENCES Parcelles(parcelle_id)
);

CREATE TABLE Groupes_Animaux (
    groupe_id INT AUTO_INCREMENT PRIMARY KEY,
    espece VARCHAR(50),
    nombre_approximatif INT,
    parcelle_id INT,
    FOREIGN KEY (parcelle_id) REFERENCES Parcelles(parcelle_id)
);

CREATE TABLE PreferencesGardiens (
    gardien_id INT,
    secteur_id INT,
    type_preference ENUM('Favori', 'Non apprecie'),
    PRIMARY KEY (gardien_id, secteur_id),
    FOREIGN KEY (gardien_id) REFERENCES Gardiens(gardien_id),
    FOREIGN KEY (secteur_id) REFERENCES Secteurs(secteur_id)
);
-- Insert into Services
INSERT INTO Services (nom_service) VALUES 
('Surveillance');

-- Insert into Employes
INSERT INTO Employes (code_mnemo, nom, prenom, date_naissance, lieu_naissance, num_avs, adresse, telephone, service_id)
VALUES 
('JEA', 'Dupont', 'Jean', '1985-06-12', 'Paris', '756.123.456', '123 Rue A', '0123456789', 1),
('DUV', 'Dupuis', 'Jean-Marc', '1987-03-05', 'Lyon', '756.234.567', '456 Rue B', '0987654321', 1),
('YVE', 'Yves', 'Martin', '1990-08-15', 'Marseille', '756.345.678', '789 Rue C', '0678901234', 1),
('LUC', 'Michelot', 'Luc', '1988-12-17', 'Bordeaux', '756.456.789', '321 Rue D', '0777888999', 1),
('VIT', 'Lemoine', 'Victor', '1989-05-10', 'Nice', '756.567.890', '654 Rue E', '0765432101', 1);

-- Insert into Secteurs
INSERT INTO Secteurs (nom_secteur, chef_secteur_id)
VALUES 
('Singes', 4),  -- LUC
('oiseaux', 2),  -- VIT
('aquarium', 4),  -- JEA

('Reptiles', 2); -- DUV

-- Insert into Parcelles
INSERT INTO Parcelles (nom_parcelle, secteur_id)
VALUES 
('Parcelle 1', 1), -- Secteur Singes
('Parcelle 2', 1),
('Parcelle 3', 1),
('Parcelle 4', 1),
('Parcelle 5', 1);

-- Insert into Gardiens
INSERT INTO Gardiens (gardien_id, taux_occupation, grade)
VALUES 
(1, 100, 'Senior'),  -- JEA
(2, 100, 'Senior'),  -- DUV
(3, 100, 'Senior'),  -- YVE
(4, 100, 'Senior'),  -- LUC
(5, 100, 'Senior');  -- VIT

-- Insert into Horaires
INSERT INTO Horaires (gardien_id, parcelle_id, date, heure_debut, heure_fin)
VALUES 
(1, 1, '2024-06-10', '09:00', '10:00'), -- JEA - Parcelle 1
(2, 2, '2024-06-10', '09:00', '10:00'), -- DUV - Parcelle 2
(3, 3, '2024-06-10', '09:00', '10:00'), -- YVE - Parcelle 3
(4, 4, '2024-06-10', '09:00', '10:00'), -- LUC - Parcelle 4
(5, 5, '2024-06-10', '09:00', '10:00'); -- VIT - Parcelle 5
SELECT * FROM Employes;
SELECT * FROM Secteurs;
SELECT * FROM Parcelles;
SELECT * FROM Gardiens;
SELECT * FROM Horaires;
