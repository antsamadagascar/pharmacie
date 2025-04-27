package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import models.Achats;
import utils.connection.PostgresConnection;

public class AchatsDAO {
    public void insertMultipleAchats(List<Achats> achats) throws SQLException {
        String query = "INSERT INTO achats (idProduit, quantiteAchat, prixAchat, dateAchat, idUnite) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
             
            conn.setAutoCommit(false);
            try {
                for (Achats achat : achats) {
                    if (achat.getProduits() == null) {
                        throw new IllegalArgumentException("Le produit est null");
                    }
                    if (achat.getProduits().getIdProduit() <= 0) {
                        throw new IllegalArgumentException("ID produit invalide: " + achat.getProduits().getIdProduit());
                    }

                    if (achat.getUnites() == null) {
                        throw new IllegalArgumentException("L'unité est null");
                    }
                    if (achat.getUnites().getIdUnite() <= 0) {
                        throw new IllegalArgumentException("ID unité invalide: " + achat.getUnites().getIdUnite());
                    }
    
                    if (achat.getQuantiteAchat() <= 0) {
                        throw new IllegalArgumentException("La quantité doit être supérieure à 0: " + achat.getQuantiteAchat());
                    }
    
                    if (achat.getPrixAchat() == null) {
                        throw new IllegalArgumentException("Le prix est null");
                    }
                    if (achat.getPrixAchat().compareTo(BigDecimal.ZERO) <= 0) {
                        throw new IllegalArgumentException("Le prix doit être supérieur à 0: " + achat.getPrixAchat());
                    }
    
                    System.out.println("Insertion achat:");
                    System.out.println("- Produit ID: " + achat.getProduits().getIdProduit());
                    System.out.println("- Unité ID: " + achat.getUnites().getIdUnite());
                    System.out.println("- Quantité: " + achat.getQuantiteAchat());
                    System.out.println("- Prix: " + achat.getPrixAchat());
                    System.out.println("- Date: " + achat.getDateAchat());
    
                    stmt.setInt(1, achat.getProduits().getIdProduit());
                    stmt.setInt(2, achat.getQuantiteAchat());
                    stmt.setBigDecimal(3, achat.getPrixAchat());
                    stmt.setDate(4, achat.getDateAchat());
                    stmt.setInt(5, achat.getUnites().getIdUnite());
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
}
