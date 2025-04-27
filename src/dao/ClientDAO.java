package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Client;
import utils.connection.PostgresConnection;

public class ClientDAO {

    public List<Client> getAllClients() {
        List<Client> clients = new ArrayList<>();
        String query = "SELECT * FROM Clients";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Client client = new Client();
                client.setIdClient(resultSet.getInt("idClient"));
                client.setNom(resultSet.getString("nom"));
                client.setPrenom(resultSet.getString("prenom"));
                clients.add(client);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des listes des clients : " + e.getMessage());
        }

        return clients;
    }

    
public Client getById(int id) {
    String query = "SELECT * FROM Clients WHERE idClient = ?";
    try (Connection connection = PostgresConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(query)) {
        statement.setInt(1, id);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return new Client(rs.getInt("idClient"), rs.getString("nom"),rs.getString("prenom"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Erreur lors de la récupération de Clients : " + e.getMessage());
    }
    return null;
}

public int insertMultipleClients(List<Client> clients) {
    String query = "INSERT INTO Clients (nom, prenom) VALUES (?, ?)";
    int insertedCount = 0;

    try (Connection connection = PostgresConnection.getConnection()) {
        connection.setAutoCommit(false); 

        try (PreparedStatement statement = connection.prepareStatement(query)) {
            for (Client client : clients) {
                if (client.getNom() == null || client.getPrenom() == null) {
                    throw new IllegalArgumentException("Nom ou prénom manquant pour un client.");
                }

                statement.setString(1, client.getNom());
                statement.setString(2, client.getPrenom());

                statement.addBatch();
                insertedCount++;
            }


            statement.executeBatch();
            connection.commit(); 

        } catch (SQLException e) {
            connection.rollback(); 
            System.err.println("Erreur lors de l'insertion multiple des clients : " + e.getMessage());
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
        ClientDAO dao = new ClientDAO();
        System.out.println("Liste des catégories :");
        List<Client> clients = dao.getAllClients();
        for (Client client : clients) {
            System.out.println("ID: " + client.getIdClient() +
                                "Prenom:" +client.getPrenom() +
                               ", Nom: " + client.getNom());
        }

    }
    
}
