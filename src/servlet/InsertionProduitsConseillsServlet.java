package servlet;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import dao.ProduitDAO;
import models.ProduitsConseilles;
import utils.SqlDateAdapter;


public class InsertionProduitsConseillsServlet extends HttpServlet {
    Gson gson = new GsonBuilder()
    .registerTypeAdapter(Date.class, new SqlDateAdapter())
    .create();

    private final ProduitDAO produitDAO = new ProduitDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/produits/insertion-produits-conseills.jsp"; 
        request.setAttribute("pageContent", pageContent); 
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String json = request.getReader().lines().collect(Collectors.joining());
        System.out.println("Données reçues : " + json);
        Type listType = new TypeToken<List<ProduitsConseilles>>() {}.getType();
        
        List<ProduitsConseilles> produitsConseilles = gson.fromJson(json, listType);
        System.out.println("DateConseil dans les données : " + produitsConseilles.get(0).getMoisConseil());


        int insertedCount = produitDAO.insertMultipleProduitsConseilles(produitsConseilles);

        if (insertedCount > 0) {
            response.setContentType("application/xml");
            response.setStatus(HttpServletResponse.SC_OK);

            response.getWriter().write("{\"success\": true, \"message\": \"Produits conseillés enregistrés avec succès!\"}");
        } else {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Erreur lors de l'enregistrement des produits conseillés.\"}");
        }
    }

}
