package dao;

import models.GroupeAge;
import utils.connection.PostgresConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GroupeAgeDAO {
    public List<GroupeAge> getAll() {
        List<GroupeAge> groupes = new ArrayList<>();
        String query = "SELECT * FROM groupesAge";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                groupes.add(new GroupeAge(
                    rs.getInt("idGroupeAge"),
                    rs.getString("nomGroupe"),
                    rs.getInt("ageMin"),
                    rs.getInt("ageMax")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return groupes;
    }
}
