package servlet;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import dao.VentesDAO;
import models.Ventes;
import utils.SqlDateAdapter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;

public class InsertionVentesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/vente/insertion-vente.jsp"; 
        request.setAttribute("pageContent", pageContent); 
        RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonVentes = sb.toString();

            System.out.println("JSON reçu : " + jsonVentes);

            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(java.sql.Date.class, new SqlDateAdapter())
                    .create();

            Type listType = new TypeToken<List<Ventes>>() {}.getType();
            List<Ventes> ventes = gson.fromJson(jsonVentes, listType);

            VentesDAO venteDAO = new VentesDAO();
            venteDAO.insertMultipleVentes(ventes);

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } catch (Exception e) {

            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

}
