package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import models.*;
import utils.connection.PostgresConnection;

@WebServlet("/RecherchePrixProduits")
public class RecherchePrixProduitsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String pageContent = "/WEB-INF/pages/recherche/historique-prix.jsp";
        request.setAttribute("pageContent", pageContent);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dateDebut = request.getParameter("dateDebut");
        String dateFin = request.getParameter("dateFin");
        String categorie = request.getParameter("categorie");
        String typeProduit = request.getParameter("typeProduit");

        StringBuilder query = new StringBuilder(
            "SELECT * FROM v_historique_prix_produits WHERE 1=1"
        );
        List<Object> params = new ArrayList<>();

        if (dateDebut != null && !dateDebut.isEmpty()) {
            query.append(" AND dateChangement >= ?");
            params.add(Date.valueOf(dateDebut));
        }
        if (dateFin != null && !dateFin.isEmpty()) {
            query.append(" AND dateChangement <= ?");
            params.add(Date.valueOf(dateFin));
        }
        if (categorie != null && !categorie.isEmpty()) {
            query.append(" AND categorie = ?");
            params.add(categorie);
        }
        if (typeProduit != null && !typeProduit.isEmpty()) {
            query.append(" AND type_produit = ?");
            params.add(typeProduit);
        }

        query.append(" ORDER BY dateChangement DESC");

        List<HistoriquePrix> historiquePrix = new ArrayList<>();

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HistoriquePrix historique = new HistoriquePrix();
                    historique.setIdHistorique(rs.getInt("idHistorique"));
                    
                    Produits produit = new Produits();
                    produit.setIdProduit(rs.getInt("idProduit"));
                    produit.setNomProduit(rs.getString("nomProduit"));
                    
                    TypeProduit type = new TypeProduit();
                    type.setNomType(rs.getString("type_produit"));
                    produit.setTypeProduit(type);
                    
                    Categorie cat = new Categorie();
                    cat.setNomCategorie(rs.getString("categorie"));
                    produit.setCategorie(cat);
                    
                    historique.setProduit(produit);
                    historique.setAncienPrix(rs.getDouble("ancienPrix"));
                    historique.setNouveauPrix(rs.getDouble("nouveauPrix"));
                    historique.setDateChangement(rs.getDate("dateChangement"));
                    historique.setRaison(rs.getString("raison"));
                    
                    Stock stock = new Stock();
                    stock.setReste(rs.getInt("stock_disponible"));
                    Unites unite = new Unites();
                    unite.setNomUnite(rs.getString("unite"));
                    stock.setUnite(unite);
                    historique.setStock(stock);
                    
                    historiquePrix.add(historique);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Erreur lors de la récupération des données\"}");
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(historiquePrix, response.getWriter());
    }
}