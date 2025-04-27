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
        GroupeAgeDAO groupeAgeDAO = new GroupeAgeDAO();
        TypeMaladieDAO typeMaladieDAO = new TypeMaladieDAO();
        List<GroupeAge> groupesAge = groupeAgeDAO.getAll();
        List<TypeMaladie> typesMaladie = typeMaladieDAO.getAll();
    %>

    <div class="container">
        <div class="search-container">
            <h2 class="search-title">
                <i class="fas fa-search me-2"></i>Recherche des medicaments
            </h2>
            <form id="searchForm">
                <div class="row">
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="typeMaladie">Type Maladie:</label>
                            <select class="form-control" id="typeMaladie" name="typeAdmin">
                                <option value="">Tous les types</option>
                                <% for(TypeMaladie type : typesMaladie) { %>
                                    <option value="<%= type.getNomMaladie() %>"><%= type.getNomMaladie() %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-5">
                        <div class="form-group">
                            <label for="groupeAge">Groupe d'âge:</label>
                            <select class="form-control" id="groupeAge" name="groupeAge">
                                <option value="">Tous les groupes</option>
                                <% 
                                    for(GroupeAge groupe : groupesAge) { 
                                        int ageMin = groupe.getAgeMin();
                                        int ageMax = groupe.getAgeMax();
                                %>
                                    <option value="<%= groupe.getNomGroupe() %>">
                                        <%= groupe.getNomGroupe() %> (Ages: <%= ageMin %> - <%= ageMax %>)
                                    </option>
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
            <table class="table table-striped" id="resultsTable">
                <thead>
                    <tr>
                        <th>Médicament</th>
                        <th>Type Maladie</th>
                        <th>Categorie Medicament</th>
                        <th>Type Administration</th>
                        <th>Groupe Âge</th>
                        <th>Prix Unitaire</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.6.4.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/load.js"></script>
    <script>
    $(document).ready(function() {

        $('#searchForm').on('submit', function(e) {
            e.preventDefault();
            searchMedicaments();
        });

    function searchMedicaments() {
        $.ajax({
            url: 'RechercheMedicaments',  
            method: 'POST',
            data: {
                typeMaladie: $('#typeMaladie').val(),  
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

    function displayResults(medicaments) {
    var tbody = $('#resultsTable tbody');
    tbody.empty();  

    medicaments.forEach(function(medicament) {
        var row = $('<tr>');

        row.append($('<td>').text(medicament.produit.nomProduit));

        var typesMaladies = medicament.typesMaladies.map(function(typeMaladie) {
            return typeMaladie.nomMaladie;
        }).join(', '); 
        row.append($('<td>').text(typesMaladies));

        var categorie = medicament.produit.categorie ? medicament.produit.categorie.nomCategorie : 'Non spécifié';
        row.append($('<td>').text(categorie));

        row.append($('<td>').text(medicament.typeAdmin.nomType));
        row.append($('<td>').text(medicament.groupeAge.nomGroupe));
        row.append($('<td>').text(formatPrice(medicament.produit.prixUnitaire)));  

        tbody.append(row);
    });

    }
    searchMedicaments();
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