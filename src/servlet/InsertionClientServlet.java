package servlet;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import dao.ClientDAO;
import models.Client;

public class InsertionClientServlet extends HttpServlet {
    Gson gson = new Gson();
    private final ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pageContent = "/WEB-INF/pages/clients/insertion-clients.jsp"; 
        request.setAttribute("pageContent", pageContent); 
        request.getRequestDispatcher("/WEB-INF/views/template.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String json = request.getReader().lines().collect(Collectors.joining());
        System.out.println("Données reçues : " + json);
        Type listType = new TypeToken<List<Client>>() {}.getType();
        
        List<Client> Client = gson.fromJson(json, listType);

        int insertedCount = clientDAO.insertMultipleClients(Client);

        if (insertedCount > 0) {
            response.setContentType("application/xml");
            response.setStatus(HttpServletResponse.SC_OK);

            response.getWriter().write("{\"success\": true, \"message\": \"client enregistrés avec succès!\"}");
        } else {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Erreur lors de l'enregistrement des client.\"}");
        }
    }
}
