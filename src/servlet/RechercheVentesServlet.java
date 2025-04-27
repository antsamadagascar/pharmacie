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

import models.Medicament;
import models.Produits;
import models.Categorie;
import models.TypeAdministration;
import models.Ventes;
import models.GroupeAge;
import utils.connection.PostgresConnection;

public class RechercheVentesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/recherche/ventes-medicaments.jsp"; 
        request.setAttribute("pageContent", pageContent); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String typeAdmin = request.getParameter("typeAdmin");
        String groupeAge = request.getParameter("groupeAge");

        List<Ventes> ventes = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM vue_ventes_details WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (typeAdmin != null && !typeAdmin.isEmpty()) {
            query.append(" AND nomType = ?");
            params.add(typeAdmin);
        }
        if (groupeAge != null && !groupeAge.isEmpty()) {
            query.append(" AND nomGroupe = ?");
            params.add(groupeAge);
        }

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {

                    Categorie categorie = new Categorie();
                    categorie.setNomCategorie(rs.getString("nomCategorie"));
                
                    TypeAdministration type = new TypeAdministration();
                    type.setNomType(rs.getString("nomType"));
                
                    GroupeAge groupe = new GroupeAge();
                    groupe.setNomGroupe(rs.getString("nomGroupe"));
                
                    Produits produit = new Produits();
                    produit.setIdProduit(rs.getInt("idProduit"));   
                    produit.setNomProduit(rs.getString("nomProduit"));
                    produit.setPrixUnitaire(rs.getDouble("prixUnitaire"));
                    produit.setCategorie(categorie);
                    Medicament medicament = new Medicament();
                    medicament.setIdMedicament(rs.getInt("idMedicament"));
                    medicament.setTypeAdmin(type);
                    medicament.setGroupeAge(groupe);
                    medicament.setProduit(produit);

                    Ventes vente = new Ventes();
                    vente.setQuantite(rs.getInt("quantite"));
                    vente.setPrixTotal(rs.getBigDecimal("prixTotal"));
                    vente.setDateVente(rs.getDate("dateVente")); 
                    vente.setProduits(produit); 
                    vente.setMedicament(medicament); 

                    ventes.add(vente);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Une erreur est survenue lors de la récupération des données.\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = new Gson().toJson(ventes);
        System.out.println(json); 
        response.getWriter().write(json);
    }
}
