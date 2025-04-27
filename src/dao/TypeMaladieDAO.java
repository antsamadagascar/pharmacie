package dao;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.TypeMaladie;
import utils.connection.PostgresConnection;

public class TypeMaladieDAO {
    public List<TypeMaladie> getAll() {
        List<TypeMaladie> typeMaladies = new ArrayList<>();
        String query = "SELECT * FROM typesMaladies";

        try (Connection connection = PostgresConnection.getConnection(); 
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            while (resultSet.next()) {
                int idTypeMaladie = resultSet.getInt("idTypeMaladie");
                String nomMaladie = resultSet.getString("nomMaladie");
                String description = resultSet.getString("description");

                TypeMaladie typeMaladie = new TypeMaladie(idTypeMaladie, nomMaladie, description);
                typeMaladies.add(typeMaladie);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return typeMaladies;
    }
    public static void main(String[] args) {
        TypeMaladieDAO dao = new TypeMaladieDAO();
        List<TypeMaladie> maladies = dao.getAll();

        for (TypeMaladie maladie : maladies) {
            System.out.println(maladie);
        }
    }
   
}
