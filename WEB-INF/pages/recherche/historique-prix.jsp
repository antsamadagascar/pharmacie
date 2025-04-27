<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Historique des Prix</title>
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
                <i class="fas fa-history me-2"></i>Historique des Prix
            </h2>
            <form id="searchForm">
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label for="typeProduit">Type Produits :</label>
                            <select class="form-control" id="typeProduit" name="typeProduit">
                                <option value="">Tous les types</option>
                                <% for (TypeProduit type : typesProduits) { %>
                                    <option value="<%= type.getNomType() %>"><%= type.getNomType() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>

                    <div class="col-md-3">
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
                            <label for="dateDebut">Date début :</label>
                            <input type="date" class="form-control" id="dateDebut" name="dateDebut">
                        </div>
                    </div>

                    <div class="col-md-2">
                        <div class="form-group">
                            <label for="dateFin">Date fin :</label>
                            <input type="date" class="form-control" id="dateFin" name="dateFin">
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

        <div class="results-container mt-4">
            <table class="table table-striped" id="resultsTable">
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Type</th>
                        <th>Catégorie</th>
                        <th>Ancien Prix</th>
                        <th>Nouveau Prix</th>
                        <th>Variation</th>
                        <th>Date Changement</th>
                        <th>Raison</th>
                    
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#searchForm').on('submit', function(e) {
                e.preventDefault();
                searchPriceHistory();
            });

            function searchPriceHistory() {
                $.ajax({
                    url: 'RecherchePrixProduits',
                    method: 'POST',
                    data: {
                        dateDebut: $('#dateDebut').val(),
                        dateFin: $('#dateFin').val(),
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

            function displayResults(historiquePrix) {
                var tbody = $('#resultsTable tbody');
                tbody.empty();

                historiquePrix.forEach(function(historique) {
                    var row = $('<tr>');
                    row.append($('<td>').text(historique.produit.nomProduit));
                    row.append($('<td>').text(historique.produit.typeProduit.nomType));
                    row.append($('<td>').text(historique.produit.categorie.nomCategorie));
                    row.append($('<td>').text(formatPrice(historique.ancienPrix)));
                    row.append($('<td>').text(formatPrice(historique.nouveauPrix)));
                    
                    var variation = ((historique.nouveauPrix - historique.ancienPrix) / historique.ancienPrix * 100).toFixed(2);
                    var variationCell = $('<td>').text(variation + '%');
                    variationCell.addClass(variation > 0 ? 'text-danger' : 'text-success');
                    row.append(variationCell);
                    
                    row.append($('<td>').text(new Date(historique.dateChangement).toLocaleDateString()));
                    row.append($('<td>').text(historique.raison || '-'));
                    
                  //  var stockText = historique.stock ? 
                //        historique.stock.reste + ' ' + (historique.stock.unite || '') : '-';
                //    row.append($('<td>').text(stockText));

                    tbody.append(row);
                });
            }

            function formatPrice(price) {
                if (!price) return '0,00 Ar';
                return new Intl.NumberFormat('fr-FR', {
                    style: 'currency',
                    currency: 'MGA',
                    minimumFractionDigits: 2
                }).format(price).replace('MGA', 'Ar');
            }

            searchPriceHistory();
        });
    </script>
</body>
</html>