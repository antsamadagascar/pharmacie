package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Unites;
import utils.connection.PostgresConnection;

public class UniteDAO {
    public List<Unites> getAllUnites() {
        List<Unites> Unites = new ArrayList<>();
        String query = "SELECT * FROM Unites";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Unites Unite = new Unites();
                Unite.setIdUnite(resultSet.getInt("idUnite"));
                Unite.setNomUnite(resultSet.getString("nomUnite"));
                Unites.add(Unite);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des listes des Unites : " + e.getMessage());
        }

        return Unites;
    }

    
public Unites getById(int id) {
    String query = "SELECT * FROM Unites WHERE idUnites = ?";
    try (Connection connection = PostgresConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(query)) {
        statement.setInt(1, id);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return new Unites(rs.getInt("idUnite"), rs.getString("nomUnite"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Erreur lors de la récupération de Unites : " + e.getMessage());
    }
    return null;
}

public int insertMultipleUnites(List<Unites> Unites) {
    String query = "INSERT INTO Unites (nomUnite) VALUES (?)";
    int insertedCount = 0;

    try (Connection connection = PostgresConnection.getConnection()) {
        connection.setAutoCommit(false); 

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            for (Unites Unite : Unites) {
                if (Unite.getNomUnite() == null) {
                    throw new IllegalArgumentException("Nom Unite manquant ");
                }

                statement.setString(1, Unite.getNomUnite());

                statement.addBatch();
                insertedCount++;
            }

            statement.executeBatch();
            connection.commit(); 

        } catch (SQLException e) {
            connection.rollback(); 
            System.err.println("Erreur lors de l'insertion multiple des Unites : " + e.getMessage());
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


    public static void main(String[] args) {
        UniteDAO dao = new UniteDAO();
        System.out.println("Liste des Unites :");
        List<Unites> Unites = dao.getAllUnites();
        for (Unites Unite : Unites) {
            System.out.println("ID: " + Unite.getIdUnite() +
                               ", Nom: " + Unite.getNomUnite());
        }

    }
}
