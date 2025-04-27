package servlet;

import java.io.IOException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import dao.VentesDAO;
import models.Categorie;
import models.Client;
import models.Produits;
import models.TypeProduit;
import models.Ventes;


public class  RechercheVentesClientServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String pageContent = "/WEB-INF/pages/recherche/ventes-client.jsp"; 
        request.setAttribute("pageContent", pageContent); 

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
        
    }
    
   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String typeProduit = request.getParameter("typeProduit");
        String categorie = request.getParameter("categorie");
        String date = request.getParameter("date");

        try {
            VentesDAO ventesDAO = new VentesDAO();
            

            typeProduit = (typeProduit != null && !typeProduit.trim().isEmpty()) ? typeProduit : null;
            categorie = (categorie != null && !categorie.trim().isEmpty()) ? categorie : null;
            date = (date != null && !date.trim().isEmpty()) ? date : null;

            System.out.println("Paramètres reçus - Type: " + typeProduit + ", Catégorie: " + categorie + ", Date: " + date);


            List<Ventes> ventes = ventesDAO.getVentes(typeProduit, categorie, date);
            List<Map<String, Object>> resultats = new ArrayList<>();

            for (Ventes vente : ventes) {
                Map<String, Object> venteMap = new HashMap<>();

                Client client = vente.getClient();
                if (client != null) {
                    venteMap.put("nomClient", client.getNom() + " " + client.getPrenom());
                } else {
                    venteMap.put("nomClient", "Client inconnu");
                }

                Produits produit = vente.getProduits();
                if (produit != null) {
                    venteMap.put("nomProduit", produit.getNomProduit());

                    TypeProduit typeProd = produit.getTypeProduit();
                    venteMap.put("typeProduit", typeProd != null ? typeProd.getNomType() : "");

                    Categorie cat = produit.getCategorie();
                    venteMap.put("categorieProduit", cat != null ? cat.getNomCategorie() : "");
                } else {
                    venteMap.put("nomProduit", "Produit inconnu");
                    venteMap.put("typeProduit", "");
                    venteMap.put("categorieProduit", "");
                }

                venteMap.put("quantite", vente.getQuantite());
                venteMap.put("dateVente",vente.getDateVente());
                venteMap.put("prixTotal", vente.getPrixTotal());

                resultats.add(venteMap);
            }

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            

            String json = new Gson().toJson(resultats);
            response.getWriter().write(json);

        } catch (Exception e) {
    
            System.err.println("Erreur lors du traitement de la requête: " + e.getMessage());
            e.printStackTrace();
            

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            Map<String, String> errorResponse = new HashMap<>();
            errorResponse.put("error", "Une erreur est survenue lors de la récupération des ventes: " + e.getMessage());
            response.getWriter().write(new Gson().toJson(errorResponse));
        }
    }

}