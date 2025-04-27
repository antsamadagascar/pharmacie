package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import models.*;
import utils.connection.PostgresConnection;

public class VentesDAO {

    public void insertMultipleVentes(List<Ventes> ventes) throws SQLException {
        String query = "INSERT INTO ventes (dateVente, idProduit, quantite, prixTotal, idClient, idVendeur) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            conn.setAutoCommit(false);
            try {
                for (Ventes vente : ventes) {
                    // Validation du produit
                    if (vente.getProduits() == null || vente.getProduits().getIdProduit() == 0) {
                        throw new IllegalArgumentException("Le produit dans la vente est invalide.");
                    }
                    // Validation du client
                    if (vente.getClient() == null || vente.getClient().getIdClient() == 0) {
                        throw new IllegalArgumentException("Le client dans la vente est invalide.");
                    }
                    // Validation du vendeur
                    if (vente.getVendeur() == null || vente.getVendeur().getIdVendeur() == 0) {
                        throw new IllegalArgumentException("Le vendeur dans la vente est invalide.");
                    }
                    // Validation de la quantité
                    if (vente.getQuantite() <= 0) {
                        throw new IllegalArgumentException("La quantité doit être supérieure à 0.");
                    }
                    // Validation du prix
                    if (vente.getPrixTotal() == null || vente.getPrixTotal().compareTo(BigDecimal.ZERO) <= 0) {
                        throw new IllegalArgumentException("Le prix total doit être supérieur à 0.");
                    }
    
                    stmt.setDate(1, vente.getDateVente());
                    stmt.setInt(2, vente.getProduits().getIdProduit());
                    stmt.setInt(3, vente.getQuantite());
                    stmt.setBigDecimal(4, vente.getPrixTotal());
                    stmt.setInt(5, vente.getClient().getIdClient());
                    stmt.setInt(6, vente.getVendeur().getIdVendeur());
                    stmt.addBatch();
                }
                stmt.executeBatch();
                conn.commit();
            } catch (SQLException | IllegalArgumentException e) {
                conn.rollback();
                throw e;
            }
        }
    }
    public List<Map<String, Object>> getCommissionsVendeurs(String idVendeur, String dateMin, String dateMax, String idGenre) {
        List<Map<String, Object>> resultats = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
       
        sql.append("SELECT * FROM vue_commissions_vendeurs WHERE 1=1");
       
        // Conditions avec gestion des paramètres null
        List<Object> params = new ArrayList<>();
        
        if (dateMin != null && dateMax != null) {
            sql.append(" AND dateVente BETWEEN ? AND ?");
            params.add(java.sql.Date.valueOf(dateMin));
            params.add(java.sql.Date.valueOf(dateMax));
        } else if (dateMin != null) {
            sql.append(" AND dateVente >= ?");
            params.add(java.sql.Date.valueOf(dateMin));
        } else if (dateMax != null) {
            sql.append(" AND dateVente <= ?");
            params.add(java.sql.Date.valueOf(dateMax));
        }
       
        if (idVendeur != null) {
            sql.append(" AND idVendeur = ?");
            params.add(Integer.parseInt(idVendeur));
        }
        
        if (idGenre != null) {
            sql.append(" AND idGenre = ?");
            params.add(Integer.parseInt(idGenre));
        }
       
        sql.append(" ORDER BY dateVente");
        
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            // Paramètres pour les dates
            if (dateMin != null && dateMax != null) {
                pstmt.setDate(paramIndex++, java.sql.Date.valueOf(dateMin));
                pstmt.setDate(paramIndex++, java.sql.Date.valueOf(dateMax));
            } else if (dateMin != null) {
                pstmt.setDate(paramIndex++, java.sql.Date.valueOf(dateMin));
            } else if (dateMax != null) {
                pstmt.setDate(paramIndex++, java.sql.Date.valueOf(dateMax));
            }
            
            // Paramètre pour le vendeur
            if (idVendeur != null) {
                pstmt.setInt(paramIndex, Integer.parseInt(idVendeur));
            }

            if (idGenre != null) {
                pstmt.setInt(paramIndex, Integer.parseInt(idGenre));
            }
            
            System.out.println("Requête SQL: " + sql.toString()); 
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> commission = new HashMap<>();
                commission.put("nomVendeur", rs.getString("nom") + " " + rs.getString("prenom"));
                commission.put("nomGenre", rs.getString("nomGenre"));
                commission.put("dateVente", rs.getDate("dateVente").toString());
                commission.put("totalVentes", rs.getBigDecimal("total_ventes"));
                commission.put("nomproduit", rs.getString("nomproduit"));
                commission.put("quantite", rs.getBigDecimal("quantite"));
                commission.put("commission", rs.getBigDecimal("commission"));
                resultats.add(commission);
            }
            
        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            throw new RuntimeException("Erreur lors de la récupération des commissions", e);
        } catch (IllegalArgumentException e) {
            System.err.println("Erreur de format de date: " + e.getMessage());
            throw new RuntimeException("Format de date invalide", e);
        }
        
        return resultats;
    }
public List<Ventes> getVentes(String typeProduit, String categorie, String date) throws SQLException {
    List<Ventes> ventes = new ArrayList<>();
    StringBuilder query = new StringBuilder(
        "SELECT * FROM v_listes_ventes_clients WHERE 1=1"
    );
    
    List<Object> params = new ArrayList<>();

    if (typeProduit != null && !typeProduit.isEmpty()) {
        query.append(" AND idTypeProduit = ?::integer");
        params.add(typeProduit);
    }
    
    if (categorie != null && !categorie.isEmpty()) {
        query.append(" AND idCategorie = ?::integer");
        params.add(categorie);
    }
    
    if (date != null && !date.isEmpty()) {
        query.append(" AND DATE(dateVente) = ?::date");
        params.add(date);
    }

    try (Connection conn = PostgresConnection.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(query.toString())) {
        
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i + 1, params.get(i).toString());
        }

        try (ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Ventes vente = new Ventes();
                
                // Configuration du client
                Client client = new Client();
                client.setIdClient(rs.getInt("idClient"));
                client.setNom(rs.getString("nomClient"));
                client.setPrenom(rs.getString("prenomClient"));
                vente.setClient(client);

                // Configuration du produit
                Produits produit = new Produits();
                produit.setIdProduit(rs.getInt("idProduit"));
                produit.setNomProduit(rs.getString("nomProduit"));
                produit.setPrixUnitaire(rs.getDouble("prixUnitaire"));

                // Configuration du type de produit
                TypeProduit typeProd = new TypeProduit();
                typeProd.setIdTypeProduit(rs.getInt("idTypeProduit"));
                typeProd.setNomType(rs.getString("typeProduit"));
                produit.setTypeProduit(typeProd);

                // Configuration de la catégorie
                Categorie cat = new Categorie();
                cat.setIdCategorie(rs.getInt("idCategorie"));
                cat.setNomCategorie(rs.getString("categorieProduit"));
                produit.setCategorie(cat);

                vente.setProduits(produit);
                
                // Configuration des détails de la vente
                vente.setIdVente(rs.getInt("idVente"));
                vente.setQuantite(rs.getInt("quantite"));
                vente.setPrixTotal(rs.getBigDecimal("prixTotal"));
                vente.setDateVente(rs.getDate("dateVente"));

                ventes.add(vente);
            }
        }
    }
    
    return ventes;
}

}
