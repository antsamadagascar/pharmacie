<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Insertion des Stocks</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <style>
        .container {
            margin-top: 100px;
        }
    </style>
</head>
<body>
    <%
        UniteDAO uniteDAO =new UniteDAO();
        List<Unites> unites = uniteDAO.getAllUnites();

        ProduitDAO produitDAO =new ProduitDAO();
        List<Produits> produits =produitDAO.getAllProduits();
    %>
    
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Insertion des Stocks
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addStocksRow">
                        <i class="fas fa-plus me-2"></i>Ajouter une stock
                    </button>
                </div>
                <form id="StocksForm">
                    <div id="StocksContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer toutes les Stocks
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="StocksRowTemplate">
        <div class="row Stocks-row mb-3">
            <div class="col-md-3">
                <select class="form-select" name="idProduit" required>
                    <option value="">Sélectionner un Produit</option>
                    <% for(Produits produit : produits) { %>
                        <option value="<%= produit.getIdProduit() %>" data-prix="<%= produit.getPrixUnitaire() %>">
                            <%= produit.getNomProduit() %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <select class="form-select" name="idUnite" required>
                    <option value="">Sélectionner un unite</option>
                    <% for(Unites u : unites) { %>
                        <option value="<%= u.getIdUnite() %>"><%= u.getNomUnite() %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control quantite" name="quantite" placeholder="Quantité stock" required>
            </div>
            <div class="col-md-2">
                <input type="number" class="form-control entree" name="entree" placeholder="entree de stock" required>
            </div>
            <div class="col-md-3">
                <label for="date" ></label>
                <input type="date" class="form-control date-stock" name="date" required>
            </div>
            <div class="col-md-2 d-flex align-items-center">
                <button type="button" class="btn btn-danger remove-row">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
    </template>
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Liste des Stock
                </h2>
            </div>
            <div class="card-body">

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID Stock</th>
                    <th>Produit</th>
                    <th>Date Iventaires</th>
                    <th>Quantité</th>
                    <th>Entrée</th>
                    <th>Sortie</th>
                    <th>Reste</th>
                    <th>Unité</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="stock" items="${stocks}">
                    <tr>
                        <td>${stock.idStock}</td>
                        <td>${stock.produit.nomProduit}</td>
                        <td>${stock.dateMisAjour}</td>
                        <td>${stock.quantite}</td>
                        <td>${stock.entree}</td>
                        <td>${stock.sortie}</td>
                        <td>${stock.reste}</td>
                        <td>${stock.unite.nomUnite}</td>
                    </tr>
                </c:forEach>
                </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#addStocksRow').click(function() {
                const template = document.getElementById('StocksRowTemplate');
                const clone = template.content.cloneNode(true);
                document.getElementById('StocksContainer').appendChild(clone);
            });

            $(document).on('click', '.remove-row', function() {
                $(this).closest('.Stocks-row').remove();
            });


            $('#StocksForm').on('submit', function(e) {
            e.preventDefault();

            const Stocks = [];
            $('.Stocks-row').each(function() {
                const row = $(this);
                const idUnite = parseInt(row.find('[name="idUnite"]').val());
                const idProduit = parseInt(row.find('[name="idProduit"]').val());
                const quantite = parseInt(row.find('[name="quantite"]').val());
                const datestock = row.find('[name="date"]').val();

                if (isNaN(idProduit) || !idProduit) {
                    alert('Veuillez sélectionner un produit');
                    return;
                }
                if (isNaN(idUnite) || !idUnite) {
                    alert('Veuillez sélectionner une unité');
                    return;
                }
                if (isNaN(quantite) || quantite <= 0) {
                    alert('La quantité doit être un nombre positif');
                    return;
                }
                if (!datestock) {
                    alert('La date est requise');
                    return;
                }

                Stocks.push({
                produit: {  // Changed from produits to produit to match model
                    idProduit: idProduit
                },
                unite: {    // Changed from unites to unite to match model
                    idUnite: idUnite,
                    nomUnite: row.find('[name="idUnite"] option:selected').text()
                },
                quantite: quantite,      // Changed from quantitestock to match model
                dateMisAjour: datestock, // Changed from datestock to match model
                entree: parseInt(row.find('[name="entree"]').val()) // Added entree field
            });
        });

            if (Stocks.length === 0) {
                alert('Veuillez ajouter au moins un stock');
                return;
            }

            console.log('Données envoyées:', JSON.stringify(Stocks));  

            $.ajax({
                url: 'etatStock',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(Stocks),
                success: function(response) {
                    alert('Stocks enregistrés avec succès');
                    $('#StocksContainer').empty();
                    $('#addStocksRow').click(); 
                },
                error: function(xhr, status, error) {
                    alert('Erreur lors de l\'enregistrement: ' + xhr.responseText);
                }
            });
        });

            $('#addStocksRow').click();
        });
    </script>
</body>
</html>
