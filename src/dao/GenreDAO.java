package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import models.Client;
import models.Genre;
import utils.connection.PostgresConnection;

public class GenreDAO {
     public List<Genre> getAllGenres() {
        List<Genre> Genres = new ArrayList<>();
        String query = "SELECT * FROM Genres";

        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                Genre Genre = new Genre();
                Genre.setIdGenre(resultSet.getInt("idGenre"));
                Genre.setNomGenre(resultSet.getString("nomGenre"));
                Genres.add(Genre);
            }

        } catch (SQLException e) {
            System.err.println("Erreur lors de la récupération des listes des Genres : " + e.getMessage());
        }

        return Genres;
    }

    public Genre getById(int id) {
    String query = "SELECT * FROM Genres WHERE idGenre = ?";
    try (Connection connection = PostgresConnection.getConnection();
         PreparedStatement statement = connection.prepareStatement(query)) {
        statement.setInt(1, id);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                return new Genre(rs.getInt("idGenre"), rs.getString("nomGenre"));
            }
        }
    } catch (SQLException e) {
        System.err.println("Erreur lors de la récupération de Genre : " + e.getMessage());
    }
    return null;
}


    public static void main(String[] args) {
        GenreDAO dao = new GenreDAO();
        System.out.println("Liste des catégories :");
        List<Genre> genres = dao.getAllGenres();
        for (Genre genre : genres) {
            System.out.println("ID: " + genre.getIdGenre() +
                         
                               ", Nom: " + genre.getNomGenre());
        }

    }

}
