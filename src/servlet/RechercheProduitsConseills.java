package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date; 
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import models.Categorie;
import models.Produits;
import models.ProduitsConseilles;
import models.Stock;
import models.TypeProduit;
import utils.connection.PostgresConnection;

public class RechercheProduitsConseills extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/recherche/produits-conseills.jsp";
        request.setAttribute("pageContent", pageContent);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Gson gson = new Gson();
    
        String annee = request.getParameter("annee");
        String mois = request.getParameter("mois");
        String categorie = request.getParameter("categorie");
        String typeProduit = request.getParameter("typeProduit");

        List<ProduitsConseilles> produitsConseilles = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM v_produits_conseilles"); 

        boolean firstCondition = true; 

        if (annee != null && !annee.isEmpty()) {
            if (firstCondition) {
                query.append(" WHERE EXTRACT(YEAR FROM moisConseil) = ?");
                firstCondition = false;
            } else {
                query.append(" AND EXTRACT(YEAR FROM moisConseil) = ?");
            }
        }
        if (mois != null && !mois.isEmpty()) {
            if (firstCondition) {
                query.append(" WHERE EXTRACT(MONTH FROM moisConseil) = ?");
                firstCondition = false;
            } else {
                query.append(" AND EXTRACT(MONTH FROM moisConseil) = ?");
            }
        }
        if (categorie != null && !categorie.isEmpty()) {
            if (firstCondition) {
                query.append(" WHERE categorie = ?");
                firstCondition = false;
            } else {
                query.append(" AND categorie = ?");
            }
        }
        if (typeProduit != null && !typeProduit.isEmpty()) {
            if (firstCondition) {
                query.append(" WHERE type_produit = ?");
                firstCondition = false;
            } else {
                query.append(" AND type_produit = ?");
            }
        }

        System.out.println("Requête SQL générée : " + query.toString()); 

        try (Connection conn = PostgresConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            int paramIndex = 1;

            if (annee != null && !annee.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(annee));  
            }
            if (mois != null && !mois.isEmpty()) {
                stmt.setInt(paramIndex++, Integer.parseInt(mois));  
            }
            if (categorie != null && !categorie.isEmpty()) {
                stmt.setString(paramIndex++, categorie); 
            }
            if (typeProduit != null && !typeProduit.isEmpty()) {
                stmt.setString(paramIndex++, typeProduit);  
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProduitsConseilles produitConseilles = new ProduitsConseilles();
                    produitConseilles.setIdConseil(rs.getInt("idConseil"));

                    Date moisConseil = rs.getDate("moisConseil");
                    produitConseilles.setMoisConseil(moisConseil);

                    TypeProduit typeProduits = new TypeProduit();
                    typeProduits.setNomType(rs.getString("type_produit"));

                    Categorie categories = new Categorie();
                    categories.setNomCategorie(rs.getString("categorie"));

                    Produits produit = new Produits();
                    produit.setIdProduit(rs.getInt("idProduit"));
                    produit.setNomProduit(rs.getString("nomProduit"));
                    produit.setPrixUnitaire(rs.getDouble("prixUnitaire"));
                    produit.setTypeProduit(typeProduits);
                    produit.setCategorie(categories);

                    produitConseilles.setProduits(produit);
                    produitConseilles.setDescription(rs.getString("description"));
                    produitConseilles.setRaison(rs.getString("raison"));

                    Stock stock = new Stock();
                    stock.setReste(rs.getInt("stock_disponible"));

                    produitConseilles.setStock(stock);
                    produitsConseilles.add(produitConseilles);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Une erreur est survenue lors de la récupération des données.\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        String json = gson.toJson(produitsConseilles);
        response.getWriter().write(json);

    }
       
}


