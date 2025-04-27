
package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import models.Categorie;
import models.GroupeAge;
import models.Medicament;
import models.Produits;
import models.TypeAdministration;
import models.TypeMaladie;
import utils.connection.PostgresConnection;

public class RechercheMedicamentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String pageContent = "/WEB-INF/pages/recherche/type-medicaments.jsp"; 
        request.setAttribute("pageContent", pageContent); 

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
        
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String typeMaladie = request.getParameter("typeMaladie");
        String groupeAge = request.getParameter("groupeAge");

        List<Medicament> medicaments = new ArrayList<>();
        String query = "SELECT * FROM vue_listes_medicaments"; 

        if (typeMaladie != null && !typeMaladie.isEmpty()) {
            query += " WHERE typeMaladie = ?";
        }
        if (groupeAge != null && !groupeAge.isEmpty()) {
            query += (query.contains("WHERE") ? " AND " : " WHERE ") + "groupeAge = ?";
        }

        try (Connection conn = PostgresConnection.getConnection();
     PreparedStatement stmt = conn.prepareStatement(query)) {

    int paramIndex = 1;
    if (typeMaladie != null && !typeMaladie.isEmpty()) {
        stmt.setString(paramIndex++, typeMaladie);
    }
    if (groupeAge != null && !groupeAge.isEmpty()) {
        stmt.setString(paramIndex++, groupeAge);
    }

    try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            Produits produit = new Produits();
            produit.setIdProduit(rs.getInt("idProduit"));
            produit.setNomProduit(rs.getString("nomProduit"));
            produit.setPrixUnitaire(rs.getDouble("prixUnitaire"));
        
            Categorie categorie = new Categorie();
            categorie.setNomCategorie(rs.getString("nomCategorie"));
            produit.setCategorie(categorie);
        

            Medicament medicament = new Medicament();
            medicament.setIdMedicament(rs.getInt("idMedicament"));
            medicament.setProduit(produit);  

            TypeAdministration typeAdmin = new TypeAdministration();
            typeAdmin.setNomType(rs.getString("typeAdministration"));
            medicament.setTypeAdmin(typeAdmin);
        
            GroupeAge groupe = new GroupeAge();
            groupe.setNomGroupe(rs.getString("groupeAge"));
            medicament.setGroupeAge(groupe);
        
            List<TypeMaladie> listeTypesMaladies = new ArrayList<>();
            String typeMaladieString = rs.getString("typeMaladie"); 
            if (typeMaladieString != null && !typeMaladieString.isEmpty()) {
                String[] nomMaladies = typeMaladieString.split(","); 
                for (String nomMaladie : nomMaladies) {
                    TypeMaladie typeMaladies = new TypeMaladie();
                    typeMaladies.setNomMaladie(nomMaladie.trim()); 
                    listeTypesMaladies.add(typeMaladies); 
                }
            }
            medicament.setTypesMaladies(listeTypesMaladies); 
            medicaments.add(medicament);
        }
        
    }
    } catch (Exception e) {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        response.setContentType("application/json");
        response.getWriter().write("{\"error\":\"Une erreur est survenue lors de la récupération des données.\"}");
        return;
    }

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    String json = new Gson().toJson(medicaments);
    response.getWriter().write(json);
}
        
}
