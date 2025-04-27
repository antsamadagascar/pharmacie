package dao;

import models.TypeAdministration;
import utils.connection.PostgresConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class TypeAdministrationDAO {
    public List<TypeAdministration> getAll() {
        List<TypeAdministration> types = new ArrayList<>();
        String query = "SELECT idTypeAdmin, nomType, description FROM typesAdministration";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                types.add(new TypeAdministration(
                    rs.getInt("idTypeAdmin"),
                    rs.getString("nomType"),
                    rs.getString("description")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return types;
    }
}
