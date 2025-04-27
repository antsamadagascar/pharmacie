-- Désactivation temporaire des contraintes de clé étrangère
SET session_replication_role = replica;

-- Suppression des données
TRUNCATE TABLE ventes RESTART IDENTITY CASCADE;
TRUNCATE TABLE medicaments RESTART IDENTITY CASCADE;
TRUNCATE TABLE medicamentTypesMaladies RESTART IDENTITY CASCADE;
TRUNCATE TABLE typesMaladies RESTART IDENTITY CASCADE;
TRUNCATE TABLE categoriesMedicaments RESTART IDENTITY CASCADE;
TRUNCATE TABLE typesAdministration RESTART IDENTITY CASCADE;
TRUNCATE TABLE groupesAge RESTART IDENTITY CASCADE;

-- Réactivation des contraintes de clé étrangère
SET session_replication_role = DEFAULT;

