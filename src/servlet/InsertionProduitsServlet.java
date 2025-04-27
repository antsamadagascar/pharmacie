package servlet;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.ProduitDAO;
import models.Produits;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.stream.Collectors;

public class InsertionProduitsServlet extends HttpServlet {
    
    private final Gson gson = new Gson();
    private final ProduitDAO produitDAO = new ProduitDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
        
        ProduitDAO produitsDAO = new ProduitDAO();
        List<Produits> produitsList = produitsDAO.getAllProduits();

        String produitsJson = "[]";
        if (produitsList != null && !produitsList.isEmpty()) {
            produitsJson = new Gson().toJson(produitsList);
        }
    
        request.setAttribute("produitsJson", produitsJson);
        
        String pageContent = "/WEB-INF/pages/produits/insertion-produits.jsp";
        request.setAttribute("pageContent", pageContent);
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String json = request.getReader().lines().collect(Collectors.joining());
            Type listType = new TypeToken<List<Produits>>() {}.getType();
            List<Produits> produits = new Gson().fromJson(json, listType);

            for (Produits produit : produits) {
                if (produit.getTypeProduit() == null || produit.getTypeProduit().getIdTypeProduit() <= 0) {
                    System.out.println("ty pory:" + produit.getTypeProduit());
                    throw new IllegalArgumentException("ID TypeProduit invalide ou manquant.");
                
                }
                if (produit.getCategorie() == null || produit.getCategorie().getIdCategorie() <= 0) {
                    System.out.println("id categorie:" +produit.getCategorie().getIdCategorie());
                    throw new IllegalArgumentException("ID Categorie invalide ou manquant.");
                }
                if (produit.getNomProduit() == null || produit.getNomProduit().isEmpty()) {
                    throw new IllegalArgumentException("Nom du produit manquant.");
                }
                if (produit.getPrixUnitaire() <= 0) {
                    throw new IllegalArgumentException("Prix unitaire invalide.");
                }
            }

            int count = produitDAO.insertMultiple(produits);
            response.setContentType("application/json"); 
            response.setCharacterEncoding("UTF-8");
            if (count > 0) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Produits enregistrés avec succès !");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Aucun produit n'a été enregistré.");
            }

        } catch (Exception e) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

}
