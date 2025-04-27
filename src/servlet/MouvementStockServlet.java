package servlet;

import java.io.IOException;
import java.lang.reflect.Type;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import dao.StockDAO;
import models.MouvementStock;
import models.Stock;
import utils.SqlDateAdapter;
import utils.connection.PostgresConnection;

public class MouvementStockServlet  extends HttpServlet{
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection connection = PostgresConnection.getConnection()) {
            StockDAO stockDAO = new StockDAO();
            List<MouvementStock> stocks = stockDAO.getAllHistorique();

            request.setAttribute("MouvementStocks", stocks);
            String pageContent = "/WEB-INF/pages/stocks/mouvement-stock.jsp";
            request.setAttribute("pageContent", pageContent);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/WEB-INF/views/template.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Erreur lors de la récupération des stocks", e);
        }
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonStock = sb.toString();
            System.out.println("JSON reçu : " + jsonStock);
            
            Gson gson = new GsonBuilder()
                    .registerTypeAdapter(java.sql.Date.class, new SqlDateAdapter())
                    .setDateFormat("yyyy-MM-dd")
                    .create();
                    
            Type listType = new TypeToken<List<Stock>>() {}.getType();
            List<Stock> stocks = gson.fromJson(jsonStock, listType);
    
            for (Stock stock : stocks) {
                if (stock.getProduit() == null || stock.getUnite() == null) {
                    throw new IllegalArgumentException("Produit and Unite cannot be null");
                }
            }
            
            StockDAO stockDAO = new StockDAO();
            stockDAO.insertMultipleStock(stocks);
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
}
}
