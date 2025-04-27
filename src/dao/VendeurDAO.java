package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import models.Vendeur;
import models.Vendeur;
import utils.connection.PostgresConnection;

public class VendeurDAO {
    public List<Vendeur> getAllVendeurs() {
        List<Vendeur> Vendeurs = new ArrayList<>();
        String query = "SELECT * FROM vendeur";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Vendeur Vendeur = new Vendeur();
                Vendeur.setIdVendeur(resultSet.getInt("idVendeur"));
                Vendeur.setNom(resultSet.getString("nom"));
                Vendeur.setPrenom(resultSet.getString("prenom"));
                Vendeurs.add(Vendeur);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des listes des Vendeurs : " + e.getMessage());
        }

        return Vendeurs;
    }
    
  

    public static void main(String[] args) {
        VendeurDAO dao = new VendeurDAO();
        System.out.println("Liste des catégories :");
        List<Vendeur> Vendeurs = dao.getAllVendeurs();
        for (Vendeur Vendeur : Vendeurs) {
            System.out.println("ID: " + Vendeur.getIdVendeur() +
                                "Prenom:" +Vendeur.getPrenom() +
                               ", Nom: " + Vendeur.getNom());
        }

    }
}
