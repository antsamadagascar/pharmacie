package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Categorie;
import models.GroupeAge;
import models.Medicament;
import models.Produits;
import models.TypeAdministration;
import utils.connection.PostgresConnection;

public class MedicamentDAO {

    public List<Medicament> getAll() {
    List<Medicament> medicaments = new ArrayList<>();
    String query = "SELECT p.idProduit, p.nomProduit, c.idCategorie, c.nomCategorie, t.idTypeAdmin, t.nomType, " +
                   "g.idGroupeAge, g.nomGroupe, m.prixUnitaire, p.idProduit, p.nomProduit, p.prixUnitaire, p.idCategorie " +
                   "FROM medicaments m " +
                   "JOIN categoriesMedicaments c ON m.idCategorie = c.idCategorie " +
                   "JOIN typesAdministration t ON m.idTypeAdmin = t.idTypeAdmin " +
                   "JOIN groupesAge g ON m.idGroupeAge = g.idGroupeAge " +
                   "JOIN produits p ON m.idProduit = p.idProduit";

    try (Connection conn = PostgresConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(query);
         ResultSet rs = stmt.executeQuery()) {

        while (rs.next()) {
            // Créer l'objet Categorie
            Categorie categorie = new Categorie();
            categorie.setIdCategorie(rs.getInt("idCategorie"));
            categorie.setNomCategorie(rs.getString("nomCategorie"));

            // Créer l'objet TypeAdministration
            TypeAdministration typeAdmin = new TypeAdministration();
            typeAdmin.setIdTypeAdmin(rs.getInt("idTypeAdmin"));
            typeAdmin.setNomType(rs.getString("nomType"));

            // Créer l'objet GroupeAge
            GroupeAge groupeAge = new GroupeAge();
            groupeAge.setIdGroupeAge(rs.getInt("idGroupeAge"));
            groupeAge.setNomGroupe(rs.getString("nomGroupe"));

            // Créer l'objet Produit
            Produits produit = new Produits();
            produit.setIdProduit(rs.getInt("idProduit"));
            produit.setNomProduit(rs.getString("nomProduit"));
            produit.setPrixUnitaire(rs.getDouble("prixUnitaire"));

            // Associer la catégorie au produit
            Categorie produitCategorie = new Categorie();
            produitCategorie.setIdCategorie(rs.getInt("idCategorie"));
            produit.setCategorie(produitCategorie);

            // Créer l'objet Medicament avec le produit et autres informations
            Medicament medicament = new Medicament(
                    rs.getInt("idMedicament"),
                    typeAdmin,
                    groupeAge,
                    produit 
            );

            medicaments.add(medicament);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return medicaments;
}

}
