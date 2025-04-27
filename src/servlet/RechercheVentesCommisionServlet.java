package servlet;

import java.io.IOException;
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

public class RechercheVentesCommisionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pageContent = "/WEB-INF/pages/recherche/liste-ventes-commision.jsp"; 
        request.setAttribute("pageContent", pageContent); 

        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }
    
    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {

    String idVendeur = request.getParameter("idVendeur");
    String dateMin = request.getParameter("dateMin");
    String dateMax = request.getParameter("dateMax");
    String idGenre = request.getParameter("idGenre");

    try {
        VentesDAO ventesDAO = new VentesDAO();
        
        // Validation des paramètres
        idVendeur = (idVendeur != null && !idVendeur.trim().isEmpty()) ? idVendeur : null;
        idGenre = (idGenre != null && !idGenre.trim().isEmpty()) ? idGenre : null;
        dateMin = (dateMin != null && !dateMin.trim().isEmpty()) ? dateMin : null;
        dateMax = (dateMax != null && !dateMax.trim().isEmpty()) ? dateMax : null;

        System.out.println("Paramètres reçus - Vendeur: " + idVendeur + 
                         ", Date Min: " + dateMin + 
                         ", Date Max: " + dateMax);

        // Récupération des résultats
        List<Map<String, Object>> resultats = ventesDAO.getCommissionsVendeurs(idVendeur, dateMin, dateMax,idGenre);

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
        errorResponse.put("error", "Une erreur est survenue: " + e.getMessage());
        response.getWriter().write(new Gson().toJson(errorResponse));
    }
}
}