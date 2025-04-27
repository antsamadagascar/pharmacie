INSERT INTO typesMaladies (nomMaladie, description)
VALUES
    ('Infection de la Gorge', 'Maladies affectant la gorge, comme les amygdalites, pharyngites, etc.'),
    ('Grippe', 'Infection virale qui touche les voies respiratoires supérieures, causée par des virus de la grippe.'),
    ('Rhume', 'Maladie virale bénigne affectant les voies respiratoires supérieures, souvent causée par des rhinovirus.'),
    ('Bronchite', 'Inflammation des bronches, souvent due à une infection virale ou bactérienne.'),
    ('Asthme', 'Affection respiratoire caractérisée par des difficultés respiratoires liées à l’inflammation des bronches.');
    ('Antipyrétiques', 'Accun');

INSERT INTO Unites (nomUnite) VALUES
    ('Boîte'),
    ('Comprimé'),
    ('Flacon'),
    ('Ampoule'),
    ('Tube'),
    ('Sachet'),
    ('Pièce');

INSERT INTO TypeProduit (nomType) VALUES
    ('Médicaments'),
    ('Parapharmacie'),
    ('Matériel médical'),
    ('Hygiène'),
    ('Compléments alimentaires');

INSERT INTO Categories (nomCategorie, description) VALUES
    ('Antibiotiques', 'Médicaments qui combattent les infections bactériennes'),
    ('Antidouleurs', 'Médicaments qui soulagent la douleur'),
    ('Vaccins', 'Préparations immunologiques préventives'),
    ('Vitamines', 'Suppléments vitaminiques essentiels'),
    ('Antihistaminiques', 'Médicaments contre les allergies'),
    ('Antipyrétiques', 'Médicaments contre la fièvre'),
    ('Medicaments de Gorge', 'Médicaments contre la fièvre');

INSERT INTO typesAdministration (nomType, description) VALUES
    ('Injectable', 'Administration par injection'),
    ('Oral', 'Administration par voie orale'),
    ('Topique', 'Application sur la peau'),
    ('Suppositoire', 'Administration rectale'),
    ('Spray nasal', 'Administration par voie nasale');

INSERT INTO groupesAge (nomGroupe, ageMin, ageMax) VALUES
    ('Nouveau-né', 0, 1),
    ('Bébé', 1, 3),
    ('Enfant', 3, 12),
    ('Adolescent', 12, 18),
    ('Adulte', 18, 65),
    ('Senior', 65, 120);

INSERT INTO clients (nom, prenom) VALUES 
    ('Dupont', 'Jean'),
    ('Martin', 'Sophie'),
    ('Bernard', 'Luc'),
    ('Durand', 'Alice'),
    ('Lefevre', 'Paul');

INSERT INTO Produits (idTypeProduit, idCategorie, nomProduit, prixUnitaire) VALUES
    -- Médicaments
    (1, 1, 'Amoxicilline 500mg', 8.50),
    (1, 1, 'Paracétamol 1000mg', 2.99),
    (1, 1, 'Ibuprofène 400mg', 4.50),
    (1, 1, 'Aspirine 500mg', 3.99),
    (1, 1, 'Doliprane 1000mg', 6.50),
    -- Parapharmacie
    (2, 5, 'Crème hydratante', 12.99),
    (2, 5, 'Solution antiseptique', 7.50),
    (2, 5, 'Shampooing antipelliculaire', 9.99),
    (2, 5, 'Baume à lèvres', 4.20),
    (2, 5, 'Lait corporel', 10.50),
    -- Matériel médical
    (3, 2, 'Thermomètre digital', 15.99),
    (3, 2, 'Pansements stériles', 3.99),
    (3, 2, 'Tensiomètre', 25.00),
    (3, 2, 'Masque chirurgical (boîte de 50)', 20.00),
    (3, 2, 'Gants en latex (boîte de 100)', 12.00),
    -- Hygiène
    (4, 2, 'Gel hydroalcoolique', 3.50),
    (4, 2, 'Savon antiseptique', 2.50),
    (4, 2, 'Déodorant 24h', 5.99),
    (4, 2, 'Serviettes hygiéniques', 6.99),
    (4, 2, 'Lingettes désinfectantes', 4.99),
    -- Compléments alimentaires
    (5, 2, 'Vitamine C 1000mg', 9.99),
    (5, 2, 'Magnésium B6', 11.50),
    (5, 2, 'Oméga 3', 13.99),
    (5, 2, 'Probiotiques', 14.99),
    (5, 2, 'Zinc 25mg', 8.99);


INSERT INTO ProduitsConseilles (idProduit, moisConseil, description, raison) VALUES
    -- 2022
    (11, '2022-01-01', 'Conseillé pour les infections bactériennes en hiver', 'Fréquence élevée de pathologies respiratoires'),
    (12, '2022-02-01', 'Utilisé pour soulager les douleurs et la fièvre', 'Grippe saisonnière et rhumes'),
    (13, '2022-03-01', 'Anti-inflammatoire pour douleurs articulaires', 'Augmentation des pathologies chroniques au printemps'),
    (14, '2022-04-01', 'Hydratation pour peaux sèches', 'Changements climatiques au printemps'),
    (15, '2022-05-01', 'Pour l\''hygiène quotidienne', 'Saison estivale et transpiration accrue'),

    -- 2023
    (6, '2023-01-01', 'Mesure rapide de la température', 'Saisonnalité des infections grippales'),
    (7, '2023-02-01', 'Pour la protection des plaies', 'Fréquence accrue des blessures domestiques'),
    (8, '2023-03-01', 'Gel désinfectant pour les mains', 'Maintenir l''hygiène dans les lieux publics'),
    (9, '2023-04-01', 'Renforcement du système immunitaire', 'Prévention des carences en vitamines'),
    (10, '2023-05-01', 'Réduction du stress et de la fatigue', 'Augmentation des besoins en magnésium'),

    -- 2024
    (1, '2024-01-01', 'Conseillé pour les infections bactériennes hivernales', 'Fort risque d''épidémies'),
    (2, '2024-02-01', 'Réduction des douleurs liées à la grippe', 'Augmentation de la propagation des virus'),
    (3, '2024-03-01', 'Anti-inflammatoire recommandé', 'Soulager les douleurs de printemps'),
    (4, '2024-04-01', 'Crème hydratante protectrice', 'Prévention des irritations printanières'),
    (5, '2024-05-01', 'Produit de soin antiseptique', 'Prévention des infections cutanées');

INSERT INTO medicaments (idProduit, idTypeAdmin, idGroupeAge) VALUES
    (1, 2, 5), -- Amoxicilline 500mg, Oral, Adulte
    (2, 2, 4), -- Paracétamol 1000mg, Oral, Adolescent
    (3, 2, 5), -- Ibuprofène 400mg, Oral, Adulte
    (4, 2, 5), -- Aspirine 500mg, Oral, Adulte
    (5, 2, 5), -- Doliprane 1000mg, Oral, Adulte
    (6, 3, 5), -- Crème hydratante, Topique, Adulte
    (7, 3, 5), -- Solution antiseptique, Topique, Adulte
    (8, 3, 3), -- Shampooing antipelliculaire, Topique, Enfant
    (9, 3, 5), -- Baume à lèvres, Topique, Adulte
    (10, 3, 5); -- Lait corporel, Topique, Adulte

INSERT INTO medicamentTypesMaladies (idMedicament, idTypeMaladie) VALUES
    (1, 1), -- Amoxicilline 500mg, Infection de la Gorge
    (2, 2), -- Paracétamol 1000mg, Grippe
    (3, 3), -- Ibuprofène 400mg, Rhume
    (4, 1), -- Aspirine 500mg, Infection de la Gorge
    (5, 6), -- Doliprane 1000mg, Antipyrétiques
    (6, 4), -- Crème hydratante, Bronchite
    (7, 4), -- Solution antiseptique, Bronchite
    (8, 5), -- Shampooing antipelliculaire, Asthme
    (9, 2), -- Baume à lèvres, Grippe
    (10, 6); -- Lait corporel, Antipyrétiques


INSERT INTO Stocks (idProduit, quantite, entree, sortie, idUnite) VALUES
    (1, 100, 100, 0, 2), -- Stock initial de Amoxicilline 500mg (comprimés)
    (2, 200, 200, 0, 2), -- Stock initial de Paracétamol 1000mg (comprimés)
    (3, 150, 150, 0, 2), -- Stock initial de Ibuprofène 400mg (comprimés)
    (4, 100, 100, 0, 2), -- Stock initial de Aspirine 500mg (comprimés)
    (5, 250, 250, 0, 2), -- Stock initial de Doliprane 1000mg (comprimés)
    (6, 50, 50, 0, 4), -- Stock initial de Crème hydratante (tubes)
    (7, 80, 80, 0, 3), -- Stock initial de Solution antiseptique (flacons)
    (8, 60, 60, 0, 3), -- Stock initial de Shampooing antipelliculaire (flacons)
    (9, 90, 90, 0, 4), -- Stock initial de Baume à lèvres (tubes)
    (10, 100, 100, 0, 4); -- Stock initial de Lait corporel (tubes)



INSERT INTO vendeur (nom, prenom) VALUES 
    ('Mark', 'Jean'),
    ('Ivo', 'Sophie'),
    ('Dupony', 'Luc'),
    ('Durand', 'Alice'),
    ('Lefevre', 'Paul');

INSERT INTO Genres(nomGenre) VALUES 
('Homme'),
('Femme');