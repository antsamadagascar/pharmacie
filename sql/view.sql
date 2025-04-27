--
-- Fonctionnalies1: Listes medicaments pour enfant pour un maladie de type gorder
--
CREATE VIEW vue_listes_medicaments AS
SELECT
    m.idMedicament,
    p.nomProduit,
    p.idProduit,
    t.nomMaladie AS typeMaladie,
    c.nomCategorie,
    a.nomType AS typeAdministration,
    g.nomGroupe AS groupeAge,
    p.prixUnitaire
FROM
    medicaments m
JOIN
    medicamentTypesMaladies mtm ON m.idMedicament = mtm.idMedicament
JOIN
    typesMaladies t ON mtm.idTypeMaladie = t.idTypeMaladie
JOIN
    produits p ON P.idProduit = m.idProduit
JOIN
    categories c ON p.idCategorie = c.idCategorie
JOIN
    typesAdministration a ON m.idTypeAdmin = a.idTypeAdmin
JOIN
    groupesAge g ON m.idGroupeAge = g.idGroupeAge ;

--
-- Fonctionnalies2:Listes ventes medicaments injectables pour bebes
--
CREATE OR REPLACE VIEW vue_ventes_details AS
SELECT 
    m.idMedicament,
    p.nomProduit,
    p.idProduit,
    c.nomCategorie,
    t.nomType,
    g.nomGroupe,
    p.prixUnitaire,
    v.quantite,
    v.prixTotal,
    v.dateVente
FROM ventes v
JOIN produits p ON v.idProduit = p.idProduit
JOIN medicaments m on m.idProduit = p.idProduit
JOIN categories c ON p.idCategorie = c.idCategorie
JOIN typesAdministration t ON m.idTypeAdmin = t.idTypeAdmin
JOIN groupesAge g ON m.idGroupeAge = g.idGroupeAge;

---
-- Foncionnalites3:Listes  produits conseillés du mois
---
CREATE OR REPLACE VIEW v_produits_conseilles AS
SELECT 
    pc.idConseil,
    p.idProduit,
    p.nomProduit,
    tp.nomType as type_produit,
    c.nomCategorie as categorie,
    p.prixUnitaire,
    pc.description,
    pc.raison,
    pc.moisConseil,
    s.reste as stock_disponible,
    u.nomUnite
FROM ProduitsConseilles pc
JOIN Produits p ON p.idProduit = pc.idProduit
JOIN TypeProduit tp ON tp.idTypeProduit = p.idTypeProduit
JOIN Categories c ON c.idCategorie = p.idCategorie
JOIN Stocks s ON s.idProduit = p.idProduit
JOIN Unites u ON u.idUnite = s.idUnite
WHERE s.reste > 0
ORDER BY pc.moisConseil DESC;

---
-- Fonctionnalites4:Listes Ventes client du jours (ou multicriteres)
---
CREATE OR REPLACE VIEW v_listes_ventes_clients AS
SELECT
    v.idVente,
    v.dateVente,
    v.quantite,
    v.prixTotal,
    c.idCategorie,
    p.idProduit,
    tp.idTypeProduit,
    tp.nomType as typeProduit,
    p.nomProduit,
    p.prixUnitaire,
    c.nomCategorie as categorieProduit,
    cl.idClient,
    cl.nom AS nomClient,
    cl.prenom AS prenomClient
FROM ventes v
JOIN Produits p ON v.idProduit = p.idProduit
JOIN Categories c ON p.idCategorie = c.idCategorie
JOIN clients cl ON v.idClient = cl.idClient
JOIN typeProduit tp ON tp.idTypeProduit = p.idTypeProduit;
--
-- Etat de stock
---
CREATE OR REPLACE VIEW AS V_stocks
SELECT 
    p.nomProduit as Produit,
    c.nomCategorie as Categorie,
    t.nomType as TypeProduit,
    s.entree,
    s.sortie,
    s.reste,
    u.nomUnite as Unite,
    p.prixUnitaire
FROM Stocks s
JOIN Produits p ON p.idProduit = s.idProduit
JOIN Categories c ON c.idCategorie = p.idCategorie
JOIN TypeProduit t ON t.idTypeProduit = p.idTypeProduit
JOIN Unites u ON u.idUnite = s.idUnite
ORDER BY t.nomType, p.nomProduit;

ALTER TABLE ventes 
ADD COLUMN idVendeur INTEGER REFERENCES Vendeurs(idVendeur);


CREATE OR REPLACE VIEW vue_commissions_vendeurs AS
SELECT 
    v.idVendeur,
    vd.nom,
    vd.prenom ,
    v.dateVente,
    SUM(v.prixTotal) AS total_ventes,
    ROUND(SUM(v.prixTotal * 0.05), 2) AS commission
FROM 
    ventes v
    JOIN vendeur vd ON v.idVendeur = vd.idVendeur
GROUP BY 
    v.idVendeur,
    vd.nom,
	vd.prenom,
    v.dateVente
ORDER BY 
    v.dateVente DESC, 
    v.idVendeur;

--
-- vue ventes commission
--

CREATE OR REPLACE VIEW vue_commissions_vendeurs AS
SELECT 
    v.idVendeur,
    vd.nom,
    vd.prenom,
    v.dateVente,
    p.nomProduit,
    g.nomGenre,
    g.idGenre,
    v.quantite,
    v.prixTotal,
    SUM(v.prixTotal) AS total_ventes,
    CASE 
        WHEN SUM(v.prixTotal) >= 200000 
        THEN ROUND(SUM(v.prixTotal * 0.05), 2) 
        ELSE 0 
    END AS commission
FROM 
    ventes v
    JOIN vendeur vd ON v.idVendeur = vd.idVendeur
    JOIN produits p ON p.idProduit = v.idProduit
    JOIN Genres g ON g.idGenre = vd.idGenre
GROUP BY 
    v.idVendeur,
    vd.nom,
    vd.prenom,
    p.nomProduit,
    v.dateVente,
    v.quantite,
    v.prixTotal,
    g.nomGenre,
    g.idGenre
ORDER BY 
    v.dateVente DESC, 
    v.idVendeur,
    g.nomGenre;


---
-- vue pour recuperer les historiques des prix
---
CREATE VIEW v_historique_prix_produits AS
SELECT 
    hp.idHistorique,
    p.idProduit,
    p.nomProduit,
    tp.nomType as type_produit,
    c.nomCategorie as categorie,
    hp.ancienPrix,
    hp.nouveauPrix,
    hp.dateChangement,
    hp.raison,
    s.reste as stock_disponible,
    u.nomUnite as unite
FROM HistoriquePrix hp
JOIN Produits p ON hp.idProduit = p.idProduit
JOIN TypeProduit tp ON p.idTypeProduit = tp.idTypeProduit
JOIN Categories c ON p.idCategorie = c.idCategorie
LEFT JOIN Stocks s ON p.idProduit = s.idProduit
LEFT JOIN Unites u ON s.idUnite = u.idUnite;