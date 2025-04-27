-- Fonction pour vérifier si le stock est suffisant
CREATE OR REPLACE FUNCTION check_stock_availability()
RETURNS TRIGGER AS $$
BEGIN
    -- Vérifier s'il y a assez de stock disponible
    IF NOT EXISTS (
        SELECT 1 
        FROM Stocks 
        WHERE idProduit = NEW.idProduit 
        AND (entree - sortie) >= NEW.quantite
    ) THEN
        RAISE EXCEPTION 'Stock insuffisant pour le produit id: %', NEW.idProduit;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour vérifier le stock avant l'insertion d'une vente
CREATE TRIGGER check_stock_before_sale
BEFORE INSERT ON ventes
FOR EACH ROW
EXECUTE FUNCTION check_stock_availability();

-- Fonction pour mettre à jour le stock après une vente
CREATE OR REPLACE FUNCTION update_stock_after_sale()
RETURNS TRIGGER AS $$
BEGIN
    -- Mettre à jour la sortie dans la table Stocks
    UPDATE Stocks
    SET 
        sortie = sortie + NEW.quantite,
        dateMisAjour = CURRENT_TIMESTAMP
    WHERE idProduit = NEW.idProduit;

    -- Si le stock restant est faible (moins de 10 unités), logger l'alerte
    INSERT INTO stock_alerts (idProduit, message, date_alerte)
    SELECT 
        NEW.idProduit,
        'Stock faible - Reste: ' || (entree - sortie)::text || ' unités',
        CURRENT_TIMESTAMP
    FROM Stocks
    WHERE idProduit = NEW.idProduit
    AND (entree - sortie) < 10;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger pour mettre à jour le stock après une vente
CREATE TRIGGER update_stock_after_sale
AFTER INSERT ON ventes
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_sale();

-- Table pour les alertes de stock
CREATE TABLE stock_alerts (
    id SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit),
    message TEXT NOT NULL,
    date_alerte TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'NEW'
);

-- Fonction pour l'historique des mouvements de stock
CREATE OR REPLACE FUNCTION log_stock_movement()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO stock_movements (
        idProduit,
        type_mouvement,
        quantite,
        date_mouvement
    ) VALUES (
        NEW.idProduit,
        CASE 
            WHEN NEW.entree > OLD.entree THEN 'ENTREE'
            WHEN NEW.sortie > OLD.sortie THEN 'SORTIE'
        END,
        CASE 
            WHEN NEW.entree > OLD.entree THEN NEW.entree - OLD.entree
            WHEN NEW.sortie > OLD.sortie THEN NEW.sortie - OLD.sortie
        END,
        CURRENT_TIMESTAMP
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Table pour l'historique des mouvements
CREATE TABLE stock_movements (
    id SERIAL PRIMARY KEY,
    idProduit INTEGER REFERENCES Produits(idProduit),
    type_mouvement VARCHAR(20) NOT NULL,
    quantite INTEGER NOT NULL,
    date_mouvement TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trigger pour logger les mouvements de stock
CREATE TRIGGER log_stock_changes
AFTER UPDATE ON Stocks
FOR EACH ROW
EXECUTE FUNCTION log_stock_movement();


---
-- fonction pour mettre a jour le prix unitaire d'un produit apres insetion produits
---

CREATE OR REPLACE FUNCTION update_prix_produits()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Produits
    SET prixUnitaire = NEW.nouveauPrix
    WHERE idProduit = NEW.idProduit;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_prix_trigger
AFTER INSERT ON HistoriquePrix
FOR EACH ROW
EXECUTE FUNCTION update_prix_produits();
