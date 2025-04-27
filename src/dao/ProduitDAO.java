package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Categorie;
import models.Produits;
import models.ProduitsConseilles;
import models.TypeProduit;
import utils.connection.PostgresConnection;

public class ProduitDAO {
    
    public int insertMultiple(List<Produits> produits) {
        String query = "INSERT INTO Produits (idTypeProduit, idCategorie, nomProduit, prixUnitaire) " +
                      "VALUES (?, ?, ?, ?)";
        int insertedCount = 0;
    
        try (Connection connection = PostgresConnection.getConnection()) {
            connection.setAutoCommit(false);
    
            try (PreparedStatement statement = connection.prepareStatement(query)) {
                for (Produits produit : produits) {
                    if (produit.getTypeProduit() == null || produit.getTypeProduit().getIdTypeProduit() == 0) {
                        throw new IllegalArgumentException("TypeProduit est invalide pour un produit.");
                    }
                    if (produit.getCategorie() == null || produit.getCategorie().getIdCategorie() == 0) {
                        throw new IllegalArgumentException("Categorie est invalide pour un produit.");
                    }
                    if (produit.getNomProduit() == null || produit.getNomProduit().isEmpty()) {
                        throw new IllegalArgumentException("NomProduit est manquant.");
                    }
                    if (produit.getPrixUnitaire() <= 0) {
                        throw new IllegalArgumentException("PrixUnitaire doit être supérieur à 0.");
                    }
                    System.out.println("Produit : " + produit.getNomProduit() +
                   ", TypeProduit: " + produit.getTypeProduit() +
                   ", Categorie: " + produit.getCategorie());
                    

                    statement.setInt(1, produit.getTypeProduit().getIdTypeProduit());
                    statement.setInt(2, produit.getCategorie().getIdCategorie());
                    statement.setString(3, produit.getNomProduit());
                    statement.setDouble(4, produit.getPrixUnitaire());
    
                    statement.addBatch();
                    insertedCount++;
                }
    
                statement.executeBatch();
                connection.commit();
    
            } catch (SQLException e) {
                connection.rollback();
                System.err.println("Erreur lors de l'insertion multiple des produits : " + e.getMessage());
                return 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur de connexion : " + e.getMessage());
            return 0;
        } catch (IllegalArgumentException e) {
            System.err.println("Erreur de validation : " + e.getMessage());
            return 0;
        }
    
        return insertedCount;
    }

    public List<Produits> getAllProduits() {
        String query = "SELECT p.idProduit, tp.idTypeProduit, tp.nomType, c.idCategorie, c.nomCategorie, " +
                       "p.nomProduit, p.prixUnitaire " +
                       "FROM produits p " +
                       "JOIN TypeProduit tp ON p.idTypeProduit = tp.idTypeProduit " +
                       "JOIN Categories c ON p.idCategorie = c.idCategorie";

        List<Produits> produitsList = new ArrayList<>();

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Produits produit = new Produits();
                produit.setIdProduit(resultSet.getInt("idProduit"));

                TypeProduit typeProduit = new TypeProduit();
                typeProduit.setIdTypeProduit(resultSet.getInt("idTypeProduit"));
                typeProduit.setNomType(resultSet.getString("nomType"));
                produit.setTypeProduit(typeProduit);

                Categorie categorie = new Categorie();
                categorie.setIdCategorie(resultSet.getInt("idCategorie"));
                categorie.setNomCategorie(resultSet.getString("nomCategorie"));
                produit.setCategorie(categorie);

                produit.setNomProduit(resultSet.getString("nomProduit"));
                produit.setPrixUnitaire(resultSet.getDouble("prixUnitaire"));

                produitsList.add(produit);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des produits : " + e.getMessage());
        }

        return produitsList;
    }


    public int insertMultipleProduitsConseilles(List<ProduitsConseilles> produitsConseilles) {
        String query = "INSERT INTO ProduitsConseilles (idProduit, moisConseil, description, raison) " +
                       "VALUES (?, ?, ?, ?)";
        int insertedCount = 0;
        
        try (Connection connection = PostgresConnection.getConnection()) {
            connection.setAutoCommit(false);

            try (PreparedStatement statement = connection.prepareStatement(query)) {
                for (ProduitsConseilles produitConseille : produitsConseilles) {
                    if (produitConseille.getProduits() == null || produitConseille.getProduits().getIdProduit() == 0) {
                        throw new IllegalArgumentException("Produit est invalide pour l'insertion.");
                    }
    
                    if (produitConseille.getMoisConseil() == null )  {

                        throw new IllegalArgumentException("MoisConseil est manquant.");
                    }
                    if (produitConseille.getDescription() == null || produitConseille.getDescription().isEmpty()) {
                        throw new IllegalArgumentException("Description est manquante.");
                    }
                    if (produitConseille.getRaison() == null || produitConseille.getRaison().isEmpty()) {
                        throw new IllegalArgumentException("Raison est manquante.");
                    }

                    statement.setInt(1, produitConseille.getProduits().getIdProduit());
                    statement.setDate(2, produitConseille.getMoisConseil());
                    statement.setString(3, produitConseille.getDescription());
                    statement.setString(4, produitConseille.getRaison());

                    statement.addBatch(); 
                    insertedCount++;
                }

                statement.executeBatch(); 
                connection.commit(); 

            } catch (SQLException e) {
                connection.rollback();
                System.err.println("Erreur lors de l'insertion multiple des produits conseillés : " + e.getMessage());
                return 0;
            }
        } catch (SQLException e) {
            System.err.println("Erreur de connexion : " + e.getMessage());
            return 0;
        } catch (IllegalArgumentException e) {
            System.err.println("Erreur de validation : " + e.getMessage());
            return 0;
        }

        return insertedCount; 
    }
}

