package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import dao.HistoriquePrixDAO;
import models.HistoriquePrix;
import utils.SqlDateAdapter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;

@WebServlet("/insertionHistoriquePrix")
public class InsertionHistoriquePrixServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/produits/insertion-historique-prix.jsp";
        request.setAttribute("pageContent", pageContent);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonHistorique = sb.toString();
            System.out.println("JSON reçu : " + jsonHistorique);

            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(java.sql.Date.class, new SqlDateAdapter())
                    .create();

            Type listType = new TypeToken<List<HistoriquePrix>>(){}.getType();
            List<HistoriquePrix> historiques = gson.fromJson(jsonHistorique, listType);

            HistoriquePrixDAO historiquePrixDAO = new HistoriquePrixDAO();
            historiquePrixDAO.insertMultipleHistoriques(historiques);

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}