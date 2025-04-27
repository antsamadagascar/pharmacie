<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recherche des Ventes</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/chearch.css" rel="stylesheet">
</head>
<body>
    <%
        CategorieDAO categorieDAO = new CategorieDAO();
        TypeProduitDAO typeProduitDAO = new TypeProduitDAO();
    
        List<Categorie> categories = categorieDAO.getAllCategories();
        List<TypeProduit> typesProduits = typeProduitDAO.getAllTypeProduits();
    %>

    <div class="container">
        <div class="search-container">
            <h2 class="search-title">
                <i class="fas fa-search me-2"></i>Filtrage Listes  Ventes Clients
            </h2>
            <form id="searchForm">
                <div class="row">
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="typeProduit">Type Produits :</label>
                            <select class="form-control" id="typeProduit" name="typeProduit">
                                <option value="">Tous les types</option>
                                <% for (TypeProduit type : typesProduits) { %>
                                    <option value="<%= type.getIdTypeProduit() %>"><%= type.getNomType() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
            
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="categorie">Catégorie :</label>
                            <select class="form-control" id="categorie" name="categorie">
                                <option value="">Toutes les catégories</option>
                                <% for (Categorie categorie : categories) { %>
                                    <option value="<%= categorie.getIdCategorie() %>"><%= categorie.getNomCategorie() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
            
                    <div class="form-group">
                        <label for="date">Date :</label>
                        <input type="date" id="date" name="date" class="form-control">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-search btn-primary w-100">
                            <i class="fas fa-search me-2"></i>Rechercher
                        </button>
                    </div>
                </div>
            </form>
        </div>
        <div class="loading-spinner">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Chargement...</span>
            </div>
        </div>
        <div class="results-container">
            <table class="table table-striped" id="resultsTable">
                <thead>
                    <tr>
                        <th>Client</th>
                        <th>Produits</th>
                        <th>Type Produit</th>
                        <th>Catégorie Produit</th>
                        <th>Quantité</th>
                        <th>Prix Total</th>
                        <th>Date Vente</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
        

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/load.js"></script>
    <script>
        $(document).ready(function() {
    
            $('#searchForm').on('submit', function(e) {
                e.preventDefault();
                searchProductConseills();
            });
    
            function searchProductConseills() {
            $.ajax({
                url: 'RechercheVentesClientServlet',  
                method: 'POST',
                data: {
                    typeProduit: $('#typeProduit').val(),  
                    categorie: $('#categorie').val(),
                    date: $('input[name="date"]').val()
                },
                success: function(data) {
                    displayResults(data); 
                },
                error: function(xhr, status, error) {
                    console.error('Erreur:', error);
                    alert('Erreur lors de la recherche: ' + error); 
                }
            });
        }
    
        function displayResults(ventes) {
            console.log('Données reçues:', ventes);

            var tbody = $('#resultsTable tbody');
            tbody.empty();

            ventes.forEach(function(vente) {
                var row = $('<tr>');
                row.append($('<td>').text(vente.nomClient || ''));
                row.append($('<td>').text(vente.nomProduit || ''));
                row.append($('<td>').text(vente.typeProduit || ''));
                row.append($('<td>').text(vente.categorieProduit || ''));
                row.append($('<td>').text(vente.quantite || '0'));
                row.append($('<td>').text(formatPrice(vente.prixTotal)));  
 
                row.append($('<td>').text(vente.dateVente || ''));
                tbody.append(row);
                console.log('Données reçues:', ventes);

            });
        }



        function searchProductConseills() {
            $.ajax({
                url: 'rechercheVentesClient',  
                method: 'POST',
                data: {
                    typeProduit: $('#typeProduit').val(),  
                    categorie: $('#categorie').val(),
                    date: $('input[name="date"]').val()
                },
                success: function(data) {
                    console.log('Données reçues:', data); 
                    displayResults(data); 
                },
                error: function(xhr, status, error) {
                    console.error('Erreur:', error);
                    alert('Erreur lors de la recherche: ' + error); 
                }
            });
        }
        
        searchProductConseills(); 
    
     });
     function formatPrice(price) {
        if (!price) return '0,00 Ar';
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'MGA',
            minimumFractionDigits: 2
        }).format(price).replace('MGA', 'Ar');
    }

</script> 
</body>
</html>
