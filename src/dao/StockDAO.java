package dao;

import models.Stock;
import models.MouvementStock;
import models.Produits;
import models.Unites;
import utils.connection.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StockDAO {

    public List<Stock> getAllStock() throws SQLException {
        String query = "SELECT s.idStock, s.dateMisAjour, s.quantite, s.entree, s.sortie, " +
                       "s.reste, p.idProduit, p.nomProduit, u.idUnite, u.nomUnite " +
                       "FROM stocks s " +
                       "JOIN produits p ON s.idProduit = p.idProduit " +
                       "JOIN unites u ON s.idUnite = u.idUnite";

        List<Stock> stocks = new ArrayList<>();

        try (Connection connection = PostgresConnection.getConnection();
             Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                Stock stock = new Stock();
                stock.setIdStock(rs.getInt("idStock"));
                stock.setDateMisAjour(rs.getTimestamp("dateMisAjour"));
                stock.setQuantite(rs.getInt("quantite"));
                stock.setEntree(rs.getInt("entree"));
                stock.setSortie(rs.getInt("sortie"));
                stock.setReste(rs.getInt("reste"));

                Produits produit = new Produits();
                produit.setIdProduit(rs.getInt("idProduit"));
                produit.setNomProduit(rs.getString("nomProduit"));
                stock.setProduit(produit);

                Unites unite = new Unites();
                unite.setIdUnite(rs.getInt("idUnite"));
                unite.setNomUnite(rs.getString("nomUnite"));
                stock.setUnite(unite);

                stocks.add(stock);
            }
        }
        return stocks;
    }

    public void insertMultipleStock(List<Stock> stocks) throws SQLException {
        String query = "INSERT INTO stocks (idProduit, dateMisAjour, quantite, entree, sortie, idUnite) " +
                       "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            for (Stock stock : stocks) {
                stmt.setInt(1, stock.getProduit().getIdProduit());
                stmt.setTimestamp(2, stock.getDateMisAjour());
                stmt.setInt(3, stock.getQuantite());
                stmt.setInt(4, stock.getEntree());
                stmt.setInt(5, stock.getSortie());
                stmt.setInt(6, stock.getUnite().getIdUnite());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public void insertMultipleMouvementStock(List<MouvementStock> mouvements) throws SQLException {
        String query = "INSERT INTO stock_movements (idProduit, type_mouvement, quantite, date_mouvement) " +
                       "VALUES (?, ?, ?, ?)";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query)) {

            for (MouvementStock mouvement : mouvements) {
                stmt.setInt(1, mouvement.getProduits().getIdProduit());
                stmt.setString(2, mouvement.getTypeMouvement());
                stmt.setInt(3, mouvement.getQuantite());
                stmt.setDate(4, mouvement.getDateMouvement());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public List<MouvementStock> getAllHistorique() throws SQLException {
        String query = "SELECT sm.id, sm.type_mouvement, sm.quantite, sm.date_mouvement, " +
                       "p.idProduit, p.nomProduit " +
                       "FROM stock_movements sm " +
                       "JOIN produits p ON sm.idProduit = p.idProduit";

        List<MouvementStock> historique = new ArrayList<>();

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                MouvementStock mouvement = new MouvementStock();
                mouvement.setIdMouvement(rs.getInt("id"));
                mouvement.setTypeMouvement(rs.getString("type_mouvement"));
                mouvement.setQuantite(rs.getInt("quantite"));
                mouvement.setDateMouvement(rs.getDate("date_mouvement"));

                Produits produit = new Produits();
                produit.setIdProduit(rs.getInt("idProduit"));
                produit.setNomProduit(rs.getString("nomProduit"));
                mouvement.setProduits(produit);

                historique.add(mouvement);
            }
        }

        return historique;
    }
}
