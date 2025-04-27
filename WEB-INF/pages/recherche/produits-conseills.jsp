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
                <i class="fas fa-search me-2"></i>Filtrage Historique produits
            </h2>
            <form id="searchForm">
                <div class="row">
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="typeProduit">Type Produits :</label>
                            <select class="form-control" id="typeProduit" name="typeProduit">
                                <option value="">Tous les types</option>
                                <% for (TypeProduit type : typesProduits) { %>
                                    <option value="<%= type.getNomType()  %>"><%= type.getNomType() %></option>
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
                                    <option value="<%= categorie.getNomCategorie() %>"><%= categorie.getNomCategorie() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
            
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="annee">Année :</label>
                            <select class="form-control" id="annee" name="annee">
                                <option value="">Toutes les années</option>
                                <option value="2022">2022</option>
                                <option value="2023">2023</option>
                                <option value="2024">2024</option>
                            </select>
                        </div>
                    </div>
            
                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="mois">Mois :</label>
                            <select class="form-control" id="mois" name="mois">
                                <option value="">Tous les mois</option>
                                <option value="01">Janvier</option>
                                <option value="02">Février</option>
                                <option value="03">Mars</option>
                                <option value="04">Avril</option>
                                <option value="05">Mai</option>
                                <option value="06">Juin</option>
                                <option value="07">Juillet</option>
                                <option value="08">Août</option>
                                <option value="09">Septembre</option>
                                <option value="10">Octobre</option>
                                <option value="11">Novembre</option>
                                <option value="12">Décembre</option>
                            </select>
                        </div>
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
                        <th>Produits</th>
                        <th>Type Produit</th>
                        <th>Catégorie Produit</th>
                        <th>Prix Unitaire</th>
                        <th>Description</th>
                        <th>Raison</th>
                        <th>Mois</th>
                        <th>Stock</th>
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
                    url: 'RechercheProduitsConseills',  
                    method: 'POST',
                    data: {
                        annee: $('#annee').val(), 
                        mois: $('#mois').val(),
                        categorie: $('#categorie').val(),
                        typeProduit: $('#typeProduit').val()
                    },
                        success: function(data) {
                        displayResults(data); 
                    },
                    error: function(xhr, status, error) {
                        alert('Erreur lors de la recherche: ' + error); 
                    }
                });
            }
    
            function displayResults(produitsConseilles) {
            var tbody = $('#resultsTable tbody');
            tbody.empty();

            produitsConseilles.forEach(function(produitConseilles) {
                var row = $('<tr>');
                row.append($('<td>').text(produitConseilles.produits.nomProduit));
                row.append($('<td>').text(produitConseilles.produits.typeProduit.nomType));
                row.append($('<td>').text(produitConseilles.produits.categorie.nomCategorie));
                row.append($('<td>').text(formatPrice(produitConseilles.produits.prixUnitaire)));
                row.append($('<td>').text(produitConseilles.description));
                row.append($('<td>').text(produitConseilles.raison));
                row.append($('<td>').text(produitConseilles.moisConseil));
                    
                var stockText = produitConseilles.stock.reste + ' ' + (produitConseilles.stock.unite || '');
                row.append($('<td>').text(stockText));

                tbody.append(row);
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
