package dao;

import models.Categorie;
import utils.connection.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategorieDAO {

    public List<Categorie> getAllCategories() {
        List<Categorie> categories = new ArrayList<>();
        String query = "SELECT * FROM categories";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Categorie categorie = new Categorie();
                categorie.setIdCategorie(resultSet.getInt("idCategorie"));
                categorie.setNomCategorie(resultSet.getString("nomCategorie"));
                categories.add(categorie);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des catégories : " + e.getMessage());
        }

        return categories;
    }

    
public Categorie getById(int id) {
    String query = "SELECT * FROM Categorie WHERE idCategorie = ?";
    try (Connection connection = PostgresConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(query)) {
        statement.setInt(1, id);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return new Categorie(rs.getInt("idCategorie"), rs.getString("nomCategorie"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Erreur lors de la récupération de Categorie : " + e.getMessage());
    }
    return null;
}

    public static void main(String[] args) {
        CategorieDAO dao = new CategorieDAO();
        System.out.println("Liste des catégories :");
        List<Categorie> categories = dao.getAllCategories();
        for (Categorie categorie : categories) {
            System.out.println("ID: " + categorie.getIdCategorie() +
                               ", Nom: " + categorie.getNomCategorie());
        }

    }
}
