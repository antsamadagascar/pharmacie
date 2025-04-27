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
        VendeurDAO VendeurDAO = new VendeurDAO();
        List<Vendeur> vendeurs = VendeurDAO.getAllVendeurs();

        GenreDAO genreDAO = new GenreDAO();
        List<Genre> genres= genreDAO.getAllGenres();
    %>

    <div class="container">
        <div class="search-container">
            <h2 class="search-title">
                <i class="fas fa-search me-2"></i>Filtrage Listes  Ventes Commission
            </h2>
            <form id="searchForm">
                <div class="row">
                        <div class="col-md-3">
                            <select class="form-select" name="idVendeur" >
                                <option value="">Sélectionner un vendeur</option>
                                <% for(Vendeur v : vendeurs) { %>
                                    <option value="<%= v.getIdVendeur() %>"><%= v.getNom() %></option>
                                <% } %>
                            </select>
                        </div>

                        <div class="col-md-3">
                            <select class="form-select" name="idGenre" >
                                <option value="">Sélectionner un Genre</option>
                                <% for(Genre g : genres) { %>
                                    <option value="<%= g.getIdGenre() %>"><%= g.getNomGenre() %></option>
                                <% } %>
                            </select>
                        </div>

                    <div class="form-group">
                        <label for="date">Date Min :</label>
                        <input type="date" id="date" name="dateMin" class="form-control">
                    </div>
                    <div class="form-group">
                        <label for="date">Date  Max:</label>
                        <input type="date" id="date" name="dateMax" class="form-control">
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
                        <th>Vendeur</th>
                         <th>Genre</th>
                        <th>Date Vente</th>
                        <th>Total Vente</th>
                        <th>Produit</th>
                        <th>Quantite</th>
                        <th>Commission</th>
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
        searchVenteCommission();
    });

    function searchVenteCommission() {
        $('.loading-spinner').show();
        
        $.ajax({
            url: '${pageContext.request.contextPath}/rechercheVentesCommision',
            method: 'POST',
            data: {
                idVendeur: $('select[name="idVendeur"]').val(),
                idGenre: $('select[name="idGenre"]').val(),
                dateMin: $('input[name="dateMin"]').val(),
                dateMax: $('input[name="dateMax"]').val()
            },
            success: function(data) {
                $('.loading-spinner').hide();
                displayResults(data);
            },
            error: function(xhr, status, error) {
                $('.loading-spinner').hide();
                console.error('Erreur:', error);
                alert('Erreur lors de la recherche: ' + error);
            }
        });
    }

    function displayResults(commissions) {
        var tbody = $('#resultsTable tbody');
        tbody.empty();

        if (!commissions || commissions.length === 0) {
            tbody.append('<tr><td colspan="4" class="text-center">Aucun résultat trouvé</td></tr>');
            return;
        }

        var totalVentes = 0;
        var totalCommissions = 0;

        commissions.forEach(function(commission) {
            var row = $('<tr>');
            row.append($('<td>').text(commission.nomVendeur));
                row.append($('<td>').text(commission.nomGenre));
            row.append($('<td>').text(commission.dateVente));
            row.append($('<td>').text(formatPrice(commission.totalVentes)));
            row.append($('<td>').text((commission.nomproduit)));
            row.append($('<td>').text((commission.quantite)));
            row.append($('<td>').text(formatPrice(commission.commission)));
            tbody.append(row);

            totalVentes += parseFloat(commission.totalVentes);
            totalCommissions += parseFloat(commission.commission);
        });

        var totalRow = $('<tr class="table-info">');
        totalRow.append($('<td colspan="3">').text('Total'));
        totalRow.append($('<td>').text(formatPrice(totalVentes)));
        totalRow.append($('<td></td>'));
        totalRow.append($('<td></td>'));

        totalRow.append($('<td>').text(formatPrice(totalCommissions)));
        tbody.append(totalRow);
    }

    function formatPrice(price) {
        if (!price) return '0,00 Ar';
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'MGA',
            minimumFractionDigits: 2
        }).format(price).replace('MGA', 'Ar');
    }

    searchVenteCommission(); 
    
    });
</script> 
</body>
</html>
