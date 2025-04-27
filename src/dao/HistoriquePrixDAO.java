package dao;

import models.HistoriquePrix;
import models.Produits;
import models.Stock;
import models.TypeProduit;
import models.Categorie;
import models.Unites;
import utils.connection.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistoriquePrixDAO {
    
    public void insertMultipleHistoriques(List<HistoriquePrix> historiques) throws SQLException {
        String sql = "INSERT INTO HistoriquePrix (idProduit, ancienPrix, nouveauPrix,dateChangement, raison) " +
                    "VALUES (?, ?, ?, ?,?)";
        
        try (Connection conn = PostgresConnection.getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                for (HistoriquePrix historique : historiques) {
                    pstmt.setInt(1, historique.getProduit().getIdProduit());
                    pstmt.setDouble(2, historique.getAncienPrix());
                    pstmt.setDouble(3, historique.getNouveauPrix());
                    pstmt.setDate(4, historique.getDateChangement());
                    pstmt.setString(5, historique.getRaison());
                    pstmt.addBatch();
                }
                
                int[] results = pstmt.executeBatch();
                
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    int i = 0;
                    while (rs.next() && i < historiques.size()) {
                        historiques.get(i).setIdHistorique(rs.getInt(1));
                        i++;
                    }
                }
                
                conn.commit();
                
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }
    
    public List<HistoriquePrix> getHistoriqueParProduit(int idProduit) throws SQLException {
        List<HistoriquePrix> historiques = new ArrayList<>();
        String sql = "SELECT * FROM v_historique_prix_produits WHERE idProduit = ? ORDER BY dateChangement DESC";
        
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, idProduit);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    historiques.add(mapResultSetToHistoriquePrix(rs));
                }
            }
        }
        return historiques;
    }
    

    public List<HistoriquePrix> rechercher(Date dateDebut, Date dateFin, 
            String categorie, String typeProduit) throws SQLException {
        List<HistoriquePrix> historiques = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT * FROM v_historique_prix_produits WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();
        
        if (dateDebut != null) {
            sql.append(" AND dateChangement >= ?");
            params.add(dateDebut);
        }
        if (dateFin != null) {
            sql.append(" AND dateChangement <= ?");
            params.add(dateFin);
        }
        if (categorie != null && !categorie.isEmpty()) {
            sql.append(" AND categorie = ?");
            params.add(categorie);
        }
        if (typeProduit != null && !typeProduit.isEmpty()) {
            sql.append(" AND type_produit = ?");
            params.add(typeProduit);
        }
        
        sql.append(" ORDER BY dateChangement DESC");
        
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    historiques.add(mapResultSetToHistoriquePrix(rs));
                }
            }
        }
        return historiques;
    }

    private HistoriquePrix mapResultSetToHistoriquePrix(ResultSet rs) throws SQLException {
        HistoriquePrix historique = new HistoriquePrix();
        historique.setIdHistorique(rs.getInt("idHistorique"));
        
        Produits produit = new Produits();
        produit.setIdProduit(rs.getInt("idProduit"));
        produit.setNomProduit(rs.getString("nomProduit"));
        
        TypeProduit type = new TypeProduit();
        type.setNomType(rs.getString("type_produit"));
        produit.setTypeProduit(type);
        
        Categorie categorie = new Categorie();
        categorie.setNomCategorie(rs.getString("categorie"));
        produit.setCategorie(categorie);
        
        historique.setProduit(produit);
        historique.setAncienPrix(rs.getDouble("ancienPrix"));
        historique.setNouveauPrix(rs.getDouble("nouveauPrix"));
        historique.setDateChangement(rs.getDate("dateChangement"));
        historique.setRaison(rs.getString("raison"));
        
        Stock stock = new Stock();
        stock.setReste(rs.getInt("stock_disponible"));
        Unites Unites = new Unites();
        Unites.setNomUnite(rs.getString("Unites"));
        stock.setUnite(Unites);
        historique.setStock(stock);
        
        return historique;
    }
}