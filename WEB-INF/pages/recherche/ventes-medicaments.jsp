<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.*" %>
<%@ page import="models.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Recherche des Ventes</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/chearch.css" rel="stylesheet">
</head>
<body>
    <%
        GroupeAgeDAO groupeAgeDAO = new GroupeAgeDAO();
        TypeAdministrationDAO typeAdminDAO = new TypeAdministrationDAO();
        List<GroupeAge> groupesAge = groupeAgeDAO.getAll();
        List<TypeAdministration> typesAdmin = typeAdminDAO.getAll();
    %>
    
    <div class="container">
        <div class="search-container">
            <h2 class="search-title">
                <i class="fas fa-search me-2"></i>Recherche des Ventes
            </h2>
            <form id="searchForm">
                <div class="row g-3">
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="typeAdmin" class="form-label">Type d'administration</label>
                            <select class="form-select" id="typeAdmin" name="typeAdmin">
                                <option value="">Tous les types</option>
                                <% for(TypeAdministration type : typesAdmin) { %>
                                    <option value="<%= type.getNomType() %>"><%= type.getNomType() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="groupeAge" class="form-label">Groupe d'âge</label>
                            <select class="form-select" id="groupeAge" name="groupeAge">
                                <option value="">Tous les groupes</option>
                                <% for(GroupeAge groupe : groupesAge) { %>
                                    <option value="<%= groupe.getNomGroupe() %>"><%= groupe.getNomGroupe() %></option>
                                <% } %>
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
            <div class="table-responsive">
                <table class="table table-hover" id="resultsTable">
                    <thead>
                        <tr>
                            <th>Médicament</th>
                            <th>Catégorie</th>
                            <th>Type Admin</th>
                            <th>Groupe Âge</th>
                            <th>Prix Unitaire</th>
                            <th>Quantité</th>
                            <th>Prix Total</th>
                            <th>Date Vente</th>
                        </tr>
                    </thead>
                    <tbody>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/assets/js/load.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#searchForm').on('submit', function(e) {
                e.preventDefault();
                searchVentes();
            });

            function searchVentes() {
                $.ajax({
                    url: 'RechercheVentes',
                    method: 'POST',
                    data: {
                        typeAdmin: $('#typeAdmin').val(),
                        groupeAge: $('#groupeAge').val()
                    },
                    success: function(data) {
                        displayResults(data);
                    },
                    error: function(xhr, status, error) {
                        alert('Erreur lors de la recherche: ' + error);
                    }
                });
            }
    
            function displayResults(data) {
                const tbody = $('#resultsTable tbody');
                tbody.empty();  
    
                if (!data || data.length === 0) {
                    const emptyRow = $('<tr>');
                    emptyRow.append($('<td>').attr('colspan', 8).text('Aucune vente trouvée').css('text-align', 'center'));
                    tbody.append(emptyRow);
                    return;
                }
    
                data.forEach((vente) => {
                    const row = $('<tr>');
    
                    const prixTotal = vente.produits.prixUnitaire * vente.quantite;

                    row.append($('<td>').text(vente.produits.nomProduit));
                    row.append($('<td>').text(vente.produits.categorie.nomCategorie)); 
                    row.append($('<td>').text(vente.medicament.typeAdmin.nomType)); 
                    row.append($('<td>').text(vente.medicament.groupeAge.nomGroupe)); 
                    row.append($('<td>').text(formatPrice(vente.produits.prixUnitaire))); 
                    row.append($('<td>').text(vente.quantite)); 
                    row.append($('<td>').text(formatPrice(prixTotal))); 
                    row.append($('<td>').text(vente.dateVente)); 

                    tbody.append(row);
                });
        }
        searchVentes();
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