CREATE TABLE typesMaladies (
    idTypeMaladie SERIAL PRIMARY KEY,
    nomMaladie VARCHAR(100) NOT NULL,
    description TEXT
);

CREATE TABLE TypeProduit (
    idTypeProduit SERIAL PRIMARY KEY,
    nomType VARCHAR(100) NOT NULL
);

CREATE TABLE Unites (
    idUnite SERIAL PRIMARY KEY,
    nomUnite VARCHAR(50) NOT NULL
);

CREATE TABLE Categories (
    idCategorie SERIAL PRIMARY KEY,
    nomCategorie VARCHAR(255) NOT NULL,
    description text
);

CREATE TABLE typesAdministration (
    idTypeAdmin SERIAL PRIMARY KEY,
    nomType VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE groupesAge (
    idGroupeAge SERIAL PRIMARY KEY,
    nomGroupe VARCHAR(50) NOT NULL,
    ageMin INTEGER,
    ageMax INTEGER
);


CREATE TABLE Clients (
    idClient SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL
);


CREATE TABLE Produits (
    idProduit SERIAL PRIMARY KEY,
    idTypeProduit INTEGER REFERENCES TypeProduit(idTypeProduit),
    idCategorie INTEGER REFERENCES Categories(idCategorie),
    nomProduit VARCHAR(100) NOT NULL,
    prixUnitaire DECIMAL(10,2) NOT NULL
);

CREATE TABLE medicaments (
    idMedicament SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit) UNIQUE,
    idTypeAdmin INTEGER REFERENCES typesAdministration(idTypeAdmin),
    idGroupeAge INTEGER REFERENCES groupesAge(idGroupeAge)
);

CREATE TABLE medicamentTypesMaladies (
    idMedicament INTEGER REFERENCES medicaments(idMedicament),
    idTypeMaladie INTEGER REFERENCES typesMaladies(idTypeMaladie),
    PRIMARY KEY (idMedicament, idTypeMaladie)
);

CREATE TABLE ProduitsConseilles (
    idConseil SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit),
    moisConseil DATE NOT NULL DEFAULT CURRENT_DATE,
    description TEXT,
    raison TEXT
);

CREATE TABLE ventes (
    idVente SERIAL PRIMARY KEY,
    dateVente DATE NOT NULL DEFAULT CURRENT_DATE,
    idProduit INTEGER REFERENCES Produits(idProduit),
    quantite INTEGER NOT NULL,
    prixTotal DECIMAL(10,2) NOT NULL,
    idClient INTEGER REFERENCES Clients(idClient)
);

CREATE TABLE Achats (
    idAchat SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit) ON DELETE CASCADE,
    quantiteAchat INTEGER NOT NULL CHECK (quantiteAchat > 0),
    prixAchat DECIMAL(10,2) NOT NULL CHECK (prixAchat > 0),
    dateAchat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idUnite INTEGER REFERENCES Unites(idUnite),
    totalAchat DECIMAL(10,2) GENERATED ALWAYS AS (quantiteAchat * prixAchat) STORED
);


CREATE TABLE Stocks (
    idStock SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit) ON DELETE CASCADE,
    dateMisAjour TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    quantite INTEGER NOT NULL DEFAULT 0,
    entree INTEGER NOT NULL DEFAULT 0,
    sortie INTEGER NOT NULL DEFAULT 0,
    reste INTEGER GENERATED ALWAYS AS (entree - sortie) STORED,
    idUnite INTEGER REFERENCES Unites(idUnite)
);

CREATE TABLE Vendeur(
    id serial primary key,
    nom VARCHAr(255),
    prenom VARCHAR(255),
    idGenre REFERENCES Genres(idGenre)
);
ALTER TABLE Vendeur
ADD COLUMN idGenre INTEGER REFERENCES Genres(idGenre);

CREATE TABLE Genres(
    idGenre serial primary key,
    nomGenre VARCHAR(20)
);


CREATE TABLE HistoriquePrix (
    idHistorique SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit) ON DELETE CASCADE,
    ancienPrix DECIMAL(10,2) NOT NULL,
    nouveauPrix DECIMAL(10,2) NOT NULL,
    dateChangement DATE NOT NULL,
    raison TEXT
);


