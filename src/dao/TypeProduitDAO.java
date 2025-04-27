package dao;

import models.TypeProduit;
import utils.connection.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TypeProduitDAO {


    public List<TypeProduit> getAllTypeProduits() {
        List<TypeProduit> typeProduits = new ArrayList<>();
        String query = "SELECT * FROM typeProduit";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                TypeProduit typeProduit = new TypeProduit();
                typeProduit.setIdTypeProduit(resultSet.getInt("idTypeProduit"));
                typeProduit.setNomType(resultSet.getString("nomType"));
                typeProduits.add(typeProduit);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des types de produits : " + e.getMessage());
        }

        return typeProduits;
    }
   
}
