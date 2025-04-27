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
    <title>Insertion des Mouvement</title>
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
                    <i class="fas fa-plus me-2"></i>Insertion des Mouvement
                </h2>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <button type="button" class="btn btn-primary" id="addMouvementRow">
                        <i class="fas fa-plus me-2"></i>Ajouter une Mouvement
                    </button>
                </div>
                <form id="MouvementForm">
                    <div id="MouvementContainer">
            
                    </div>
                    <button type="submit" class="btn btn-success mt-3">
                        <i class="fas fa-save me-2"></i>Enregistrer toutes les Mouvement
                    </button>
                </form>
            </div>
        </div>
    </div>

    <template id="MouvementRowTemplate">
        <div class="row Mouvement-row mb-3">
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
      
            <div class="col-md-2">
                <input type="number" class="form-control quantite" name="quantite" placeholder="Quantité " required>
            </div>
            <div class="col-md-3">
                <select class="form-select" name="typeMouvement" required>
                    <option value="">Sélectionner un type Mouvement</option>
                    <option value="ENTREE">ENTREE</option>
                    <option value="SORTIE">SORTIE</option>
                </select>
            </div>
            <div class="col-md-2">
                <input type="date" class="form-control date-Mouvement" name="date" required>
            </div>
            <div class="col-md-2 ">
                <button type="button" class="btn btn-danger remove-row">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
    </template>
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h2 class="card-title">
                    <i class="fas fa-plus me-2"></i>Historiques Mouvement
                </h2>
            </div>
            <div class="card-body">

                <table class="table table-bordered table-striped">
                    <thead>
                        <tr>
                            <th>ID Mouvement</th>
                            <th>Produit</th>
                            <th>Quantité</th>
                            <th>Date Mouvement</th>
                            <th>Type Mouvement</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="mouvementStock" items="${MouvementStocks}">
                            <tr>
                                <td>${mouvementStock.idMouvement}</td>
                                <td>${mouvementStock.produits.nomProduit}</td>
                                <td>${mouvementStock.quantite}</td>
                                <td>${mouvementStock.dateMouvement}</td>
                                <td>${mouvementStock.typeMouvement}</td>
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
        $('#addMouvementRow').click(function() {
            const template = document.getElementById('MouvementRowTemplate');
            const clone = template.content.cloneNode(true);
            document.getElementById('MouvementContainer').appendChild(clone);
        });

        $(document).on('click', '.remove-row', function() {
            $(this).closest('.Mouvement-row').remove();
        });

        $('#MouvementForm').on('submit', function(e) {
            e.preventDefault();

            const Mouvement = [];
            $('.Mouvement-row').each(function() {
                const row = $(this);
                const idProduit = parseInt(row.find('[name="idProduit"]').val());
                const quantite = parseInt(row.find('[name="quantite"]').val());
                const typeMouvement = row.find('[name="typeMouvement"]').val();
                const dateMouvement = row.find('[name="date"]').val();

                if (!idProduit) {
                    alert('Veuillez sélectionner un produit');
                    return;
                }
                if (!typeMouvement) {
                    alert('Veuillez sélectionner un type de Mouvement');
                    return;
                }
                if (isNaN(quantite) || quantite <= 0) {
                    alert('La quantité doit être un nombre positif');
                    return;
                }
                if (!dateMouvement) {
                    alert('La date est requise');
                    return;
                }

                Mouvement.push({
                    produit: {  
                        idProduit: idProduit
                    },
                    type_mouvement: typeMouvement,
                    quantite: quantite,
                    date_mouvement: dateMouvement
                });
            });

            if (Mouvement.length === 0) {
                alert('Veuillez ajouter au moins un Mouvement');
                return;
            }

            console.log('Données envoyées:', JSON.stringify(Mouvement));  

            $.ajax({
                url: 'mouvementStock',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(Mouvement),
                success: function(response) {
                    alert('Mouvement enregistrés avec succès');
                    $('#MouvementContainer').empty();
                    $('#addMouvementRow').click(); 
                },
                error: function(xhr, status, error) {
                    alert('Erreur lors de l\'enregistrement: ' + xhr.responseText);
                }
            });
        });

        $('#addMouvementRow').click();
    });
</script>

</body>
</html>
